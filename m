From: Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next] cgroup: support attaching eBPF programs to net_prio cgroup
Date: Thu, 25 Jan 2018 23:38:48 +0800
Message-ID: <1516894728-2061-1-git-send-email-laoar.shao@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JGZ+WG6OMBHaKqjD0DO39lgaHCuMQCioRcL/O2zzjjI=;
        b=BtNxr/g5fpCRL9mMequoI7tVg3wE36ci6fj7pFksZ8JQ6XrF1lfrooQNY9WHlgrowE
         MRaSSni25gO7Zx/vTg6ITZ2XZifxXBFVjekARzzuGClfEfKhSV8CYP8IU9LipsxH0pNU
         yuhijgP65PUHCLxhKyPVqlMR2ikLY2sqQihoq/eyn1eYp7b6+Tuugyie8oH+t5mNXyjc
         LWRDbf3VQjtvzoLcvTYbApxcle9MXwhEoE4cJ6JyN+5tcpnLHs1M2x+JRkmIY+LyCwSG
         F50lUeQeHssm09oqZ9nHFZMn/XIscWY0YG8xJd/yMo+ibKurC9aTRcow+IIIlEJBVLFH
         GzGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, guro@fb.com, davem@davemloft.net, longman@redhat.com, lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>

If net_prio is used, we could also use eBPF programs to attach it,
because the net_prio cgroup could be got with prioidx in struct
sock_cgroup_data.
Hence it should not only be limited to cgroup2.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/cgroup.h | 18 ++++++++++++++++--
 kernel/cgroup/cgroup.c |  6 +-----
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 473e0c0..1d67def 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -772,8 +772,22 @@ static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
 	 */
 	v = READ_ONCE(skcd->val);

-	if (v & 1)
-		return &cgrp_dfl_root.cgrp;
+	/* either net_prio or net_cls or both being used. */
+	if (v & 1) {
+		if (skcd->prioidx != 1) {
+			struct cgroup_subsys_state *css;
+			struct cgroup *cg;
+
+			rcu_read_lock();
+			css = css_from_id(skcd->prioidx, &net_prio_cgrp_subsys);
+			cg = css->cgroup;
+			rcu_read_unlock();
+
+			return cg;
+		}
+
+		return task_cgroup(current, net_prio_cgrp_id);
+	}

 	return (struct cgroup *)(unsigned long)v ?: &cgrp_dfl_root.cgrp;
 #else
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 7e4c445..59610f5 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5735,7 +5735,7 @@ struct cgroup *cgroup_get_from_path(const char *path)

 /**
  * cgroup_get_from_fd - get a cgroup pointer from a fd
- * @fd: fd obtained by open(cgroup2_dir)
+ * @fd: fd obtained by open(cgroup2_dir or net_prio_dir)
  *
  * Find the cgroup from a fd which should be obtained
  * by opening a cgroup directory.  Returns a pointer to the
@@ -5758,10 +5758,6 @@ struct cgroup *cgroup_get_from_fd(int fd)
 		return ERR_CAST(css);

 	cgrp = css->cgroup;
-	if (!cgroup_on_dfl(cgrp)) {
-		cgroup_put(cgrp);
-		return ERR_PTR(-EBADF);
-	}

 	return cgrp;
 }
--
1.8.3.1

