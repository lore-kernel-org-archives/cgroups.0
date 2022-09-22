From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH 10/20] x86/sgx: Return the number of EPC pages that were successfully reclaimed
Date: Thu, 22 Sep 2022 10:10:47 -0700
Message-ID: <20220922171057.1236139-11-kristen@linux.intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663866784; x=1695402784;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IRVYENCJ7yHBfO6uy21g2daHEDZv9zK8fsTrdOaM4yM=;
  b=EXxjT2XZLxuD5xD8eD5nTCvlL5NCtCt28zOQLTSRdUbrqH4D/ha+lf7J
   Oml4nU0ZmmzBymmEDjw0L1f7cydWSZn8bqbSV95VQNL1b0jJ89at3KDY6
   V1HXjL0sTGgifDMRBjXRNveDaIsxZN8QMWF+v30He/La0OcvQCjKbNZZL
   W0XcdBdg0UfkgvVE6mRzQ2BYcyfxusV3NPkAGlaGcEnQhdDK42XS8wNUF
   NeNn/Un0mhyRBsoMFm+JRxAF0g1RBAljbLxPc8VgtPPJWxdEhX31IPVrM
   DAY+EHNUg3FQeoXrPYFNsVwJpxQiplZZ/j3G6dB0iyyh9Hy2XbEUlaBoy
   A==;
In-Reply-To: <20220922171057.1236139-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Return the number of reclaimed pages from sgx_reclaim_pages(), the EPC
cgroup will use the result to track the success rate of its reclaim
calls, e.g. to escalate to a more forceful reclaiming mode if necessary.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 0010ed1b2e98..fc5aed813834 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -290,8 +290,10 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
  * + EWB) but not sufficiently. Reclaiming one page at a time would also be
  * problematic as it would increase the lock contention too much, which would
  * halt forward progress.
+ *
+ * Return: number of EPC pages reclaimed
  */
-static void sgx_reclaim_pages(int nr_to_scan)
+static int sgx_reclaim_pages(int nr_to_scan)
 {
 	struct sgx_backing backing[SGX_MAX_NR_TO_RECLAIM];
 	struct sgx_encl_page *encl_page;
@@ -373,6 +375,7 @@ static void sgx_reclaim_pages(int nr_to_scan)
 	}
 out:
 	cond_resched();
+	return i;
 }
 
 static bool sgx_should_reclaim(unsigned long watermark)
-- 
2.37.3

