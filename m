From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 11/26] x86/sgx: Add option to ignore age of page during EPC reclaim
Date: Fri, 11 Nov 2022 10:35:16 -0800
Message-ID: <20221111183532.3676646-12-kristen@linux.intel.com>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668191761; x=1699727761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T3P7Q3xIri7oBiVTNsBMGR4O8OWA5OQYl9qvR3LdFVU=;
  b=XkUwzZ3aHIemRjo/noiKurMhPxOTF54mZDv4Cq1yMUGABab6eXeoUeeW
   e0QW9HCj8qQIdygxumVqKLqfoSsD5sbZDZuA1OvUcZlOv28HynRETJuKa
   UAZjLwQMa2VaZyYBIgw3N+rMtiyIDgPw4N8RsFaTo+KC3EDeQRhZ/Ur3S
   omM39GLEu/QErO96sWoScPvvQzzTxUVy8OlSEMkyTROVFZehPGES8HNg/
   PoUxJTxTU//YUKWXiPF97MlKM6Hd+BUobHPEfqfiI1m1X1CDkz/3LqfFE
   HKBlM8AzJqbjuTMimnlZ8n6HTRr734pVSAVC89q/V6jzQr4j/bG8ACdFt
   Q==;
In-Reply-To: <20221111183532.3676646-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add a flag to sgx_reclaim_pages() to instruct it to ignore the age of
page, i.e. reclaim the page even if it's young.  The EPC cgroup will use
the flag to enforce its limits by draining the reclaimable lists before
resorting to other measures, e.g. forcefully reclaimable "unreclaimable"
pages by killing enclaves.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index dfd76c605ef2..b72b5868dd01 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -278,6 +278,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 /**
  * sgx_reclaim_pages() - Reclaim EPC pages from the consumers
  * @nr_to_scan:		 Number of EPC pages to scan for reclaim
+ * @ignore_age:		 Reclaim a page even if it is young
  *
  * Take a fixed number of pages from the head of the active page pool and
  * reclaim them to the enclave's private shmem files. Skip the pages, which have
@@ -291,7 +292,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
  * problematic as it would increase the lock contention too much, which would
  * halt forward progress.
  */
-static int __sgx_reclaim_pages(int nr_to_scan)
+static int __sgx_reclaim_pages(int nr_to_scan, bool ignore_age)
 {
 	struct sgx_backing backing[SGX_MAX_NR_TO_RECLAIM];
 	struct sgx_epc_page *epc_page, *tmp;
@@ -332,7 +333,8 @@ static int __sgx_reclaim_pages(int nr_to_scan)
 	list_for_each_entry_safe(epc_page, tmp, &iso, list) {
 		encl_page = epc_page->encl_owner;
 
-		if (i == SGX_MAX_NR_TO_RECLAIM || !sgx_reclaimer_age(epc_page))
+		if (i == SGX_MAX_NR_TO_RECLAIM ||
+		    (!ignore_age && !sgx_reclaimer_age(epc_page)))
 			goto skip;
 
 		page_index = PFN_DOWN(encl_page->desc - encl_page->encl->base);
@@ -374,11 +376,11 @@ static int __sgx_reclaim_pages(int nr_to_scan)
 	return i;
 }
 
-static int sgx_reclaim_pages(int nr_to_scan)
+static int sgx_reclaim_pages(int nr_to_scan, bool ignore_age)
 {
 	int ret;
 
-	ret = __sgx_reclaim_pages(nr_to_scan);
+	ret = __sgx_reclaim_pages(nr_to_scan, ignore_age);
 	cond_resched();
 	return ret;
 }
@@ -399,7 +401,7 @@ static bool sgx_should_reclaim(unsigned long watermark)
 void sgx_reclaim_direct(void)
 {
 	if (sgx_should_reclaim(SGX_NR_LOW_PAGES))
-		__sgx_reclaim_pages(SGX_NR_TO_SCAN);
+		__sgx_reclaim_pages(SGX_NR_TO_SCAN, false);
 }
 
 static int ksgxd(void *p)
@@ -425,7 +427,7 @@ static int ksgxd(void *p)
 				     sgx_should_reclaim(SGX_NR_HIGH_PAGES));
 
 		if (sgx_should_reclaim(SGX_NR_HIGH_PAGES))
-			sgx_reclaim_pages(SGX_NR_TO_SCAN);
+			sgx_reclaim_pages(SGX_NR_TO_SCAN, false);
 	}
 
 	return 0;
@@ -600,7 +602,7 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 			break;
 		}
 
-		sgx_reclaim_pages(SGX_NR_TO_SCAN);
+		sgx_reclaim_pages(SGX_NR_TO_SCAN, false);
 	}
 
 	if (sgx_should_reclaim(SGX_NR_LOW_PAGES))
-- 
2.37.3

