From: Haitao Huang <haitao.huang@linux.intel.com>
Subject: [PATCH v3 07/28] x86/sgx: Introduce EPC page states
Date: Wed, 12 Jul 2023 16:01:41 -0700
Message-ID: <20230712230202.47929-8-haitao.huang@linux.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689202930; x=1720738930;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f3mu4uIXArDYT21Apy+M3Wl9cTO7R4RRDcqW9oEa0ps=;
  b=LI+gcS5j0Ttgf57PoQR8Qmmpye52LKc2/VuweXwqyzG1Z5XkDFOc8b8e
   ZqGGJm3tlBdq+cVUA4eV46N9mnlsIGgzdNBd/k64iZDGW/JNQucZTovmJ
   2DhOlwDmcZChrFpbTeMFFTYiJ9p0fQpJXtR+8PIqSWaS+GGL8nkqtBUk1
   KbNvlO3kT7vTRVmNJ6VAO3141PspIq49fSepTqAIvNZGouRJcOYnpopMA
   0JJx+AcTvxnq/A6qsacTLI6/QwUt3dvTDkNZiVGIcU2hWz5sL+AeZ6H5/
   JT2QJ+DAYKoJeP9abtkpaOyKiyo1mrgGlCHfyY5VDLL8Q/PQ/gFycADbc
   Q==;
In-Reply-To: <20230712230202.47929-1-haitao.huang@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko@kernel.org, dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: kai.huang@intel.com, reinette.chatre@intel.com, zhiquan1.li@intel.com, kristen@linux.intel.com, seanjc@google.com

Use the lower 3 bits in the flags field of sgx_epc_page struct to
track EPC states in its life cycle and define an enum for possible
states. More state(s) will be added later.

Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>

V3:
- This is new in V3 to replace the bit mask based approach (requested by Jarkko)
---
 arch/x86/kernel/cpu/sgx/encl.c  | 10 +++----
 arch/x86/kernel/cpu/sgx/ioctl.c |  6 ++--
 arch/x86/kernel/cpu/sgx/main.c  | 19 +++++++------
 arch/x86/kernel/cpu/sgx/sgx.h   | 50 +++++++++++++++++++++++++++++----
 4 files changed, 63 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index edb8d8c1c229..e7319209fc4a 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -253,7 +253,7 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 		if (IS_ERR(epc_page))
 			return ERR_CAST(epc_page);
 		sgx_record_epc_page(epc_page, SGX_EPC_OWNER_ENCL_PAGE |
-				    SGX_EPC_PAGE_RECLAIMER_UNTRACKED);
+				    SGX_EPC_PAGE_UNRECLAIMABLE);
 	}
 
 	epc_page = sgx_encl_eldu(entry, encl->secs.epc_page);
@@ -262,7 +262,7 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 
 	encl->secs_child_cnt++;
 	sgx_record_epc_page(epc_page, SGX_EPC_OWNER_ENCL_PAGE |
-			    SGX_EPC_PAGE_RECLAIMER_TRACKED);
+			    SGX_EPC_PAGE_RECLAIMABLE);
 
 	return entry;
 }
@@ -382,7 +382,7 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	encl->secs_child_cnt++;
 
 	sgx_record_epc_page(epc_page, SGX_EPC_OWNER_ENCL_PAGE |
-			    SGX_EPC_PAGE_RECLAIMER_TRACKED);
+			    SGX_EPC_PAGE_RECLAIMABLE);
 
 	phys_addr = sgx_get_epc_phys_addr(epc_page);
 	/*
@@ -1242,7 +1242,7 @@ struct sgx_epc_page *sgx_alloc_va_page(struct sgx_encl *encl, bool reclaim)
 		return ERR_PTR(-EFAULT);
 	}
 	sgx_record_epc_page(epc_page, SGX_EPC_OWNER_ENCL |
-			    SGX_EPC_PAGE_RECLAIMER_UNTRACKED);
+			    SGX_EPC_PAGE_UNRECLAIMABLE);
 
 	return epc_page;
 }
@@ -1302,7 +1302,7 @@ void sgx_encl_free_epc_page(struct sgx_epc_page *page)
 {
 	int ret;
 
-	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
+	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_STATE_MASK);
 
 	ret = __eremove(sgx_get_epc_virt_addr(page));
 	if (WARN_ONCE(ret, EREMOVE_ERROR_MESSAGE, ret, ret))
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 4e6d0c9d043a..4f95096c9786 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -115,7 +115,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	encl->attributes_mask = SGX_ATTR_UNPRIV_MASK;
 
 	sgx_record_epc_page(encl->secs.epc_page, SGX_EPC_OWNER_ENCL_PAGE |
-			    SGX_EPC_PAGE_RECLAIMER_UNTRACKED);
+			    SGX_EPC_PAGE_UNRECLAIMABLE);
 
 	/* Set only after completion, as encl->lock has not been taken. */
 	set_bit(SGX_ENCL_CREATED, &encl->flags);
@@ -327,7 +327,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 	}
 
 	sgx_record_epc_page(epc_page, SGX_EPC_OWNER_ENCL_PAGE |
-			    SGX_EPC_PAGE_RECLAIMER_TRACKED);
+			    SGX_EPC_PAGE_RECLAIMABLE);
 	mutex_unlock(&encl->lock);
 	mmap_read_unlock(current->mm);
 	return ret;
@@ -982,7 +982,7 @@ static long sgx_enclave_modify_types(struct sgx_encl *encl,
 			mutex_lock(&encl->lock);
 
 			sgx_record_epc_page(entry->epc_page, SGX_EPC_OWNER_ENCL_PAGE |
-					    SGX_EPC_PAGE_RECLAIMER_TRACKED);
+					    SGX_EPC_PAGE_RECLAIMABLE);
 		}
 
 		/* Change EPC type */
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 9252728865fa..02c358f10383 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -319,7 +319,7 @@ static void sgx_reclaim_pages(void)
 			/* The owner is freeing the page. No need to add the
 			 * page back to the list of reclaimable pages.
 			 */
-			epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
+			sgx_epc_page_reset_state(epc_page);
 	}
 	spin_unlock(&sgx_global_lru.lock);
 
@@ -345,6 +345,7 @@ static void sgx_reclaim_pages(void)
 
 skip:
 		spin_lock(&sgx_global_lru.lock);
+		sgx_epc_page_set_state(epc_page, SGX_EPC_PAGE_RECLAIMABLE);
 		list_add_tail(&epc_page->list, &sgx_global_lru.reclaimable);
 		spin_unlock(&sgx_global_lru.lock);
 
@@ -368,7 +369,7 @@ static void sgx_reclaim_pages(void)
 		sgx_reclaimer_write(epc_page, &backing[i]);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
-		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
+		sgx_epc_page_reset_state(epc_page);
 
 		sgx_free_epc_page(epc_page);
 	}
@@ -508,9 +509,9 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
 void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags)
 {
 	spin_lock(&sgx_global_lru.lock);
-	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
+	WARN_ON_ONCE(sgx_epc_page_reclaimable(page->flags));
 	page->flags |= flags;
-	if (flags & SGX_EPC_PAGE_RECLAIMER_TRACKED)
+	if (sgx_epc_page_reclaimable(flags))
 		list_add_tail(&page->list, &sgx_global_lru.reclaimable);
 	else
 		list_add_tail(&page->list, &sgx_global_lru.unreclaimable);
@@ -530,7 +531,7 @@ void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags)
 int sgx_drop_epc_page(struct sgx_epc_page *page)
 {
 	spin_lock(&sgx_global_lru.lock);
-	if (page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED) {
+	if (sgx_epc_page_reclaimable(page->flags)) {
 		/* The page is being reclaimed. */
 		if (list_empty(&page->list)) {
 			spin_unlock(&sgx_global_lru.lock);
@@ -538,7 +539,7 @@ int sgx_drop_epc_page(struct sgx_epc_page *page)
 		}
 
 		list_del(&page->list);
-		page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
+		sgx_epc_page_reset_state(page);
 	}
 	spin_unlock(&sgx_global_lru.lock);
 
@@ -610,6 +611,8 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
 	struct sgx_numa_node *node = section->node;
 
+	WARN_ON_ONCE(page->flags & (SGX_EPC_PAGE_STATE_MASK));
+
 	spin_lock(&node->lock);
 
 	page->encl_page = NULL;
@@ -617,7 +620,7 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 		list_add(&page->list, &node->sgx_poison_page_list);
 	else
 		list_add_tail(&page->list, &node->free_page_list);
-	page->flags = SGX_EPC_PAGE_IS_FREE;
+	page->flags = SGX_EPC_PAGE_FREE;
 
 	spin_unlock(&node->lock);
 	atomic_long_inc(&sgx_nr_free_pages);
@@ -718,7 +721,7 @@ int arch_memory_failure(unsigned long pfn, int flags)
 	 * If the page is on a free list, move it to the per-node
 	 * poison page list.
 	 */
-	if (page->flags & SGX_EPC_PAGE_IS_FREE) {
+	if (page->flags == SGX_EPC_PAGE_FREE) {
 		list_move(&page->list, &node->sgx_poison_page_list);
 		goto out;
 	}
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 9f780b2c4cfe..057905eba466 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -23,14 +23,36 @@
 #define SGX_NR_LOW_PAGES		32
 #define SGX_NR_HIGH_PAGES		64
 
-/* Pages, which are not tracked by the page reclaimer. */
-#define SGX_EPC_PAGE_RECLAIMER_UNTRACKED 0
+enum sgx_epc_page_state {
+	/* Not tracked by the reclaimer:
+	 * Pages allocated for virtual EPC which are never tracked by the host
+	 * reclaimer; pages just allocated from free list but not yet put in
+	 * use; pages just reclaimed, but not yet returned to the free list.
+	 * Becomes FREE after sgx_free_epc()
+	 * Becomes RECLAIMABLE or UNRECLAIMABLE after sgx_record_epc()
+	 */
+	SGX_EPC_PAGE_NOT_TRACKED = 0,
+
+	/* Page is in the free list, ready for allocation
+	 * Becomes NOT_TRACKED after sgx_alloc_epc_page()
+	 */
+	SGX_EPC_PAGE_FREE = 1,
+
+	/* Page is in use and tracked in a reclaimable LRU list
+	 * Becomes NOT_TRACKED after sgx_drop_epc()
+	 */
+	SGX_EPC_PAGE_RECLAIMABLE = 2,
+
+	/* Page is in use but tracked in an unreclaimable LRU list. These are
+	 * only reclaimable when the whole enclave is OOM killed or the enclave
+	 * is released, e.g., VA, SECS pages
+	 * Becomes NOT_TRACKED after sgx_drop_epc()
+	 */
+	SGX_EPC_PAGE_UNRECLAIMABLE = 3,
 
-/* Pages, which are being tracked by the page reclaimer. */
-#define SGX_EPC_PAGE_RECLAIMER_TRACKED	BIT(0)
+};
 
-/* Pages on free list */
-#define SGX_EPC_PAGE_IS_FREE		BIT(1)
+#define SGX_EPC_PAGE_STATE_MASK GENMASK(2, 0)
 
 /* flag for pages owned by a sgx_encl_page */
 #define SGX_EPC_OWNER_ENCL_PAGE		BIT(3)
@@ -49,6 +71,22 @@ struct sgx_epc_page {
 	struct list_head list;
 };
 
+static inline void sgx_epc_page_reset_state(struct sgx_epc_page *page)
+{
+	page->flags &= ~SGX_EPC_PAGE_STATE_MASK;
+}
+
+static inline void sgx_epc_page_set_state(struct sgx_epc_page *page, unsigned long flags)
+{
+	page->flags &= ~SGX_EPC_PAGE_STATE_MASK;
+	page->flags |= (flags & SGX_EPC_PAGE_STATE_MASK);
+}
+
+static inline bool sgx_epc_page_reclaimable(unsigned long flags)
+{
+	return SGX_EPC_PAGE_RECLAIMABLE == (flags & SGX_EPC_PAGE_STATE_MASK);
+}
+
 /*
  * Contains the tracking data for NUMA nodes having EPC pages. Most importantly,
  * the free page list local to the node is stored here.
-- 
2.25.1

