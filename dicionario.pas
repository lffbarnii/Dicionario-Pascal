program dicionario;

uses crt;

type 
    //Esse ponteiro aponta pra um endereço na memória que contem um elemento do tipo "registro"
    ponteiroRegistro = ^registro;
    
    registro = record
        palavra_chave : string;
        proximo : ponteiroRegistro;
        anterior : ponteiroRegistro;
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

procedure alterarPalavra(var lista_registro:TipoLista; var palavra_remover, nova_palavra: string);
begin
removerRegistro(lista_registro, palavra_remover);
incluirRegistro(lista_registro, nova_palavra);
end;

procedure escreverListaRegistros(lista_registro : TipoLista);
var
    ponteiro_temporario : ponteiroRegistro;
begin
    ponteiro_temporario := lista_registro.inicio;
    
    while ponteiro_temporario <> nil do
    begin
        writeln(ponteiro_temporario^.palavra_chave);
        ponteiro_temporario := ponteiro_temporario^.proximo;
    end;
end;

var
    lista_registro : TipoLista;
    nova_palavra, palavra_remover: string;
    opcao:integer;
    
begin
    criarListaRegistro(lista_registro);
repeat
    clrscr; // Limpa a tela (da unidade crt)
    writeln('--- DICIONARIO DE STRINGS (LISTA DINAMICA) ---');
    writeln('1. Incluir Registro');
    writeln('2. Remover Registro');
    writeln('3. Visualizar Lista');
    writeln('4. Alterar Lista');
    writeln('5. Sair');
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
          writeln('--- LISTA ATUAL ---');
          escreverListaRegistros(lista_registro);
          writeln('-------------------');
          readkey;
        end;
        
      4:
        begin
         writeln('Informe o valor a ser alterado: ');
         readln(palavra_remover);
         writeln('Informe o novo valor a ser colocado');
         readln(nova_palavra);
         alterarPalavra(lista_registro, palavra_remover, nova_palavra);
         readkey;
        end;
      
      5: writeln('Saindo do programa...');
      
      else
        begin
          writeln('Opcao invalida! Tente novamente.');
          readkey;
        end;
    end;

  until opcao = 5;
end.



