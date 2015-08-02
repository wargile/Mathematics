function [x, my_figure] = terje()
    funcprot(0);
    x = -100:100;
    clf;
    
    my_figure = plot(x^3, 'bo-');
    
    set(gca(), "grid", [4, 12]);
    //set(my_figure, "anti_aliasing", "4x");
    set(gcf(), "background", 12);
    
    da = gda();
    da.title.text="My Neat Title";
    da.title.foreground = 12;
    da.title.font_size = 4;
    
    a = get("current_axes");
    //get the handle of the newly created axes
    a.box = "on";
endfunction

//add_profiling("terje")
//terje()
//profile(terje)
//plotprofile(terje)
