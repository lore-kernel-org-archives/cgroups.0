From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH 06/20] x86/sgx: Introduce RECLAIM_IN_PROGRESS flag for EPC pages
Date: Thu, 22 Sep 2022 10:10:43 -0700
Message-ID: <20220922171057.1236139-7-kristen@linux.intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663866936; x=1695402936;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nj39Q9ceqr5A+bt2PwpCeJxtAg2UJZ0zT/MG8hez1vE=;
  b=dHm3Vzz3l5arsdDq+EDfzMzGSzpvwUmJ83p720XVbIHPoJ7XVlS3MSBo
   iB6vjClvWBvamj0q0Jh9AfIdp0q5bLxxWSpZXQAdgDNoPDPenkpd2JJ1j
   uqEMRw7YA1hJkdwH5fJZhSK1IkVHjgtL9/3h6Epha/sH1mFS0USAuRHFN
   hrop34GTvoE4hD3pdG2+j8DF9PpyUEa/2N8cxQYhYxwnyivDS2Ob54MPl
   l44lH9HyVeqYOaq7erLidypc6RQY9JVTA4HxOyQ8r5ESvOU3MPjdnXisQ
   pKt22qyjUW+l1/heF5jhs/wxWfbiwqazc8baKqFkLvuSpU2t4hNP5BkgJ
   w==;
In-Reply-To: <20220922171057.1236139-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Keep track of whether the EPC page is in the middle of being reclaimed
and do not delete the page off the it's LRU if it has not yet finished
being reclaimed.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 14 +++++++++-----
 arch/x86/kernel/cpu/sgx/sgx.h  |  5 +++++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 543bc5b20508..93aa9e09c26d 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -307,13 +307,15 @@ static void sgx_reclaim_pages(void)
 		list_del_init(&epc_page->list);
 		encl_page = epc_page->owner;
 
-		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0)
+		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0) {
+			epc_page->flags |= SGX_EPC_PAGE_RECLAIM_IN_PROGRESS;
 			chunk[cnt++] = epc_page;
-		else
+		} else {
 			/* The owner is freeing the page. No need to add the
 			 * page back to the list of reclaimable pages.
 			 */
 			epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
+		}
 	}
 	spin_unlock(&sgx_global_lru.lock);
 
@@ -339,6 +341,7 @@ static void sgx_reclaim_pages(void)
 
 skip:
 		spin_lock(&sgx_global_lru.lock);
+		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIM_IN_PROGRESS;
 		list_add_tail(&epc_page->list, &sgx_global_lru.reclaimable);
 		spin_unlock(&sgx_global_lru.lock);
 
@@ -362,7 +365,8 @@ static void sgx_reclaim_pages(void)
 		sgx_reclaimer_write(epc_page, &backing[i]);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
-		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
+		epc_page->flags &= ~(SGX_EPC_PAGE_RECLAIMER_TRACKED |
+				     SGX_EPC_PAGE_RECLAIM_IN_PROGRESS);
 
 		sgx_free_epc_page(epc_page);
 	}
@@ -504,7 +508,7 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
 void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags)
 {
 	spin_lock(&sgx_global_lru.lock);
-	WARN_ON(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
+	WARN_ON(page->flags & SGX_EPC_PAGE_RECLAIM_FLAGS);
 	page->flags |= flags;
 	if (flags & SGX_EPC_PAGE_RECLAIMER_TRACKED)
 		list_add_tail(&page->list, &sgx_global_lru.reclaimable);
@@ -528,7 +532,7 @@ int sgx_drop_epc_page(struct sgx_epc_page *page)
 	spin_lock(&sgx_global_lru.lock);
 	if (page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED) {
 		/* The page is being reclaimed. */
-		if (list_empty(&page->list)) {
+		if (page->flags & SGX_EPC_PAGE_RECLAIM_IN_PROGRESS) {
 			spin_unlock(&sgx_global_lru.lock);
 			return -EBUSY;
 		}
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 65625ea8fd6e..284d0cda9e36 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -29,6 +29,11 @@
 /* Pages on free list */
 #define SGX_EPC_PAGE_IS_FREE		BIT(1)
 
+/* page flag to indicate reclaim is in progress */
+#define SGX_EPC_PAGE_RECLAIM_IN_PROGRESS BIT(2)
+#define SGX_EPC_PAGE_RECLAIM_FLAGS	(SGX_EPC_PAGE_RECLAIMER_TRACKED | \
+					 SGX_EPC_PAGE_RECLAIM_IN_PROGRESS)
+
 struct sgx_epc_page {
 	unsigned int section;
 	u16 flags;
-- 
2.37.3

