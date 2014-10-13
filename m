From: Aditya Kali <adityakali@google.com>
Subject: [PATCHv1 3/8] cgroup: add function to get task's cgroup on default hierarchy
Date: Mon, 13 Oct 2014 14:23:45 -0700
Message-ID: <1413235430-22944-4-git-send-email-adityakali@google.com>
References: <adityakali-cgroupns>
 <1413235430-22944-1-git-send-email-adityakali@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vCrJYk5VcNvMy6j5g74sAVs8M0Ml1j62KgqDVSTSfs0=;
        b=ETuDXU/CVoQaqz4ymm1nfFsOw0yQp/kPalMLFZlsYzORiWGbgyITDvjmKCoaUkE0Ux
         ZhPB3qlCMd8kOm1tWRpnGNFQH/L9XTB2ldgx130Hlhf+qI8Gw4Hpm/taNdjJ5UbBgS+Z
         0rh2ULrGPkrTcYwBV3FrW01GN+3gqxW5o6W4w8FnW/8tFgLz/e8PySAgFFYTz/Ywg+tw
         2hiA/l+mjFsKqFpeqcf5DgM0Ay82GuarEhPTGn91uv7gd/FNVSn+mxSszwAM7pKwSIdb
         zJZaQnPBoQjka8ogw+OiS5vVmsIeAK8sLgIaRtp9VhZ9jE6WscG+cbNeFBwPTbe0qorj
         0H1w==
In-Reply-To: <1413235430-22944-1-git-send-email-adityakali@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com, serge.hallyn@ubuntu.com, luto@amacapital.net, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, mingo@redhat.com
Cc: containers@lists.linux-foundation.org, jnagal@google.com, Aditya Kali <adityakali@google.com>

get_task_cgroup() returns the (reference counted) cgroup of the
given task on the default hierarchy.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup.c        | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1d51968..80ed6e0 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -579,6 +579,7 @@ static inline void pr_cont_cgroup_path(struct cgroup *cgrp)
 }
 
 char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
+struct cgroup *get_task_cgroup(struct task_struct *task);
 
 int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index cab7dc4..56d507b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1916,6 +1916,31 @@ char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 }
 EXPORT_SYMBOL_GPL(task_cgroup_path);
 
+/*
+ * get_task_cgroup - returns the cgroup of the task in the default cgroup
+ * hierarchy.
+ *
+ * @task: target task
+ * This function returns the @task's cgroup on the default cgroup hierarchy. The
+ * returned cgroup has its reference incremented (by calling cgroup_get()). So
+ * the caller must cgroup_put() the obtained reference once it is done with it.
+ */
+struct cgroup *get_task_cgroup(struct task_struct *task)
+{
+	struct cgroup *cgrp;
+
+	mutex_lock(&cgroup_mutex);
+	down_read(&css_set_rwsem);
+
+	cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
+	cgroup_get(cgrp);
+
+	up_read(&css_set_rwsem);
+	mutex_unlock(&cgroup_mutex);
+	return cgrp;
+}
+EXPORT_SYMBOL_GPL(get_task_cgroup);
+
 /* used to track tasks and other necessary states during migration */
 struct cgroup_taskset {
 	/* the src and dst cset list running through cset->mg_node */
-- 
2.1.0.rc2.206.gedb03e5
