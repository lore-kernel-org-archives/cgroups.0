From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH V4 13/18] iommu/ioasid: Add a workqueue for cleanup work
Date: Sat, 27 Feb 2021 14:01:21 -0800
Message-ID: <1614463286-97618-14-git-send-email-jacob.jun.pan@linux.intel.com>
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

An IOASID can have multiple users, such as IOMMU driver, KVM, and device
drivers.   The atomic IOASID notifier is used to inform users of IOASID
state change. For example, the IOASID_NOTIFY_UNBIND event is issued when
the IOASID is no longer bound to an address space. This requires ordered
actions among users to tear down their contexts.

Not all work can be handled in the atomic notifier handler. This patch
introduces a shared, ordered workqueue for all IOASID users who wish to
perform work asynchronously upon notification.

Signed-off-by: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/iommu/ioasid.c | 25 +++++++++++++++++++++++++
 include/linux/ioasid.h |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/iommu/ioasid.c b/drivers/iommu/ioasid.c
index 28a2e9b6594d..d42b39ca2c8b 100644
--- a/drivers/iommu/ioasid.c
+++ b/drivers/iommu/ioasid.c
@@ -32,6 +32,9 @@ static ioasid_t ioasid_capacity = PCI_PASID_MAX;
 static ioasid_t ioasid_capacity_avail = PCI_PASID_MAX;
 static DEFINE_XARRAY_ALLOC(ioasid_sets);
 
+/* Workqueue for IOASID users to do cleanup upon notification */
+static struct workqueue_struct *ioasid_wq;
+
 struct ioasid_set_nb {
 	struct list_head	list;
 	struct notifier_block	*nb;
@@ -1281,6 +1284,12 @@ int ioasid_register_notifier_mm(struct mm_struct *mm, struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(ioasid_register_notifier_mm);
 
+bool ioasid_queue_work(struct work_struct *work)
+{
+	return queue_work(ioasid_wq, work);
+}
+EXPORT_SYMBOL_GPL(ioasid_queue_work);
+
 void ioasid_unregister_notifier_mm(struct mm_struct *mm, struct notifier_block *nb)
 {
 	struct ioasid_set_nb *curr;
@@ -1303,7 +1312,23 @@ void ioasid_unregister_notifier_mm(struct mm_struct *mm, struct notifier_block *
 }
 EXPORT_SYMBOL_GPL(ioasid_unregister_notifier_mm);
 
+static int __init ioasid_init(void)
+{
+	ioasid_wq = alloc_ordered_workqueue("ioasid_wq", 0);
+	if (!ioasid_wq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void __exit ioasid_cleanup(void)
+{
+	destroy_workqueue(ioasid_wq);
+}
+
 MODULE_AUTHOR("Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>");
 MODULE_AUTHOR("Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>");
 MODULE_DESCRIPTION("IO Address Space ID (IOASID) allocator");
 MODULE_LICENSE("GPL");
+module_init(ioasid_init);
+module_exit(ioasid_cleanup);
diff --git a/include/linux/ioasid.h b/include/linux/ioasid.h
index 9624b665f810..4547086797df 100644
--- a/include/linux/ioasid.h
+++ b/include/linux/ioasid.h
@@ -135,6 +135,7 @@ void ioasid_set_for_each_ioasid(struct ioasid_set *sdata,
 				void *data);
 int ioasid_register_notifier_mm(struct mm_struct *mm, struct notifier_block *nb);
 void ioasid_unregister_notifier_mm(struct mm_struct *mm, struct notifier_block *nb);
+bool ioasid_queue_work(struct work_struct *work);
 #else /* !CONFIG_IOASID */
 static inline void ioasid_install_capacity(ioasid_t total)
 {
-- 
2.25.1
