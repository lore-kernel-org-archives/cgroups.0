From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 14/26] x86/sgx: Expose sgx_reclaim_pages() for use by EPC cgroup
Date: Fri, 11 Nov 2022 10:35:19 -0800
Message-ID: <20221111183532.3676646-15-kristen@linux.intel.com>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668191766; x=1699727766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9lDq2QGtdu+ipirjs6bxBHl2Vfzbdikl95QVLbAr5eU=;
  b=RZUE1KX7cUxej+1xwc5R2arogNp2qVojj/AJkjgbNgHM2knPfCFJWizI
   FsITFUyFWtiMwvkVWX+D9kyjH5h+TQUimvR7AEohr5Qy3ZNCA6GI+HZCY
   fRYIwKDuL3No5IKQqEmvCGmCsw1AfQyltFKx0BHTLFIZlCNpKLOIoG8E0
   SaZqdr6z7GzVeVJeEHbsSG4RDiAQXkpnNkblNsi7GCdgGsWEo/d8y5WQT
   VgAU6RC4YLdBWhu1GLqDoVVW85cGNmyE+0ZRs/W5NroPDbHEptDD9cqWA
   aNsctRcAuopVWFjTExnM+VCrzymklAtKA5Xs6COMvFNashGEMd3ncJglH
   g==;
In-Reply-To: <20221111183532.3676646-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Expose the top-level reclaim function as sgx_reclaim_epc_pages() for use
by the upcoming EPC cgroup, which will initiate reclaim to enforce
changes to high/max limits.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 7 ++++---
 arch/x86/kernel/cpu/sgx/sgx.h  | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index b2c050fcc989..cb6f57caf24c 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -281,6 +281,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 
 /**
  * sgx_reclaim_pages() - Reclaim EPC pages from the consumers
+ * sgx_reclaim_epc_pages() - Reclaim EPC pages from the consumers
  * @nr_to_scan:		 Number of EPC pages to scan for reclaim
  * @ignore_age:		 Reclaim a page even if it is young
  *
@@ -382,7 +383,7 @@ static int __sgx_reclaim_pages(int nr_to_scan, bool ignore_age)
 	return i;
 }
 
-static int sgx_reclaim_pages(int nr_to_scan, bool ignore_age)
+int sgx_reclaim_epc_pages(int nr_to_scan, bool ignore_age)
 {
 	int ret;
 
@@ -438,7 +439,7 @@ static int ksgxd(void *p)
 				     sgx_should_reclaim(SGX_NR_HIGH_PAGES));
 
 		if (sgx_should_reclaim(SGX_NR_HIGH_PAGES))
-			sgx_reclaim_pages(SGX_NR_TO_SCAN, false);
+			sgx_reclaim_epc_pages(SGX_NR_TO_SCAN, false);
 	}
 
 	return 0;
@@ -617,7 +618,7 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 			break;
 		}
 
-		sgx_reclaim_pages(SGX_NR_TO_SCAN, false);
+		sgx_reclaim_epc_pages(SGX_NR_TO_SCAN, false);
 	}
 
 	if (sgx_should_reclaim(SGX_NR_LOW_PAGES))
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index f3fc027f7cd0..ca51b3c7d905 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -181,6 +181,7 @@ void sgx_reclaim_direct(void);
 void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags);
 int sgx_drop_epc_page(struct sgx_epc_page *page);
 struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
+int sgx_reclaim_epc_pages(int nr_to_scan, bool ignore_age);
 
 void sgx_ipi_cb(void *info);
 
-- 
2.37.3

