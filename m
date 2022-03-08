From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] mm/memcg: add next_mz back if not reclaimed yet
Date: Tue,  8 Mar 2022 01:20:47 +0000
Message-ID: <20220308012047.26638-3-richard.weiyang@gmail.com>
References: <20220308012047.26638-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sX5s7jKgXd2WsU9F7nau9nEnt0LTAgg+hfHcITuEuBM=;
        b=ENqz0NVeHdKTzIpACb7Q9gDD11SNNdauqiy2jAzmxV49Bs5xz4/6u9nc363FgnwjOc
         db2aQrmbgMm+JEYdPncFEX5VQQvsjRhKVbvD+muJcfiBRB3R6diHamEZVbnJUElfYMuG
         K3ST7QJkIRRXUetvZ6Aad9u1qs+uNVbbL396ReLYD6W7jFWTCK/au2vp1ulGBSqTS3K8
         dmGAadaViT8WcX/booDtkS9outqBMSNflWKOygUbbjiOdYnZOMAuIvhB8GjmBaXUXsnZ
         1uV5J5PCNTxR8Qz3h6bQzbo+ZQ0H3mI8J0TkdHHpzQwO3jTkl8rKoNKzMKtUN1DvKjcK
         BMJw==
In-Reply-To: <20220308012047.26638-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

next_mz is removed from rb_tree, let's add it back if no reclaim has
been tried.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 344a7e891bc5..e803ff02aae2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3493,8 +3493,13 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
 			break;
 	} while (!nr_reclaimed);
-	if (next_mz)
+	if (next_mz) {
+		spin_lock_irq(&mctz->lock);
+		excess = soft_limit_excess(next_mz->memcg);
+		__mem_cgroup_insert_exceeded(next_mz, mctz, excess);
+		spin_unlock_irq(&mctz->lock);
 		css_put(&next_mz->memcg->css);
+	}
 	return nr_reclaimed;
 }
 
-- 
2.33.1

