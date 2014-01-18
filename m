From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] cgroup: trivial style updates
Date: Sat, 18 Jan 2014 08:57:25 -0500
Message-ID: <20140118135725.GA3640@htj.dyndns.org>
References: <1390031808-31818-1-git-send-email-sj38.park@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Lf43Z12OpgFaZk7PQFgBri1xJmBvO6FPZzVinHy2vIA=;
        b=ujUgVkBKWm6jKgEkNPCSaojY1bCd9I89wqJCEyTMXwujRJQNWniVZmpJWGux2lqwyj
         oNBs3bMHlBvS0kIchVmBuULLYxqYQdEADsNgRiHGfiZprXIROYVA26wFtiSlRyJE5unC
         rvkw7CuGeVSj6WRgE9vEH/km/E+kyDt7UxJ5DZcnmNwlRR7JpBTfM3NruMbnrhoAzbsR
         8B7zmLGlcS5wb6CHfXgjpOXZF41I1jwjjI/cxo+Ip6qiPfYdaZW2lQ0YMWi1n6MLZfDs
         0s9Cw1T1fW901Q4dVwd1cy/IoqLTwN+cM6M3/T8wSvy2qsc8VgMG7xQwOtR6MAn42neR
         cJDQ==
Content-Disposition: inline
In-Reply-To: <1390031808-31818-1-git-send-email-sj38.park-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: SeongJae Park <sj38.park-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Merged the two into one patch and applied to cgroup/for-3.14.

Thanks.
------ 8< ------
From dd4b0a4676907481256d16d5de0851b315a6f22c Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj38.park-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Sat, 18 Jan 2014 16:56:47 +0900

* Place newline before function opening brace in cgroup_kill_sb().

* Insert space before assignment in attach_task_by_pid()

tj: merged two patches into one.

Signed-off-by: SeongJae Park <sj38.park-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7030f04..680e2be 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1669,7 +1669,8 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	return ERR_PTR(ret);
 }
 
-static void cgroup_kill_sb(struct super_block *sb) {
+static void cgroup_kill_sb(struct super_block *sb)
+{
 	struct cgroupfs_root *root = sb->s_fs_info;
 	struct cgroup *cgrp = &root->top_cgroup;
 	struct cgrp_cset_link *link, *tmp_link;
@@ -2117,7 +2118,7 @@ retry_find_task:
 		tsk = find_task_by_vpid(pid);
 		if (!tsk) {
 			rcu_read_unlock();
-			ret= -ESRCH;
+			ret = -ESRCH;
 			goto out_unlock_cgroup;
 		}
 		/*
-- 
1.8.4.2
