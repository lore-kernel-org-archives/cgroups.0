From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 07/18] x86/sgx: Use a list to track to-be-reclaimed pages during reclaim
Date: Fri,  2 Dec 2022 10:36:43 -0800
Message-ID: <20221202183655.3767674-8-kristen@linux.intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670006239; x=1701542239;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PbbVkK5yr2Kuz5SaGN/Zwcz0c3hpgNwJRYQamx2sNnY=;
  b=B/MoItuIy/YUBQ+4Jm57rpL/mpakpaCj5PR2vuzRmtiATfJChy7Uuxr6
   x96MbIo4SmCPlifSl+kqcflEyGUGKk3990eiUsYU+ZcOGiImHuecYgSzA
   izeSA+NSn21w5fucKP0qI2gy60Qe6De4Cq6fRA0wKr3/M6vhrGagJGGGC
   DB3+m/p8FGGRFGe0Qj+85rjc0VSjxcSk3ouqFYQJ8FJK/dt4Fy7JjfmDa
   ZGf0Q/33MKdJu9lDLdRVM+v8SiS5LWzpjZ2rpwM6tp+w9VcndEAiXJwLe
   mBXxMC+/vMBacN+BZVfh9pggx5EegK/LV4fbgoNPN8NMecDjUrGzyHtIn
   A==;
In-Reply-To: <20221202183655.3767674-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change sgx_reclaim_pages() to use a list rather than an array for
storing the epc_pages which will be reclaimed. This change is needed
to transition to the LRU implementation for EPC cgroup support.

This change requires keeping track of whether newly recorded
EPC pages are pages for VA Arrays, or for Enclave data. In addition,
helper functions are added to move pages from one list to another and
enforce a consistent queue like behavior for the LRU lists.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/encl.c  |  7 ++--
 arch/x86/kernel/cpu/sgx/ioctl.c |  5 ++-
 arch/x86/kernel/cpu/sgx/main.c  | 69 +++++++++++++++++----------------
 arch/x86/kernel/cpu/sgx/sgx.h   | 42 ++++++++++++++++++++
 4 files changed, 85 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 4683da9ef4f1..9ee306ac2a8e 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -252,7 +252,7 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 		epc_page = sgx_encl_eldu(&encl->secs, NULL);
 		if (IS_ERR(epc_page))
 			return ERR_CAST(epc_page);
-		sgx_record_epc_page(epc_page, 0);
+		sgx_record_epc_page(epc_page, SGX_EPC_PAGE_ENCLAVE);
 	}
 
 	epc_page = sgx_encl_eldu(entry, encl->secs.epc_page);
@@ -260,7 +260,8 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 		return ERR_CAST(epc_page);
 
 	encl->secs_child_cnt++;
-	sgx_record_epc_page(entry->epc_page, SGX_EPC_PAGE_RECLAIMER_TRACKED);
+	sgx_record_epc_page(entry->epc_page,
+			    (SGX_EPC_PAGE_ENCLAVE | SGX_EPC_PAGE_RECLAIMER_TRACKED));
 
 	return entry;
 }
@@ -1221,7 +1222,7 @@ struct sgx_epc_page *sgx_alloc_va_page(struct sgx_encl *encl, bool reclaim)
 		sgx_encl_free_epc_page(epc_page);
 		return ERR_PTR(-EFAULT);
 	}
-	sgx_record_epc_page(epc_page, 0);
+	sgx_record_epc_page(epc_page, SGX_EPC_PAGE_VERSION_ARRAY);
 
 	return epc_page;
 }
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index aca80a3f38a1..c3a9bffbc37e 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -114,7 +114,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	encl->attributes = secs->attributes;
 	encl->attributes_mask = SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT | SGX_ATTR_KSS;
 
-	sgx_record_epc_page(encl->secs.epc_page, 0);
+	sgx_record_epc_page(encl->secs.epc_page, SGX_EPC_PAGE_ENCLAVE);
 
 	/* Set only after completion, as encl->lock has not been taken. */
 	set_bit(SGX_ENCL_CREATED, &encl->flags);
@@ -325,7 +325,8 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 			goto err_out;
 	}
 
-	sgx_record_epc_page(encl_page->epc_page, SGX_EPC_PAGE_RECLAIMER_TRACKED);
+	sgx_record_epc_page(encl_page->epc_page,
+			    (SGX_EPC_PAGE_ENCLAVE | SGX_EPC_PAGE_RECLAIMER_TRACKED));
 	mutex_unlock(&encl->lock);
 	mmap_read_unlock(current->mm);
 	return ret;
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index bad72498b0a7..83aaf5cea7b9 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -288,37 +288,43 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
  */
 static void __sgx_reclaim_pages(void)
 {
-	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
 	struct sgx_backing backing[SGX_NR_TO_SCAN];
+	struct sgx_epc_page *epc_page, *tmp;
 	struct sgx_encl_page *encl_page;
-	struct sgx_epc_page *epc_page;
 	pgoff_t page_index;
-	int cnt = 0;
+	LIST_HEAD(iso);
 	int ret;
 	int i;
 
 	spin_lock(&sgx_global_lru.lock);
 	for (i = 0; i < SGX_NR_TO_SCAN; i++) {
-		epc_page = sgx_epc_pop_reclaimable(&sgx_global_lru);
+		epc_page = sgx_epc_peek_reclaimable(&sgx_global_lru);
 		if (!epc_page)
 			break;
 
 		encl_page = epc_page->encl_owner;
 
+		if (WARN_ON_ONCE(!(epc_page->flags & SGX_EPC_PAGE_ENCLAVE)))
+			continue;
+
 		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0) {
 			epc_page->flags |= SGX_EPC_PAGE_RECLAIM_IN_PROGRESS;
-			chunk[cnt++] = epc_page;
+			list_move_tail(&epc_page->list, &iso);
 		} else {
-			/* The owner is freeing the page. No need to add the
-			 * page back to the list of reclaimable pages.
+			/* The owner is freeing the page, remove it from the
+			 * LRU list
 			 */
 			epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
+			list_del_init(&epc_page->list);
 		}
 	}
 	spin_unlock(&sgx_global_lru.lock);
 
-	for (i = 0; i < cnt; i++) {
-		epc_page = chunk[i];
+	if (list_empty(&iso))
+		return;
+
+	i = 0;
+	list_for_each_entry_safe(epc_page, tmp, &iso, list) {
 		encl_page = epc_page->encl_owner;
 
 		if (!sgx_reclaimer_age(epc_page))
@@ -333,6 +339,7 @@ static void __sgx_reclaim_pages(void)
 			goto skip;
 		}
 
+		i++;
 		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
 		mutex_unlock(&encl_page->encl->lock);
 		continue;
@@ -340,31 +347,25 @@ static void __sgx_reclaim_pages(void)
 skip:
 		spin_lock(&sgx_global_lru.lock);
 		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIM_IN_PROGRESS;
-		sgx_epc_push_reclaimable(&sgx_global_lru, epc_page);
+		sgx_epc_move_reclaimable(&sgx_global_lru, epc_page);
 		spin_unlock(&sgx_global_lru.lock);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
-
-		chunk[i] = NULL;
 	}
 
-	for (i = 0; i < cnt; i++) {
-		epc_page = chunk[i];
-		if (epc_page)
-			sgx_reclaimer_block(epc_page);
-	}
-
-	for (i = 0; i < cnt; i++) {
-		epc_page = chunk[i];
-		if (!epc_page)
-			continue;
-
+	list_for_each_entry(epc_page, &iso, list)
+		sgx_reclaimer_block(epc_page);
+ 
+	i = 0;
+	list_for_each_entry_safe(epc_page, tmp, &iso, list) {
 		encl_page = epc_page->encl_owner;
-		sgx_reclaimer_write(epc_page, &backing[i]);
+		sgx_reclaimer_write(epc_page, &backing[i++]);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 		epc_page->flags &= ~(SGX_EPC_PAGE_RECLAIMER_TRACKED |
-				     SGX_EPC_PAGE_RECLAIM_IN_PROGRESS);
+				     SGX_EPC_PAGE_RECLAIM_IN_PROGRESS |
+				     SGX_EPC_PAGE_ENCLAVE |
+				     SGX_EPC_PAGE_VERSION_ARRAY);
 
 		sgx_free_epc_page(epc_page);
 	}
@@ -505,6 +506,7 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
 /**
  * sgx_record_epc_page() - Add a page to the LRU tracking
  * @page:	EPC page
+ * @flags:	Reclaim flags for the page.
  *
  * Mark a page with the specified flags and add it to the appropriate
  * (un)reclaimable list.
@@ -535,18 +537,19 @@ void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags)
 int sgx_drop_epc_page(struct sgx_epc_page *page)
 {
 	spin_lock(&sgx_global_lru.lock);
-	if (page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED) {
-		/* The page is being reclaimed. */
-		if (page->flags & SGX_EPC_PAGE_RECLAIM_IN_PROGRESS) {
-			spin_unlock(&sgx_global_lru.lock);
-			return -EBUSY;
-		}
-
-		page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
+	if ((page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED) &&
+	    (page->flags & SGX_EPC_PAGE_RECLAIM_IN_PROGRESS)) {
+		spin_unlock(&sgx_global_lru.lock);
+		return -EBUSY;
 	}
 	list_del(&page->list);
 	spin_unlock(&sgx_global_lru.lock);
 
+	page->flags &= ~(SGX_EPC_PAGE_RECLAIMER_TRACKED |
+			 SGX_EPC_PAGE_RECLAIM_IN_PROGRESS |
+			 SGX_EPC_PAGE_ENCLAVE |
+			 SGX_EPC_PAGE_VERSION_ARRAY);
+
 	return 0;
 }
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 37d66bc6ca27..ec8d567cd975 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -32,6 +32,8 @@
 #define SGX_EPC_PAGE_KVM_GUEST		BIT(2)
 /* page flag to indicate reclaim is in progress */
 #define SGX_EPC_PAGE_RECLAIM_IN_PROGRESS BIT(3)
+#define SGX_EPC_PAGE_ENCLAVE		BIT(4)
+#define SGX_EPC_PAGE_VERSION_ARRAY	BIT(5)
 
 struct sgx_epc_page {
 	unsigned int section;
@@ -118,6 +120,14 @@ static inline void __sgx_epc_page_list_push(struct list_head *list, struct sgx_e
 	list_add_tail(&page->list, list);
 }
 
+/*
+ * Must be called with queue lock acquired
+ */
+static inline void __sgx_epc_page_list_move(struct list_head *list, struct sgx_epc_page *page)
+{
+	list_move_tail(&page->list, list);
+}
+
 /*
  * Must be called with queue lock acquired
  */
@@ -157,6 +167,38 @@ static inline void sgx_epc_push_unreclaimable(struct sgx_epc_lru_lists *lrus,
 	__sgx_epc_page_list_push(&(lrus)->unreclaimable, page);
 }
 
+/*
+ * Must be called with queue lock acquired
+ */
+static inline struct sgx_epc_page * __sgx_epc_page_list_peek(struct list_head *list)
+{
+	struct sgx_epc_page *epc_page;
+
+	if (list_empty(list))
+		return NULL;
+
+	epc_page = list_first_entry(list, struct sgx_epc_page, list);
+	return epc_page;
+}
+
+static inline struct sgx_epc_page *
+sgx_epc_peek_reclaimable(struct sgx_epc_lru_lists *lrus)
+{
+	return __sgx_epc_page_list_peek(&(lrus)->reclaimable);
+}
+
+static inline void sgx_epc_move_reclaimable(struct sgx_epc_lru_lists *lru,
+					    struct sgx_epc_page *page)
+{
+	__sgx_epc_page_list_move(&(lru)->reclaimable, page);
+}
+
+static inline struct sgx_epc_page *
+sgx_epc_peek_unreclaimable(struct sgx_epc_lru_lists *lrus)
+{
+	return __sgx_epc_page_list_peek(&(lrus)->unreclaimable);
+}
+
 struct sgx_epc_page *__sgx_alloc_epc_page(void);
 void sgx_free_epc_page(struct sgx_epc_page *page);
 
-- 
2.38.1

