From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] cgroup: make css_tryget_online_from_dir() also recognize cgroup2 fs
Date: Thu,  7 Jan 2016 17:29:47 -0500
Message-ID: <1452205790-21331-4-git-send-email-tj@kernel.org>
References: <1452205790-21331-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=29wOgIU4vlUlpYin+je0WOhygTEJ4TYHiyPkDJFZd7Y=;
        b=d6H351Awld9yG5cGJR2uZvO23FrT+fzNTBI1liAFfVb5TVSXVMtbPHUURtOCn+/QGa
         opfUYj3drLUyUXBNXhWktFi+uaAZtnYt4U0yOKx3g6tHlcYp1XG6fjEdiT1dwztBbiTV
         1I9o3FJWAq+PPFsINvQpEBKwz1xW2YCdxmn7vG/ztQvIo+UfCbIGYI8KbLYVvbLj4kJL
         WFsRnarP5/1W31E8Tt2HqocZDYuAuwC3Vze7MOPMLHAdn254Zie7rIICaLKDZdgscaBv
         SV+0l4b9Z3Re42Z7ftourAy4YYEaNtBYCgFpUGfnwQByGhTMMNF1qS3E/wUEP/4yf/lg
         oikw==
In-Reply-To: <1452205790-21331-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, a.p.zijlstra@chello.nl, mingo@redhat.com, acme@kernel.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

The function currently returns -EBADF for a directory on the default
hierarchy.  Make it also recognize cgroup2_fs_type.  This will be used
for perf_event cgroup2 support.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f542264..8a92043 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5748,12 +5748,13 @@ struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
 						       struct cgroup_subsys *ss)
 {
 	struct kernfs_node *kn = kernfs_node_from_dentry(dentry);
+	struct file_system_type *s_type = dentry->d_sb->s_type;
 	struct cgroup_subsys_state *css = NULL;
 	struct cgroup *cgrp;
 
 	/* is @dentry a cgroup dir? */
-	if (dentry->d_sb->s_type != &cgroup_fs_type || !kn ||
-	    kernfs_type(kn) != KERNFS_DIR)
+	if ((s_type != &cgroup_fs_type && s_type != &cgroup2_fs_type) ||
+	    !kn || kernfs_type(kn) != KERNFS_DIR)
 		return ERR_PTR(-EBADF);
 
 	rcu_read_lock();
-- 
2.5.0

