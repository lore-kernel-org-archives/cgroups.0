From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v5 2/4] selftests: cgroup: return -errno from
 cg_read()/cg_write() on failure
Date: Mon, 25 Apr 2022 19:00:38 +0000
Message-ID: <20220425190040.2475377-3-yosryahmed@google.com>
References: <20220425190040.2475377-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OERxjUiMWr1cQdsDG2DOpxyattqqP1OOWWgJQWH3L+Q=;
        b=jny3uMCrVBnmU4KDEBjxFsNJ+VQFDuZs2Of3Od5sz8dt2N8StM4QwzqkfKRfsR2PfJ
         04xxC8sY4WVBXUNIHQnO3TDQtNk2mQI5Bv9TrMkGE46T+NAgqKUPQzVfhj1gB8tDph5u
         UmK+li0N/cdU24sX+whw1L8S1DSaDJ4Y+wD/WlGONCStk3DPn7EmkqUT0OgZ8aYJ6dyn
         D5vmzhn/g+i+rRip2IlvPQOMq/Yv8PFURN8S3CPi5j868Dex+B48+XwMpbVAMJy/W7AT
         cJzzCERjoZDLjEcEDQyUGJOSErR614eYQY7PZP9qDV4G7CSk3yjVAqmJHqS+FU2WYbGN
         gDwg==
In-Reply-To: <20220425190040.2475377-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>
Cc: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

Currently, cg_read()/cg_write() returns 0 on success and -1 on failure.
Modify them to return the -errno on failure.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
---
 tools/testing/selftests/cgroup/cgroup_util.c | 44 +++++++++-----------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index dbaa7aabbb4a..e6f3679cdcc0 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -19,6 +19,7 @@
 #include "cgroup_util.h"
 #include "../clone3/clone3_selftests.h"
 
+/* Returns read len on success, or -errno on failure. */
 static ssize_t read_text(const char *path, char *buf, size_t max_len)
 {
 	ssize_t len;
@@ -26,35 +27,29 @@ static ssize_t read_text(const char *path, char *buf, size_t max_len)
 
 	fd = open(path, O_RDONLY);
 	if (fd < 0)
-		return fd;
+		return -errno;
 
 	len = read(fd, buf, max_len - 1);
-	if (len < 0)
-		goto out;
 
-	buf[len] = 0;
-out:
+	if (len >= 0)
+		buf[len] = 0;
+
 	close(fd);
-	return len;
+	return len < 0 ? -errno : len;
 }
 
+/* Returns written len on success, or -errno on failure. */
 static ssize_t write_text(const char *path, char *buf, ssize_t len)
 {
 	int fd;
 
 	fd = open(path, O_WRONLY | O_APPEND);
 	if (fd < 0)
-		return fd;
+		return -errno;
 
 	len = write(fd, buf, len);
-	if (len < 0) {
-		close(fd);
-		return len;
-	}
-
 	close(fd);
-
-	return len;
+	return len < 0 ? -errno : len;
 }
 
 char *cg_name(const char *root, const char *name)
@@ -87,16 +82,16 @@ char *cg_control(const char *cgroup, const char *control)
 	return ret;
 }
 
+/* Returns 0 on success, or -errno on failure. */
 int cg_read(const char *cgroup, const char *control, char *buf, size_t len)
 {
 	char path[PATH_MAX];
+	ssize_t ret;
 
 	snprintf(path, sizeof(path), "%s/%s", cgroup, control);
 
-	if (read_text(path, buf, len) >= 0)
-		return 0;
-
-	return -1;
+	ret = read_text(path, buf, len);
+	return ret >= 0 ? 0 : ret;
 }
 
 int cg_read_strcmp(const char *cgroup, const char *control,
@@ -177,17 +172,15 @@ long cg_read_lc(const char *cgroup, const char *control)
 	return cnt;
 }
 
+/* Returns 0 on success, or -errno on failure. */
 int cg_write(const char *cgroup, const char *control, char *buf)
 {
 	char path[PATH_MAX];
-	ssize_t len = strlen(buf);
+	ssize_t len = strlen(buf), ret;
 
 	snprintf(path, sizeof(path), "%s/%s", cgroup, control);
-
-	if (write_text(path, buf, len) == len)
-		return 0;
-
-	return -1;
+	ret = write_text(path, buf, len);
+	return ret == len ? 0 : ret;
 }
 
 int cg_find_unified_root(char *root, size_t len)
@@ -545,7 +538,8 @@ ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t
 	else
 		snprintf(path, sizeof(path), "/proc/%d/%s", pid, item);
 
-	return read_text(path, buf, size);
+	size = read_text(path, buf, size);
+	return size < 0 ? -1 : size;
 }
 
 int proc_read_strstr(int pid, bool thread, const char *item, const char *needle)
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

