From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH 05/20] x86/sgx: Introduce unreclaimable EPC page lists
Date: Thu, 22 Sep 2022 10:10:42 -0700
Message-ID: <20220922171057.1236139-6-kristen@linux.intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663866934; x=1695402934;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UDz/+joCMOsr/E6xxinNXlAv/UogP8vf91LabdqMtoc=;
  b=hu+DqGiNgWVVBqPQUqlZoZnwzx51emQGWvl8fosYNc3n2EN/wnwuoGNg
   8/br2GViVc2+UzzqpnyLgEmEmmKk5LIx67qEq8EjA7ic/Fno0GzJTRNZr
   2FZb7J3PVp4HHBn4A9L4V4Kq5DKWr8jDvN/h+z/nMYpgNRWdOq2WEYG+K
   Dcf7d5413gbS8GWVnOKw6SMut8/aKwMP9i5vijTUjGkFwCgDON1uCnDtG
   DVcZK2m3KCLZLOIiHvzeW394ALgqEQSobNm/SNYLJ9iBETAyhAqgfjz8q
   cEiAPthAmTH+yLc5epo6GjXGNE+2BT9KVAtAl43HxyTuhqc1zPYT++9VD
   A==;
In-Reply-To: <20220922171057.1236139-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add code to keep track of pages that are not tracked by the reclaimer
in the LRU's "unreclaimable" list. When there is an OOM event and an
enclave must be OOM killed, the EPC pages which are not tracked by
the reclaimer can still be freed.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/encl.c  | 10 +++++++---
 arch/x86/kernel/cpu/sgx/ioctl.c | 11 +++++++----
 arch/x86/kernel/cpu/sgx/main.c  | 26 +++++++++++++++-----------
 arch/x86/kernel/cpu/sgx/sgx.h   |  7 ++++---
 arch/x86/kernel/cpu/sgx/virt.c  | 28 ++++++++++++++++++++--------
 5 files changed, 53 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index a18f1311b57d..ad611c06798f 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -252,6 +252,7 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 		epc_page = sgx_encl_eldu(&encl->secs, NULL);
 		if (IS_ERR(epc_page))
 			return ERR_CAST(epc_page);
+		sgx_record_epc_page(epc_page, 0);
 	}
 
 	epc_page = sgx_encl_eldu(entry, encl->secs.epc_page);
@@ -259,7 +260,7 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 		return ERR_CAST(epc_page);
 
 	encl->secs_child_cnt++;
-	sgx_mark_page_reclaimable(entry->epc_page);
+	sgx_record_epc_page(entry->epc_page, SGX_EPC_PAGE_RECLAIMER_TRACKED);
 
 	return entry;
 }
@@ -375,7 +376,7 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	encl_page->type = SGX_PAGE_TYPE_REG;
 	encl->secs_child_cnt++;
 
-	sgx_mark_page_reclaimable(encl_page->epc_page);
+	sgx_record_epc_page(encl_page->epc_page, SGX_EPC_PAGE_RECLAIMER_TRACKED);
 
 	phys_addr = sgx_get_epc_phys_addr(epc_page);
 	/*
@@ -687,7 +688,7 @@ void sgx_encl_release(struct kref *ref)
 			 * The page and its radix tree entry cannot be freed
 			 * if the page is being held by the reclaimer.
 			 */
-			if (sgx_unmark_page_reclaimable(entry->epc_page))
+			if (sgx_drop_epc_page(entry->epc_page))
 				continue;
 
 			sgx_encl_free_epc_page(entry->epc_page);
@@ -703,6 +704,7 @@ void sgx_encl_release(struct kref *ref)
 	xa_destroy(&encl->page_array);
 
 	if (!encl->secs_child_cnt && encl->secs.epc_page) {
+		sgx_drop_epc_page(encl->secs.epc_page);
 		sgx_encl_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 	}
@@ -711,6 +713,7 @@ void sgx_encl_release(struct kref *ref)
 		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 					   list);
 		list_del(&va_page->list);
+		sgx_drop_epc_page(va_page->epc_page);
 		sgx_encl_free_epc_page(va_page->epc_page);
 		kfree(va_page);
 	}
@@ -1218,6 +1221,7 @@ struct sgx_epc_page *sgx_alloc_va_page(struct sgx_encl *encl, bool reclaim)
 		sgx_encl_free_epc_page(epc_page);
 		return ERR_PTR(-EFAULT);
 	}
+	sgx_record_epc_page(epc_page, 0);
 
 	epc_page->owner = encl;
 
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 9a1bb3c3211a..aca80a3f38a1 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -48,6 +48,7 @@ void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page)
 	encl->page_cnt--;
 
 	if (va_page) {
+		sgx_drop_epc_page(va_page->epc_page);
 		sgx_encl_free_epc_page(va_page->epc_page);
 		list_del(&va_page->list);
 		kfree(va_page);
@@ -113,6 +114,8 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	encl->attributes = secs->attributes;
 	encl->attributes_mask = SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT | SGX_ATTR_KSS;
 
+	sgx_record_epc_page(encl->secs.epc_page, 0);
+
 	/* Set only after completion, as encl->lock has not been taken. */
 	set_bit(SGX_ENCL_CREATED, &encl->flags);
 
@@ -322,7 +325,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 			goto err_out;
 	}
 
-	sgx_mark_page_reclaimable(encl_page->epc_page);
+	sgx_record_epc_page(encl_page->epc_page, SGX_EPC_PAGE_RECLAIMER_TRACKED);
 	mutex_unlock(&encl->lock);
 	mmap_read_unlock(current->mm);
 	return ret;
@@ -958,7 +961,7 @@ static long sgx_enclave_modify_types(struct sgx_encl *encl,
 			 * Prevent page from being reclaimed while mutex
 			 * is released.
 			 */
-			if (sgx_unmark_page_reclaimable(entry->epc_page)) {
+			if (sgx_drop_epc_page(entry->epc_page)) {
 				ret = -EAGAIN;
 				goto out_entry_changed;
 			}
@@ -973,7 +976,7 @@ static long sgx_enclave_modify_types(struct sgx_encl *encl,
 
 			mutex_lock(&encl->lock);
 
-			sgx_mark_page_reclaimable(entry->epc_page);
+			sgx_record_epc_page(entry->epc_page, SGX_EPC_PAGE_RECLAIMER_TRACKED);
 		}
 
 		/* Change EPC type */
@@ -1130,7 +1133,7 @@ static long sgx_encl_remove_pages(struct sgx_encl *encl,
 			goto out_unlock;
 		}
 
-		if (sgx_unmark_page_reclaimable(entry->epc_page)) {
+		if (sgx_drop_epc_page(entry->epc_page)) {
 			ret = -EBUSY;
 			goto out_unlock;
 		}
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index af68dc1c677b..543bc5b20508 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -262,7 +262,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 			goto out;
 
 		sgx_encl_ewb(encl->secs.epc_page, &secs_backing);
-
+		sgx_drop_epc_page(encl->secs.epc_page);
 		sgx_encl_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 
@@ -495,31 +495,35 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
 }
 
 /**
- * sgx_mark_page_reclaimable() - Mark a page as reclaimable
+ * sgx_record_epc_page() - Add a page to the LRU tracking
  * @page:	EPC page
  *
- * Mark a page as reclaimable and add it to the active page list. Pages
- * are automatically removed from the active list when freed.
+ * Mark a page with the specified flags and add it to the appropriate
+ * (un)reclaimable list.
  */
-void sgx_mark_page_reclaimable(struct sgx_epc_page *page)
+void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags)
 {
 	spin_lock(&sgx_global_lru.lock);
-	page->flags |= SGX_EPC_PAGE_RECLAIMER_TRACKED;
-	list_add_tail(&page->list, &sgx_global_lru.reclaimable);
+	WARN_ON(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
+	page->flags |= flags;
+	if (flags & SGX_EPC_PAGE_RECLAIMER_TRACKED)
+		list_add_tail(&page->list, &sgx_global_lru.reclaimable);
+	else
+		list_add_tail(&page->list, &sgx_global_lru.unreclaimable);
 	spin_unlock(&sgx_global_lru.lock);
 }
 
 /**
- * sgx_unmark_page_reclaimable() - Remove a page from the reclaim list
+ * sgx_drop_epc_page() - Remove a page from a LRU list
  * @page:	EPC page
  *
- * Clear the reclaimable flag and remove the page from the active page list.
+ * Clear the reclaimable flag if set and remove the page from its LRU.
  *
  * Return:
  *   0 on success,
  *   -EBUSY if the page is in the process of being reclaimed
  */
-int sgx_unmark_page_reclaimable(struct sgx_epc_page *page)
+int sgx_drop_epc_page(struct sgx_epc_page *page)
 {
 	spin_lock(&sgx_global_lru.lock);
 	if (page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED) {
@@ -529,9 +533,9 @@ int sgx_unmark_page_reclaimable(struct sgx_epc_page *page)
 			return -EBUSY;
 		}
 
-		list_del(&page->list);
 		page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
 	}
+	list_del(&page->list);
 	spin_unlock(&sgx_global_lru.lock);
 
 	return 0;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 7b208ee8eb45..65625ea8fd6e 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -86,20 +86,21 @@ static inline void *sgx_get_epc_virt_addr(struct sgx_epc_page *page)
 struct sgx_epc_lru {
 	spinlock_t lock;
 	struct list_head reclaimable;
+	struct list_head unreclaimable;
 };
 
 static inline void sgx_lru_init(struct sgx_epc_lru *lru)
 {
 	spin_lock_init(&lru->lock);
 	INIT_LIST_HEAD(&lru->reclaimable);
+	INIT_LIST_HEAD(&lru->unreclaimable);
 }
 
 struct sgx_epc_page *__sgx_alloc_epc_page(void);
 void sgx_free_epc_page(struct sgx_epc_page *page);
-
 void sgx_reclaim_direct(void);
-void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
-int sgx_unmark_page_reclaimable(struct sgx_epc_page *page);
+void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags);
+int sgx_drop_epc_page(struct sgx_epc_page *page);
 struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
 
 void sgx_ipi_cb(void *info);
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 6a77a14eee38..287e235bc3c1 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -62,6 +62,8 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
 		goto err_delete;
 	}
 
+	sgx_record_epc_page(epc_page, 0);
+
 	return 0;
 
 err_delete:
@@ -146,6 +148,7 @@ static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
 		return ret;
 	}
 
+	sgx_drop_epc_page(epc_page);
 	sgx_free_epc_page(epc_page);
 	return 0;
 }
@@ -218,8 +221,15 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
 		 * have been removed, the SECS page must have a child on
 		 * another instance.
 		 */
-		if (sgx_vepc_free_page(epc_page))
+		if (sgx_vepc_free_page(epc_page)) {
+			/*
+			 * Drop the page before adding it to the list of SECS
+			 * pages.  Moving the page off the unreclaimable list
+			 * needs to be done under the LRU's spinlock.
+			 */
+			sgx_drop_epc_page(epc_page);
 			list_add_tail(&epc_page->list, &secs_pages);
+		}
 
 		xa_erase(&vepc->page_array, index);
 	}
@@ -234,15 +244,17 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
 	mutex_lock(&zombie_secs_pages_lock);
 	list_for_each_entry_safe(epc_page, tmp, &zombie_secs_pages, list) {
 		/*
-		 * Speculatively remove the page from the list of zombies,
-		 * if the page is successfully EREMOVE'd it will be added to
-		 * the list of free pages.  If EREMOVE fails, throw the page
-		 * on the local list, which will be spliced on at the end.
+		 * If EREMOVE fails, throw the page on the local list, which
+		 * will be spliced on at the end.
+		 *
+		 * Note, this abuses sgx_drop_epc_page() to delete the page off
+		 * the list of zombies, but this is a very rare path (probably
+		 * never hit in production).  It's not worth special casing the
+		 * free path for this super rare case just to avoid taking the
+		 * LRU's spinlock.
 		 */
-		list_del(&epc_page->list);
-
 		if (sgx_vepc_free_page(epc_page))
-			list_add_tail(&epc_page->list, &secs_pages);
+			list_move_tail(&epc_page->list, &secs_pages);
 	}
 
 	if (!list_empty(&secs_pages))
-- 
2.37.3

