From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH 13/20] x86/sgx: Prepare for multiple LRUs
Date: Thu, 22 Sep 2022 10:10:50 -0700
Message-ID: <20220922171057.1236139-14-kristen@linux.intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663866785; x=1695402785;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n2WN4hJfwaj5ptNYeIEmphrPKVncHIzDa6421dNQKGI=;
  b=Rnn9FtAG7nyMCpIAzBbAQokX0UvsOOHxXmGOB+Fl1xf/FwWS2CrdQ6yT
   4627OM/+9OgTfRvzzxFi+4EzguxLcMC9EAMZloCAfXVErx7RttH+2Qa4S
   Or2zewLtA+UtSEv2NLdSNvFQD2/zbA/ttPHPTZSktaJmwGJ7tSTkMd6YJ
   TDmhGih/+BKw7WPmgskNOIdtdMgjkvwUFyvcyxaGS6tmWU7Z2wzBwuizx
   TQusCoPQOBNWzOt8AG5Eybnu5xRCb+s/YeFWZKQbfd1Zw4IuDLKnAVq2i
   xqkx/ShVvbUcNAwJrEGZh9UD6hgmKwils6Rk1vgflj8lJFSQaG5kYHhfO
   Q==;
In-Reply-To: <20220922171057.1236139-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

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
index 9f2cb264a347..ac49346302ed 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -386,10 +386,15 @@ static int sgx_reclaim_pages(int nr_to_scan, bool ignore_age)
 	return i;
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
@@ -588,7 +593,7 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 			break;
 		}
 
-		if (list_empty(&sgx_global_lru.reclaimable))
+		if (!sgx_can_reclaim())
 			return ERR_PTR(-ENOMEM);
 
 		if (!reclaim) {
-- 
2.37.3

