From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v3 2/4] selftests: cgroup: return the errno of write() in
 cg_write() on failure
Date: Fri,  8 Apr 2022 04:57:41 +0000
Message-ID: <20220408045743.1432968-3-yosryahmed@google.com>
References: <20220408045743.1432968-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RpFXlKvwb4pUJyIrx0BwPq/Sz7TwgzSMaU3KXpjsnFg=;
        b=PZfwTndHaHFeiId6kJJWIk58eh5ykRjdyumVYKw/V0Oluj34d7Lv6G9QfbAO6MG68X
         5Cp8uWVnKwShcF0BFnxZHLWp6ZB5aWPOXG/Oix4YaoRQJT/TamzL0Z+Q0C1feePcwpoK
         FENgXFWEzQHHDlbUa6+OWFMfZy/Zs5THpeXzBDDUoSOpdHazwli+xVssStSpQX6dXP87
         +gEZWfq2i6qSv+b+zRxuTxamA08CMwUpQtHbpqJp/ibE+JIapaGcj0/Y8FuPUv9ANtvB
         K64P3pZuES8BJSknRtTorjKzVC0kiVkym17TcMpzn9ih6gm1W5AFO0y+l2ijh3LMEALt
         vIDg==
In-Reply-To: <20220408045743.1432968-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>
Cc: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

Currently, cg_write() returns 0 on success and -1 on failure. Modify it
to return the errno of write() syscall when write() fails.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 tools/testing/selftests/cgroup/cgroup_util.c | 32 +++++++++++---------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index dbaa7aabbb4a..3b6bb09985fa 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -38,23 +38,23 @@ static ssize_t read_text(const char *path, char *buf, size_t max_len)
 	return len;
 }
 
-static ssize_t write_text(const char *path, char *buf, ssize_t len)
+/*
+ * Returns:
+ *	success -> 0
+ *	open() failure -> -1
+ *	write() failure -> errno
+ */
+static int write_text(const char *path, char *buf, ssize_t len)
 {
-	int fd;
+	int fd, ret;
 
 	fd = open(path, O_WRONLY | O_APPEND);
 	if (fd < 0)
 		return fd;
 
-	len = write(fd, buf, len);
-	if (len < 0) {
-		close(fd);
-		return len;
-	}
-
+	ret = write(fd, buf, len) < 0 ? errno : 0;
 	close(fd);
-
-	return len;
+	return ret;
 }
 
 char *cg_name(const char *root, const char *name)
@@ -177,17 +177,19 @@ long cg_read_lc(const char *cgroup, const char *control)
 	return cnt;
 }
 
+/*
+ * Returns:
+ *	success -> 0
+ *	open() failure -> -1
+ *	write() failure -> errno
+ */
 int cg_write(const char *cgroup, const char *control, char *buf)
 {
 	char path[PATH_MAX];
 	ssize_t len = strlen(buf);
 
 	snprintf(path, sizeof(path), "%s/%s", cgroup, control);
-
-	if (write_text(path, buf, len) == len)
-		return 0;
-
-	return -1;
+	return write_text(path, buf, len);
 }
 
 int cg_find_unified_root(char *root, size_t len)
-- 
2.35.1.1178.g4f1659d476-goog

