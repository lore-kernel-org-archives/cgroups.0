From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH V4 03/18] iommu/ioasid: Add a separate function for detach data
Date: Sat, 27 Feb 2021 14:01:11 -0800
Message-ID: <1614463286-97618-4-git-send-email-jacob.jun.pan@linux.intel.com>
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

IOASID private data can be cleared by ioasid_attach_data() with a NULL
data pointer. A common use case is for a caller to free the data
afterward. ioasid_attach_data() calls synchronize_rcu() before return
such that free data can be sure without outstanding readers.
However, since synchronize_rcu() may sleep, ioasid_attach_data() cannot
be used under spinlocks.

This patch adds ioasid_detach_data() as a separate API where
synchronize_rcu() is called only in this case. ioasid_attach_data() can
then be used under spinlocks. In addition, this change makes the API
symmetrical.

Signed-off-by: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/iommu/intel/svm.c |  4 +--
 drivers/iommu/ioasid.c    | 54 +++++++++++++++++++++++++++++++--------
 include/linux/ioasid.h    |  5 +++-
 3 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 0053df9edffc..68372a7eb8b5 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -425,7 +425,7 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 	list_add_rcu(&sdev->list, &svm->devs);
  out:
 	if (!IS_ERR_OR_NULL(svm) && list_empty(&svm->devs)) {
-		ioasid_attach_data(data->hpasid, NULL);
+		ioasid_detach_data(data->hpasid);
 		kfree(svm);
 	}
 
@@ -468,7 +468,7 @@ int intel_svm_unbind_gpasid(struct device *dev, u32 pasid)
 				 * the unbind, IOMMU driver will get notified
 				 * and perform cleanup.
 				 */
-				ioasid_attach_data(pasid, NULL);
+				ioasid_detach_data(pasid);
 				kfree(svm);
 			}
 		}
diff --git a/drivers/iommu/ioasid.c b/drivers/iommu/ioasid.c
index eeadf4586e0a..4eb9b3dd1b85 100644
--- a/drivers/iommu/ioasid.c
+++ b/drivers/iommu/ioasid.c
@@ -273,23 +273,57 @@ int ioasid_attach_data(ioasid_t ioasid, void *data)
 
 	spin_lock(&ioasid_allocator_lock);
 	ioasid_data = xa_load(&active_allocator->xa, ioasid);
-	if (ioasid_data)
-		rcu_assign_pointer(ioasid_data->private, data);
-	else
+
+	if (!ioasid_data) {
 		ret = -ENOENT;
-	spin_unlock(&ioasid_allocator_lock);
+		goto done_unlock;
+	}
 
-	/*
-	 * Wait for readers to stop accessing the old private data, so the
-	 * caller can free it.
-	 */
-	if (!ret)
-		synchronize_rcu();
+	if (ioasid_data->private) {
+		ret = -EBUSY;
+		goto done_unlock;
+	}
+	rcu_assign_pointer(ioasid_data->private, data);
+
+done_unlock:
+	spin_unlock(&ioasid_allocator_lock);
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ioasid_attach_data);
 
+/**
+ * ioasid_detach_data - Clear the private data of an ioasid
+ *
+ * @ioasid: the IOASIDD to clear private data
+ */
+void ioasid_detach_data(ioasid_t ioasid)
+{
+	struct ioasid_data *ioasid_data;
+
+	spin_lock(&ioasid_allocator_lock);
+	ioasid_data = xa_load(&active_allocator->xa, ioasid);
+
+	if (!ioasid_data) {
+		pr_warn("IOASID %u not found to detach data from\n", ioasid);
+		goto done_unlock;
+	}
+
+	if (ioasid_data->private) {
+		rcu_assign_pointer(ioasid_data->private, NULL);
+		goto done_unlock;
+	}
+
+done_unlock:
+	spin_unlock(&ioasid_allocator_lock);
+	/*
+	 * Wait for readers to stop accessing the old private data,
+	 * so the caller can free it.
+	 */
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(ioasid_detach_data);
+
 /**
  * ioasid_alloc - Allocate an IOASID
  * @set: the IOASID set
diff --git a/include/linux/ioasid.h b/include/linux/ioasid.h
index 60ea279802b8..f6e705f832f0 100644
--- a/include/linux/ioasid.h
+++ b/include/linux/ioasid.h
@@ -41,7 +41,7 @@ void *ioasid_find(struct ioasid_set *set, ioasid_t ioasid,
 int ioasid_register_allocator(struct ioasid_allocator_ops *allocator);
 void ioasid_unregister_allocator(struct ioasid_allocator_ops *allocator);
 int ioasid_attach_data(ioasid_t ioasid, void *data);
-
+void ioasid_detach_data(ioasid_t ioasid);
 #else /* !CONFIG_IOASID */
 static inline ioasid_t ioasid_alloc(struct ioasid_set *set, ioasid_t min,
 				    ioasid_t max, void *private)
@@ -78,5 +78,8 @@ static inline int ioasid_attach_data(ioasid_t ioasid, void *data)
 	return -ENOTSUPP;
 }
 
+static inline void ioasid_detach_data(ioasid_t ioasid)
+{
+}
 #endif /* CONFIG_IOASID */
 #endif /* __LINUX_IOASID_H */
-- 
2.25.1
