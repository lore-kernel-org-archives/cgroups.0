From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH V4 08/18] iommu/ioasid: Introduce ioasid_set private ID
Date: Sat, 27 Feb 2021 14:01:16 -0800
Message-ID: <1614463286-97618-9-git-send-email-jacob.jun.pan@linux.intel.com>
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

When an IOASID set is used for guest SVA, each VM will acquire its
ioasid_set for IOASID allocations. IOASIDs within the VM must have a
host/physical IOASID backing, mapping between guest and host IOASIDs can
be non-identical. IOASID set private ID (SPID) is introduced in this
patch to be used as guest IOASID. However, the concept of ioasid_set
specific namespace is generic, thus named SPID.

As SPID namespace is within the IOASID set, the IOASID core can provide
lookup services at both directions. SPIDs may not be available when its
IOASID is allocated, the mapping between SPID and IOASID is usually
established when a guest page table is bound to a host PASID.

Signed-off-by: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/iommu/ioasid.c | 104 +++++++++++++++++++++++++++++++++++++++++
 include/linux/ioasid.h |  18 +++++++
 2 files changed, 122 insertions(+)

diff --git a/drivers/iommu/ioasid.c b/drivers/iommu/ioasid.c
index 9a3ba157dec3..7707bb608bdd 100644
--- a/drivers/iommu/ioasid.c
+++ b/drivers/iommu/ioasid.c
@@ -26,6 +26,7 @@ enum ioasid_state {
  * struct ioasid_data - Meta data about ioasid
  *
  * @id:		Unique ID
+ * @spid:	Private ID unique within a set
  * @refs:	Number of active users
  * @state:	Track state of the IOASID
  * @set:	ioasid_set of the IOASID belongs to
@@ -34,6 +35,7 @@ enum ioasid_state {
  */
 struct ioasid_data {
 	ioasid_t id;
+	ioasid_t spid;
 	enum ioasid_state state;
 	struct ioasid_set *set;
 	void *private;
@@ -413,6 +415,107 @@ void ioasid_detach_data(ioasid_t ioasid)
 }
 EXPORT_SYMBOL_GPL(ioasid_detach_data);
 
+static ioasid_t ioasid_find_by_spid_locked(struct ioasid_set *set, ioasid_t spid, bool get)
+{
+	ioasid_t ioasid = INVALID_IOASID;
+	struct ioasid_data *entry;
+	unsigned long index;
+
+	if (!xa_load(&ioasid_sets, set->id)) {
+		pr_warn("Invalid set\n");
+		goto done;
+	}
+
+	xa_for_each(&set->xa, index, entry) {
+		if (spid == entry->spid) {
+			if (get)
+				refcount_inc(&entry->refs);
+			ioasid = index;
+		}
+	}
+done:
+	return ioasid;
+}
+
+/**
+ * ioasid_attach_spid - Attach ioasid_set private ID to an IOASID
+ *
+ * @ioasid: the system-wide IOASID to attach
+ * @spid:   the ioasid_set private ID of @ioasid
+ *
+ * After attching SPID, future lookup can be done via ioasid_find_by_spid().
+ */
+int ioasid_attach_spid(ioasid_t ioasid, ioasid_t spid)
+{
+	struct ioasid_data *data;
+	int ret = 0;
+
+	if (spid == INVALID_IOASID)
+		return -EINVAL;
+
+	spin_lock(&ioasid_allocator_lock);
+	data = xa_load(&active_allocator->xa, ioasid);
+
+	if (!data) {
+		pr_err("No IOASID entry %d to attach SPID %d\n",
+			ioasid, spid);
+		ret = -ENOENT;
+		goto done_unlock;
+	}
+	/* Check if SPID is unique within the set */
+	if (ioasid_find_by_spid_locked(data->set, spid, false) != INVALID_IOASID) {
+		ret = -EINVAL;
+		goto done_unlock;
+	}
+	data->spid = spid;
+
+done_unlock:
+	spin_unlock(&ioasid_allocator_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ioasid_attach_spid);
+
+void ioasid_detach_spid(ioasid_t ioasid)
+{
+	struct ioasid_data *data;
+
+	spin_lock(&ioasid_allocator_lock);
+	data = xa_load(&active_allocator->xa, ioasid);
+
+	if (!data || data->spid == INVALID_IOASID) {
+		pr_err("Invalid IOASID entry %d to detach\n", ioasid);
+		goto done_unlock;
+	}
+	data->spid = INVALID_IOASID;
+
+done_unlock:
+	spin_unlock(&ioasid_allocator_lock);
+}
+EXPORT_SYMBOL_GPL(ioasid_detach_spid);
+
+/**
+ * ioasid_find_by_spid - Find the system-wide IOASID by a set private ID and
+ * its set.
+ *
+ * @set:	the ioasid_set to search within
+ * @spid:	the set private ID
+ * @get:	flag indicates whether to take a reference once found
+ *
+ * Given a set private ID and its IOASID set, find the system-wide IOASID. Take
+ * a reference upon finding the matching IOASID if @get is true. Return
+ * INVALID_IOASID if the IOASID is not found in the set or the set is not valid.
+ */
+ioasid_t ioasid_find_by_spid(struct ioasid_set *set, ioasid_t spid, bool get)
+{
+	ioasid_t ioasid;
+
+	spin_lock(&ioasid_allocator_lock);
+	ioasid = ioasid_find_by_spid_locked(set, spid, get);
+	spin_unlock(&ioasid_allocator_lock);
+	return ioasid;
+}
+EXPORT_SYMBOL_GPL(ioasid_find_by_spid);
+
 static inline bool ioasid_set_is_valid(struct ioasid_set *set)
 {
 	return xa_load(&ioasid_sets, set->id) == set;
@@ -616,6 +719,7 @@ ioasid_t ioasid_alloc(struct ioasid_set *set, ioasid_t min, ioasid_t max,
 	}
 	data->id = id;
 	data->state = IOASID_STATE_IDLE;
+	data->spid = INVALID_IOASID;
 
 	/* Store IOASID in the per set data */
 	if (xa_err(xa_store(&set->xa, id, data, GFP_ATOMIC))) {
diff --git a/include/linux/ioasid.h b/include/linux/ioasid.h
index e7f3e6108724..dcab02886cb5 100644
--- a/include/linux/ioasid.h
+++ b/include/linux/ioasid.h
@@ -81,6 +81,9 @@ int ioasid_register_allocator(struct ioasid_allocator_ops *allocator);
 void ioasid_unregister_allocator(struct ioasid_allocator_ops *allocator);
 int ioasid_attach_data(ioasid_t ioasid, void *data);
 void ioasid_detach_data(ioasid_t ioasid);
+int ioasid_attach_spid(ioasid_t ioasid, ioasid_t spid);
+void ioasid_detach_spid(ioasid_t ioasid);
+ioasid_t ioasid_find_by_spid(struct ioasid_set *set, ioasid_t spid, bool get);
 void ioasid_set_for_each_ioasid(struct ioasid_set *sdata,
 				void (*fn)(ioasid_t id, void *data),
 				void *data);
@@ -173,6 +176,21 @@ static inline struct ioasid_set *ioasid_find_set(ioasid_t ioasid)
 	return ERR_PTR(-ENOTSUPP);
 }
 
+static inline int ioasid_attach_spid(ioasid_t ioasid, ioasid_t spid)
+{
+	return -ENOTSUPP;
+}
+
+static inline void ioasid_detach_spid(ioasid_t ioasid)
+{
+}
+
+static inline ioasid_t ioasid_find_by_spid(struct ioasid_set *set,
+					   ioasid_t spid, bool get)
+{
+	return INVALID_IOASID;
+}
+
 static inline void ioasid_set_for_each_ioasid(struct ioasid_set *sdata,
 					      void (*fn)(ioasid_t id, void *data),
 					      void *data)
-- 
2.25.1
