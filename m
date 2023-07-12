From: Haitao Huang <haitao.huang@linux.intel.com>
Subject: [PATCH v3 05/28] x86/sgx: Store reclaimable epc pages in sgx_epc_lru_lists
Date: Wed, 12 Jul 2023 16:01:39 -0700
Message-ID: <20230712230202.47929-6-haitao.huang@linux.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689202928; x=1720738928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=chkYgAsoYzG4KCqvu3JEl3d42kseLyS4qIMTUoOAaz0=;
  b=E5HaPGmKN1qS2XMkSO2yWN/kgfnrkwU4vrWWUmspMclQLDKiK4j1Ixb/
   IzzI4+PzJRdwU503A7aqDlao3RlWqw2635FxaCSkuTLQXu6AbbjTGW2Q3
   k+4uIFU4T+2COipzGWA5KZlOYuPkJCva401oVFqAcX616IAc5kZwL3HBT
   vQK2xEPnnMaIU8zSX8c3hI26YiOv/e3XbSDkidJycwWXwU5/9jqn2ZONi
   pahAp3bkaD+hwFscPWzWweM1QO9KG62lz+Piwq9eLYqgF31igyCtyUcwX
   ySQZKsByq87XqsTgtMFruOiBjgIi3W8jQnfqYtAbg+zOA/Y2ZP0KogdE2
   A==;
In-Reply-To: <20230712230202.47929-1-haitao.huang@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko@kernel.org, dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: kai.huang@intel.com, reinette.chatre@intel.com, Kristen Carlson Accardi <kristen@linux.intel.com>, zhiquan1.li@intel.com, seanjc@google.com

From: Kristen Carlson Accardi <kristen@linux.intel.com>

When an OOM event occurs, it becomes necessary to free all pages
associated with an enclave, including those not currently tracked by the
reclaimer. As a result, each page must eventually be added to the
cgroup's LRU list struct, regardless of whether it is tracked by the
reclaimer or not.

This patch prepares for the inclusion of currently untracked pages by
replacing the functions sgx_mark_page_reclaimable() and
sgx_unmark_page_reclaimable() with sgx_record_epc_page() and
sgx_drop_epc_page(). The sgx_record_epc_page() function adds the
epc_page to the "reclaimable" list in the sgx_epc_lru_lists struct,
while sgx_drop_epc_page() removes the page from the LRU list.

For now, this change serves as a straightforward replacement of the two
functions for pages tracked by the reclaimer. A subsequent patch will
introduce the capability to track unreclaimable pages using these same
functions.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/cpu/sgx/encl.c  | 10 +++++-----
 arch/x86/kernel/cpu/sgx/ioctl.c | 12 ++++++------
 arch/x86/kernel/cpu/sgx/main.c  | 22 ++++++++++++----------
 arch/x86/kernel/cpu/sgx/sgx.h   |  4 ++--
 4 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 3bc2f95b1da2..f68af9e37daa 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -260,8 +260,8 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 		return ERR_CAST(epc_page);
 
 	encl->secs_child_cnt++;
-	sgx_mark_page_reclaimable(entry->epc_page);
-	entry->epc_page->flags |= SGX_EPC_OWNER_ENCL_PAGE;
+	sgx_record_epc_page(epc_page, SGX_EPC_OWNER_ENCL_PAGE |
+			    SGX_EPC_PAGE_RECLAIMER_TRACKED);
 
 	return entry;
 }
@@ -380,8 +380,8 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	encl_page->type = SGX_PAGE_TYPE_REG;
 	encl->secs_child_cnt++;
 
-	sgx_mark_page_reclaimable(encl_page->epc_page);
-	encl_page->epc_page->flags |= SGX_EPC_OWNER_ENCL_PAGE;
+	sgx_record_epc_page(epc_page, SGX_EPC_OWNER_ENCL_PAGE |
+			    SGX_EPC_PAGE_RECLAIMER_TRACKED);
 
 	phys_addr = sgx_get_epc_phys_addr(epc_page);
 	/*
@@ -697,7 +697,7 @@ void sgx_encl_release(struct kref *ref)
 			 * The page and its radix tree entry cannot be freed
 			 * if the page is being held by the reclaimer.
 			 */
-			if (sgx_unmark_page_reclaimable(entry->epc_page))
+			if (sgx_drop_epc_page(entry->epc_page))
 				continue;
 
 			sgx_encl_free_epc_page(entry->epc_page);
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index fe3e89cf013f..dd7ab1c80db6 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -324,8 +324,8 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 			goto err_out;
 	}
 
-	sgx_mark_page_reclaimable(encl_page->epc_page);
-	encl_page->epc_page->flags |= SGX_EPC_OWNER_ENCL_PAGE;
+	sgx_record_epc_page(epc_page, SGX_EPC_OWNER_ENCL_PAGE |
+			    SGX_EPC_PAGE_RECLAIMER_TRACKED);
 	mutex_unlock(&encl->lock);
 	mmap_read_unlock(current->mm);
 	return ret;
@@ -964,7 +964,7 @@ static long sgx_enclave_modify_types(struct sgx_encl *encl,
 			 * Prevent page from being reclaimed while mutex
 			 * is released.
 			 */
-			if (sgx_unmark_page_reclaimable(entry->epc_page)) {
+			if (sgx_drop_epc_page(entry->epc_page)) {
 				ret = -EAGAIN;
 				goto out_entry_changed;
 			}
@@ -979,8 +979,8 @@ static long sgx_enclave_modify_types(struct sgx_encl *encl,
 
 			mutex_lock(&encl->lock);
 
-			sgx_mark_page_reclaimable(entry->epc_page);
-			entry->epc_page->flags |= SGX_EPC_OWNER_ENCL_PAGE;
+			sgx_record_epc_page(entry->epc_page, SGX_EPC_OWNER_ENCL_PAGE |
+					    SGX_EPC_PAGE_RECLAIMER_TRACKED);
 		}
 
 		/* Change EPC type */
@@ -1137,7 +1137,7 @@ static long sgx_encl_remove_pages(struct sgx_encl *encl,
 			goto out_unlock;
 		}
 
-		if (sgx_unmark_page_reclaimable(entry->epc_page)) {
+		if (sgx_drop_epc_page(entry->epc_page)) {
 			ret = -EBUSY;
 			goto out_unlock;
 		}
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 71c3386ccf23..371135665ff7 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -268,7 +268,6 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 			goto out;
 
 		sgx_encl_ewb(encl->secs.epc_page, &secs_backing);
-
 		sgx_encl_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 
@@ -498,31 +497,34 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
 }
 
 /**
- * sgx_mark_page_reclaimable() - Mark a page as reclaimable
+ * sgx_record_epc_page() - Add a page to the appropriate LRU list
  * @page:	EPC page
+ * @flags:	The type of page that is being recorded
  *
- * Mark a page as reclaimable and add it to the active page list. Pages
- * are automatically removed from the active list when freed.
+ * Mark a page with the specified flags and add it to the appropriate
+ * list.
  */
-void sgx_mark_page_reclaimable(struct sgx_epc_page *page)
+void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags)
 {
 	spin_lock(&sgx_global_lru.lock);
-	page->flags |= SGX_EPC_PAGE_RECLAIMER_TRACKED;
-	list_add_tail(&page->list, &sgx_global_lru.reclaimable);
+	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
+	page->flags |= flags;
+	if (flags & SGX_EPC_PAGE_RECLAIMER_TRACKED)
+		list_add_tail(&page->list, &sgx_global_lru.reclaimable);
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
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 77fceba73a25..c60bbd995942 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -113,8 +113,8 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void);
 void sgx_free_epc_page(struct sgx_epc_page *page);
 
 void sgx_reclaim_direct(void);
-void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
-int sgx_unmark_page_reclaimable(struct sgx_epc_page *page);
+void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags);
+int sgx_drop_epc_page(struct sgx_epc_page *page);
 struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
 
 void sgx_ipi_cb(void *info);
-- 
2.25.1

