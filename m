From: Haitao Huang <haitao.huang@linux.intel.com>
Subject: [PATCH v3 11/28] x85/sgx: Return the number of EPC pages that were successfully reclaimed
Date: Wed, 12 Jul 2023 16:01:45 -0700
Message-ID: <20230712230202.47929-12-haitao.huang@linux.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689202933; x=1720738933;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fJtlT/xQbGuqifSvzspe+hCOxY7ihArgj6I6Qvo1HZE=;
  b=JB7IdPOrpTpeHYj1zlQuFbeN7nZEXzgZLxLb9TGoq49s2ys7RwHSmj81
   r7st3YpFI4mKcgDbehEUF3XjzCPD/p7cea427vlK03IWoVg/3OUybDTtT
   jRXm4XMVEmbpPMkg5Mj89IBkd5qLK1IN7gwPaG8wxt3S39HRjuU5N5x16
   9J1BoW7bpRKoFgNUbwoiKtNWoxcCv2X0M1sYbvFLScUxm/RYcl6DhpCHJ
   /kAHonVL0jTR5rAULM+/mkQgrxZhi2qSpAZpoLPBIfMiCTVvVybiqJmQv
   f7bvkrKBaa3zUSw3K8o8Udj1vbP2q1Vr619j7RM/pupouZa00uyfKMojb
   A==;
In-Reply-To: <20230712230202.47929-1-haitao.huang@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko@kernel.org, dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: kai.huang@intel.com, reinette.chatre@intel.com, Sean Christopherson <sean.j.christopherson@intel.com>, zhiquan1.li@intel.com, kristen@linux.intel.com, seanjc@google.com

From: Sean Christopherson <sean.j.christopherson@intel.com>

Return the number of reclaimed pages from sgx_reclaim_pages(), the EPC
cgroup will use the result to track the success rate of its reclaim
calls, e.g. to escalate to a more forceful reclaiming mode if necessary.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index cd5e5517866a..4fc931156972 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -299,15 +299,15 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
  * problematic as it would increase the lock contention too much, which would
  * halt forward progress.
  */
-static void sgx_reclaim_pages(int nr_to_scan)
+static size_t sgx_reclaim_pages(size_t nr_to_scan)
 {
 	struct sgx_backing backing[SGX_NR_TO_SCAN_MAX];
 	struct sgx_epc_page *epc_page, *tmp;
 	struct sgx_encl_page *encl_page;
 	pgoff_t page_index;
 	LIST_HEAD(iso);
-	int ret;
-	int i;
+	size_t ret;
+	size_t i;
 
 	spin_lock(&sgx_global_lru.lock);
 	for (i = 0; i < SGX_NR_TO_SCAN; i++) {
@@ -333,7 +333,7 @@ static void sgx_reclaim_pages(int nr_to_scan)
 	spin_unlock(&sgx_global_lru.lock);
 
 	if (list_empty(&iso))
-		return;
+		return 0;
 
 	i = 0;
 	list_for_each_entry_safe(epc_page, tmp, &iso, list) {
@@ -378,6 +378,7 @@ static void sgx_reclaim_pages(int nr_to_scan)
 
 		sgx_free_epc_page(epc_page);
 	}
+	return i;
 }
 
 static bool sgx_should_reclaim(unsigned long watermark)
-- 
2.25.1

