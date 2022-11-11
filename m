From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 10/26] x86/sgx: Return the number of EPC pages that were successfully reclaimed
Date: Fri, 11 Nov 2022 10:35:15 -0800
Message-ID: <20221111183532.3676646-11-kristen@linux.intel.com>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668191760; x=1699727760;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=auEkniWHXFa2fE8QomwYSOXBkMl7XCSjIOySc76haUo=;
  b=moE5q5ze8HRfh2Io/10CiATX4QuLtmCZ9WUGz5eTpMe6kB/wOIsPq+WB
   U/UmBWrsSRMys87dGMDh24avstK8wJ5z6a4ZT079FDDoyyinPiX+Fe+0F
   sP98tgIkmDERihHKBVt/odKR2/Wz3h6rWmsjg4xQlGf1maJ7tQnAw/4lh
   r40zxA1+d0apprXFTYBRK7vFqL+CNrIbv2jWcmj74x4iS6RmOBWus4hJr
   dOVHHOhbVR5fj631MvmkeP8sCUWKzc7JHtlH9a1aWlD4ElJeg4Ciz1z4Z
   BpRXTP9Yi+0RoU9YqYu8jvGo/Oyi82Xp0EIoPZwomsjVu7aDPb9eacr8D
   A==;
In-Reply-To: <20221111183532.3676646-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Return the number of reclaimed pages from sgx_reclaim_pages(), the EPC
cgroup will use the result to track the success rate of its reclaim
calls, e.g. to escalate to a more forceful reclaiming mode if necessary.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 02b9eafa90a2..dfd76c605ef2 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -291,7 +291,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
  * problematic as it would increase the lock contention too much, which would
  * halt forward progress.
  */
-static void __sgx_reclaim_pages(int nr_to_scan)
+static int __sgx_reclaim_pages(int nr_to_scan)
 {
 	struct sgx_backing backing[SGX_MAX_NR_TO_RECLAIM];
 	struct sgx_epc_page *epc_page, *tmp;
@@ -326,7 +326,7 @@ static void __sgx_reclaim_pages(int nr_to_scan)
 	spin_unlock(&sgx_global_lru.lock);
 
 	if (list_empty(&iso))
-		return;
+		return 0;
 
 	i = 0;
 	list_for_each_entry_safe(epc_page, tmp, &iso, list) {
@@ -371,12 +371,16 @@ static void __sgx_reclaim_pages(int nr_to_scan)
 
 		sgx_free_epc_page(epc_page);
 	}
+	return i;
 }
 
-static void sgx_reclaim_pages(int nr_to_scan)
+static int sgx_reclaim_pages(int nr_to_scan)
 {
-	__sgx_reclaim_pages(nr_to_scan);
+	int ret;
+
+	ret = __sgx_reclaim_pages(nr_to_scan);
 	cond_resched();
+	return ret;
 }
 
 static bool sgx_should_reclaim(unsigned long watermark)
-- 
2.37.3

