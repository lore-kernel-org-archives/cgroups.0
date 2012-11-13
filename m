From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 06/17] cgroup: remove duplicate RCU free on struct cgroup
Date: Mon, 12 Nov 2012 19:01:33 -0800
Message-ID: <1352775704-9023-7-git-send-email-tj@kernel.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
	:references; bh=885s/sHml9RiQX8FMwAtklo7CTmeYKUZgSGVNvd52Yo=;
	b=hQtnXnUP5vD45EHx2Ww9GRtSmsvDQNkW6oXqLO00kyCCstYnzIxp3tLu+sI2RUQYb9
	DHkaOk0UWXKA5+mcBXW3iMww+qibELdvI2qIJMFI4hr8hB5TwGZh6uCUQGU7J6AEvtbf
	/dwED/l0SBmdziZlDFHRDTlYw2v6w3dviJCHWivE2trjz5nz9JctyevU9UqHo8tj+12W
	niQ1MKREaUB9U89hEDGp5iJjrc65aV53S1esUlu7v+rj1ZwhZYxA2tbmu1sL6vZGfUo8
	U069J+0vgAXrTIudf2cWlQOrnNxOokr20xFhLt81Znsv1VPsR5Xd2Y2xr3OYde0h+F1K
	vfcQ==
In-Reply-To: <1352775704-9023-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

struct cgroup is made RCU-safe by synchronize_rcu() in cgroup_diput().
There is no reason to use RCU safe kfree on it after it.  Remove
cgroup->rcu_head and use kfree() instead of kfree_rcu() in
cgroup_diput().

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup.h | 3 ---
 kernel/cgroup.c        | 2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index d605857..9dcbfa1 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -196,9 +196,6 @@ struct cgroup {
 	struct list_head pidlists;
 	struct mutex pidlist_mutex;
 
-	/* For RCU-protected deletion */
-	struct rcu_head rcu_head;
-
 	/* List of events which userspace want to receive */
 	struct list_head event_list;
 	spinlock_t event_list_lock;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 278752e..a91e7ad 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -893,7 +893,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 
 		simple_xattrs_free(&cgrp->xattrs);
 
-		kfree_rcu(cgrp, rcu_head);
+		kfree(cgrp);
 	} else {
 		struct cfent *cfe = __d_cfe(dentry);
 		struct cgroup *cgrp = dentry->d_parent->d_fsdata;
-- 
1.7.11.7
