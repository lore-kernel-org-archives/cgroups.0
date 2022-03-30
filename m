From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [Patch v2 2/3] mm/memcg: set pos explicitly for reclaim and !reclaim
Date: Wed, 30 Mar 2022 23:47:18 +0000
Message-ID: <20220330234719.18340-3-richard.weiyang@gmail.com>
References: <20220330234719.18340-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6FJnqnKyYiDxw5+zHvmYhDEIHbsPH/AeIDmnSnqcv8U=;
        b=o5aWz+8c0XSKHv66RUMiIoR/ArVLQsHrsbZ9viJiWDel0QYolsZo+3P9o/TlWTdErM
         VM6LJrjtXVstBK+E+JwFdt37ex4X7hoR19Pnhxcnckr3VmFzG6JzVC6Fw+zBSi490HwX
         ZYiKTzS5tmQa16DJPiF7Dl5GiNAHQnXVF/DOUdjlxt/zPutCxvoWRnB2tsDK1yPy9gRu
         xU3yvDN9PThnJQVF2S053ymA5I4eqRir0mck8ma8Y8JW3FMWOU1adRcAFqn5DxCl4an1
         glGeCvdWJOYmXzxxyc5qx08I1hzkYp2UtU+6l+Ah+4sc/q/Bad87aiQ4K4JliZ2OyhJj
         5yaQ==
In-Reply-To: <20220330234719.18340-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

During mem_cgroup_iter, there are two ways to get iteration position:
reclaim vs non-reclaim mode.

Let's do it explicitly for reclaim vs non-reclaim mode.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
v2: split into two explicit part as suggested by Johannes
---
 mm/memcontrol.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index eed9916cdce5..5d433b79ba47 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1005,9 +1005,6 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 	if (!root)
 		root = root_mem_cgroup;
 
-	if (prev && !reclaim)
-		pos = prev;
-
 	rcu_read_lock();
 
 	if (reclaim) {
@@ -1033,6 +1030,8 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 			 */
 			(void)cmpxchg(&iter->position, pos, NULL);
 		}
+	} else if (prev) {
+		pos = prev;
 	}
 
 	if (pos)
-- 
2.33.1

