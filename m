From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH 07/20] x86/sgx: Use a list to track to-be-reclaimed pages during reclaim
Date: Thu, 22 Sep 2022 10:10:44 -0700
Message-ID: <20220922171057.1236139-8-kristen@linux.intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663866936; x=1695402936;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DRy35tf5iLyrHuxp2SgL7lHDqjPxBWrPxC87VIa2/uA=;
  b=m0HVHg6povi8OQ8CI7/MQbPJwtOS+85+4I0bgmZgszRbvpObJJ9Xcxuo
   FyUZ7FZEeRY8Yfd3OEtEx1ppOrnDiwmL/4c+aPJAY4bC95on7k0BH2Hja
   6IB1J5w+d3ovgfroMB4gOkdEl2kiLBrPF7gqD7ldTjbfNPGW6HdBCbXnc
   mI1uoi0c+9T3MdDkr3ccSdE4drKQGlZHOsmTfaMAf6CQ3JqsxTFjQFCE8
   a3op0OBa+8DVAYxnRVLexeZ2m1fAZQtkI9xVk5vzeNLaLC+rUHTXVxSF0
   WFw1zSdJydqsmYXpP2kBzH3YrrdcfHf92Ed5jEaa2RFafI6vycI79Q2FZ
   w==;
In-Reply-To: <20220922171057.1236139-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change sgx_reclaim_pages() to use a list rather than an array for
storing the epc_pages which will be reclaimed. This change is needed
to transition to the LRU implementation for EPC cgroup support.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 43 +++++++++++++++-------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 93aa9e09c26d..085c06fdc359 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -288,12 +288,11 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
  */
 static void sgx_reclaim_pages(void)
 {
-	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
 	struct sgx_backing backing[SGX_NR_TO_SCAN];
 	struct sgx_encl_page *encl_page;
-	struct sgx_epc_page *epc_page;
+	struct sgx_epc_page *epc_page, *tmp;
 	pgoff_t page_index;
-	int cnt = 0;
+	LIST_HEAD(iso);
 	int ret;
 	int i;
 
@@ -304,23 +303,26 @@ static void sgx_reclaim_pages(void)
 
 		epc_page = list_first_entry(&sgx_global_lru.reclaimable,
 					    struct sgx_epc_page, list);
-		list_del_init(&epc_page->list);
 		encl_page = epc_page->owner;
 
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
+		goto out;
+
+	i = 0;
+	list_for_each_entry_safe(epc_page, tmp, &iso, list) {
 		encl_page = epc_page->owner;
 
 		if (!sgx_reclaimer_age(epc_page))
@@ -335,6 +337,7 @@ static void sgx_reclaim_pages(void)
 			goto skip;
 		}
 
+		i++;
 		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
 		mutex_unlock(&encl_page->encl->lock);
 		continue;
@@ -342,27 +345,19 @@ static void sgx_reclaim_pages(void)
 skip:
 		spin_lock(&sgx_global_lru.lock);
 		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIM_IN_PROGRESS;
-		list_add_tail(&epc_page->list, &sgx_global_lru.reclaimable);
+		list_move_tail(&epc_page->list, &sgx_global_lru.reclaimable);
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
+	list_for_each_entry(epc_page, &iso, list)
+		sgx_reclaimer_block(epc_page);
 
+	i= 0;
+	list_for_each_entry_safe(epc_page, tmp, &iso, list) {
 		encl_page = epc_page->owner;
-		sgx_reclaimer_write(epc_page, &backing[i]);
+		sgx_reclaimer_write(epc_page, &backing[i++]);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 		epc_page->flags &= ~(SGX_EPC_PAGE_RECLAIMER_TRACKED |
@@ -370,7 +365,7 @@ static void sgx_reclaim_pages(void)
 
 		sgx_free_epc_page(epc_page);
 	}
-
+out:
 	cond_resched();
 }
 
-- 
2.37.3

