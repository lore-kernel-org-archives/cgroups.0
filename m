From: Mina Almasry <almasrymina@google.com>
Subject: [PATCH v8 7/9] hugetlb_cgroup: support noreserve mappings
Date: Tue, 29 Oct 2019 18:36:59 -0700
Message-ID: <20191030013701.39647-7-almasrymina@google.com>
References: <20191030013701.39647-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GL9Xhy7auTZAhL7LZXwL8avj9iHl4q0U3M40OgeObhE=;
        b=Mk9A2s+VDeLN9SO5/y6PDx1MOdEtWWd7Itp4QHrRujBXntkM/xloWXUcu0lUqVvCXV
         i4nWuGHCYOVdIy7S5tr5r7+TiWVjWOQ2HGriAa7K/btJY/cppsKtyf+oiDgW7PJCb6W6
         oGY8EEKEgxNuhJur1z2CEzO5VOC7fZrxhzrq3qIsLS9bA9HkaWvj6/HeDlI9Tl5sNUiV
         ktbhNgl23IZlPuI6GGuc/TFWaoMmd25kymPG0QrmvXFLSz8k1dv8+HPx4BtrezkRt3+p
         /Zokn/6vanoKP4GyVnlL+WVN9ydBxSByL0pTutxFrolB5gpbMs6qfj/47WWLFWLay934
         vkHA==
In-Reply-To: <20191030013701.39647-1-almasrymina@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mike.kravetz@oracle.com
Cc: shuah@kernel.org, almasrymina@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com

Support MAP_NORESERVE accounting as part of the new counter.

For each hugepage allocation, at allocation time we check if there is
a reservation for this allocation or not. If there is a reservation for
this allocation, then this allocation was charged at reservation time,
and we don't re-account it. If there is no reserevation for this
allocation, we charge the appropriate hugetlb_cgroup.

The hugetlb_cgroup to uncharge for this allocation is stored in
page[3].private. We use new APIs added in an earlier patch to set this
pointer.

Signed-off-by: Mina Almasry <almasrymina@google.com>

---
 mm/hugetlb.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 40f4b85de59c4..cb06b3d5bd4d7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1309,6 +1309,7 @@ static void update_and_free_page(struct hstate *h, struct page *page)
 				1 << PG_writeback);
 	}
 	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page(page, false), page);
+	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page(page, true), page);
 	set_compound_page_dtor(page, NULL_COMPOUND_DTOR);
 	set_page_refcounted(page);
 	if (hstate_is_gigantic(h)) {
@@ -1420,6 +1421,9 @@ void free_huge_page(struct page *page)
 	clear_page_huge_active(page);
 	hugetlb_cgroup_uncharge_page(hstate_index(h), pages_per_huge_page(h),
 				     page, false);
+	hugetlb_cgroup_uncharge_page(hstate_index(h), pages_per_huge_page(h),
+				     page, true);
+
 	if (restore_reserve)
 		h->resv_huge_pages++;

@@ -1446,6 +1450,7 @@ static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 	set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
 	spin_lock(&hugetlb_lock);
 	set_hugetlb_cgroup(page, NULL, false);
+	set_hugetlb_cgroup(page, NULL, true);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
 	spin_unlock(&hugetlb_lock);
@@ -2241,10 +2246,19 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 			gbl_chg = 1;
 	}

+	/* If this allocation is not consuming a reservation, charge it now.
+	 */
+	if (map_chg || avoid_reserve || !vma_resv_map(vma)) {
+		ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h),
+						   &h_cg, true);
+		if (ret)
+			goto out_subpool_put;
+	}
+
 	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg,
 					   false);
 	if (ret)
-		goto out_subpool_put;
+		goto out_uncharge_cgroup_reservation;

 	spin_lock(&hugetlb_lock);
 	/*
@@ -2268,6 +2282,11 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 	}
 	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page,
 				     false);
+	if (!vma_resv_map(vma) || map_chg || avoid_reserve) {
+		hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg,
+					     page, true);
+	}
+
 	spin_unlock(&hugetlb_lock);

 	set_page_private(page, (unsigned long)spool);
@@ -2293,6 +2312,10 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg,
 				       false);
+out_uncharge_cgroup_reservation:
+	if (map_chg || avoid_reserve || !vma_resv_map(vma))
+		hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h),
+					       h_cg, true);
 out_subpool_put:
 	if (map_chg || avoid_reserve)
 		hugepage_subpool_put_pages(spool, 1);
--
2.24.0.rc1.363.gb1bccd3e3d-goog
