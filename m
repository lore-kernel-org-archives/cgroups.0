From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 3/4] memcg: optimize memcg_get_hierarchical_limit
Date: Mon, 25 Jun 2012 16:44:32 +0800
Message-ID: <1340613872-9581-1-git-send-email-liwp.linux@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=0ZYakQ3oelabxHywtNMhVOpQbqbC9UkOwQZG0dU6bV4=;
        b=sAkQq8wVds9ust6zcYc4t6Hv0FjESUTB1gUXbXSJ7QbKVR59TYF3FQ/vN+fsDDasHU
         UCM3nPs3zwDfG6cEOoIGMs4vwiKa7CfK7MNxIloFs6Fc3K33hYN6zuxmUKxBAK9okBeC
         8j4YQgugRuO2t8OmKf9p99hfnpx93XvvTYTk4/UlhHjmsrlY8V4K597ut7wEdtV8zePD
         zSk2ILazNT4eCtGw6h65Sg7nBSh/sYUAU6sgP5odJ7Tc9o5sM2SvM9LOnlqjARyFt1YG
         8McjGtvt0HJReQAmM+wId6IJyLt7M8jyv/3ICLV/DWZKrAzGSUCKNbs1KtQhnJVoCCUi
         240Q==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Arun Sharma <asharma-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Optimize memcg_get_hierarchical_limit to save cpu cycle.

Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2e81328..4520b57 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3917,9 +3917,9 @@ static void memcg_get_hierarchical_limit(struct mem_cgroup *memcg,
 
 	min_limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
 	min_memsw_limit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
-	cgroup = memcg->css.cgroup;
 	if (!memcg->use_hierarchy)
 		goto out;
+	cgroup = memcg->css.cgroup;
 
 	while (cgroup->parent) {
 		cgroup = cgroup->parent;
-- 
1.7.9.5
