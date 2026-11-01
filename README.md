# DevOps Case Study - Step 1: Dockerization & Local Setup

Bu döküman, Spring Petclinic uygulaması üzerine uygulanan beş adımlık DevOps case çalışmasının ilk aşamasını, yani uygulamanın Dockerize edilmesi ve yerel ortamda docker-compose ile çalıştırılmasını kapsamaktadır.

## Case Çalışması Genel Adımları

1. **Dockerize Etme ve Yerel Çalıştırma:** Uygulama ve veritabanı için Dockerfile ve Docker Compose yapılandırmasının hazırlanması.
2. **Kubernetes Ortamı:** Minikube veya Kind kullanılarak yerel bir Kubernetes cluster kurulumunun gerçekleştirilmesi.
3. **Kubernetes Manifestleri:** Uygulama ve veritabanı için Kubernetes deployment, service ve diğer manifest dosyalarının hazırlanması.
4. **Helm Chart veya Kustomize:** Dağıtım süreçlerinin şablonlaştırılması.
5. **CI/CD Pipeline:** Otomatik test, derleme ve dağıtım süreçlerinin kurgulanması.

## Adım 1: Docker ve Docker Compose Yapılandırması

## Çalıştırma Komutları

Uygulamayı ve veritabanını Docker Compose kullanarak yerel ortamda ayağa kaldırmak için proje ana dizininde aşağıdaki komutu çalıştırınız:

```bash
docker compose up --build
```

Servisleri durdurmak ve temizlemek icin:
```bash
docker compose down
```

Servisler hazır olduktan sonra uygulamaya aşağıdaki adres üzerinden erişebilirsiniz:

* **Uygulama URL:** `http://localhost:8081`

## Adım 2: Kubernetes Kümesi Kurulumu ve Dağıtımı

Bu adımda, yerel geliştirme ortamında konteyner orchestrasyonu sağlamak amacıyla Minikube tercih edilmiş ve uygulama ile veritabanı manifestoları cluster üzerine uygulanmıştır.

### Bileşenler ve Akış

1. **Minikube Başlatma:** Docker driver kullanılarak yerel Kubernetes cluster ortamı oluşturulur.
2. **Image Yükleme:** Yerel ortamda bulunan uygulama imajı (`petclinic:v1`) ve MySQL imajı (`mysql:9.7`) Minikube ortamına yüklenir.
3. **Manifest Uygulama:** Deployment ve Service konfigürasyonlarını içeren `petclinic.yaml` dosyası cluster üzerine uygulanır.
4. **Erişim:** Uygulama NodePort servisi aracılığıyla dış dünyaya açılır.

## Çalıştırma Talimatları

Yerel Kubernetes ortamını kurmak, imajları aktarmak ve uygulamayı otomatize edilmiş bir şekilde ayağa kaldırmak için hazırlanan bash dosyasını kullanabilirsiniz.

1. Çalıştırma izni verin:
   ```bash
   chmod +x deploy-petclinic.sh
   ```

2. Çalıştırın:
   ```bash
   ./deploy-petclinic.sh
   ```

Küme içerisine kubectl apply -f petclinic.yaml ile yüklediğiniz deployment, service ve diğer manifest dosyalarını tamamen kaldırmak için:
   ```bash
   kubectl delete -f petclinic.yaml
   ```


## Adım 3: Helm Chart ile Kubernetes Dağıtımı Uygulama ve veritabanı bileşenleri


## 📁 Helm Chart Yapısı (`petclinic-chart`)

Dağıtım için kullanılan Helm chart dizin yapısı ve bileşenleri aşağıda açıklanmıştır:

```text
petclinic-chart/
├── Chart.yaml              # Helm chart meta verilerini barındırır.
├── values.yaml             # Dinamik konfigürasyon değişkenleri (replica, imaj, env vb.).
└── templates/
    ├── mysql-deployment.yaml     # MySQL veritabanı deployment konfigürasyonu.
    ├── mysql-service.yaml        # MySQL servis (ClusterIP vb.) tanımı.
    ├── mysql-pvc.yaml            # Veri kalıcılığı için PersistentVolumeClaim.
    ├── mysql-secret.yaml         # Hassas veriler (şifreler vb.) için Secret nesnesi.
    ├── petclinic-deployment.yaml # Spring Petclinic uygulama deployment tanımı.
    ├── petclinic-configmap.yaml  # Uygulama çalışma zamanı konfigürasyonları.
    └── petclinic-ingress.yaml    # Ingress yönlendirme ve dışarıya açma kuralları.
```

1. Çalıştırma izni verin:
   ```bash
   chmod +x deploy.sh
   ```
2. Çalıştırın:
   ```bash
   ./deploy.sh
   ```
3. Gerekirse ayrı terminalde çalıştırın:
   ```bash
   kubectl port-forward svc/petclinic-service 8080:8080
   ```
* **Uygulama URL:** `http://localhost:8080`

Helm release'ini silmek için:

   ```bash
   helm uninstall petclinic-release
   ```
Minikube kümesini durdurmak isterseniz (verileriniz silinmez):
   ```bash
   minikube stop
   ```
   
## Adım 4: GitHub Actions ile CI/CD Pipeline Yapılandırması

Bu adımda, geliştirilen kodun `main` dalına (branch) gönderilmesiyle (push) tetiklenen; derleme, Docker Hub'a imaj yükleme, geçici bir Kind cluster ayağa kaldırma ve Helm ile Kubernetes ortamına dağıtma adımlarını içeren otomatize edilmiş bir iş akışı kurulmuştur.

### Repository Secrets Yapılandırması

Pipeline'ın güvenli bir şekilde çalışabilmesi ve hassas verilere erişebilmesi için GitHub repository ayarlarından (`Settings > Secrets and variables > Actions`) şu secret'lar tanımlanmıştır:

* `DOCKER_HUB_USERNAME`: Docker Hub kullanıcı adınız.
* `DOCKER_HUB_ACCESS_TOKEN`: Docker Hub erişim belirteci (token).
* `MYSQL_USER`: Veritabanı kullanıcı adı.
* `MYSQL_PASSWORD`: Veritabanı şifresi.
* `MYSQL_ROOT_PASSWORD`: MySQL kök (root) şifresi.

### Pipeline Adımları ve Akış

1. **Checkout:** Kodların runner ortamına indirilmesi.
2. **Java Kurulumu:** Proje için JDK 17 (Temurin dağıtımı) ortamının hazırlanması ve Maven önbelleklemesinin (cache) aktifleştirilmesi.
3. **Build İşlemi:** Maven wrapper kullanılarak uygulamanın paketlenmesi.
4. **Docker Hub Girişi:** Tanımlanan secret'lar kullanılarak Docker Hub kimlik doğrulaması.
5. **İmaj Oluşturma ve Gönderme:** Uygulama Docker imajının (`petclinic:v1`) oluşturularak Docker Hub'a gönderilmesi.
6. **Kind Cluster Kurulumu:** Test amaçlı izole bir Kubernetes ortamının (`helm/kind-action`) ayağa kaldırılması.
7. **Helm ile Dağıtım (CD):** Hazırlanan Helm chart (`./petclinic-chart`) kullanılarak veritabanı ve uygulama bileşenlerinin Kubernetes cluster'ına kurulması, şifre ve kullanıcı adı gibi hassas verilerin `--set` parametreleriyle beslenmesi.
8. **Doğrulama ve Test:** Pod ve servis durumlarının kontrol edilmesi, logların incelenmesi ve `port-forward` ile arayüzün (`curl`) test edilmesi.

## Pipeline Dosyası (`ci-cd.yml`)

Proje kök dizininde `.github/workflows/ci-cd.yml` yolunda bulunan pipeline yapılandırması

Boş bir commit atarak (yani kod değişikliği yapmadan) GitHub Actions pipeline'ını manuel olarak tetikleme:
   ```bash
   git commit --allow-empty -m "ci: trigger pipeline manually"
   ```
   ```bash
   git push origin main
   ```
