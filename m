From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/8] cgroup: move cgroup->kn->priv clearing to cgroup_rmdir()
Date: Tue,  6 May 2014 16:19:30 -0400
Message-ID: <1399407574-21472-5-git-send-email-tj@kernel.org>
References: <1399407574-21472-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CrhjKTaBkBwb/WsGsofmgWLz7DmdPbiQjCY48DHVI/Y=;
        b=yHfUNsLcNafcRRvaAy3SAhPcTMAigAJmDIdeHmR1SkwEAUvUYY8LEr/0LYxs0x0Bfn
         w1N9wASk2GHmujzF11QSBP8Zfoe2nIgU5NaXthKbcV4dexNgmBYv2lyK/o3pmZVCdTmf
         ioR7gJ8rfsHwXu7W2fkqD5pyE7gXZbDNfEJw4r2fja1OgqB/y1uu8xrDIfb26HBOkiAt
         KYNYUTfxn75IlMHOKe761y+ttpjGCgVaDzkWAv2NWvdmbf0n3h8UYUmCjaxprRjOVb7g
         M3z/Rfaer7u7KQx8AZjmCFJrPxkG78k2g6h7JSR9WOEq9i2ssaPHOT2n1oryZSLX5vIr
         ZWuA==
In-Reply-To: <1399407574-21472-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

The ->priv field of a cgroup directory kernfs_node points back to the
cgroup.  This field is RCU cleared in cgroup_destroy_locked() for
non-kernfs accesses from css_tryget_from_dir() and
cgroupstats_build().

As these are only applicable to cgroups which finished creation
successfully and fully initialized cgroups are always removed by
cgroup_rmdir(), this can be safely moved to the end of cgroup_rmdir().

This will help simplifying cgroup locking and shouldn't introduce any
behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f544e46..3118a63 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4547,17 +4547,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 
 	/* remove @cgrp directory along with the base files */
 	mutex_unlock(&cgroup_mutex);
-
-	/*
-	 * There are two control paths which try to determine cgroup from
-	 * dentry without going through kernfs - cgroupstats_build() and
-	 * css_tryget_from_dir().  Those are supported by RCU protecting
-	 * clearing of cgrp->kn->priv backpointer, which should happen
-	 * after all files under it have been removed.
-	 */
 	kernfs_remove(cgrp->kn);	/* @cgrp has an extra ref on its kn */
-	RCU_INIT_POINTER(*(void __rcu __force **)&cgrp->kn->priv, NULL);
-
 	mutex_lock(&cgroup_mutex);
 
 	return 0;
@@ -4616,6 +4606,17 @@ static int cgroup_rmdir(struct kernfs_node *kn)
 	mutex_unlock(&cgroup_tree_mutex);
 
 	kernfs_unbreak_active_protection(kn);
+
+	/*
+	 * There are two control paths which try to determine cgroup from
+	 * dentry without going through kernfs - cgroupstats_build() and
+	 * css_tryget_from_dir().  Those are supported by RCU protecting
+	 * clearing of kn->priv backpointer, which should happen after all
+	 * files under it have been removed.
+	 */
+	if (!ret)
+		RCU_INIT_POINTER(*(void __rcu __force **)&kn->priv, NULL);
+
 	cgroup_put(cgrp);
 	return ret;
 }
@@ -5175,7 +5176,7 @@ struct cgroup_subsys_state *css_tryget_from_dir(struct dentry *dentry,
 	/*
 	 * This path doesn't originate from kernfs and @kn could already
 	 * have been or be removed at any point.  @kn->priv is RCU
-	 * protected for this access.  See destroy_locked() for details.
+	 * protected for this access.  See cgroup_rmdir() for details.
 	 */
 	cgrp = rcu_dereference(kn->priv);
 	if (cgrp)
-- 
1.9.0
