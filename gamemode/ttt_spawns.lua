ents.TTT = {}

function ents.TTT.CanImportEntities(map)
   if not tostring(map) then return false end

   local fname = "maps/" .. map .. "_ttt.txt"

   return file.Exists(fname, "GAME")
end

function ents.TTT.CreateSpawns(map)
   if not ents.TTT.CanImportEntities(map) then return end

      local fname = "maps/" .. map .. "_ttt.txt"

      local buf = file.Read(fname, "GAME")
      local lines = string.Explode("\n", buf)
      local num = 0
      for k, line in ipairs(lines) do
         if (not string.match(line, "^#")) and (not string.match(line, "^setting")) and line != "" and string.byte(line) != 0 then
            local data = string.Explode("\t", line)

            local fail = true -- pessimism

            if data[2] and data[3] then
               local cls = data[1]
               local ang = nil
               local pos = nil

               local posraw = string.Explode(" ", data[2])
               pos = Vector(tonumber(posraw[1]), tonumber(posraw[2]), tonumber(posraw[3]))

               local angraw = string.Explode(" ", data[3])
               ang = Angle(tonumber(angraw[1]), tonumber(angraw[2]), tonumber(angraw[3]))

               local kv = {}
               if data[4] then
               local kvraw = string.Explode(" ", data[4])
               local key = kvraw[1]
               local val = tonumber(kvraw[2])

               if key and val then
                  kv[key] = val
               end
            end

            if (cls == "ttt_playerspawn")
               fail = not CreateImportedEnt("info_player_deathmatch", pos, ang, kv)
            end
         end

         if fail then
            ErrorNoHalt("Invalid line " .. k .. " in " .. fname .. "\n")
         else
            num = num + 1
         end
      end
   end

   return true
end