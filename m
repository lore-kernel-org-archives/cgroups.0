From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 01/18] x86/sgx: Call cond_resched() at the end of sgx_reclaim_pages()
Date: Fri,  2 Dec 2022 10:36:37 -0800
Message-ID: <20221202183655.3767674-2-kristen@linux.intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670006226; x=1701542226;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qv8PoJW739IycS7cP6BKN7byFcsUeUj+E5iETGUdTaY=;
  b=fjwrwjP9y+xUEsMd6ZeGhn8XC348NLasrXvwxkfJICVBO3ZSoij9vVmd
   6n287W0Zzn8E3fNXrvfyuK9LQn5YK/Qs11plq4giEMXVX8lTMYiFuwfEs
   QEpOUFuhTtLoQvWK6EQSi6TctCfuSeG0vO1EmjwEJ8QsD7FEviR89DLlT
   sIuJDFUD/uH85zJcrDOXw8cvjUFZOfqxGXtl7TpDw8vU07t6dbq5tKTs0
   wXuvF00RoE3LxhWuD1HrUFBI3Yys/YJIUztwpoEiqJzp58mPhX8LVReCW
   EcFU/FwdhO5Xmlp4DIidrt4HPrm3/R3nttsrRQZIYLD/oAQqq9k4gb+w+
   w==;
In-Reply-To: <20221202183655.3767674-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In order to avoid repetition of cond_resched() in ksgxd() and
sgx_alloc_epc_page(), move the invocation of post-reclaim cond_resched()
inside sgx_reclaim_pages(). Except in the case of sgx_reclaim_direct(),
sgx_reclaim_pages() is always called in a loop and is always followed
by a call to cond_resched().  This will hold true for the EPC cgroup
as well, which adds even more calls to sgx_reclaim_pages() and thus
cond_resched(). Calls to sgx_reclaim_direct() may be performance
sensitive. Allow sgx_reclaim_direct() to avoid the cond_resched()
call by moving the original sgx_reclaim_pages() call to
__sgx_reclaim_pages() and then have sgx_reclaim_pages() become a
wrapper around that call with a cond_resched().

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 160c8dbee0ab..ffce6fc70a1f 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -287,7 +287,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
  * problematic as it would increase the lock contention too much, which would
  * halt forward progress.
  */
-static void sgx_reclaim_pages(void)
+static void __sgx_reclaim_pages(void)
 {
 	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
 	struct sgx_backing backing[SGX_NR_TO_SCAN];
@@ -369,6 +369,12 @@ static void sgx_reclaim_pages(void)
 	}
 }
 
+static void sgx_reclaim_pages(void)
+{
+	__sgx_reclaim_pages();
+	cond_resched();
+}
+
 static bool sgx_should_reclaim(unsigned long watermark)
 {
 	return atomic_long_read(&sgx_nr_free_pages) < watermark &&
@@ -378,12 +384,14 @@ static bool sgx_should_reclaim(unsigned long watermark)
 /*
  * sgx_reclaim_direct() should be called (without enclave's mutex held)
  * in locations where SGX memory resources might be low and might be
- * needed in order to make forward progress.
+ * needed in order to make forward progress. This call to
+ * __sgx_reclaim_pages() avoids the cond_resched() in sgx_reclaim_pages()
+ * to improve performance.
  */
 void sgx_reclaim_direct(void)
 {
 	if (sgx_should_reclaim(SGX_NR_LOW_PAGES))
-		sgx_reclaim_pages();
+		__sgx_reclaim_pages();
 }
 
 static int ksgxd(void *p)
@@ -410,8 +418,6 @@ static int ksgxd(void *p)
 
 		if (sgx_should_reclaim(SGX_NR_HIGH_PAGES))
 			sgx_reclaim_pages();
-
-		cond_resched();
 	}
 
 	return 0;
@@ -582,7 +588,6 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 		}
 
 		sgx_reclaim_pages();
-		cond_resched();
 	}
 
 	if (sgx_should_reclaim(SGX_NR_LOW_PAGES))
-- 
2.38.1

