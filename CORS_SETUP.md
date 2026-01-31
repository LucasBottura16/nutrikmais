# Configuração CORS para Firebase Storage

## Problema
As imagens do Firebase Storage não carregam no Flutter Web devido a restrições de CORS (Cross-Origin Resource Sharing).

## Solução

### 1. Criar arquivo `cors.json`

Crie um arquivo chamado `cors.json` com o seguinte conteúdo:

```json
[
  {
    "origin": ["*"],
    "method": ["GET", "HEAD"],
    "maxAgeSeconds": 3600
  }
]
```

### 2. Instalar Google Cloud SDK

- Windows: https://cloud.google.com/sdk/docs/install
- Linux/Mac: `curl https://sdk.cloud.google.com | bash`

### 3. Configurar CORS no Firebase Storage

Execute os seguintes comandos no terminal:

```bash
# Fazer login no Google Cloud
gcloud auth login

# Configurar o projeto (substitua SEU-PROJECT-ID pelo ID do seu projeto Firebase)
gcloud config set project nutrikmais

# Aplicar configuração CORS
gsutil cors set cors.json gs://app.nutrikmais.com.br
```

### 4. Verificar configuração

```bash
gsutil cors get gs://app.nutrikmais.com.br
```

## Alternativa Simples (Sem Google Cloud SDK)

Use o Firebase Console:

1. Acesse: https://console.firebase.google.com/
2. Selecione seu projeto
3. Vá em Storage → Rules
4. Adicione as regras de CORS manualmente

## Para desenvolvimento local

Adicione no arquivo `web/index.html` antes do `</head>`:

```html
<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
```

## Verificação

Após configurar o CORS, limpe o cache do navegador:
- Chrome: Ctrl+Shift+Delete
- Edge: Ctrl+Shift+Delete
- Firefox: Ctrl+Shift+Delete

E recarregue a aplicação.
