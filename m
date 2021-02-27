From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH V4 02/18] iommu/ioasid: Rename ioasid_set_data()
Date: Sat, 27 Feb 2021 14:01:10 -0800
Message-ID: <1614463286-97618-3-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1614463286-97618-1-git-send-email-jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Sender: "iommu" <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Rename ioasid_set_data() to ioasid_attach_data() to avoid confusion with
struct ioasid_set. ioasid_set is a group of IOASIDs that share a common
token.

Reviewed-by: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/iommu/intel/svm.c | 6 +++---
 drivers/iommu/ioasid.c    | 6 +++---
 include/linux/ioasid.h    | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 18a9f05df407..0053df9edffc 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -371,7 +371,7 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 			svm->gpasid = data->gpasid;
 			svm->flags |= SVM_FLAG_GUEST_PASID;
 		}
-		ioasid_set_data(data->hpasid, svm);
+		ioasid_attach_data(data->hpasid, svm);
 		INIT_LIST_HEAD_RCU(&svm->devs);
 		mmput(svm->mm);
 	}
@@ -425,7 +425,7 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 	list_add_rcu(&sdev->list, &svm->devs);
  out:
 	if (!IS_ERR_OR_NULL(svm) && list_empty(&svm->devs)) {
-		ioasid_set_data(data->hpasid, NULL);
+		ioasid_attach_data(data->hpasid, NULL);
 		kfree(svm);
 	}
 
@@ -468,7 +468,7 @@ int intel_svm_unbind_gpasid(struct device *dev, u32 pasid)
 				 * the unbind, IOMMU driver will get notified
 				 * and perform cleanup.
 				 */
-				ioasid_set_data(pasid, NULL);
+				ioasid_attach_data(pasid, NULL);
 				kfree(svm);
 			}
 		}
diff --git a/drivers/iommu/ioasid.c b/drivers/iommu/ioasid.c
index 50ee27bbd04e..eeadf4586e0a 100644
--- a/drivers/iommu/ioasid.c
+++ b/drivers/iommu/ioasid.c
@@ -259,14 +259,14 @@ void ioasid_unregister_allocator(struct ioasid_allocator_ops *ops)
 EXPORT_SYMBOL_GPL(ioasid_unregister_allocator);
 
 /**
- * ioasid_set_data - Set private data for an allocated ioasid
+ * ioasid_attach_data - Set private data for an allocated ioasid
  * @ioasid: the ID to set data
  * @data:   the private data
  *
  * For IOASID that is already allocated, private data can be set
  * via this API. Future lookup can be done via ioasid_find.
  */
-int ioasid_set_data(ioasid_t ioasid, void *data)
+int ioasid_attach_data(ioasid_t ioasid, void *data)
 {
 	struct ioasid_data *ioasid_data;
 	int ret = 0;
@@ -288,7 +288,7 @@ int ioasid_set_data(ioasid_t ioasid, void *data)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(ioasid_set_data);
+EXPORT_SYMBOL_GPL(ioasid_attach_data);
 
 /**
  * ioasid_alloc - Allocate an IOASID
diff --git a/include/linux/ioasid.h b/include/linux/ioasid.h
index e9dacd4b9f6b..60ea279802b8 100644
--- a/include/linux/ioasid.h
+++ b/include/linux/ioasid.h
@@ -40,7 +40,7 @@ void *ioasid_find(struct ioasid_set *set, ioasid_t ioasid,
 		  bool (*getter)(void *));
 int ioasid_register_allocator(struct ioasid_allocator_ops *allocator);
 void ioasid_unregister_allocator(struct ioasid_allocator_ops *allocator);
-int ioasid_set_data(ioasid_t ioasid, void *data);
+int ioasid_attach_data(ioasid_t ioasid, void *data);
 
 #else /* !CONFIG_IOASID */
 static inline ioasid_t ioasid_alloc(struct ioasid_set *set, ioasid_t min,
@@ -73,7 +73,7 @@ static inline void ioasid_unregister_allocator(struct ioasid_allocator_ops *allo
 {
 }
 
-static inline int ioasid_set_data(ioasid_t ioasid, void *data)
+static inline int ioasid_attach_data(ioasid_t ioasid, void *data)
 {
 	return -ENOTSUPP;
 }
-- 
2.25.1
