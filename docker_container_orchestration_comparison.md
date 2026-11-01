# Dockerfile, Docker Compose, Kubernetes ve Ekosistem Araçları Karşılaştırma Dokümanı

Bu doküman; **Dockerfile**, **Docker Compose**, **Kubernetes (K8s)** ve modern DevOps ekosistemindeki tamamlayıcı araçların ne olduğunu, hangi amaçla kullanıldığını ve aralarındaki temel farkları özetlemek için hazırlanmıştır.

---

## 1. Temel Araçlar: Tanım ve Amaç

| Araç | Ne Anlama Gelir? | Temel Amacı |
| :--- | :--- | :--- |
| **Dockerfile** | **İnşaat Tarifi (Reçete)** | Tek bir uygulamanın kodunu, kütüphanelerini ve bağımlılıklarını tek bir **Docker İmajı (Image)** haline getirmek. |
| **Docker Compose** | **Yerel Orkestratör (Tek Sunucu)** | Birden fazla konteyneri (Örn: Uygulama + Veritabanı) tek bir makinede yan yana çalıştırmak ve aralarındaki ağı kurmak. |
| **Kubernetes (K8s)** | **Dağıtık Sistem Orkestratörü (Devasa Küme)** | Yüzlerce sunucu üzerinde koşan konteynerleri otomatik ölçeklemek, güvenliğini sağlamak ve çöktüğünde yeniden diriltmek. |

---

## 2. Detaylı Karşılaştırma Tablosu

| Özellik | Dockerfile | Docker Compose | Kubernetes (K8s) |
| :--- | :--- | :--- | :--- |
| **Kapsam** | **Tekil:** Sadece bir imaj üretir. | **Çoklu (Yerel):** Tek sunucuda çoklu konteyner yönetir. | **Çoklu (Üretim):** Çoklu sunucularda (Cluster) devasa sistem yönetir. |
| **Çalışma Ortamı** | Herhangi bir geliştirme bilgisayarı. | Tek bir bilgisayar veya tek bir sunucu (Host). | Birden fazla fiziksel veya bulut sunucusu (Nodes). |
| **Ölçekleme (Scaling)** | Yoktur (Sadece tariftir). | Kısıtlıdır (Tek sunucunun gücüyle sınırlıdır). | **Sınırsız ve Otomatiktir:** Trafik artınca kopya sayısını artırır. |
| **Kendi Kendini İyileştirme** | Yoktur. | Yoktur (Konteyner çözerse öylece kalır). | **Mükemmeldir:** Çöken konteynerin yerine anında yenisini açar. |
| **Dosya Formatı** | `Dockerfile` | `docker-compose.yml` | `.yaml` (Deployment, Service vb. manifestolar) |
| **Kullanım Yeri** | Kodunu paketlemek istediğin her an. | Lokal geliştirme, testler ve küçük projeler. | Canlı ortamlar (Production), büyük kurumsal sistemler. |

---

## 3. Ekosistemi Tamamlayan Kritik Araçlar

| Araç / Konsept | Ne İşe Yarar? | Nerede Kullanılır? |
| :--- | :--- | :--- |
| **Minikube / Kind** | Bilgisayarında hafif bir yerel Kubernetes cluster'ı kurmanı sağlar. | Yerel geliştirme ve K8s test aşamalarında. |
| **Helm** | Kubernetes için paket yöneticisidir (APT veya NPM gibidir). YAML dosyalarını şablonlaştırarak tek komutla kurulum yapar. | Kurumsal Kubernetes yönetiminde. |
| **CI/CD (GitHub Actions / GitLab CI)** | Kodu GitHub'a gönderdiğin an otomatik test eden, Docker imajı build eden ve Kubernetes'e deploy eden otomasyon hattıdır. | Otomasyon ve sürekli teslimat süreçlerinde. |

---

## 4. Hayat Döngüsü İçindeki Sıralaması (Büyük Resim)

Bir yazılım projesini geliştirip canlıya alırken bu araçlar sırasıyla ve birbirini tamamlayarak şöyle kullanılır:

1. **Adım (`Dockerfile`):** Kodunu paketleyip bir `petclinic:v1` imajı üretirsin.
2. **Adım (`Docker Compose`):** Bilgisayarında kod yazarken, hem bu imajı hem de MySQL'i yerelde test etmek için kullanırsın.
3. **Adım (`Minikube & Kubernetes`):** Projeyi canlıya taşımadan önce bilgisayarında Kubernetes manifestolarıyla test edersin.
4. **Adım (`CI/CD & Helm`):** Süreci otomatikleştirip canlı ortamlara kolayca dağıtırsın.