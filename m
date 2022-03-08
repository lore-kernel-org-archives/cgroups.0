From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] mm/memcg: mz already removed from rb_tree in mem_cgroup_largest_soft_limit_node()
Date: Tue,  8 Mar 2022 01:20:45 +0000
Message-ID: <20220308012047.26638-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=fCsAW2UJBB6c8M7QlLxk/JpB7LFkDqCihtv/AG+0X8o=;
        b=YNtiEQf2jKNmJlXMfNeoZdWXaEcpCVilMpTG4BBRfrU5l33H8y5awom0neQTkabjSX
         pBacWDo4xIUCPIHGBfw8yvFDySfav4+5cR+67pRdAYrfHCJG8s8qLWatTR7Ll2Fwh0qF
         kCRrRu4GRUB9MJiL+tBGkICngiZEf4MCXvacOYMjF/BHDYrwDZf87XL9JqdclDLzultF
         ynwtsCaghvo7fjOVtIBZ6zPFNE5BcX7AAyrIQinfAEbOknUsm9ZTEhEMWSXCrm+DAE0u
         YOYYaKv7BMSg0g228arxqpgpLUAwOBwl416q0s5wF5SmYlImMDxL4488GLTUc22hVd0N
         gTSQ==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

When mz is not NULL, mem_cgroup_largest_soft_limit_node() has removed
it from rb_tree.

Not necessary to call __mem_cgroup_remove_exceeded() again.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f898320b678a..d70bf5cf04eb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3458,7 +3458,6 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 		nr_reclaimed += reclaimed;
 		*total_scanned += nr_scanned;
 		spin_lock_irq(&mctz->lock);
-		__mem_cgroup_remove_exceeded(mz, mctz);
 
 		/*
 		 * If we failed to reclaim anything from this memory cgroup
-- 
2.33.1

