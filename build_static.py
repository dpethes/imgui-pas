# Static ImGui class method declaration/definition generator.
# Uses external function list as input
# for example: function  igGetIdStr(str_id: PChar): ImGuiID; cdecl; external ImguiLibName;
f = open('funclist.pas', 'r')
methodDeclList = []
methodDefList = []
for line in f:
    line = line.rstrip('\n ')
    if (len(line) < 10) or (line[:2] == '//') or (line[:1] == '{'):
        methodDeclList.append(line)
        methodDefList.append(line)
        continue
    line = line.replace(' cdecl; external ImguiLibName;', '')  #remove specs
    prefix = 'class '
    isFunction = line.startswith('function')
    if isFunction:
        line = line.replace('function  ig', '')
        prefix += 'function'
    else:
        line = line.replace('procedure ig', '')
        prefix += 'procedure'

    newDecl = prefix + ' '
    if isFunction:
        newDecl += ' ' #indent by one more space for vertical align
    newDecl += line + '  inline;'
    newDef = prefix + ' ImGui.' + line

    if '(' in line:
        #has params
        procname = line.partition('(')[0]
    else:
        procname = line.partition(';')[0]
        if isFunction:
            procname = line.partition(':')[0]

    paramlist = line.replace(procname, '')
    bodyParamList = ''
    if len(paramlist) > 2:
        if isFunction:
            listend = paramlist.find(')')
            paramlist = paramlist[:listend]
            if not '(' in paramlist:
                listend = paramlist.find(':')
                paramlist = paramlist[:listend]

        paramlist = paramlist.rstrip('); ').lstrip('(')
        paramDeclList = paramlist.split('; ')  #drops return value in functions too
        #print(paramDeclList)
        for par in paramDeclList:
            par = par.split(':')[0];
            if len(bodyParamList) > 0:
                bodyParamList += ', '
            bodyParamList += par;


    #function body
    body = '    begin '
    if isFunction:
        body += 'result := '
    body += 'ig' + procname
    if len(paramlist) > 2:
        body += '(' + bodyParamList + ')'
    body += ' end;'

    #debug output
    #print(line)
    #print(newDecl)
    #print(newDef)
    #print(body)

    methodDeclList.append(newDecl)
    methodDefList.append(newDef)
    methodDefList.append(body)

for s in methodDeclList:
    print(s)
for s in methodDefList:
    print(s)
