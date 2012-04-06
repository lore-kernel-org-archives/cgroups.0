From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V5 03/14] hugetlbfs: Add an inline helper for finding hstate index
Date: Sat,  7 Apr 2012 00:20:49 +0530
Message-ID: <1333738260-1329-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1333738260-1329-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1333738260-1329-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Add an inline helper and use it in the code.

Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/linux/hugetlb.h |    6 ++++++
 mm/hugetlb.c            |   18 ++++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 000837e..876457e 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -294,6 +294,11 @@ static inline unsigned hstate_index_to_shift(unsigned index)
 	return hstates[index].order + PAGE_SHIFT;
 }
 
+static inline int hstate_index(struct hstate *h)
+{
+	return h - hstates;
+}
+
 #else
 struct hstate {};
 #define alloc_huge_page_node(h, nid) NULL
@@ -312,6 +317,7 @@ static inline unsigned int pages_per_huge_page(struct hstate *h)
 	return 1;
 }
 #define hstate_index_to_shift(index) 0
+#define hstate_index(h) 0
 #endif
 
 #endif /* _LINUX_HUGETLB_H */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5a472a5..d94c987 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1646,7 +1646,7 @@ static int hugetlb_sysfs_add_hstate(struct hstate *h, struct kobject *parent,
 				    struct attribute_group *hstate_attr_group)
 {
 	int retval;
-	int hi = h - hstates;
+	int hi = hstate_index(h);
 
 	hstate_kobjs[hi] = kobject_create_and_add(h->name, parent);
 	if (!hstate_kobjs[hi])
@@ -1741,11 +1741,13 @@ void hugetlb_unregister_node(struct node *node)
 	if (!nhs->hugepages_kobj)
 		return;		/* no hstate attributes */
 
-	for_each_hstate(h)
-		if (nhs->hstate_kobjs[h - hstates]) {
-			kobject_put(nhs->hstate_kobjs[h - hstates]);
-			nhs->hstate_kobjs[h - hstates] = NULL;
+	for_each_hstate(h) {
+		int idx = hstate_index(h);
+		if (nhs->hstate_kobjs[idx]) {
+			kobject_put(nhs->hstate_kobjs[idx]);
+			nhs->hstate_kobjs[idx] = NULL;
 		}
+	}
 
 	kobject_put(nhs->hugepages_kobj);
 	nhs->hugepages_kobj = NULL;
@@ -1848,7 +1850,7 @@ static void __exit hugetlb_exit(void)
 	hugetlb_unregister_all_nodes();
 
 	for_each_hstate(h) {
-		kobject_put(hstate_kobjs[h - hstates]);
+		kobject_put(hstate_kobjs[hstate_index(h)]);
 	}
 
 	kobject_put(hugepages_kobj);
@@ -2678,7 +2680,7 @@ retry:
 		 */
 		if (unlikely(PageHWPoison(page))) {
 			ret = VM_FAULT_HWPOISON |
-			      VM_FAULT_SET_HINDEX(h - hstates);
+				VM_FAULT_SET_HINDEX(hstate_index(h));
 			goto backout_unlocked;
 		}
 	}
@@ -2751,7 +2753,7 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			return 0;
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
 			return VM_FAULT_HWPOISON_LARGE |
-			       VM_FAULT_SET_HINDEX(h - hstates);
+				VM_FAULT_SET_HINDEX(hstate_index(h));
 	}
 
 	ptep = huge_pte_alloc(mm, address, huge_page_size(h));
-- 
1.7.10.rc3.3.g19a6c

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
