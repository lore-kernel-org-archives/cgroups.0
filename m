From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 18/28] cgroup/misc: Fix an overflow
Date: Wed, 12 Jul 2023 16:01:52 -0700
Message-ID: <20230712230202.47929-19-haitao.huang@linux.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689202937; x=1720738937;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gtPme0IuXCAV4jbp0xb73aBMQFtTiscdTlcYYwDyGg8=;
  b=LU/fwLB0h47yZrs3fFKLbojxHgRpYrQ6iIvzDpxHqSnhwm5C1Bb8lLs3
   ZZ6eclaF+n5kv3WCCBcwpdZ6Bbk/iqdD9EfLa77GTJO+z9mNYI+HXbDjw
   Y85VOTZTDQegwUXEfgzDNOdIbhgoO/gOSGk9uKinxNZv1aKMEMqUMzaWh
   hGKMsgb9vB9RX1YA2Nsepz7A34ZIoWfQXbWMU+jLkSuXjDid1mudOwH+y
   JVcIWZvhc9ffHBl1yLv1/kt7JjkPJ6DpegqdUBLCCM/KmrxWFJNudHqC9
   o+PNaBrus11gnGpxuGjD4b4J7cOq/j/q9dX6kGwTfYHJNt7hAV1lC+qxO
   A==;
In-Reply-To: <20230712230202.47929-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org

Overflow may happen in misc_cg_try_charge if new_usage becomes above
INT_MAX, for example, on platforms with large SGX EPC sizes.

Change type of new_usage to long from int and check overflow.

Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

