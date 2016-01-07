From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] cgroup, perf_event: make perf_event controller work on cgroup2 hierarchy
Date: Thu,  7 Jan 2016 17:29:50 -0500
Message-ID: <1452205790-21331-7-git-send-email-tj@kernel.org>
References: <1452205790-21331-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NflOlPrruRx+OZ0HtisXP6ejMw5QtjEY/YTcv6ZyNh0=;
        b=jW8Se6bj2vctC+v091yt4vyc1B3XXOkehkwC8fidUIRpSgSb6LbxLKjCbRR8allwxr
         aytL889F+CslB5Ywt87xI0CmDpKtjHtemTkZ1h6nSajxmQEX5vCJn0jBvEw7+CXfBvIm
         iBHv3SLaHIiVTZpK2Q449yWIcpDYWpyQAzTgXi9ijiGAzJqOqS4y+pAs7UabNcu9M7ER
         OSbmffSousR/ziFzDNkW7VqS5UClqBHOb05RimjIuBOG3L5a6Tu+T6BhsMBpElg4tBPv
         mhi2NQv5TNkeA9UMTHAm0Q1Um3isT/fgPSiEMZNw6hHY+jghhJEjZrKIJ6fsd0ozDatf
         Vr4Q==
In-Reply-To: <1452205790-21331-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, a.p.zijlstra@chello.nl, mingo@redhat.com, acme@kernel.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

perf_event is a utility controller whose primary role is identifying
cgroup membership to filter perf events; however, because it also
tracks some per-css state, it can't be replaced by pure cgroup
membership test.  Mark the controller as implicitly enabled on the
default hierarchy so that perf events can always be filtered based on
cgroup v2 path as long as the controller is not mounted on a legacy
hierarchy.

"perf record" is updated accordingly so that it searches for both v1
and v2 hierarchies.  A v1 hierarchy is used if perf_event is mounted
on it; otherwise, it uses the v2 hierarchy.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
---
 Documentation/cgroup.txt | 13 +++++++++++++
 kernel/events/core.c     |  6 ++++++
 tools/perf/util/cgroup.c | 26 +++++++++++++++++++-------
 3 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/Documentation/cgroup.txt b/Documentation/cgroup.txt
index 31d1f7b..721e43e 100644
--- a/Documentation/cgroup.txt
+++ b/Documentation/cgroup.txt
@@ -47,6 +47,8 @@ CONTENTS
   5-3. IO
     5-3-1. IO Interface Files
     5-3-2. Writeback
+  5-4. Misc
+    5-4-1. perf_event
 P. Information on Kernel Programming
   P-1. Filesystem Support for Writeback
 D. Deprecated v1 Core Features
@@ -1013,6 +1015,17 @@ writeback as follows.
 	vm.dirty[_background]_ratio.
 
 
+5-4. Misc
+
+5-4-1. perf_event
+
+perf_event controller, if not mounted on a legacy hierarchy on the
+first mount of cgroup v2, is automatically enabled on the v2 hierarchy
+so that perf events can always be filtered by cgroup v2 path.  The
+controller can still be moved to a legacy hierarchy after v2 hierarchy
+is populated.
+
+
 P. Information on Kernel Programming
 
 This section contains kernel programming information in the areas
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 026305d..02ad5b3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9469,5 +9469,11 @@ struct cgroup_subsys perf_event_cgrp_subsys = {
 	.css_alloc	= perf_cgroup_css_alloc,
 	.css_free	= perf_cgroup_css_free,
 	.attach		= perf_cgroup_attach,
+	/*
+	 * Implicitly enable on dfl hierarchy so that perf events can
+	 * always be filtered by cgroup2 path as long as perf_event
+	 * controller is not mounted on a legacy hierarchy.
+	 */
+	.implicit_on_dfl = true,
 };
 #endif /* CONFIG_CGROUP_PERF */
diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
index 32e12ec..54b5bf4 100644
--- a/tools/perf/util/cgroup.c
+++ b/tools/perf/util/cgroup.c
@@ -12,8 +12,8 @@ cgroupfs_find_mountpoint(char *buf, size_t maxlen)
 {
 	FILE *fp;
 	char mountpoint[PATH_MAX + 1], tokens[PATH_MAX + 1], type[PATH_MAX + 1];
+	char path_v1[PATH_MAX + 1], path_v2[PATH_MAX + 2], *path;
 	char *token, *saved_ptr = NULL;
-	int found = 0;
 
 	fp = fopen("/proc/mounts", "r");
 	if (!fp)
@@ -24,31 +24,43 @@ cgroupfs_find_mountpoint(char *buf, size_t maxlen)
 	 * and inspect every cgroupfs mount point to find one that has
 	 * perf_event subsystem
 	 */
+	path_v1[0] = '\0';
+	path_v2[0] = '\0';
+
 	while (fscanf(fp, "%*s %"STR(PATH_MAX)"s %"STR(PATH_MAX)"s %"
 				STR(PATH_MAX)"s %*d %*d\n",
 				mountpoint, type, tokens) == 3) {
 
-		if (!strcmp(type, "cgroup")) {
+		if (!path_v1[0] && !strcmp(type, "cgroup")) {
 
 			token = strtok_r(tokens, ",", &saved_ptr);
 
 			while (token != NULL) {
 				if (!strcmp(token, "perf_event")) {
-					found = 1;
+					strcpy(path_v1, mountpoint);
 					break;
 				}
 				token = strtok_r(NULL, ",", &saved_ptr);
 			}
 		}
-		if (found)
+
+		if (!path_v2[0] && !strcmp(type, "cgroup2"))
+			strcpy(path_v2, mountpoint);
+
+		if (path_v1[0] && path_v2[0])
 			break;
 	}
 	fclose(fp);
-	if (!found)
+
+	if (path_v1[0])
+		path = path_v1;
+	else if (path_v2[0])
+		path = path_v2;
+	else
 		return -1;
 
-	if (strlen(mountpoint) < maxlen) {
-		strcpy(buf, mountpoint);
+	if (strlen(path) < maxlen) {
+		strcpy(buf, path);
 		return 0;
 	}
 	return -1;
-- 
2.5.0

