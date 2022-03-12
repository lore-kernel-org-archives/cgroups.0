From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [Patch v2 1/3] mm/memcg: mz already removed from rb_tree in mem_cgroup_largest_soft_limit_node()
Date: Sat, 12 Mar 2022 07:16:21 +0000
Message-ID: <20220312071623.19050-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=fCsAW2UJBB6c8M7QlLxk/JpB7LFkDqCihtv/AG+0X8o=;
        b=gqlsHeWUslWmzUd/Eur6w3QnGn7z2Zwd53xTFvdB8A32ZYPRsfJNBaAwpSKYMaKBN7
         Ow2oIrQFQHSV+lmB4JpCjzVpV2lwJ/YqI/9FSKwQDmDfs9VaBrPJeEKgtx5nwB1Lj2x/
         6+bmSn4/Ei6xKx5X/k4isDUc4/6feXGplx3FStYBqaIVKj0l6LGBxLX3sskLSsysS+dz
         RbUBSKdevPvprvhQXzMqfkOQ7m6kNdlwRCda0DYDQx+tNNXdjB/tImVE6t7B8C5x68HJ
         wY5JZZhZoFO7SN/y9eB4vA9xiunMKSr3rXaoa0YlR0eGT7jKk3wZgxmcQPxo8jLz5Fn+
         TYcg==
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

