From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 07/26] x86/sgx: Use a list to track to-be-reclaimed pages during reclaim
Date: Fri, 11 Nov 2022 10:35:12 -0800
Message-ID: <20221111183532.3676646-8-kristen@linux.intel.com>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668191759; x=1699727759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CIa/7h6XPbf5DpSxTVt6veE3s6+KUgB6b/1ZxHux3uI=;
  b=aaVhyy4smRD5mAabgZ3ld1/76uN6/RYyrnkt41wrAWLNLnnPHpHvROnb
   8hGBJGNEEZUWjA/7xvwdVP7T5BS690Ee47VAQnx5UZW3UIdy5DJBQE0+H
   1ydiNp9II13fXLkIk9UDHh3lvsr23J+FSMZBaNKZdSwXSA1joizIWtqdC
   +bAGuyLpnyNMVVGs3h4hcXkF/twa9Q5NBvBun+YcKUMREVMGCihSJhrqD
   F7UPK6coHJze3R1s8CED7ALYO58zMvBidrTmvcm02VYQpLoAPNq8MkQBB
   JTtRDtKzQg1UeTHfgxnQZVxN075YdiFrX/3tMbF8AckDQEKvHOOry0t85
   Q==;
In-Reply-To: <20221111183532.3676646-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change sgx_reclaim_pages() to use a list rather than an array for
storing the epc_pages which will be reclaimed. This change is needed
to transition to the LRU implementation for EPC cgroup support.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 44 ++++++++++++++++------------------
 arch/x86/kernel/cpu/sgx/sgx.h  | 28 ++++++++++++++++++++++
 2 files changed, 48 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8c451071fa91..c76a53b63fa2 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -288,18 +288,17 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
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
 
@@ -307,18 +306,22 @@ static void __sgx_reclaim_pages(void)
 
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
@@ -333,6 +336,7 @@ static void __sgx_reclaim_pages(void)
 			goto skip;
 		}
 
+		i++;
 		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
 		mutex_unlock(&encl_page->encl->lock);
 		continue;
@@ -340,27 +344,19 @@ static void __sgx_reclaim_pages(void)
 skip:
 		spin_lock(&sgx_global_lru.lock);
 		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIM_IN_PROGRESS;
-		sgx_epc_push_reclaimable(&sgx_global_lru, epc_page);
+		sgx_epc_move_reclaimable(&sgx_global_lru, epc_page);
 		spin_unlock(&sgx_global_lru.lock);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
-
-		chunk[i] = NULL;
-	}
-
-	for (i = 0; i < cnt; i++) {
-		epc_page = chunk[i];
-		if (epc_page)
-			sgx_reclaimer_block(epc_page);
 	}
 
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
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 04ca644928a8..29c0981d6310 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -116,6 +116,14 @@ static inline void __sgx_epc_page_list_push(struct list_head *list, struct sgx_e
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
@@ -131,14 +139,34 @@ static inline struct sgx_epc_page * __sgx_epc_page_list_pop(struct list_head *li
 	return epc_page;
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
 #define sgx_epc_pop_reclaimable(lru) \
 	__sgx_epc_page_list_pop(&(lru)->reclaimable)
 #define sgx_epc_push_reclaimable(lru, page) \
 	__sgx_epc_page_list_push(&(lru)->reclaimable, page)
+#define sgx_epc_peek_reclaimable(lru) \
+	__sgx_epc_page_list_peek(&(lru)->reclaimable)
+#define sgx_epc_move_reclaimable(lru, page) \
+	__sgx_epc_page_list_move(&(lru)->reclaimable, page)
 #define sgx_epc_pop_unreclaimable(lru) \
 	__sgx_epc_page_list_pop(&(lru)->unreclaimable)
 #define sgx_epc_push_unreclaimable(lru, page) \
 	__sgx_epc_page_list_push(&(lru)->unreclaimable, page)
+#define sgx_epc_peek_unreclaimable(lru) \
+	__sgx_epc_page_list_peek(&(lru)->unreclaimable)
 
 struct sgx_epc_page *__sgx_alloc_epc_page(void);
 void sgx_free_epc_page(struct sgx_epc_page *page);
-- 
2.37.3

