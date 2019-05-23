From: Roman Gushchin <guro@fb.com>
Subject: [PATCH v3 bpf-next 3/4] selftests/bpf: enable all available cgroup v2 controllers
Date: Thu, 23 May 2019 12:45:31 -0700
Message-ID: <20190523194532.2376233-4-guro@fb.com>
References: <20190523194532.2376233-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=dguLJ5dXFo20uX3NNIRPvxtSl5doCiRMzTCOHYR6kDA=;
 b=ZgxBi6W6jGo8DKHbJYzuR6jkS53jmKDx8cavFtfYQ10a9IS7N+Dt21J2l884qXS47FFz
 wV9RxZ/pMNcENcs/rilrAhSB/xwbgSmjsf3oFku+V97mA6FUErgwwEuukTUivoCnAWLe
 qRkvA0cdPl+UQc31qsvoYwF3UvsPiNsr8vM= 
In-Reply-To: <20190523194532.2376233-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, Stanislav Fomichev <sdf@fomichev.me>, Yonghong Song <yhs@fb.com>, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

Enable all available cgroup v2 controllers when setting up
the environment for the bpf kselftests. It's required to properly test
the bpf prog auto-detach feature. Also it will generally increase
the code coverage.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 tools/testing/selftests/bpf/cgroup_helpers.c | 57 ++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c b/tools/testing/selftests/bpf/cgroup_helpers.c
index 6692a40a6979..0d89f0396be4 100644
--- a/tools/testing/selftests/bpf/cgroup_helpers.c
+++ b/tools/testing/selftests/bpf/cgroup_helpers.c
@@ -33,6 +33,60 @@
 	snprintf(buf, sizeof(buf), "%s%s%s", CGROUP_MOUNT_PATH, \
 		 CGROUP_WORK_DIR, path)
 
+/**
+ * enable_all_controllers() - Enable all available cgroup v2 controllers
+ *
+ * Enable all available cgroup v2 controllers in order to increase
+ * the code coverage.
+ *
+ * If successful, 0 is returned.
+ */
+int enable_all_controllers(char *cgroup_path)
+{
+	char path[PATH_MAX + 1];
+	char buf[PATH_MAX];
+	char *c, *c2;
+	int fd, cfd;
+	size_t len;
+
+	snprintf(path, sizeof(path), "%s/cgroup.controllers", cgroup_path);
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		log_err("Opening cgroup.controllers: %s", path);
+		return 1;
+	}
+
+	len = read(fd, buf, sizeof(buf) - 1);
+	if (len < 0) {
+		close(fd);
+		log_err("Reading cgroup.controllers: %s", path);
+		return 1;
+	}
+	buf[len] = 0;
+	close(fd);
+
+	/* No controllers available? We're probably on cgroup v1. */
+	if (len == 0)
+		return 0;
+
+	snprintf(path, sizeof(path), "%s/cgroup.subtree_control", cgroup_path);
+	cfd = open(path, O_RDWR);
+	if (cfd < 0) {
+		log_err("Opening cgroup.subtree_control: %s", path);
+		return 1;
+	}
+
+	for (c = strtok_r(buf, " ", &c2); c; c = strtok_r(NULL, " ", &c2)) {
+		if (dprintf(cfd, "+%s\n", c) <= 0) {
+			log_err("Enabling controller %s: %s", c, path);
+			close(cfd);
+			return 1;
+		}
+	}
+	close(cfd);
+	return 0;
+}
+
 /**
  * setup_cgroup_environment() - Setup the cgroup environment
  *
@@ -71,6 +125,9 @@ int setup_cgroup_environment(void)
 		return 1;
 	}
 
+	if (enable_all_controllers(cgroup_workdir))
+		return 1;
+
 	return 0;
 }
 
-- 
2.20.1

