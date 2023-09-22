From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH bpf-next 3/8] cgroup: Add cgroup_get_from_id_within_subsys()
Date: Fri, 22 Sep 2023 11:28:41 +0000
Message-ID: <20230922112846.4265-4-laoar.shao@gmail.com>
References: <20230922112846.4265-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695382150; x=1695986950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IHx9zaz06OEXWU+TLyQGeUCpNolCvM+zvySDcLZVKEk=;
        b=e6XHujtU2Xmv56Jn0+m+2DYhpGsthOUu9Gte9bZzvYYRAIDR0u29uGpH//SACfBzLI
         MQrgx5QZnM8YL3OQxZvjXzYscm18DEr9t5cuO5dih6pUDkW11ejfi2nol1lrvKNWHpXK
         dkrvX5fCWdvVh68V2SZJhBoPunsf8YH2tpmxfFQBT+N6R9S1p1TqBdrCddg+9m0JT14J
         lqW1aBfBnS2iXB3y+/g0zDZSBdosQQlIDNLx6rcVP7MvIGEQ6oyuysubH9rhlMUGwB5T
         z7UxooOhIwl+Cs+/ZCc5VEUgUxAZmNls+tsHfLt2PARq5Tjp+GElRAZZbCUDawbdYtj7
         zcuA==
In-Reply-To: <20230922112846.4265-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Introduce a new helper function to retrieve the cgroup associated with a
specific cgroup ID within a particular subsystem.

Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup/cgroup.c | 32 +++++++++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e16cfb98b44c..9f7616cbf710 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -656,6 +656,7 @@ static inline void cgroup_kthread_ready(void)
 
 void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen);
 struct cgroup *cgroup_get_from_id(u64 id);
+struct cgroup *cgroup_get_from_id_within_subsys(u64 cgid, int ssid);
 #else /* !CONFIG_CGROUPS */
 
 struct cgroup_subsys_state;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1fb7f562289d..d30a62eed14c 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6195,17 +6195,28 @@ void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
 }
 
 /*
- * cgroup_get_from_id : get the cgroup associated with cgroup id
- * @id: cgroup id
+ * cgroup_get_from_id_within_subsys - get the cgroup associated with cgroup id
+ *                                    within specific subsystem
+ * @cgid: cgroup id
+ * @ssid: cgroup subsystem id, -1 for cgroup default tree
  * On success return the cgrp or ERR_PTR on failure
  * Only cgroups within current task's cgroup NS are valid.
  */
-struct cgroup *cgroup_get_from_id(u64 id)
+struct cgroup *cgroup_get_from_id_within_subsys(u64 cgid, int ssid)
 {
+	struct cgroup_root *root;
 	struct kernfs_node *kn;
-	struct cgroup *cgrp, *root_cgrp;
+	struct cgroup *cgrp;
 
-	kn = kernfs_find_and_get_node_by_id(cgrp_dfl_root.kf_root, id);
+	if (ssid == -1) {
+		root = &cgrp_dfl_root;
+	} else {
+		if (ssid >= CGROUP_SUBSYS_COUNT)
+			return ERR_PTR(-EINVAL);
+		root = cgroup_subsys[ssid]->root;
+	}
+
+	kn = kernfs_find_and_get_node_by_id(root->kf_root, cgid);
 	if (!kn)
 		return ERR_PTR(-ENOENT);
 
@@ -6226,6 +6237,17 @@ struct cgroup *cgroup_get_from_id(u64 id)
 	if (!cgrp)
 		return ERR_PTR(-ENOENT);
 
+	return cgrp;
+}
+
+struct cgroup *cgroup_get_from_id(u64 id)
+{
+	struct cgroup *root_cgrp, *cgrp;
+
+	cgrp = cgroup_get_from_id_within_subsys(id, -1);
+	if (IS_ERR(cgrp))
+		return cgrp;
+
 	root_cgrp = current_cgns_cgroup_dfl();
 	if (!cgroup_is_descendant(cgrp, root_cgrp)) {
 		cgroup_put(cgrp);
-- 
2.30.1 (Apple Git-130)

