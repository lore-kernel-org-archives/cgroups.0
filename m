From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH V4 07/18] iommu/ioasid: Add ioasid_set iterator helper
 functions
Date: Sat, 27 Feb 2021 14:01:15 -0800
Message-ID: <1614463286-97618-8-git-send-email-jacob.jun.pan@linux.intel.com>
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

Users of an ioasid_set may not keep track of all the IOASIDs allocated
under the set. When collective actions are needed for each IOASIDs, it
is useful to iterate over all the IOASIDs within the set. For example,
when the ioasid_set is freed, the user might perform the same cleanup
operation on each IOASID.

This patch adds an API to iterate all the IOASIDs within the set.

Signed-off-by: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/iommu/ioasid.c | 84 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/ioasid.h | 20 ++++++++++
 2 files changed, 104 insertions(+)

diff --git a/drivers/iommu/ioasid.c b/drivers/iommu/ioasid.c
index a10f8154c680..9a3ba157dec3 100644
--- a/drivers/iommu/ioasid.c
+++ b/drivers/iommu/ioasid.c
@@ -700,6 +700,61 @@ void ioasid_free(struct ioasid_set *set, ioasid_t ioasid)
 	spin_unlock(&ioasid_allocator_lock);
 }
 EXPORT_SYMBOL_GPL(ioasid_free);
+
+/**
+ * ioasid_free_all_in_set
+ *
+ * @brief
+ * Free all PASIDs from system-wide IOASID pool, all subscribers gets
+ * notified and do cleanup of their own.
+ * Note that some references of the IOASIDs within the set can still
+ * be held after the free call. This is OK in that the IOASIDs will be
+ * marked inactive, the only operations can be done is ioasid_put.
+ * No need to track IOASID set states since there is no reclaim phase.
+ *
+ * @param
+ * struct ioasid_set where all IOASIDs within the set will be freed.
+ */
+void ioasid_free_all_in_set(struct ioasid_set *set)
+{
+	struct ioasid_data *entry;
+	unsigned long index;
+
+	if (!ioasid_set_is_valid(set))
+		return;
+
+	if (xa_empty(&set->xa))
+		return;
+
+	if (!atomic_read(&set->nr_ioasids))
+		return;
+	spin_lock(&ioasid_allocator_lock);
+	xa_for_each(&set->xa, index, entry) {
+		ioasid_free_locked(set, index);
+		/* Free from per set private pool */
+		xa_erase(&set->xa, index);
+	}
+	spin_unlock(&ioasid_allocator_lock);
+}
+EXPORT_SYMBOL_GPL(ioasid_free_all_in_set);
+
+/**
+ * ioasid_set_for_each_ioasid
+ * @brief
+ * Iterate over all the IOASIDs within the set
+ */
+void ioasid_set_for_each_ioasid(struct ioasid_set *set,
+				void (*fn)(ioasid_t id, void *data),
+				void *data)
+{
+	struct ioasid_data *entry;
+	unsigned long index;
+
+	xa_for_each(&set->xa, index, entry)
+		fn(index, data);
+}
+EXPORT_SYMBOL_GPL(ioasid_set_for_each_ioasid);
+
 int ioasid_get_locked(struct ioasid_set *set, ioasid_t ioasid)
 {
 	struct ioasid_data *data;
@@ -789,6 +844,35 @@ bool ioasid_put(struct ioasid_set *set, ioasid_t ioasid)
 }
 EXPORT_SYMBOL_GPL(ioasid_put);
 
+/**
+ * @brief
+ * Find the ioasid_set of an IOASID. As long as the IOASID is valid,
+ * the set must be valid since the refcounting is based on the number of IOASID
+ * in the set.
+ *
+ * @param ioasid
+ * @return struct ioasid_set*
+ */
+struct ioasid_set *ioasid_find_set(ioasid_t ioasid)
+{
+	struct ioasid_allocator_data *idata;
+	struct ioasid_data *ioasid_data;
+	struct ioasid_set *set = NULL;
+
+	rcu_read_lock();
+	idata = rcu_dereference(active_allocator);
+	ioasid_data = xa_load(&idata->xa, ioasid);
+	if (!ioasid_data) {
+		set = ERR_PTR(-ENOENT);
+		goto unlock;
+	}
+	set = ioasid_data->set;
+unlock:
+	rcu_read_unlock();
+	return set;
+}
+EXPORT_SYMBOL_GPL(ioasid_find_set);
+
 /**
  * ioasid_find - Find IOASID data
  * @set: the IOASID set
diff --git a/include/linux/ioasid.h b/include/linux/ioasid.h
index cabaf0b0348f..e7f3e6108724 100644
--- a/include/linux/ioasid.h
+++ b/include/linux/ioasid.h
@@ -73,12 +73,17 @@ int ioasid_get_locked(struct ioasid_set *set, ioasid_t ioasid);
 bool ioasid_put(struct ioasid_set *set, ioasid_t ioasid);
 bool ioasid_put_locked(struct ioasid_set *set, ioasid_t ioasid);
 void ioasid_free(struct ioasid_set *set, ioasid_t ioasid);
+void ioasid_free_all_in_set(struct ioasid_set *set);
 void *ioasid_find(struct ioasid_set *set, ioasid_t ioasid,
 		  bool (*getter)(void *));
+struct ioasid_set *ioasid_find_set(ioasid_t ioasid);
 int ioasid_register_allocator(struct ioasid_allocator_ops *allocator);
 void ioasid_unregister_allocator(struct ioasid_allocator_ops *allocator);
 int ioasid_attach_data(ioasid_t ioasid, void *data);
 void ioasid_detach_data(ioasid_t ioasid);
+void ioasid_set_for_each_ioasid(struct ioasid_set *sdata,
+				void (*fn)(ioasid_t id, void *data),
+				void *data);
 #else /* !CONFIG_IOASID */
 static inline void ioasid_install_capacity(ioasid_t total)
 {
@@ -158,5 +163,20 @@ static inline int ioasid_attach_data(ioasid_t ioasid, void *data)
 static inline void ioasid_detach_data(ioasid_t ioasid)
 {
 }
+
+static inline void ioasid_free_all_in_set(struct ioasid_set *set)
+{
+}
+
+static inline struct ioasid_set *ioasid_find_set(ioasid_t ioasid)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
+
+static inline void ioasid_set_for_each_ioasid(struct ioasid_set *sdata,
+					      void (*fn)(ioasid_t id, void *data),
+					      void *data)
+{
+}
 #endif /* CONFIG_IOASID */
 #endif /* __LINUX_IOASID_H */
-- 
2.25.1
