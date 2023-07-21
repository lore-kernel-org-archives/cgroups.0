From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] cgroup/misc: Store atomic64_t reads to u64
Date: Fri, 21 Jul 2023 05:02:31 -0700
Message-ID: <20230721120231.13916-1-haitao.huang@linux.intel.com>
References: <ZLcXmvDKheCRYOjG@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689941056; x=1721477056;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4uv9zD1JJrwXe0E9I+ej0cnkJSwI8eyQL9t7kRDmIDo=;
  b=JrMHGcYdzpNM9PLduB1h5Sn+FLeqPXacQsvIBFPFH4chBjg+pDfZ6ksl
   GGvwSFeQ0lavCreYuva2h76uzqR6rVFmtXQpbfiwcnkevVEVJXERBKjpG
   KP9Nf/0N812B8pS90yjPIoJzqX79cMVYFwO7zKGZdvNoMCG5ZyVgVBXGM
   96Ho/79J6m0IhJndRgtx7iaoNjKAkejuoGLPdPaSkHuvQ4gyn3pMPtDEq
   yvbPmIQrDPaqDGeQvH2NNMl1jLvf5lB9F+C9uO179RPXiN4jIsw7rWIrz
   t+Gt0ZtZCul+y749XaCYxYrMveKYlVMmXTNXG7X5tGzDv5Tlg/YhUIqSR
   g==;
In-Reply-To: <ZLcXmvDKheCRYOjG-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

Change 'new_usage' type to u64 so it can be compared with unsigned 'max'
and 'capacity' properly even if the value crosses the signed boundary.

Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 kernel/cgroup/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index abbe9aa5cdd1..79a3717a5803 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -142,7 +142,7 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg, u64 amount)
 	struct misc_cg *i, *j;
 	int ret;
 	struct misc_res *res;
-	s64 new_usage;
+	u64 new_usage;
 
 	if (!(valid_type(type) && cg && READ_ONCE(misc_res_capacity[type])))
 		return -EINVAL;

base-commit: 32bf85c60ca3584a7ba3bef19da2779b73b2e7d6
-- 
2.25.1

