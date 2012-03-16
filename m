From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V4 02/10] hugetlbfs: don't use ERR_PTR with VM_FAULT* values
Date: Fri, 16 Mar 2012 23:09:22 +0530
Message-ID: <1331919570-2264-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Using VM_FAULT_* codes with ERR_PTR will require us to make sure
VM_FAULT_* values will not exceed MAX_ERRNO value.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 mm/hugetlb.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d623e71..3782da8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1034,10 +1034,10 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	 */
 	chg = vma_needs_reservation(h, vma, addr);
 	if (chg < 0)
-		return ERR_PTR(-VM_FAULT_OOM);
+		return ERR_PTR(-ENOMEM);
 	if (chg)
 		if (hugetlb_get_quota(inode->i_mapping, chg))
-			return ERR_PTR(-VM_FAULT_SIGBUS);
+			return ERR_PTR(-ENOSPC);
 
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
@@ -1047,7 +1047,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
 		if (!page) {
 			hugetlb_put_quota(inode->i_mapping, chg);
-			return ERR_PTR(-VM_FAULT_SIGBUS);
+			return ERR_PTR(-ENOSPC);
 		}
 	}
 
@@ -2395,6 +2395,7 @@ retry_avoidcopy:
 	new_page = alloc_huge_page(vma, address, outside_reserve);
 
 	if (IS_ERR(new_page)) {
+		int err = PTR_ERR(new_page);
 		page_cache_release(old_page);
 
 		/*
@@ -2424,7 +2425,10 @@ retry_avoidcopy:
 
 		/* Caller expects lock to be held */
 		spin_lock(&mm->page_table_lock);
-		return -PTR_ERR(new_page);
+		if (err == -ENOMEM)
+			return VM_FAULT_OOM;
+		else
+			return VM_FAULT_SIGBUS;
 	}
 
 	/*
@@ -2542,7 +2546,11 @@ retry:
 			goto out;
 		page = alloc_huge_page(vma, address, 0);
 		if (IS_ERR(page)) {
-			ret = -PTR_ERR(page);
+			ret = PTR_ERR(page);
+			if (ret == -ENOMEM)
+				ret = VM_FAULT_OOM;
+			else
+				ret = VM_FAULT_SIGBUS;
 			goto out;
 		}
 		clear_huge_page(page, address, pages_per_huge_page(h));
-- 
1.7.9

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
