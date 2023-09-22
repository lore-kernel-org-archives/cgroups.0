From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH bpf-next 4/8] bpf: Add new kfuncs support for cgroup controller
Date: Fri, 22 Sep 2023 11:28:42 +0000
Message-ID: <20230922112846.4265-5-laoar.shao@gmail.com>
References: <20230922112846.4265-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695382152; x=1695986952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+XT7WoTwvT3Nj7+0W/TJCIkVvjE4LDdWtuhMgBEm65Q=;
        b=KqduS1WQ3tt/XGwC/26Nnm/PIg1S8yuPI7ISaGucHojbIEBJwigNaj1k7WHB7GWPGp
         k46upGiZet85LZaaHB6RRt0cipiPiaYNOQKBkUBqgsN+stPDDSfjGQAHGoOUuDiUIPAN
         NIyJ5wCdH/mN3EtsLhDmD0n4IReFd/psh3BsZn6o0xfzfKzfHGX0f1goutjOIS3A8UKb
         HB+DL0svNVJCC4ripMfbxH5jJiWDjlms/jvbu8nR3unU+Q5x+qV/tH4wxqtQMdABGrHd
         wXOiqLYWoFCsInAU/L86sSQL6EtzD8en9BQdneGWyIk0SCn/mMsUI+X/BofCHO94Pc47
         A6FA==
In-Reply-To: <20230922112846.4265-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Introducing new kfuncs:

- bpf_cgroup_id_from_task_within_controller
  Retrieves the cgroup ID from a task within a specific cgroup controller.
- bpf_cgroup_acquire_from_id_within_controller
  Acquires the cgroup from a cgroup ID within a specific cgroup controller.
- bpf_cgroup_ancestor_id_from_task_within_controller
  Retrieves the ancestor cgroup ID from a task within a specific cgroup
  controller.

These functions eliminate the need to consider cgroup hierarchies,
regardless of whether they involve cgroup1 or cgroup2.

Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/bpf/helpers.c | 70 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index bb521b181cc3..1316b5fda349 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2219,6 +2219,73 @@ __bpf_kfunc long bpf_task_under_cgroup(struct task_struct *task,
 	rcu_read_unlock();
 	return ret;
 }
+
+/**
+ * bpf_cgroup_id_from_task_within_controller - To get the associated cgroup_id from
+ * a task within a specific cgroup controller.
+ * @task: The target task
+ * @ssid: The id of cgroup controller, e.g. cpu_cgrp_id, memory_cgrp_id and etc.
+ */
+__bpf_kfunc u64 bpf_cgroup_id_from_task_within_controller(struct task_struct *task, int ssid)
+{
+	struct cgroup *cgroup;
+	int id = 0;
+
+	rcu_read_lock();
+	cgroup = task_cgroup(task, ssid);
+	if (!cgroup)
+		goto out;
+	id = cgroup_id(cgroup);
+
+out:
+	rcu_read_unlock();
+	return id;
+}
+
+/**
+ * bpf_cgroup_id_from_task_within_controller - To get the associated cgroup_id from
+ * a task within a specific cgroup controller.
+ * @task: The target task
+ * @ssid: The id of cgroup subsystem, e.g. cpu_cgrp_id, memory_cgrp_id and etc.
+ * @level: The level of ancestor to look up
+ */
+__bpf_kfunc u64 bpf_cgroup_ancestor_id_from_task_within_controller(struct task_struct *task,
+								   int ssid, int level)
+{
+	struct cgroup *cgrp, *ancestor;
+	int id = 0;
+
+	rcu_read_lock();
+	cgrp = task_cgroup(task, ssid);
+	if (!cgrp)
+		goto out;
+	ancestor = cgroup_ancestor(cgrp, level);
+	if (ancestor)
+		id = cgroup_id(ancestor);
+
+out:
+	rcu_read_unlock();
+	return id;
+}
+
+/**
+ * bpf_cgroup_acquire_from_id_within_controller - To acquire the cgroup from a
+ * cgroup id within specific cgroup controller. A cgroup acquired by this kfunc
+ * which is not stored in a map as a kptr, must be released by calling
+ * bpf_cgroup_release().
+ * @cgid: cgroup id
+ * @ssid: The id of a cgroup controller, e.g. cpu_cgrp_id, memory_cgrp_id and etc.
+ */
+__bpf_kfunc struct cgroup *bpf_cgroup_acquire_from_id_within_controller(u64 cgid, int ssid)
+{
+	struct cgroup *cgrp;
+
+	cgrp = cgroup_get_from_id_within_subsys(cgid, ssid);
+	if (IS_ERR(cgrp))
+		return NULL;
+	return cgrp;
+}
+
 #endif /* CONFIG_CGROUPS */
 
 /**
@@ -2525,6 +2592,9 @@ BTF_ID_FLAGS(func, bpf_cgroup_release, KF_RELEASE)
 BTF_ID_FLAGS(func, bpf_cgroup_ancestor, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_cgroup_from_id, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_task_under_cgroup, KF_RCU)
+BTF_ID_FLAGS(func, bpf_cgroup_id_from_task_within_controller)
+BTF_ID_FLAGS(func, bpf_cgroup_ancestor_id_from_task_within_controller)
+BTF_ID_FLAGS(func, bpf_cgroup_acquire_from_id_within_controller, KF_ACQUIRE | KF_RET_NULL)
 #endif
 BTF_ID_FLAGS(func, bpf_task_from_pid, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_throw)
-- 
2.30.1 (Apple Git-130)

