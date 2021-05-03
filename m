From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 3/5] tests/cgroup: use cgroup.kill in cg_killall()
Date: Mon,  3 May 2021 16:39:21 +0200
Message-ID: <20210503143922.3093755-3-brauner@kernel.org>
References: <20210503143922.3093755-1-brauner@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620052824;
        bh=6Sf1JD7r+JgTYZS8K/J2qUYaOsenxFzh+TJhtjMKVCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HqpNc3ZvgN4cXp1Ru0F1DLJHflD0heZFRKV3i5HuYJx5VclfS27QcXJpRbKxOstDV
         rdVj9pUhi36fcuL8TqitF/tLZj5KDm8pitzOiFEc/1HeFiOmMLAIQtQ8WfnXwmXmcq
         H7OX7YiTYFgX9ym8sY9te0reLYSPiYpCQF53C2dW1P2cF3XAI7ZzL6KVzWvcwlHop9
         L/NYGolgcoN07DokUGCrMmoMeMWvIZ/OBWdZQXFVO43b1FLWcvBOvsEKL/aNJId3UE
         a78s0wcuQfO5bxnr2WjYmJnOhNPXN8iW36mQRZhLpwXoZlc3Gcus6EbQWQFfg9KxjL
         jsLrOI8w8S7dA==
In-Reply-To: <20210503143922.3093755-1-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

If cgroup.kill file is supported make use of it.

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
/* v2 */
- Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>:
  - Fix whitespace.
---
 tools/testing/selftests/cgroup/cgroup_util.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index 027014662fb2..f60f7d764690 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -252,6 +252,10 @@ int cg_killall(const char *cgroup)
 	char buf[PAGE_SIZE];
 	char *ptr = buf;
 
+	/* If cgroup.kill exists use it. */
+	if (!cg_write(cgroup, "cgroup.kill", "1"))
+		return 0;
+
 	if (cg_read(cgroup, "cgroup.procs", buf, sizeof(buf)))
 		return -1;
 
-- 
2.27.0

