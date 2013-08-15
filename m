From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 12/12] cgroup: unexport cgroup_css() and remove __file_cft()
Date: Thu, 15 Aug 2013 12:02:30 -0400
Message-ID: <1376582550-12548-13-git-send-email-tj@kernel.org>
References: <1376582550-12548-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6JQxvSmAtxDOSpJxgG7ds3NiOQCI05YH6I1DpLgHPU4=;
        b=sl08/lI/Zeng+oTMi4S379+5l9iOGc88HiXEU4yZMXJEtJ27qDo4VGVNWDW7ni0zL+
         3Tz7HG2V1ALDnxwGiTqsdbaZeFw1JGt3AL11e7HY6bkaH9ByQeODifuajbJUt0kFIiAu
         wpx2PBjke2+V/u+ZbpE0ZEv8S/DQ7BANfrmyeA6LWxDjZdJySF1arzPlxO1sTpuSrEsq
         AvvDg4txyJ/c+1EIxll6URBzRlFNMqqbdB6wDTMANbud1cVM+WOyOiuEYY+bFc0DP77q
         ZnEiTpWVLzGIHcB+A1954ajjQKviRz9BYX9ufQioidGUcQpaOQtyg73nWwCwN2MAqxG1
         9FnQ==
In-Reply-To: <1376582550-12548-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Now that cgroup_event is made memcg specific, the temporarily exported
functions are no longer necessary.  Unexport cgroup_css() and remove
__file_cft() which doesn't have any user left.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup.h |  5 -----
 kernel/cgroup.c        | 14 ++------------
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index d2cad3f..f9a4194 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -899,11 +899,6 @@ unsigned short css_id(struct cgroup_subsys_state *css);
 struct cgroup_subsys_state *css_from_dir(struct dentry *dentry,
 					 struct cgroup_subsys *ss);
 
-/* XXX: temporary */
-struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
-				       struct cgroup_subsys *ss);
-struct cftype *__file_cft(struct file *file);
-
 #else /* !CONFIG_CGROUPS */
 
 static inline int cgroup_init_early(void) { return 0; }
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4368a6c..1402366 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -202,8 +202,8 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
  * keep accessing it outside the said locks.  This function may return
  * %NULL if @cgrp doesn't have @subsys_id enabled.
  */
-struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
-				       struct cgroup_subsys *ss)
+static struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
+					      struct cgroup_subsys *ss)
 {
 	if (ss)
 		return rcu_dereference_check(cgrp->subsys[ss->subsys_id],
@@ -2634,16 +2634,6 @@ static struct dentry *cgroup_lookup(struct inode *dir, struct dentry *dentry, un
 	return NULL;
 }
 
-/*
- * Check if a file is a control file
- */
-struct cftype *__file_cft(struct file *file)
-{
-	if (file_inode(file)->i_fop != &cgroup_file_operations)
-		return ERR_PTR(-EINVAL);
-	return __d_cft(file->f_dentry);
-}
-
 static int cgroup_create_file(struct dentry *dentry, umode_t mode,
 				struct super_block *sb)
 {
-- 
1.8.3.1
