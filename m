From: Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next] cgroup: support attaching eBPF programs to net_prio cgroup
Date: Thu, 25 Jan 2018 23:50:25 +0800
Message-ID: <1516895425-2311-1-git-send-email-laoar.shao@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=URyhHaYCA6dtxn/yFTGGRDkza89QjZnfuxPB/1gDO0w=;
        b=Ws/1KkojY3+6izCI7O4SoVei68zQwihMExy1v7GJpgGzE0m65V+KjI7D1vtk2yJRvx
         AXHVQ5gtG4xBgiPOMUaTWQuw1bAdxV9a2y6dznc70tOTj6BCIazAtjwm81T27wwwS0+G
         BRKR7IjtPcujHI73CILoe1Cw9L//RxYD6WXvUqFzAcyIt/pLtk1Y+kXZSvwMfJvnjvhg
         6XdpFShGl75Oafr7UahQNbbErfsvgDaz3Y5qHeYZZaSx5ITE0yeHQbuJbambqbNeLv/c
         TCpu1MbEl2jiUHDfDHWtJKt2J/w8tKcOxUvhmTEF/NKd2qYt7m7AJepSzPdqEX6++3RL
         JLnA==
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
 include/linux/cgroup.h | 16 +++++++++++++++-
 kernel/cgroup/cgroup.c |  6 +-----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 473e0c0..c0cb46b 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -772,8 +772,22 @@ static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
 	 */
 	v = READ_ONCE(skcd->val);
 
-	if (v & 1)
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
 		return &cgrp_dfl_root.cgrp;
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

