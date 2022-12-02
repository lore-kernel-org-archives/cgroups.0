From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 11/18] x86/sgx: Prepare for multiple LRUs
Date: Fri,  2 Dec 2022 10:36:47 -0800
Message-ID: <20221202183655.3767674-12-kristen@linux.intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670006246; x=1701542246;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UYpUlq+6H1OK5zNVWPbJu6ZZ/ARyRWJyKUaDzZw64U4=;
  b=XbcsOr+W7KNHyshrAEZOusqAx5gaBk4z2MtzqvNjf6HLhjwk5n678+Gk
   9tnmKoaopQFpGbB6UZg/RAnD2bQmmBSZPBbKkhryB2t3j8soUeYs15B1R
   z2PZUgXCTaz2V6IBtbh/14jVofCds1X5aQ+zAkR4w/b22Y8j9dwur1rAy
   hPA5GOlwnA7Lt1Z4d/K6lqy9HMTo5FsuAE4aSWkJyz//igtdb+vZtGxTX
   pl5J28hGUD7z+cVl1xHvZc2+bc94Xm09k4ymHMvdt+5alrAVSwFCKQJIj
   oGG0iiA3ROdhWGhfLRZxhgNCwiBvi5EJj/VGuQ7kBiX+4YUllAgQnSdRl
   w==;
In-Reply-To: <20221202183655.3767674-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add sgx_can_reclaim() wrapper so that in a subsequent patch, multiple LRUs
can be used cleanly.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index db96483e2e74..96399e2016a8 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -394,10 +394,15 @@ static int sgx_reclaim_pages(int nr_to_scan, bool ignore_age)
 	return ret;
 }
 
+static bool sgx_can_reclaim(void)
+{
+	return !list_empty(&sgx_global_lru.reclaimable);
+}
+
 static bool sgx_should_reclaim(unsigned long watermark)
 {
 	return atomic_long_read(&sgx_nr_free_pages) < watermark &&
-	       !list_empty(&sgx_global_lru.reclaimable);
+		sgx_can_reclaim();
 }
 
 /*
@@ -606,7 +611,7 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 			break;
 		}
 
-		if (list_empty(&sgx_global_lru.reclaimable))
+		if (!sgx_can_reclaim())
 			return ERR_PTR(-ENOMEM);
 
 		if (!reclaim) {
-- 
2.38.1

