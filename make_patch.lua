local ziparchive = require "ziparchive"
local lfs = require "lfs"
local utils = require "script.lualib.utils"
local json = require "script.lualib.json"

local apk_files = {}

local function read_archive(archive, path)
    local handle = archive:fileopen(path)
    local data = archive:fileread(handle)
    archive:fileclose(handle)
    return data
end

local function write_archive(archive, path, data)
    local handle = archive:filecreate(path)
    archive:filewrite(handle, data)
    archive:fileclose(handle)
end

-- 取得当前目录下所有apk文件
for name in lfs.dir(".") do
    local fa = lfs.attributes(name)
    if string.find(name, ".apk") ~= nil then
        table.insert(apk_files, name)
        --print(name, utils.dump(fa))
    end
end
table.sort(apk_files)

local version_file_path = "assets/assets.manifest"
local archive = ziparchive.new()
-- 将包内版本号文件中的版本号改为当前apk的文件名
for i=1, #apk_files do
      local apk_name = apk_files[i]
      -- 读取包内版本文件数据
      archive:open(apk_name, "r")
      local data = read_archive(archive, version_file_path)
      archive:close()
      -- 版本数据修改为apk名
      local table_data = json.decode(data)
      table_data.version = string.sub(apk_name, 1, 5)
      table_data = json.encode(table_data)
      -- 将新的数据写入包内
      archive:open(apk_name, "a")
      write_archive(archive, version_file_path, table_data)
      archive:close()
end

-- 导出两个apk的差异包
local function export_patch(old_apk_path, new_apk_path, export_path)

        local archive_new = ziparchive.new()
        local archive_old = ziparchive.new()
        -- 差异列表
        local different_file = {}

        archive_new:open(new_apk_path, 'r')
        archive_old:open(old_apk_path, "r")

        for i=1,archive_new:fileentrycount() do
            local entry_new = archive_new:fileentry(i)
            local entry_old = archive_old:findfileentry(entry_new.filename)

            local file_name = entry_new.filename
              -- 文件不存在 
            if not entry_old then
                    table.insert(different_file, file_name)
              --  crc对不上 
            elseif  entry_old.crc ~= entry_new.crc then
                    table.insert(different_file, file_name)
              -- 文件size对不上
            elseif  entry_old.uncompressed_size ~= entry_new.uncompressed_size then
                    table.insert(different_file, file_name)
            end
        end

        -- 差异包
        local patch_archive = ziparchive.open(export_path, "w")
        -- 将文件写入差异包
        for i=1, #different_file do
            local file_name = different_file[i]
            local data = read_archive(archive_new, file_name)
            -- 缩进assets目录 
            file_name = string.gsub(file_name, "assets/", "")
            write_archive(patch_archive, file_name, data)
        end

        archive_new:close()
        archive_old:close()
        patch_archive:close()
end

-- 生成各版本更新包
for i=1, #apk_files-1 do
    local old_path = apk_files[i]
    local new_path = apk_files[i+1]
    local export_path = "patch/"..string.gsub(old_path, ".apk", "") .. "-" .. string.gsub(new_path, ".apk", "") .. ".zip"
    -- 找不到时再生成
    if archive:open(export_path) == false then
        export_patch(old_path, new_path, export_path)
    else
        archive:close()
    end
end



