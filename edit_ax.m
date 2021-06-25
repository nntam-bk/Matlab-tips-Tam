classdef edit_ax < handle
    % Code to edit an axis follow my style
    properties
        xlim=[];
        ylim=[];
        zlim=[];
        data=[];
        xdata=[];
        ydata=[];
        zdata=[];
    end
    methods
        function self = edit_ax(gca)
            self.xlim=get(gca,'XLim');
            self.ylim=get(gca,'YLim');
            self.zlim=get(gca,'ZLim');
            self.data=get(gca,'Children');
            self.xdata=get(self.data,'XData');
            self.ydata=get(self.data,'YData');
            self.zdata=get(self.data,'ZData');
            
        end
        function ex_to_bound(self)
            set(gca,'XLim',[min(min(self.xdata)) max(max(self.xdata))])
            set(gca,'YLim',[min(min(self.ydata)) max(max(self.ydata))])
            set(gca,'ZLim',[min(min(self.zdata)) max(max(self.zdata))])          
        end
        function export_pic(~,dirsave,name,exten)
                        %apply style sheet info
            snam='mystyle'; % The name of your style file (NO extension)
            s=hgexport('readstyle',snam);
            fnam=fullfile(dirsave,name+"."+exten); % your file name
            s.Format = exten; %I needed this to make it work but maybe you wont.
            set(gcf,'Color','none');
            hgexport(gcf,fnam,s);
        end
    end
end
            