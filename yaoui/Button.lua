local yui_path = (...):match('(.-)[^%.]+$')
local Object = require(yui_path .. 'UI.classic.classic')
local Button = Object:extend('Button')

function Button:new(yui, settings)
    self.yui = yui
    self.text = settings.text or ''
    self.name = settings.name
    self.x, self.y = 0, 0
    self.size = settings.size or 20
    self.icon_str = settings.icon
    self.icon_position = settings.icon_position
    self.icon = ''
    if settings.icon then 
        self.icon = self.yui.Theme.font_awesome[settings.icon] 
        self.original_icon = self.yui.Theme.font_awesome[settings.icon] 
    end
    self.font = love.graphics.newFont(self.yui.Theme.open_sans_semibold, math.floor(self.size*0.7))
    self.font:setFallbacks(love.graphics.newFont(self.yui.Theme.font_awesome_path, math.floor(self.size*0.7)))
    self.w = self.font:getWidth(self.text .. ' ' .. self.icon) + self.size
    self.h = self.font:getHeight() + math.floor(self.size*0.7)
    self.button = self.yui.UI.Button(0, 0, self.w, self.h, {
        yui = self.yui,
        extensions = {self.yui.Theme.Button},
        icon = self.yui.Theme.font_awesome[settings.icon], 
        font = self.font,
        text = self.text,
        parent = self,
    })
    self.onClick = settings.onClick

    self.loading = false
    self.icon_r = 0
end

function Button:update(dt)
    if self.button.hot and self.button.released then
        if self.onClick then
            self:onClick()
        end
    end

    self.button.x, self.button.y = self.x, self.y
    self.button:update(dt)

    if self.button.enter then love.mouse.setCursor(self.yui.Theme.hand_cursor) end
    if self.button.exit then love.mouse.setCursor() end
    if self.loading then self.icon_r = self.icon_r + 3*math.pi*dt end
end

function Button:draw()
    self.button:draw()
end

function Button:setLoading()
    self.icon = self.yui.Theme.font_awesome['fa-refresh']
    self.button.icon = self.icon
    self.loading = true
end

function Button:unsetLoading()
    self.icon = self.yui.Theme.font_awesome[self.icon_str]
    self.button.icon = self.icon
    self.icon_r = 0
    self.loading = false
end

return Button