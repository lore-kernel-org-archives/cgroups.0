From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] cgroup, memcg: allocate cgroup ID from 1
Date: Thu, 24 Apr 2014 17:02:09 -0400
Message-ID: <1398373333-1521-3-git-send-email-tj@kernel.org>
References: <1398373333-1521-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NS7b9GReK4W0w4B7KTY8c5W986Q2j2YWJgjUpO7QIps=;
        b=nDqBe0mPGPVJqCoParjWGiCsh7qRTSH/noa9wANssOpYul7czmoYPg4172YUQjiirp
         Wb4vjr6swwho8VK/ysS+r77lJInfRhVf4cMR6mjh3cC8epNYAfsaJpnNA7mPFOCtONHa
         telb6M5IoG/OsMGI6CsfFkJp3Ad4wGEqinOLRPu6RsMhKpob3GtsG6SzzK1Q/ZvEPrvY
         4mcQyF+zIEkTzTAh4aY/aLKL0EiYHvGHwOlbM5ii956TShT97dfS3YtWD8RidN9ErZ4/
         QqeqjYAqhX2RgRqvchnQx+4G5lL5ZQp4AWUbTZDPSVx124kQKST0xluQ+0ovAYOR3W7Z
         iSkQ==
In-Reply-To: <1398373333-1521-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, nasa4836@gmail.com, Tejun Heo <tj@kernel.org>

Currently, cgroup->id is allocated from 0, which is always assigned to
the root cgroup; unfortunately, memcg wants to use ID 0 to indicate
invalid IDs and ends up incrementing all IDs by one.

It's reasonable to reserve 0 for special purposes.  This patch updates
cgroup core so that ID 0 is not used and the root cgroups get ID 1.
The ID incrementing is removed form memcg.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
---
 include/linux/cgroup.h | 4 ++--
 kernel/cgroup.c        | 4 ++--
 mm/memcontrol.c        | 8 ++------
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c6c703f..793f70a 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -144,8 +144,8 @@ struct cgroup {
 	/*
 	 * idr allocated in-hierarchy ID.
 	 *
-	 * The ID of the root cgroup is always 0, and a new cgroup
-	 * will be assigned with a smallest available ID.
+	 * ID 0 is not used, the ID of the root cgroup is always 1, and a
+	 * new cgroup will be assigned with a smallest available ID.
 	 *
 	 * Allocating/Removing ID must be protected by cgroup_mutex.
 	 */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 21667f3..3fa0463 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1531,7 +1531,7 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned int ss_mask)
 	lockdep_assert_held(&cgroup_tree_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 
-	ret = idr_alloc(&root->cgroup_idr, root_cgrp, 0, 1, GFP_KERNEL);
+	ret = idr_alloc(&root->cgroup_idr, root_cgrp, 1, 2, GFP_KERNEL);
 	if (ret < 0)
 		goto out;
 	root_cgrp->id = ret;
@@ -4225,7 +4225,7 @@ static long cgroup_create(struct cgroup *parent, const char *name,
 	 * Temporarily set the pointer to NULL, so idr_find() won't return
 	 * a half-baked cgroup.
 	 */
-	cgrp->id = idr_alloc(&root->cgroup_idr, NULL, 1, 0, GFP_KERNEL);
+	cgrp->id = idr_alloc(&root->cgroup_idr, NULL, 2, 0, GFP_KERNEL);
 	if (cgrp->id < 0) {
 		err = -ENOMEM;
 		goto err_unlock;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 29501f0..1d0b297 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -527,18 +527,14 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 
 static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
 {
-	/*
-	 * The ID of the root cgroup is 0, but memcg treat 0 as an
-	 * invalid ID, so we return (cgroup_id + 1).
-	 */
-	return memcg->css.cgroup->id + 1;
+	return memcg->css.cgroup->id;
 }
 
 static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
 {
 	struct cgroup_subsys_state *css;
 
-	css = css_from_id(id - 1, &memory_cgrp_subsys);
+	css = css_from_id(id, &memory_cgrp_subsys);
 	return mem_cgroup_from_css(css);
 }
 
-- 
1.9.0
