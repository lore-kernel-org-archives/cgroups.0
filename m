From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 12/26] x86/sgx: Add helper to retrieve SGX EPC LRU given an EPC page
Date: Fri, 11 Nov 2022 10:35:17 -0800
Message-ID: <20221111183532.3676646-13-kristen@linux.intel.com>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668191763; x=1699727763;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xqEEntqYbLvI5IiAkoUnLqlFey5cK++4386ISoTRbDQ=;
  b=NyeS7rN3OaA/u3vut/55VUDCWVXYTm9hf7Ix0JkVZJI6BfW5/q65vi5I
   Mcx9yG0cyu4yFKXzdP+TstbbzQE3kpV/ThxJOQcqByhBh5MGp6r0KFXKY
   iYwO7ymRmhTkp0JEMdjYY/nVp68miCJi+ip68wdc5u4InuQk620Z6dJVV
   Wms1+CUebNkp4BM4PIUHTtLERBqeyL5VXCnR4/s2jbsaL+VFq7tkluWdo
   hy+MIDjZp7Dq68zx/qmQthDg+ftxAJEASR0NSSe6P2BaMdnqM0jKAt1mD
   68pDWfzd2gdIBg3cumKo78YhxxyakP6z1jGCUzcZ4q3NjdWzUhOgrkyxo
   Q==;
In-Reply-To: <20221111183532.3676646-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Introduce a function that will be used to retrieve an LRU
from an EPC page.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index b72b5868dd01..c33966eafab6 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -31,6 +31,10 @@ static DEFINE_XARRAY(sgx_epc_address_space);
  * with sgx_global_lru.lock acquired.
  */
 static struct sgx_epc_lru sgx_global_lru;
+static inline struct sgx_epc_lru *sgx_lru(struct sgx_epc_page *epc_page)
+{
+	return &sgx_global_lru;
+}
 
 static atomic_long_t sgx_nr_free_pages = ATOMIC_LONG_INIT(0);
 
@@ -297,6 +301,7 @@ static int __sgx_reclaim_pages(int nr_to_scan, bool ignore_age)
 	struct sgx_backing backing[SGX_MAX_NR_TO_RECLAIM];
 	struct sgx_epc_page *epc_page, *tmp;
 	struct sgx_encl_page *encl_page;
+	struct sgx_epc_lru *lru;
 	pgoff_t page_index;
 	LIST_HEAD(iso);
 	int ret;
@@ -352,10 +357,11 @@ static int __sgx_reclaim_pages(int nr_to_scan, bool ignore_age)
 		continue;
 
 skip:
-		spin_lock(&sgx_global_lru.lock);
+		lru = sgx_lru(epc_page);
+		spin_lock(&lru->lock);
 		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIM_IN_PROGRESS;
-		sgx_epc_move_reclaimable(&sgx_global_lru, epc_page);
-		spin_unlock(&sgx_global_lru.lock);
+		sgx_epc_move_reclaimable(lru, epc_page);
+		spin_unlock(&lru->lock);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 	}
@@ -521,14 +527,16 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
  */
 void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags)
 {
-	spin_lock(&sgx_global_lru.lock);
+	struct sgx_epc_lru *lru = sgx_lru(page);
+
+	spin_lock(&lru->lock);
 	WARN_ON(page->flags & SGX_EPC_PAGE_RECLAIM_FLAGS);
 	page->flags |= flags;
 	if (flags & SGX_EPC_PAGE_RECLAIMER_TRACKED)
-		sgx_epc_push_reclaimable(&sgx_global_lru, page);
+		sgx_epc_push_reclaimable(lru, page);
 	else
-		sgx_epc_push_unreclaimable(&sgx_global_lru, page);
-	spin_unlock(&sgx_global_lru.lock);
+		sgx_epc_push_unreclaimable(lru, page);
+	spin_unlock(&lru->lock);
 }
 
 /**
@@ -543,14 +551,16 @@ void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags)
  */
 int sgx_drop_epc_page(struct sgx_epc_page *page)
 {
-	spin_lock(&sgx_global_lru.lock);
+	struct sgx_epc_lru *lru = sgx_lru(page);
+
+	spin_lock(&lru->lock);
 	if ((page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED) &&
 	    (page->flags & SGX_EPC_PAGE_RECLAIM_IN_PROGRESS)) {
-		spin_unlock(&sgx_global_lru.lock);
+		spin_unlock(&lru->lock);
 		return -EBUSY;
 	}
 	list_del(&page->list);
-	spin_unlock(&sgx_global_lru.lock);
+	spin_unlock(&lru->lock);
 
 	page->flags &= ~SGX_EPC_PAGE_RECLAIM_FLAGS;
 
-- 
2.37.3

