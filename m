From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 24/26] cgroup/misc: Add SGX EPC resource type
Date: Fri, 11 Nov 2022 10:35:29 -0800
Message-ID: <20221111183532.3676646-25-kristen@linux.intel.com>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668191782; x=1699727782;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EBcLsiw30eqLl7g1ih7HHqPXoxhQ0Yyb7AgcJd3NM6M=;
  b=DcdzJGxlzqeMI/lVJgpZqqrS2R/BtbGEaER+UPPX/2sRCSlBUD7UsRBQ
   iinw8ZfNwf/pMHccT7UNwlg5FXGzc5JjIS2JvaGOiQ9/ZocAEF8cbrArC
   1uDU6p+EwBNwHuIhpW5jragpop1al97Xa+tUg/o6A1S7DxsRIYwYNnjsB
   psk0qIH9OPaj8FXtVonWN2kw1Fk++umdmg5ctHUgPPWhcyx0q3wFX3TQm
   tHjlLM7lyA9zJ+Vt3DtyzfY2W+aaBhL78/zIFq4m5u3ziAwsiRc2t2Kym
   FXOKldQlIV+Vj6/TBZwu5YVxa/l/hde1crqPRw2Ey7oyWNiXsWGYDupsf
   A==;
In-Reply-To: <20221111183532.3676646-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Allow SGX EPC memory to be a valid resource type for the misc
controller.

Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 include/linux/misc_cgroup.h | 4 ++++
 kernel/cgroup/misc.c        | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index cee848205715..aeaf4acf22af 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -17,6 +17,10 @@ enum misc_res_type {
 	MISC_CG_RES_SEV,
 	/* AMD SEV-ES ASIDs resource */
 	MISC_CG_RES_SEV_ES,
+#endif
+#ifdef CONFIG_CGROUP_SGX_EPC
+	/* SGX EPC memory resource */
+	MISC_CG_RES_SGX_EPC,
 #endif
 	MISC_CG_RES_TYPES
 };
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index 642879ad136f..e73a034adca3 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -25,6 +25,10 @@ static const char *const misc_res_name[] = {
 	/* AMD SEV-ES ASIDs resource */
 	"sev_es",
 #endif
+#ifdef CONFIG_CGROUP_SGX_EPC
+	/* Intel SGX EPC memory bytes */
+	"sgx_epc",
+#endif
 };
 
 /* Root misc cgroup */
-- 
2.37.3

