From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH V4 11/18] iommu/ioasid: Add ownership check in guest bind
Date: Sat, 27 Feb 2021 14:01:19 -0800
Message-ID: <1614463286-97618-12-git-send-email-jacob.jun.pan@linux.intel.com>
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

Bind guest page table call comes with an IOASID provided by the
userspace.  To prevent attacks by malicious users, we must ensure the
IOASID was allocated under the same process.

This patch adds a new API that will perform an ownership check that is
based on whether the IOASID belongs to the ioasid_set allocated with the
mm_struct pointer as a token.

Signed-off-by: Liu Yi L <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/iommu/ioasid.c | 37 +++++++++++++++++++++++++++++++++++++
 drivers/iommu/iommu.c  | 16 ++++++++++++++--
 include/linux/ioasid.h |  6 ++++++
 3 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/ioasid.c b/drivers/iommu/ioasid.c
index 96e941dfada7..28a2e9b6594d 100644
--- a/drivers/iommu/ioasid.c
+++ b/drivers/iommu/ioasid.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/xarray.h>
+#include <linux/sched/mm.h>
 
 /*
  * An IOASID can have multiple consumers where each consumer may have
@@ -1028,6 +1029,42 @@ int ioasid_get(struct ioasid_set *set, ioasid_t ioasid)
 }
 EXPORT_SYMBOL_GPL(ioasid_get);
 
+/**
+ * ioasid_get_if_owned - obtain a reference to the IOASID if the IOASID belongs
+ * 		to the ioasid_set with the current mm as token
+ * @ioasid:	the IOASID to get reference
+ *
+ *
+ * Return: 0 on success, error if failed.
+ */
+int ioasid_get_if_owned(ioasid_t ioasid)
+{
+	struct ioasid_set *set;
+	int ret;
+
+	spin_lock(&ioasid_allocator_lock);
+	set = ioasid_find_set(ioasid);
+	if (IS_ERR_OR_NULL(set)) {
+		ret = -ENOENT;
+		goto done_unlock;
+	}
+	if (set->type != IOASID_SET_TYPE_MM) {
+		ret = -EINVAL;
+		goto done_unlock;
+	}
+	if (current->mm != set->token) {
+		ret = -EPERM;
+		goto done_unlock;
+	}
+
+	ret = ioasid_get_locked(set, ioasid);
+done_unlock:
+	spin_unlock(&ioasid_allocator_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ioasid_get_if_owned);
+
 bool ioasid_put_locked(struct ioasid_set *set, ioasid_t ioasid)
 {
 	struct ioasid_data *data;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index fd76e2f579fe..18716d856b02 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2169,7 +2169,13 @@ int iommu_uapi_sva_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 	if (ret)
 		return ret;
 
-	return domain->ops->sva_bind_gpasid(domain, dev, &data);
+	ret = ioasid_get_if_owned(data.hpasid);
+	if (ret)
+		return ret;
+	ret = domain->ops->sva_bind_gpasid(domain, dev, &data);
+	ioasid_put(NULL, data.hpasid);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_uapi_sva_bind_gpasid);
 
@@ -2196,7 +2202,13 @@ int iommu_uapi_sva_unbind_gpasid(struct iommu_domain *domain, struct device *dev
 	if (ret)
 		return ret;
 
-	return iommu_sva_unbind_gpasid(domain, dev, data.hpasid);
+	ret = ioasid_get_if_owned(data.hpasid);
+	if (ret)
+		return ret;
+	ret = iommu_sva_unbind_gpasid(domain, dev, data.hpasid);
+	ioasid_put(NULL, data.hpasid);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_uapi_sva_unbind_gpasid);
 
diff --git a/include/linux/ioasid.h b/include/linux/ioasid.h
index c97e80ff65cc..9624b665f810 100644
--- a/include/linux/ioasid.h
+++ b/include/linux/ioasid.h
@@ -111,6 +111,7 @@ ioasid_t ioasid_alloc(struct ioasid_set *set, ioasid_t min, ioasid_t max,
 		      void *private);
 int ioasid_get(struct ioasid_set *set, ioasid_t ioasid);
 int ioasid_get_locked(struct ioasid_set *set, ioasid_t ioasid);
+int ioasid_get_if_owned(ioasid_t ioasid);
 bool ioasid_put(struct ioasid_set *set, ioasid_t ioasid);
 bool ioasid_put_locked(struct ioasid_set *set, ioasid_t ioasid);
 void ioasid_free(struct ioasid_set *set, ioasid_t ioasid);
@@ -180,6 +181,11 @@ static inline int ioasid_get_locked(struct ioasid_set *set, ioasid_t ioasid)
 	return -ENOTSUPP;
 }
 
+static inline int ioasid_get_if_owned(ioasid_t ioasid)
+{
+	return -ENOTSUPP;
+}
+
 static inline bool ioasid_put(struct ioasid_set *set, ioasid_t ioasid)
 {
 	return false;
-- 
2.25.1
