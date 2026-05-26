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
        
        if ponteiro_registro^.verbete = nil then
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

procedure escreverListaRegistros(lista_registro : TipoLista);
var
    ponteiro_temporario : ponteiroRegistro;
    ponteiro_verbete_temporario : ponteiroVerbete;
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
end;

var
    lista_registro : TipoLista;
    nova_palavra, palavra_remover, descricao_ingles, descricao_portugues: string;
    opcao:integer;
    
begin
    criarListaRegistro(lista_registro);
repeat
    clrscr; // Limpa a tela (da unidade crt)
    writeln('--- DICIONARIO DE STRINGS (LISTA DINAMICA) ---');
    writeln('1. Incluir Registro');
    writeln('2. Incluir Verbete');
    writeln('3. Remover Verbete');
    writeln('4. Consultar Verbete');
    writeln('5. Visualizar Lista');
    writeln('6. Sair');
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
            write('Digite a palavra para incluir: ');
            readln(nova_palavra);
            
            write('Digite a descrição em português: ');
            readln(descricao_portugues);
            
            write('Digite a descrição em inglês: ');
            readln(descricao_ingles);
            
            incluirVerbete(lista_registro, nova_palavra, descricao_portugues, descricao_ingles);
            readkey;
        end;
      
      5: 
        begin
          writeln('--- LISTA ATUAL ---');
          escreverListaRegistros(lista_registro);
          writeln('-------------------');
          readkey;
        end;
      
      6: writeln('Saindo do programa...');
      
      else
        begin
          writeln('Opcao invalida! Tente novamente.');
          readkey;
        end;
    end;

  until opcao = 5;
end.



