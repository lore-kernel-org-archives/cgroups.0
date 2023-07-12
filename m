From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 14/28] x86/sgx: Expose sgx_reclaim_pages() for use by EPC cgroup
Date: Wed, 12 Jul 2023 16:01:48 -0700
Message-ID: <20230712230202.47929-15-haitao.huang@linux.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689202934; x=1720738934;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=daxYHRT3QA1Zpwip8LWDoQLP3b3KzCxxiKp1osHbrTA=;
  b=bW2xzc32J98NefciNve4vJGMp7SJ1nVl0kN+Z7dMuOaI3KjLp6zkYv6v
   KYg4PF0SAUFcRMroS1WnyU+o4XykaqPuyTapgWPvhPDm1oZ6C1QP/SDsk
   7bN34rONoXRLDYXP4TyN0jUTey03RnSsop2Bxgy50s+75OY3jcsTz9F4k
   RyiUXdXeYvF2Xc++gmEhWsZ46Kic7nVBrlojO8EmQay1H56/80T60++61
   8dfecJsKwD0WN8PV8PnYHQU3b7bV9xw5aIJaj7b5x2z/YXgLcvHuQqG1B
   3BXd38YuXKJn2LgNQywngGsKSIBaCvlCJQZaaO8ZGZDfuAZCug3URWTnf
   w==;
In-Reply-To: <20230712230202.47929-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Expose the top-level reclaim function as sgx_reclaim_epc_pages() for use
by the upcoming EPC cgroup, which will initiate reclaim to enforce
changes to high/max limits.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 10 +++++-----
 arch/x86/kernel/cpu/sgx/sgx.h  |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index a829555b9675..e9c9e0d97300 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -289,7 +289,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 }
 
 /**
- * sgx_reclaim_pages() - Reclaim EPC pages from the consumers
+ * sgx_reclaim_epc_pages() - Reclaim EPC pages from the consumers
  * @nr_to_scan:		 Number of EPC pages to scan for reclaim
  * @ignore_age:		 Reclaim a page even if it is young
  *
@@ -305,7 +305,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
  * problematic as it would increase the lock contention too much, which would
  * halt forward progress.
  */
-static size_t sgx_reclaim_pages(size_t nr_to_scan, bool ignore_age)
+size_t sgx_reclaim_epc_pages(size_t nr_to_scan, bool ignore_age)
 {
 	struct sgx_backing backing[SGX_NR_TO_SCAN_MAX];
 	struct sgx_epc_page *epc_page, *tmp;
@@ -409,7 +409,7 @@ static bool sgx_should_reclaim(unsigned long watermark)
 void sgx_reclaim_direct(void)
 {
 	if (sgx_should_reclaim(SGX_NR_LOW_PAGES))
-		sgx_reclaim_pages(SGX_NR_TO_SCAN, false);
+		sgx_reclaim_epc_pages(SGX_NR_TO_SCAN, false);
 }
 
 static int ksgxd(void *p)
@@ -432,7 +432,7 @@ static int ksgxd(void *p)
 				     sgx_should_reclaim(SGX_NR_HIGH_PAGES));
 
 		if (sgx_should_reclaim(SGX_NR_HIGH_PAGES))
-			sgx_reclaim_pages(SGX_NR_TO_SCAN, false);
+			sgx_reclaim_epc_pages(SGX_NR_TO_SCAN, false);
 
 		cond_resched();
 	}
@@ -607,7 +607,7 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 			break;
 		}
 
-		sgx_reclaim_pages(SGX_NR_TO_SCAN, false);
+		sgx_reclaim_epc_pages(SGX_NR_TO_SCAN, false);
 		cond_resched();
 	}
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index f26ed4c0d12f..98d3b15341b1 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -175,6 +175,7 @@ void sgx_reclaim_direct(void);
 void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags);
 int sgx_drop_epc_page(struct sgx_epc_page *page);
 struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
+size_t sgx_reclaim_epc_pages(size_t nr_to_scan, bool ignore_age);
 
 void sgx_ipi_cb(void *info);
 
-- 
2.25.1

