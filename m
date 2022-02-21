From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] cgroup: clarify cgroup_css_set_fork()
Date: Mon, 21 Feb 2022 16:16:39 +0100
Message-ID: <20220221151639.3828143-1-brauner@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645456609;
        bh=7ju0dRgH/yYPJtn4KOG60za9bLFOf4tZUIskehK0LyI=;
        h=From:To:Cc:Subject:Date:From;
        b=C4JlmNoX87DCg4yP2xOZVFwBCLHDl95bGvlr++KOG3/OG56RRxg0dPXqYJryh2fF1
         oes715dVRKo4OUXGVfMtq3QQsswPlV54cuhEF5awvdSH6AIIaBOSSxvUBskVrZUz7h
         W820oYXs+87vrrLFjiJ7NUXDt0xFwhapunn35UhwCpGeJOQbluHwd7ISenQO9OKqZl
         I4w/BhFuSGsjzNv5BpFU1PFkHil4UzxUCH7IbVsOKeKoDVdUjBMXwZmlKyaUVyb890
         Ycpo1dp0QCJICQOFusySwOjs4eUloM8rUVokO4v1xX72osvV+KSHmAEWgFlIpDnqi0
         v+zI3ct3z3Umg==
X-Developer-Signature: v=1; a=openpgp-sha256; l=1559; h=from:subject; bh=7ju0dRgH/yYPJtn4KOG60za9bLFOf4tZUIskehK0LyI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQJr3J1W2Xaf+XqhDfMExM5e3z++i9fXmNudUvsyFr/CdcW 9T3g6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIxj1Ghjm1Lw7xvfkelLFcREWAKy 1v2S7XCZctjSWe1zxTCtus+53hf8DnuGRmQ79qjU27F/74mXrY6JdUwzF9A3Mbo5Q1spKVzAA=
X-Developer-Key: i=brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

With recent fixes for the permission checking when moving a task into a cgroup
using a file descriptor to a cgroup's cgroup.procs file and calling write() it
seems a good idea to clarify CLONE_INTO_CGROUP permission checking with a
comment.

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 9d05c3ca2d5e..0f8bd120be17 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6166,6 +6166,18 @@ static int cgroup_css_set_fork(struct kernel_clone_args *kargs)
 	if (ret)
 		goto err;
 
+	/*
+	 * Note, spawning a task directly into a cgroup works by passing a file
+	 * descriptor to the target cgroup directory. This can even be an
+	 * O_PATH file descriptor. But it can never be a cgroup.procs file
+	 * descriptor. This was done on purpose so spawning into a cgroup could
+	 * be conceptualized as an atomic
+	 * fd = openat(dfd_cgroup, "cgroup.procs", ...);
+	 * write(fd, <child-pid>, ...);
+	 * sequence, i.e. it's a shorthand for the caller opening and writing
+	 * cgroup.procs of the cgroup indicated by @dfd_cgroup. This allows
+	 * us to always use the caller's credentials.
+	 */
 	ret = cgroup_attach_permissions(cset->dfl_cgrp, dst_cgrp, sb,
 					!(kargs->flags & CLONE_THREAD),
 					current->nsproxy->cgroup_ns);

base-commit: cfb92440ee71adcc2105b0890bb01ac3cddb8507
-- 
2.32.0

