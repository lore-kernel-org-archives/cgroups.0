From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH V4 04/18] iommu/ioasid: Support setting system-wide capacity
Date: Sat, 27 Feb 2021 14:01:12 -0800
Message-ID: <1614463286-97618-5-git-send-email-jacob.jun.pan@linux.intel.com>
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

IOASID is a system-wide resource that could vary on different systems.
The default capacity is 20 bits as defined in the PCI-E specifications.
This patch adds a function to allow adjusting system IOASID capacity.
For VT-d this is set during boot as part of the Intel IOMMU
initialization. APIs also added to support runtime capacity reservation,
potentially by cgroups.

Signed-off-by: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/iommu/intel/iommu.c |  5 +++
 drivers/iommu/ioasid.c      | 70 +++++++++++++++++++++++++++++++++++++
 include/linux/ioasid.h      | 18 ++++++++++
 3 files changed, 93 insertions(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index f665322a0991..6f42ff7d171d 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -41,6 +41,7 @@
 #include <linux/dma-direct.h>
 #include <linux/crash_dump.h>
 #include <linux/numa.h>
+#include <linux/ioasid.h>
 #include <asm/irq_remapping.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
@@ -3298,6 +3299,10 @@ static int __init init_dmars(void)
 	if (ret)
 		goto free_iommu;
 
+	/* PASID is needed for scalable mode irrespective to SVM */
+	if (intel_iommu_sm)
+		ioasid_install_capacity(intel_pasid_max_id);
+
 	/*
 	 * for each drhd
 	 *   enable fault log
diff --git a/drivers/iommu/ioasid.c b/drivers/iommu/ioasid.c
index 4eb9b3dd1b85..28681b99340b 100644
--- a/drivers/iommu/ioasid.c
+++ b/drivers/iommu/ioasid.c
@@ -10,6 +10,10 @@
 #include <linux/spinlock.h>
 #include <linux/xarray.h>
 
+/* Default to PCIe standard 20 bit PASID */
+#define PCI_PASID_MAX 0x100000
+static ioasid_t ioasid_capacity = PCI_PASID_MAX;
+static ioasid_t ioasid_capacity_avail = PCI_PASID_MAX;
 struct ioasid_data {
 	ioasid_t id;
 	struct ioasid_set *set;
@@ -258,6 +262,72 @@ void ioasid_unregister_allocator(struct ioasid_allocator_ops *ops)
 }
 EXPORT_SYMBOL_GPL(ioasid_unregister_allocator);
 
+void ioasid_install_capacity(ioasid_t total)
+{
+	spin_lock(&ioasid_allocator_lock);
+	if (ioasid_capacity && ioasid_capacity != PCI_PASID_MAX) {
+		pr_warn("IOASID capacity is already set.\n");
+		goto done_unlock;
+	}
+	ioasid_capacity = ioasid_capacity_avail = total;
+done_unlock:
+	spin_unlock(&ioasid_allocator_lock);
+}
+EXPORT_SYMBOL_GPL(ioasid_install_capacity);
+
+/**
+ * @brief Reserve capacity from the system pool
+ *
+ * @param nr_ioasid Number of IOASIDs requested to be reserved, 0 means
+ *	reserve all remaining IDs.
+ *
+ * @return the remaining capacity on success, or errno
+ */
+int ioasid_reserve_capacity(ioasid_t nr_ioasid)
+{
+	int ret = 0;
+
+	spin_lock(&ioasid_allocator_lock);
+	if (nr_ioasid > ioasid_capacity_avail) {
+		ret = -ENOSPC;
+		goto done_unlock;
+	}
+	if (!nr_ioasid)
+		nr_ioasid = ioasid_capacity_avail;
+	ioasid_capacity_avail -= nr_ioasid;
+	ret = nr_ioasid;
+done_unlock:
+	spin_unlock(&ioasid_allocator_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ioasid_reserve_capacity);
+
+/**
+ * @brief Return capacity to the system pool
+ * 	We trust the caller not to return more than it has reserved, we could
+ * 	also track reservation if needed.
+ *
+ * @param nr_ioasid Number of IOASIDs requested to be returned
+ *
+ * @return the remaining capacity on success, or errno
+ */
+int ioasid_cancel_capacity(ioasid_t nr_ioasid)
+{
+	int ret = 0;
+
+	spin_lock(&ioasid_allocator_lock);
+	if (nr_ioasid + ioasid_capacity_avail > ioasid_capacity) {
+		ret = -EINVAL;
+		goto done_unlock;
+	}
+	ioasid_capacity_avail += nr_ioasid;
+	ret = ioasid_capacity_avail;
+done_unlock:
+	spin_unlock(&ioasid_allocator_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ioasid_cancel_capacity);
+
 /**
  * ioasid_attach_data - Set private data for an allocated ioasid
  * @ioasid: the ID to set data
diff --git a/include/linux/ioasid.h b/include/linux/ioasid.h
index f6e705f832f0..2780bdc84b94 100644
--- a/include/linux/ioasid.h
+++ b/include/linux/ioasid.h
@@ -32,6 +32,10 @@ struct ioasid_allocator_ops {
 #define DECLARE_IOASID_SET(name) struct ioasid_set name = { 0 }
 
 #if IS_ENABLED(CONFIG_IOASID)
+void ioasid_install_capacity(ioasid_t total);
+int ioasid_reserve_capacity(ioasid_t nr_ioasid);
+int ioasid_cancel_capacity(ioasid_t nr_ioasid);
+
 ioasid_t ioasid_alloc(struct ioasid_set *set, ioasid_t min, ioasid_t max,
 		      void *private);
 void ioasid_get(ioasid_t ioasid);
@@ -43,6 +47,20 @@ void ioasid_unregister_allocator(struct ioasid_allocator_ops *allocator);
 int ioasid_attach_data(ioasid_t ioasid, void *data);
 void ioasid_detach_data(ioasid_t ioasid);
 #else /* !CONFIG_IOASID */
+static inline void ioasid_install_capacity(ioasid_t total)
+{
+}
+
+static inline int ioasid_reserve_capacity(ioasid_t nr_ioasid)
+{
+	return -ENOSPC;
+}
+
+static inline int ioasid_cancel_capacity(ioasid_t nr_ioasid)
+{
+	return -EINVAL;
+}
+
 static inline ioasid_t ioasid_alloc(struct ioasid_set *set, ioasid_t min,
 				    ioasid_t max, void *private)
 {
-- 
2.25.1
