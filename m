From: Kenny Ho <Kenny.Ho@amd.com>
Subject: [PATCH RFC 1/4] cgroup, perf: Add ability to connect to perf cgroup from other cgroup controller
Date: Thu, 18 Nov 2021 15:28:37 -0500
Message-ID: <20211118202840.1001787-2-Kenny.Ho@amd.com>
References: <20211118202840.1001787-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T73Z7+mHYZvKeeLZYHXHafx8/Qc7zeDlNYSdd4qtgbo=;
 b=wxcAhmkVD9KITXfdrfqNJoaxKdmvkDxIo3OS3l8HuvtFtZAjzGw/9TSEqfMARb6VnPlttvf6EWlkaXu4UHwHgKvnKfewCsdoy65QdKce6TZUCdFLB8g9favxHatOhIdawqe+agtj/JlXRyjfrDIi6aX6ipVSYaLdksWBKbgERd0=
In-Reply-To: <20211118202840.1001787-1-Kenny.Ho@amd.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org, bpf@vger.kernel.org, linux

This provides the ability to allocate cgroup specific perf_event by
bpf-cgroup in later patch

Change-Id: I13aa7f3dfc2883ba3663c0b94744a6169504bbd8
Signed-off-by: Kenny Ho <Kenny.Ho@amd.com>
---
 include/linux/cgroup.h     |  2 ++
 include/linux/perf_event.h |  2 ++
 kernel/cgroup/cgroup.c     |  4 ++--
 kernel/events/core.c       | 17 +++++++++++++++++
 4 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 75c151413fda..1754e33cfe5e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -97,6 +97,8 @@ extern struct css_set init_css_set;
 
 bool css_has_online_children(struct cgroup_subsys_state *css);
 struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss);
+struct cgroup_subsys_state *cgroup_tryget_css(struct cgroup *cgroup,
+					      struct cgroup_subsys *ss);
 struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgroup,
 					 struct cgroup_subsys *ss);
 struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgroup,
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0cbc5dfe1110..9c440db65c18 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -926,6 +926,8 @@ struct perf_cgroup {
 	struct perf_cgroup_info	__percpu *info;
 };
 
+extern struct perf_cgroup *cgroup_tryget_perf_cgroup(struct cgroup *cgrp);
+
 /*
  * Must ensure cgroup is pinned (css_get) before calling
  * this function. In other words, we cannot call this function
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 570b0c97392a..a645b212b69b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -495,8 +495,8 @@ static struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
  * Find and get @cgrp's css associated with @ss.  If the css doesn't exist
  * or is offline, %NULL is returned.
  */
-static struct cgroup_subsys_state *cgroup_tryget_css(struct cgroup *cgrp,
-						     struct cgroup_subsys *ss)
+struct cgroup_subsys_state *cgroup_tryget_css(struct cgroup *cgrp,
+					      struct cgroup_subsys *ss)
 {
 	struct cgroup_subsys_state *css;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 20367196fa9a..d34e00749c9b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -941,6 +941,18 @@ static int perf_cgroup_ensure_storage(struct perf_event *event,
 	return ret;
 }
 
+struct perf_cgroup *cgroup_tryget_perf_cgroup(struct cgroup *cgrp)
+{
+	struct cgroup_subsys_state *css;
+
+	css = cgroup_tryget_css(cgrp, &perf_event_cgrp_subsys);
+
+	if (!css)
+		return NULL;
+
+	return container_of(css, struct perf_cgroup, css);
+}
+
 static inline int perf_cgroup_connect(int fd, struct perf_event *event,
 				      struct perf_event_attr *attr,
 				      struct perf_event *group_leader)
@@ -1080,6 +1092,11 @@ static inline void perf_cgroup_sched_in(struct task_struct *prev,
 {
 }
 
+struct perf_cgroup *cgroup_tryget_perf_cgroup(struct cgroup *cgrp)
+{
+	return NULL;
+}
+
 static inline int perf_cgroup_connect(pid_t pid, struct perf_event *event,
 				      struct perf_event_attr *attr,
 				      struct perf_event *group_leader)
-- 
2.25.1

