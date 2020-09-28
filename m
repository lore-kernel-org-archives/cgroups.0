From: Jouni Roivas <jouni.roivas-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: Zero sized write should be no-op
Date: Mon, 28 Sep 2020 16:10:13 +0300
Message-ID: <20200928131013.3816044-1-jouni.roivas@tuxera.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Do not report failure on zero sized writes, and handle them as no-op.

There's issues for example in case of writev() when there's iovec
containing zero buffer as a first one. It's expected writev() on below
example to successfully perform the write to specified writable cgroup
file expecting integer value, and to return 2. For now it's returning
value -1, and skipping the write:

	int writetest(int fd) {
	  const char *buf1 = "";
	  const char *buf2 = "1\n";
          struct iovec iov[2] = {
                { .iov_base = (void*)buf1, .iov_len = 0 },
                { .iov_base = (void*)buf2, .iov_len = 2 }
          };
	  return writev(fd, iov, 2);
	}

This patch fixes the issue by checking if there's nothing to write,
and handling the write as no-op by just returning 0.

Signed-off-by: Jouni Roivas <jouni.roivas-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index dd247747ec14..331b050fd5f1 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3222,6 +3222,9 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	char *tok;
 	int ssid, ret;
 
+	if (!nbytes)
+		return 0;
+
 	/*
 	 * Parse input - space separated list of subsystem names prefixed
 	 * with either + or -.
@@ -3385,6 +3388,9 @@ static ssize_t cgroup_type_write(struct kernfs_open_file *of, char *buf,
 	struct cgroup *cgrp;
 	int ret;
 
+	if (!nbytes)
+		return 0;
+
 	/* only switching to threaded mode is supported */
 	if (strcmp(strstrip(buf), "threaded"))
 		return -EINVAL;
@@ -3421,6 +3427,9 @@ static ssize_t cgroup_max_descendants_write(struct kernfs_open_file *of,
 	int descendants;
 	ssize_t ret;
 
+	if (!nbytes)
+		return 0;
+
 	buf = strstrip(buf);
 	if (!strcmp(buf, "max")) {
 		descendants = INT_MAX;
@@ -3464,6 +3473,9 @@ static ssize_t cgroup_max_depth_write(struct kernfs_open_file *of,
 	ssize_t ret;
 	int depth;
 
+	if (!nbytes)
+		return 0;
+
 	buf = strstrip(buf);
 	if (!strcmp(buf, "max")) {
 		depth = INT_MAX;
@@ -3569,6 +3581,9 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 	struct psi_trigger *new;
 	struct cgroup *cgrp;
 
+	if (!nbytes)
+		return 0;
+
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
 		return -ENODEV;
@@ -3638,6 +3653,9 @@ static ssize_t cgroup_freeze_write(struct kernfs_open_file *of,
 	ssize_t ret;
 	int freeze;
 
+	if (!nbytes)
+		return 0;
+
 	ret = kstrtoint(strstrip(buf), 0, &freeze);
 	if (ret)
 		return ret;
@@ -3682,6 +3700,9 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 	struct cgroup_subsys_state *css;
 	int ret;
 
+	if (!nbytes)
+		return 0;
+
 	/*
 	 * If namespaces are delegation boundaries, disallow writes to
 	 * files in an non-init namespace root from inside the namespace
@@ -4777,6 +4798,9 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 	ssize_t ret;
 	bool locked;
 
+	if (!nbytes)
+		return 0;
+
 	buf = strstrip(buf);
 
 	dst_cgrp = cgroup_kn_lock_live(of->kn, false);
-- 
2.25.1

