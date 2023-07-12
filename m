From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 17/28] x86/sgx: fix a NULL pointer
Date: Wed, 12 Jul 2023 16:01:51 -0700
Message-ID: <20230712230202.47929-18-haitao.huang@linux.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689202936; x=1720738936;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=29rCY8b1sI/pP+SjE7VInjolfMafoPZmrodrQ56lQbM=;
  b=GXltZie+I4jPLkN3A6s3ad60A3gpvCwELiAms4Wm9FVXszPi9KL3nkkq
   mmfhAPa5pOyzyDgffbNlrVprAkdzVL9jDd26Sy2R7uxfimS9ZfEFsnwff
   m1Nduajsy/9+vJhif1yVqHLJ5NCKn9HPsWfXdyTuruEGcU6gxWoAa/rCy
   Kzz32WTz77TxwxgMs7q4hTH1jvlr8cSuXNzp5KD9aTDkL1TXf+sTWq8kB
   zRn8vyIdg4S32/2v6JjvZFxf9vpbBC308aOQG+VG5PK6hPoiQs1yBVVG8
   Ykt2D4AJAAP/ZtbJZncskae2RqFrHdgMS0LWIWSjbUZZFVbBBHuCojIfL
   w==;
In-Reply-To: <20230712230202.47929-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Under heavy load, the SGX EPC reclaimers (ksgxd or future EPC cgroup
worker) may reclaim SECS EPC page for an enclave and set
encl->secs.epc_page to NULL. But the SECS EPC page is required for EAUG
in #PF handler and is used without checking for NULL and reloading.

Fix this by checking if SECS is loaded before EAUG and load it if it was
reclaimed.

Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/encl.c | 30 +++++++++++++++++++++++-------
 arch/x86/kernel/cpu/sgx/main.c |  4 ++++
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index c321c848baa9..028d1b9d6572 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -235,6 +235,19 @@ static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	return epc_page;
 }
 
+static struct sgx_epc_page *sgx_encl_load_secs(struct sgx_encl *encl)
+{
+	struct sgx_epc_page *epc_page = encl->secs.epc_page;
+
+	if (!epc_page) {
+		epc_page = sgx_encl_eldu(&encl->secs, NULL);
+		if (!IS_ERR(epc_page))
+			sgx_record_epc_page(epc_page, SGX_EPC_OWNER_ENCL_PAGE |
+					    SGX_EPC_PAGE_UNRECLAIMABLE);
+	}
+	return epc_page;
+}
+
 static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 						  struct sgx_encl_page *entry)
 {
@@ -248,13 +261,9 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 		return entry;
 	}
 
-	if (!(encl->secs.epc_page)) {
-		epc_page = sgx_encl_eldu(&encl->secs, NULL);
-		if (IS_ERR(epc_page))
-			return ERR_CAST(epc_page);
-		sgx_record_epc_page(epc_page, SGX_EPC_OWNER_ENCL_PAGE |
-				    SGX_EPC_PAGE_UNRECLAIMABLE);
-	}
+	epc_page = sgx_encl_load_secs(encl);
+	if (IS_ERR(epc_page))
+		return ERR_CAST(epc_page);
 
 	epc_page = sgx_encl_eldu(entry, encl->secs.epc_page);
 	if (IS_ERR(epc_page))
@@ -342,6 +351,13 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 
 	mutex_lock(&encl->lock);
 
+	epc_page = sgx_encl_load_secs(encl);
+	if (IS_ERR(epc_page)) {
+		if (PTR_ERR(epc_page) == -EBUSY)
+			vmret =  VM_FAULT_NOPAGE;
+		goto err_out_unlock;
+	}
+
 	epc_page = sgx_alloc_epc_page(encl_page, false);
 	if (IS_ERR(epc_page)) {
 		if (PTR_ERR(epc_page) == -EBUSY)
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 9ea487469e4c..68c89d575abc 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -265,6 +265,10 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 
 	mutex_lock(&encl->lock);
 
+	/* Should not be possible */
+	if (WARN_ON(!(encl->secs.epc_page)))
+		goto out;
+
 	sgx_encl_ewb(epc_page, backing);
 	encl_page->epc_page = NULL;
 	encl->secs_child_cnt--;
-- 
2.25.1

