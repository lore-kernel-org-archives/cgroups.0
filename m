From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH 09/20] x86/sgx: Allow reclaiming up to 32 pages, but scan 16 by default
Date: Thu, 22 Sep 2022 10:10:46 -0700
Message-ID: <20220922171057.1236139-10-kristen@linux.intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663866708; x=1695402708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YYmyfKC3KMAXnaj8uAGWA1KxL3gThquOW2nfx+FoyxM=;
  b=QB2pUA5r0oWn0mSF4286hqTK36NxZRmicAWUphAmDGHoTlDkESUdczRw
   B3KhfNXHf0bUC3UHiCyYEDygDvTMGdMmEp8REQ4oX2MlI5+o0LGlYBi/6
   WVUJTq/Kn4E53PYMY15hzCy486b73v3mxObds6nfb6+iaamTUiOdWmUmY
   KpG8Zdi9ZP9JnovkDLU5fKx5R0aA5zatg8caugg/xATJEa8JVn5EUNXkz
   lNDGkJefxERcNRZah4R6tBE2cZbS9r8v4cEVfVCueHP4Q37/vWaJcyvpU
   mGSd+LLSMt94XvKAA7NjGtfAiWQ+9ErTXn6nk0EBU0fqRsn0lmeeleCFJ
   Q==;
In-Reply-To: <20220922171057.1236139-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Modify sgx_reclaim_pages() to take a parameter that specifies the
number of pages to scan for reclaiming. Specify a max value of
32, but scan 16 in the usual case. This allows the number of pages
sgx_reclaim_pages() scans to be specified by the caller, and adjusted
in future patches.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 3c0d33b72896..0010ed1b2e98 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -18,6 +18,8 @@
 #include "encl.h"
 #include "encls.h"
 
+#define SGX_MAX_NR_TO_RECLAIM	32
+
 struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 static int sgx_nr_epc_sections;
 static struct task_struct *ksgxd_tsk;
@@ -273,7 +275,10 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 	mutex_unlock(&encl->lock);
 }
 
-/*
+/**
+ * sgx_reclaim_pages() - Reclaim EPC pages from the consumers
+ * @nr_to_scan:		 Number of EPC pages to scan for reclaim
+ *
  * Take a fixed number of pages from the head of the active page pool and
  * reclaim them to the enclave's private shmem files. Skip the pages, which have
  * been accessed since the last scan. Move those pages to the tail of active
@@ -286,9 +291,9 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
  * problematic as it would increase the lock contention too much, which would
  * halt forward progress.
  */
-static void sgx_reclaim_pages(void)
+static void sgx_reclaim_pages(int nr_to_scan)
 {
-	struct sgx_backing backing[SGX_NR_TO_SCAN];
+	struct sgx_backing backing[SGX_MAX_NR_TO_RECLAIM];
 	struct sgx_encl_page *encl_page;
 	struct sgx_epc_page *epc_page, *tmp;
 	pgoff_t page_index;
@@ -297,7 +302,7 @@ static void sgx_reclaim_pages(void)
 	int i;
 
 	spin_lock(&sgx_global_lru.lock);
-	for (i = 0; i < SGX_NR_TO_SCAN; i++) {
+	for (i = 0; i < nr_to_scan; i++) {
 		if (list_empty(&sgx_global_lru.reclaimable))
 			break;
 
@@ -327,7 +332,7 @@ static void sgx_reclaim_pages(void)
 	list_for_each_entry_safe(epc_page, tmp, &iso, list) {
 		encl_page = epc_page->owner;
 
-		if (!sgx_reclaimer_age(epc_page))
+		if (i == SGX_MAX_NR_TO_RECLAIM || !sgx_reclaimer_age(epc_page))
 			goto skip;
 
 		page_index = PFN_DOWN(encl_page->desc - encl_page->encl->base);
@@ -384,7 +389,7 @@ static bool sgx_should_reclaim(unsigned long watermark)
 void sgx_reclaim_direct(void)
 {
 	if (sgx_should_reclaim(SGX_NR_LOW_PAGES))
-		sgx_reclaim_pages();
+		sgx_reclaim_pages(SGX_NR_TO_SCAN);
 }
 
 static int ksgxd(void *p)
@@ -410,7 +415,7 @@ static int ksgxd(void *p)
 				     sgx_should_reclaim(SGX_NR_HIGH_PAGES));
 
 		if (sgx_should_reclaim(SGX_NR_HIGH_PAGES))
-			sgx_reclaim_pages();
+			sgx_reclaim_pages(SGX_NR_TO_SCAN);
 	}
 
 	return 0;
@@ -581,7 +586,7 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 			break;
 		}
 
-		sgx_reclaim_pages();
+		sgx_reclaim_pages(SGX_NR_TO_SCAN);
 	}
 
 	if (sgx_should_reclaim(SGX_NR_LOW_PAGES))
-- 
2.37.3

