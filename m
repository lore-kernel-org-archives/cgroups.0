From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] mm/memcg: __mem_cgroup_remove_exceeded could handle a !on-tree mz properly
Date: Tue,  8 Mar 2022 01:20:46 +0000
Message-ID: <20220308012047.26638-2-richard.weiyang@gmail.com>
References: <20220308012047.26638-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TJpD8WbIgS+xru6bpF+N+uC+vSCiqZY6PRQI5LvMXoI=;
        b=Mr7bFXwRFUanMnGNnpUckpJUfAZz88L9eyoAngmHhhUmy7Hqswp/VuwagZ443cQndP
         oCYNfJQDtVorLVlM6sGSf1Aw7fwzcJjKa3hocgArdnUC2b8mUekANMGbZ7JYBxM1ER2N
         Bwv1pVU1nOKa3h9I+wd+bRWNJvymSim3EsfV01aqg571rb8b1vSnMwMVgQzwupbz4ds6
         FlngrH9dFe5VxrBvaH5tLHpypB4tePgIJHkW6e3MDcukco9XUnen3VuH8mD2iDs+fa92
         Uqac1l6dB+FODzmk4AEz546j7iblgAs5xOPKwCRZt77Z6pZQTSBQDhKNLnCAm66OnC50
         M9QA==
In-Reply-To: <20220308012047.26638-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

There is no tree operation if mz is not on-tree.

Let's remove the extra check.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d70bf5cf04eb..344a7e891bc5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -545,9 +545,11 @@ static void mem_cgroup_update_tree(struct mem_cgroup *memcg, int nid)
 			unsigned long flags;
 
 			spin_lock_irqsave(&mctz->lock, flags);
-			/* if on-tree, remove it */
-			if (mz->on_tree)
-				__mem_cgroup_remove_exceeded(mz, mctz);
+			/*
+			 * remove it first
+			 * If not on-tree, no tree ops.
+			 */
+			__mem_cgroup_remove_exceeded(mz, mctz);
 			/*
 			 * Insert again. mz->usage_in_excess will be updated.
 			 * If excess is 0, no tree ops.
-- 
2.33.1

