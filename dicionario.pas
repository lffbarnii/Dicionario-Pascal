program dicionario;

uses crt;

type 
    //Esse ponteiro aponta pra um endereço na memória que contem um elemento do tipo "registro"
    ponteiroRegistro = ^registro;
    ponteiroVerbete = ^verbete;
    
    verbete  = record
        palavra : string;
        descricao_ingles : string;
        descricao_portugues : string;
        proximo : ponteiroVerbete;
    end;
    
    registro = record
        palavra_chave : string;
        proximo : ponteiroRegistro;
        anterior : ponteiroRegistro;
        verbete : ponteiroVerbete;
    end;
    
    tipoLista = record
        inicio : ponteiroRegistro;
        fim : ponteiroRegistro;
    end;
    
procedure criarListaRegistro(var lista_registro : tipoLista);
begin
    //Inicia a lista sem apontar pra nenhum elemento.
    lista_registro.inicio := nil;
    lista_registro.fim := nil;
end;

Function PalavraExiste(lista_registro:TipoLista; palavra_chave: string): boolean;
var atual:ponteiroRegistro;
begin
 PalavraExiste:= false;
 atual:= lista_registro.inicio;
 while (atual <> nil) and (atual^.palavra_chave <> palavra_chave) do
  atual:= atual^.proximo;
 if atual <> nil then
  PalavraExiste:= true;
end;

procedure incluirRegistro(var lista_registro : TipoLista; palavra_chave : string);
var
    ponteiro_novo_registro, ponteiro_temporario : ponteiroRegistro;
begin
    //Aloca memória para um novo registro
    new(ponteiro_novo_registro);
    
    ponteiro_novo_registro^.palavra_chave := palavra_chave;
    ponteiro_novo_registro^.verbete := nil;

    //Se a lista estiver vazia
    if lista_registro.inicio = nil then
    begin
        ponteiro_novo_registro^.anterior := nil;
        ponteiro_novo_registro^.proximo := nil;
        lista_registro.inicio := ponteiro_novo_registro;
        lista_registro.fim := ponteiro_novo_registro;
        writeln('Palavra inserida!');
    end
    //Se não estiver vazia
    else
    begin
     //Verifica se a palavra inserida já existe no dicionário
     if PalavraExiste(lista_registro, palavra_chave) then
      writeln('Palavra já existente')
     else
      begin
        //Se a palavra chave do primeiro registro for maior que a nova palavra chave
        if lista_registro.inicio^.palavra_chave > ponteiro_novo_registro^.palavra_chave then
        begin
            ponteiro_novo_registro^.anterior := nil;
            ponteiro_novo_registro^.proximo := lista_registro.inicio;
            lista_registro.inicio^.anterior := ponteiro_novo_registro;
            lista_registro.inicio := ponteiro_novo_registro;
        end
        //Se a palavra chave do primeiro registro é menor que a nova palavra chave
        else
        begin
            ponteiro_temporario := lista_registro.inicio;
            
            //Vai até o registro em que a palavra chave é maior que a palavra chave do novo registro
            while (ponteiro_temporario <> nil) and (ponteiro_temporario^.palavra_chave < palavra_chave) do
            begin
                ponteiro_temporario := ponteiro_temporario^.proximo;
            end;

            //Se chegamos no fim da lista
            if ponteiro_temporario = nil then
            begin
                ponteiro_novo_registro^.proximo := nil;
                ponteiro_novo_registro^.anterior := lista_registro.fim;
                lista_registro.fim^.proximo := ponteiro_novo_registro;
                lista_registro.fim := ponteiro_novo_registro;
            end
            else
            begin
                //Caso contrário, inserimos antes do ponteiro_temporario
                ponteiro_novo_registro^.proximo := ponteiro_temporario;
                ponteiro_novo_registro^.anterior := ponteiro_temporario^.anterior;
                ponteiro_temporario^.anterior^.proximo := ponteiro_novo_registro;
                ponteiro_temporario^.anterior := ponteiro_novo_registro;
            end;
            writeln('Palavra inserida!');
       end;
      end;
    end;
end;

Procedure removerRegistro(var lista_registro: TipoLista; Palavra:string);
var atual: ponteiroRegistro;
begin
 //Valida se a lista está vazia
 if lista_registro.fim = nil then
  writeln('Lista vazia')
 else
 begin
  atual:= lista_registro.fim;
  //Verifica se somente há um elemento na lista
  if lista_registro.fim = lista_registro.inicio then
   begin
    dispose(atual);
    lista_registro.inicio := nil;
    lista_registro.fim := nil;
    Writeln('Palavra removida!');
   end
  else
  begin
   
 //Percorre a lista até chegar no valor ou nil
  while (atual <> nil) and (atual^.palavra_chave <> Palavra) do
    atual:=atual^.anterior;
  //verifica se ele achou alguma palavra igual a que escolheu para remover
  if atual = nil then
   writeln('Palavra solicitada para exclusão é inexistente')
  else
   begin
    
    if atual^.proximo = nil then //remove o primeiro elemento
     begin
      lista_registro.fim:= atual^.anterior;
      lista_registro.fim^.proximo:= nil;
      dispose(atual);
     end
    else if atual^.anterior = nil then //remove o ultimo elemento
     begin
      lista_registro.inicio:= atual^.proximo;
      lista_registro.inicio^.anterior:= nil;
      dispose(atual);
     end
    else //remove elemento do meio
     begin
      atual^.anterior^.proximo := atual^.proximo;
      atual^.proximo^.anterior := atual^.anterior;
      dispose(atual);
     end;
    Writeln('Palavra removida!');
    
   end;

  end;

 end;
 
end;


procedure incluirVerbete(var lista_registro : TipoLista; palavra, descricao_portugues, descricao_ingles : string);
var 
    ponteiro_registro : ponteiroRegistro;
    ponteiro_novo_verbete, ponteiro_verbete_temporario, ponteiro_verbete_anterior : ponteiroVerbete;
begin
    new(ponteiro_novo_verbete);
    
    ponteiro_novo_verbete^.palavra := palavra;
    ponteiro_novo_verbete^.descricao_portugues := descricao_portugues;
    ponteiro_novo_verbete^.descricao_ingles := descricao_ingles;
    ponteiro_novo_verbete^.proximo := nil;
    
    //Se a lista de registros estiver vazia:
    if lista_registro.inicio = nil then
        writeln('Não foi possível incluir o verbete, a lista de registros está vazia.')
    else
    begin
        ponteiro_registro := lista_registro.inicio;
        
        while (ponteiro_registro <> nil) and (ponteiro_registro^.palavra_chave < palavra) do
        begin
            ponteiro_registro := ponteiro_registro^.proximo;
        end;
        
        if ponteiro_registro = nil then
         writeln('Não é possível alocar esse verbete à nenhuma palavra chave')
        else if ponteiro_registro^.verbete = nil then
            ponteiro_registro^.verbete := ponteiro_novo_verbete
        else
        begin
            ponteiro_verbete_temporario := ponteiro_registro^.verbete;
            
            while (ponteiro_verbete_temporario <> nil) and (ponteiro_verbete_temporario^.palavra  < palavra) do
            begin
                ponteiro_verbete_anterior := ponteiro_verbete_temporario;
                ponteiro_verbete_temporario := ponteiro_verbete_temporario^.proximo;
            end;
            
            ponteiro_verbete_anterior^.proximo := ponteiro_novo_verbete;
            ponteiro_novo_verbete^.proximo := ponteiro_verbete_temporario;
        end;
    end;
end;

procedure removerVerbete(var lista_registro: TipoLista; palavra: string);
var ponteiro_registro : ponteiroRegistro;
ponteiro_verbete_temporario, ponteiro_verbete_anterior : ponteiroVerbete;
begin
 ponteiro_registro:= lista_registro.inicio;
  //Se não existir nenhuma palavra chave
 if ponteiro_registro = nil then
  writeln('Nenhuma palavra chave incluída')
 else
 begin
  //Percorre até a palavra chave correta
  while (ponteiro_registro <> nil) and (ponteiro_registro^.palavra_chave < palavra) do
  begin
   ponteiro_registro := ponteiro_registro^.proximo;
  end;
  
  if ponteiro_registro^.verbete = nil then
    writeln('Verbete inexistente')
    else
    begin
        ponteiro_verbete_temporario := ponteiro_registro^.verbete;
        ponteiro_verbete_anterior := nil;
        
        while (ponteiro_verbete_temporario <> nil) and (ponteiro_verbete_temporario^.palavra <> palavra) do
        begin
            ponteiro_verbete_anterior := ponteiro_verbete_temporario;
            ponteiro_verbete_temporario := ponteiro_verbete_temporario^.proximo;
        end;
         //Se for o primeiro verbete da lista   
        if ponteiro_verbete_anterior = nil then
         begin
          ponteiro_registro^.verbete:= ponteiro_verbete_temporario^.proximo;
          dispose(ponteiro_verbete_temporario);
         end
        //se for o ultimo elemento
        else if (ponteiro_verbete_temporario^.proximo = nil) then
         begin
          ponteiro_verbete_anterior^.proximo:= nil;
          dispose(ponteiro_verbete_temporario);
         end
        //se não localizar nenhum verbete
        else if (ponteiro_verbete_temporario = nil) then
         writeln('Verbete inexistente')
        else
         begin
          ponteiro_verbete_anterior^.proximo:= ponteiro_verbete_temporario^.proximo;
          dispose(ponteiro_verbete_temporario);
         end;
    end;
    
 end;
 
end;

procedure escreverVerbete(lista_registro: TipoLista; palavra:string);
var ponteiro_registro : ponteiroRegistro;
ponteiro_verbete_temporario: ponteiroVerbete;
begin
 ponteiro_registro:= lista_registro.inicio;
  //Se não existir nenhuma palavra chave
 if ponteiro_registro = nil then
  writeln('Nenhuma palavra chave incluída')
 else
 begin
  //Percorre até a palavra chave correta
  while (ponteiro_registro <> nil) and (ponteiro_registro^.palavra_chave < palavra) do
  begin
   ponteiro_registro := ponteiro_registro^.proximo;
  end;
  
  if ponteiro_registro = nil then
    writeln('Esse verbete não existe')
  else
   begin
    if ponteiro_registro^.verbete = nil then
      writeln('Verbete inexistente')
      else
      begin
       ponteiro_verbete_temporario:= ponteiro_registro^.verbete;
     
       while (ponteiro_verbete_temporario <> nil) and (ponteiro_verbete_temporario^.palavra <> palavra) do
         ponteiro_verbete_temporario:= ponteiro_verbete_temporario^.proximo;
       
       if ponteiro_verbete_temporario = nil then
        writeln('Verbete inexistente')
       else
        writeln('=============================================');
        writeln('Palavra: ', ponteiro_verbete_temporario^.palavra);
        writeln('Português: ', ponteiro_verbete_temporario^.descricao_portugues);
        writeln('Inglês: ', ponteiro_verbete_temporario^.descricao_ingles);
        writeln('=============================================');
     end;
     
    end;
    
  end;
  
end;


procedure escreverListaRegistros(lista_registro : TipoLista);
var
    ponteiro_temporario : ponteiroRegistro;
    ponteiro_verbete_temporario : ponteiroVerbete;
    Ordenacao: integer;
begin
    writeln('--- DESEJA ORDENAR DE FORMA CRESCENCTE OU DECRESCENTE ----');
    writeln('1. CRESCENTE');
    writeln('2. DECRESCENTE');
    readln(Ordenacao);
   
    
     if Ordenacao = 1 then
      begin
       ponteiro_temporario := lista_registro.inicio;
      
       while ponteiro_temporario <> nil do
       begin
        writeln('Palavra Chave: ', ponteiro_temporario^.palavra_chave);
        
        ponteiro_verbete_temporario := ponteiro_temporario^.verbete;
        
        while ponteiro_verbete_temporario <> nil do
        begin
            writeln('=============================================');
            writeln('Palavra: ', ponteiro_verbete_temporario^.palavra);
            writeln('Português: ', ponteiro_verbete_temporario^.descricao_portugues);
            writeln('Inglês: ', ponteiro_verbete_temporario^.descricao_ingles);
            writeln('=============================================');
            
            ponteiro_verbete_temporario := ponteiro_verbete_temporario^.proximo;
        end;
        
        ponteiro_temporario := ponteiro_temporario^.proximo;
       end;
       
      end
    
     else if Ordenacao = 2 then
      begin
       ponteiro_temporario := lista_registro.fim;
       
       while ponteiro_temporario <> nil do
        begin
         writeln('Palavra Chave: ', ponteiro_temporario^.palavra_chave);
        
         ponteiro_verbete_temporario := ponteiro_temporario^.verbete;
         
         while ponteiro_verbete_temporario <> nil do
          begin
            writeln('=============================================');
            writeln('Palavra: ', ponteiro_verbete_temporario^.palavra);
            writeln('Português: ', ponteiro_verbete_temporario^.descricao_portugues);
            writeln('Inglês: ', ponteiro_verbete_temporario^.descricao_ingles);
            writeln('=============================================');
            
            ponteiro_verbete_temporario := ponteiro_verbete_temporario^.proximo;
          end;
         ponteiro_temporario := ponteiro_temporario^.anterior; 
        end;
        
      end
      
     else
      begin
        writeln('Opcao invalida! Tente novamente.');
        readkey;
      end;
end;
var
    lista_registro : TipoLista;
    verbete_consulta, nova_palavra, palavra_remover, descricao_ingles, descricao_portugues: string;
    opcao:integer;
    
begin
    criarListaRegistro(lista_registro);
repeat
    clrscr; // Limpa a tela (da unidade crt)
    writeln('--- DICIONARIO DE STRINGS (LISTA DINAMICA) ---');
    writeln('1. Incluir Registro');
    writeln('2. Remover Registro');
    writeln('3. Incluir Verbete');
    writeln('4. Remover Verbete');
    writeln('5. Consultar Verbete');
    writeln('6. Visualizar Lista');
    writeln('7. Sair');
    write('Escolha uma opcao: ');
    readln(opcao);

    case opcao of
      1: 
        begin
          write('Digite a palavra para incluir: ');
          readln(nova_palavra);
          incluirRegistro(lista_registro, nova_palavra);
          readkey; // Pausa para o usuario ler
        end;
      
      2:
        begin
          Writeln('Informe a Palavra a Remover: ');
          Read(palavra_remover);
          removerRegistro(lista_registro, palavra_remover);
          readkey;
        end;
      
      3:
        begin
            write('Digite a palavra para incluir: ');
            readln(nova_palavra);
            
            write('Digite a descrição em português: ');
            readln(descricao_portugues);
            
            write('Digite a descrição em inglês: ');
            readln(descricao_ingles);
            
            incluirVerbete(lista_registro, nova_palavra, descricao_portugues, descricao_ingles);
            readkey;
        end;
      4:
       begin
        write('Digite o verbete a ser removido');
        readln(nova_palavra);
        removerVerbete(lista_registro, nova_palavra);
        readkey;
       end;
       
      5:
       begin
        writeln('Digite o verbete que deseja consultar');
        readln(verbete_consulta);
        escreverVerbete(lista_registro, verbete_consulta);
        readkey;
       end;
      6: 
        begin
          writeln('--- LISTA ATUAL ---');
          escreverListaRegistros(lista_registro);
          writeln('-------------------');
          readkey;
        end;
      
      7: writeln('Saindo do programa...');
      
      else
        begin
          writeln('Opcao invalida! Tente novamente.');
          readkey;
        end;
    end;

  until opcao = 7;
end.
