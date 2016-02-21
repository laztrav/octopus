local json = require "dkjson"
local parse = require "parse"
local param = require "param"
local property = require "property"
local localization = require "localization"
local database = require "database"
local exit = require "exit"
local exception = require "exception"
local userService = require "userService"
local localeService = require "localeService"
local priceService = require "priceService"
local cartService = require "cartService"



local function process (db, data)
    local op = db:operators()
    
    
    local locale = localeService.getLocale(db)
    data.locale = locale
    
    
    if param.isNotEmpty(param.address) then
        db:delete({address = {id = param.address}})
    else
        exception("address is required")
    end
end


local data = {}
local db = database.connect()
local status, err = pcall(process, db, data)
db:close()


if status then
    return ngx.redirect(property.shopUrl .. property.accountAddressesUrl)
else
    exception.toCookie(err)
    return ngx.redirect(property.shopUrl .. property.accountAddressesUrl)
end