From: Haitao Huang <haitao.huang@linux.intel.com>
Subject: [PATCH] cgroup/misc: Fix an overflow
Date: Mon, 17 Jul 2023 11:47:19 -0700
Message-ID: <20230717184719.85523-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689619641; x=1721155641;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Xn4mhx8wb+pDDvuBnsfj8E37sdsIB+VR4lYH55ZoQHk=;
  b=T+s9ij9NaN7rOESMeFL11IgEPCXS5O69U+dy7O0cf3sozFqxR8E3Oa7S
   TkUub/d9iZnwfqxvjwk6Q0oMbXUnar9RvmWG5wQay7jSWjjl0tBwFKaYg
   +HOZeFF/S5ZcNtFTiX1hM6C/p+LyylYe669vYFdBFlgmmAosGbDfpy2RO
   kjRlrtGuqTqruLt4JwMw24mRBQoFVx5R8f71k284zOAkGNeMGKX8CP5g/
   LsnQigBEHIAPxwqhA+blK/bgbAVSgBstTkJkZauvIecFAHt8SjgxkpGaZ
   JhkA61eUc+a21itcc6AH4D2mgoLWvc8nV4JcfRSvk8PCuD5HrPpUF90lw
   g==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko@kernel.org, dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: vipinsh@google.com, kai.huang@intel.com, reinette.chatre@intel.com, zhiquan1.li@intel.com, kristen@linux.intel.com

The variable 'new_usage' in misc_cg_try_charge() may overflow if it
becomes above INT_MAX. This was observed when I implement the new SGX
EPC cgroup[1] as a misc cgroup and test on a platform with large SGX EPC
sizes.

Change type of new_usage to long from int and check overflow.

Fixes: a72232eabdfcf ("cgroup: Add misc cgroup controller")
Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>

[1] https://lore.kernel.org/linux-sgx/20230712230202.47929-1-haitao.huang@linux.intel.com/
---
 kernel/cgroup/misc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index fe3e8a0eb7ed..ff9f900981a3 100644
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
@@ -153,10 +153,10 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
 
 	for (i = cg; i; i = parent_misc(i)) {
 		res = &i->res[type];
-
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

