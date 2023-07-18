From: Haitao Huang <haitao.huang@linux.intel.com>
Subject: [PATCH 1/2] cgroup/misc: Fix an overflow
Date: Mon, 17 Jul 2023 18:08:44 -0700
Message-ID: <20230718010845.35197-1-haitao.huang@linux.intel.com>
References: <ZLWmdBfcuPUBtk1K@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689642544; x=1721178544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U+HYDr0YJ1RDyX2/gcHKL0bAVncJHhQaWyxrxc5y+kQ=;
  b=IXuhTp7EdtszAEwpGuUiCPemVyaHHaYhKMbYGxKCQwae1bt0LJC/lD17
   QCYK9G0NWK+WUH4P81S9t/isYrrdfTUnmzg8nq1dqA0xMX5eOrthZvkyU
   07fUdaKA1sshaZZ7BCsi7b9ygELqW4kBwOtE5h625R1LQZb+VUp7K4XdL
   VxFUJop3SJIRbfCS+PcQE9Nm0IlOh8cAzUQOJkwbckB4JzrwPGCzqQsVZ
   sG2J2GWhynYsRcoS9tBwUR1BEaE4aoswZX6qykMi2CAteKRSifESlT6v2
   YZ/pcm8mLv9eJgCmEpQBQ06TCLjqsvR5FOX5lXSDWLJ9lCazmEBrErFR3
   A==;
In-Reply-To: <ZLWmdBfcuPUBtk1K@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, jarkko@kernel.org, dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: vipinsh@google.com, kai.huang@intel.com, reinette.chatre@intel.com, zhiquan1.li@intel.com, kristen@linux.intel.com

The variable 'new_usage' in misc_cg_try_charge() may overflow if it
becomes above INT_MAX. This was observed when I implement the new SGX
EPC cgroup[1] as a misc cgroup and test on a platform with large SGX EPC
sizes.

Change type of new_usage to long from int and check overflow.

Fixes: a72232eabdfc ("cgroup: Add misc cgroup controller")
Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>

[1] https://lore.kernel.org/linux-sgx/20230712230202.47929-1-haitao.huang@linux.intel.com/
---
 kernel/cgroup/misc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index fe3e8a0eb7ed..b127607837c6 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -143,7 +143,7 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
 	struct misc_cg *i, *j;
 	int ret;
 	struct misc_res *res;
-	int new_usage;
+	long new_usage;
 
 	if (!(valid_type(type) && cg && READ_ONCE(misc_res_capacity[type])))
 		return -EINVAL;
@@ -156,7 +156,8 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
 
 		new_usage = atomic_long_add_return(amount, &res->usage);
 		if (new_usage > READ_ONCE(res->max) ||
-		    new_usage > READ_ONCE(misc_res_capacity[type])) {
+		    new_usage > READ_ONCE(misc_res_capacity[type]) ||
+		    new_usage < 0) {
 			ret = -EBUSY;
 			goto err_charge;
 		}
-- 
2.25.1

