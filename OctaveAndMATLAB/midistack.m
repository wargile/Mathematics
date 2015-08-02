function stack = midistack()
%MIDISTACK Test PIC MidiStack code
%   MIDISTACK is test code for implementation of a different stack
%   logic that avoids the repositioning of stack elements with pushing
%   and popping.
    STACK_DEPTH = 25;
    OFFSET = 1; % Change to 0 for C-code
    stack_pos = OFFSET;
    pop_pos = OFFSET;
    POP = 0;
    PUSH = 1;
    fp = fopen('MidiStack.html', 'w');
    
    stack = zeros(1, STACK_DEPTH);

    fprintf(fp, '<html><body><table align="center">');
    fprintf(fp, '<style>\n');
    fprintf(fp, 'body { background: #d8d8d8 }\n');
    fprintf(fp, 'h1, h2, h3 { font-family: verdana, arial; }\n');
    fprintf(fp, ['th { background: #e8e8e8; border: ', ...
        '1px solid #bbb; padding: 5px }\n']);
    fprintf(fp, ['.info_popped { background: #dfe8ff; border: ', ...
        '1px solid #bbb; padding: 3px }\n']);    
    fprintf(fp, ['.info_pushed { background: #e8e8e8; border: ', ...
        '1px solid #bbb; padding: 3px }\n']);    
    fprintf(fp, ['.info_full, .info_empty { background: #f8d8d8; ', ...
        'border: 1px solid #bbb; padding: 3px }\n']);    
    fprintf(fp, ['table { font-family: verdana, arial; ', ...
        'font-size: 10px; border-collapse: collapse; ', ...
        'border: 1px solid #bbb; background: #fff }\n']);
    fprintf(fp, ['.popped { border: 1px solid #ccc; ', ...
        'background: #fff; color: #bbb; padding: 3px }\n']);
    fprintf(fp, ['.pushed { background: #d0ede0; ', ...
        'font-weight: normal; color: #000; border: ', ...
        '1px solid #bbb; padding: 3px; }\n']);
    fprintf(fp, '</style>\n');
  
    for counter = 1:18
        fprintf('Pushing %d... ', counter);
        stack_full = is_stack_full(stack, stack_pos);
        
        if ~stack_full
            [stack, stack_pos] = stack_push(counter,  stack, ...
                stack_pos, STACK_DEPTH);
        end
        
        stack_write(stack, fp, PUSH, counter, stack_full);

        if mod(counter, ceil(rand() * 10)) == 0
            [stack, number, pop_pos] = stack_pop(stack, pop_pos, ...
                STACK_DEPTH);
            stack_write(stack, fp, POP, number, stack_full);
            [stack, number, pop_pos] = stack_pop(stack, pop_pos, ...
                STACK_DEPTH);
            stack_write(stack, fp, POP, number, stack_full);
        end
    end
    
    stack_display(stack);
    
    for counter = 1:8
        [stack, number, pop_pos] = stack_pop(stack, pop_pos, STACK_DEPTH);
        stack_write(stack, fp, POP, number, stack_full);
    end
    
    stack_display(stack);
    
    fprintf(fp, '</table></body></html>');
    fclose(fp);
end

function [stack, stack_pos] = stack_push(number, stack, stack_pos, ...
    stack_depth)
    if stack(stack_pos) == 0 % TODO: Constant
        stack(stack_pos) = number;
        fprintf('Pushed: %d\n', number);
        
        if stack_pos < stack_depth
            stack_pos = stack_pos + 1;
        else
            stack_pos = 1;
        end
    else
        disp('Stack is full!');
    end
end

function [stack, number, pop_pos] = stack_pop(stack, pop_pos, stack_depth)
    number = 0;
    
    if (pop_pos <= stack_depth) && (stack(pop_pos) ~= 0) % TODO: Constant
        number = stack(pop_pos);
        stack(pop_pos) = 0; % TODO: Constant
        fprintf('Popped: %d\n', number);

        if pop_pos < stack_depth
            pop_pos = pop_pos + 1;
        else
            pop_pos = 1;
        end
    end
end

function stack_full = is_stack_full(stack, stack_pos)
    if stack(stack_pos) ~= 0 % TODO: Constant
        stack_full = true;
    else
        stack_full = false;
    end
end
        
function stack_display(stack)
    fprintf('-------------\nStack after operations are done:\n');
    fprintf('%d ', stack);
    fprintf('\n');
end

function stack_write(stack, fp, push_pop, number, stack_full)
    fprintf(fp, '<tr>');
    
    if push_pop == 1 % Pushed element
        if stack_full
            fprintf(fp, '<td class="info_full">Pushed: %02d </td>', ...
                number);
        else
            fprintf(fp, '<td class="info_pushed">Pushed: %02d </td>', ...
                number);
        end
    else
        if number == 0 % TODO: Constant
            fprintf(fp, '<td class="info_empty">Popped: %02d</td>', ...
                number);
        else
            fprintf(fp, '<td class="info_popped">Popped: %02d </td>', ...
                number);
        end
    end
    
    for counter = 1:length(stack)
        if stack(counter) == 0 % Popped/empty stack element
            fprintf(fp, '<td class="popped">%02d</td>', stack(counter));
        else
            fprintf(fp, '<td class="pushed">%02d</td>', stack(counter));
        end
    end
    
    fprintf(fp, '</tr>\n');
end