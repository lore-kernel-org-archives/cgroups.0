From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/7] cgroup: make debug an implicit controller on cgroup2
Date: Wed, 14 Jun 2017 16:08:40 -0400
Message-ID: <20170614200842.15174-6-tj@kernel.org>
References: <20170614200842.15174-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oSwuBzrnATWkLttuqkt9m8vtPAPAYyU71c3eelI5oM0=;
        b=pqUj8a0rqrxPyGRyQSSo07K3KEsz2ivvDbrE2yMmbGhBWX1E7AZq7+UqtZUxs68jNT
         0fgMgqoZc9KixJtT+MkjAYx1V57WXKUT7xH56/WDoaNO8zSs8sFCbMhiT8ovP9OG46ny
         r0HQD4uOi+bM2V8GEG1dT+UxZS5Cv2f2lqkpYwPpcIn3i4T9mkLXAGCN3ySeG2d0iJRY
         MObPh4A5CMAghbwmjOSDsy/S15t5F+ydqIxA+1fGSp647Ij6TmcmgJP5+KVaobZ9CkT8
         AUAL5NF6YAh3dockDxdY9sNGUHoyx79olQVV8L23jXZK6Ho7UC1Pwkb/tIUQu0Q9UFrX
         EdEw==
In-Reply-To: <20170614200842.15174-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Make debug an implicit controller on cgroup2 which is enabled by
"cgroup_debug" boot param.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/debug.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 56 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/debug.c b/kernel/cgroup/debug.c
index 057d9b07f461..d61e692a5338 100644
--- a/kernel/cgroup/debug.c
+++ b/kernel/cgroup/debug.c
@@ -240,7 +240,7 @@ static u64 releasable_read(struct cgroup_subsys_state *css, struct cftype *cft)
 		!css_has_online_children(&css->cgroup->self));
 }
 
-static struct cftype debug_files[] =  {
+static struct cftype debug_legacy_files[] =  {
 	{
 		.name = "taskcount",
 		.read_u64 = debug_taskcount_read,
@@ -287,9 +287,62 @@ static struct cftype debug_files[] =  {
 	{ }	/* terminate */
 };
 
+static struct cftype debug_files[] =  {
+	{
+		.name = "taskcount",
+		.read_u64 = debug_taskcount_read,
+	},
+
+	{
+		.name = "current_css_set",
+		.seq_show = current_css_set_read,
+		.flags = CFTYPE_ONLY_ON_ROOT,
+	},
+
+	{
+		.name = "current_css_set_refcount",
+		.read_u64 = current_css_set_refcount_read,
+		.flags = CFTYPE_ONLY_ON_ROOT,
+	},
+
+	{
+		.name = "current_css_set_cg_links",
+		.seq_show = current_css_set_cg_links_read,
+		.flags = CFTYPE_ONLY_ON_ROOT,
+	},
+
+	{
+		.name = "css_links",
+		.seq_show = cgroup_css_links_read,
+	},
+
+	{
+		.name = "csses",
+		.seq_show = cgroup_subsys_states_read,
+	},
+
+	{
+		.name = "masks",
+		.seq_show = cgroup_masks_read,
+	},
+
+	{ }	/* terminate */
+};
+
 struct cgroup_subsys debug_cgrp_subsys = {
 	.css_alloc	= debug_css_alloc,
 	.css_free	= debug_css_free,
-	.legacy_cftypes	= debug_files,
-	.dfl_cftypes	= debug_files,
+	.legacy_cftypes	= debug_legacy_files,
 };
+
+/*
+ * On v2, debug is an implicit controller enabled by "cgroup_debug" boot
+ * parameter.
+ */
+static int __init enable_cgroup_debug(char *str)
+{
+	debug_cgrp_subsys.dfl_cftypes = debug_files;
+	debug_cgrp_subsys.implicit_on_dfl = true;
+	return 1;
+}
+__setup("cgroup_debug", enable_cgroup_debug);
-- 
2.13.0

