From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/5] cgroup: fix a subtle bug in descendant pre-order walk
Date: Tue, 21 May 2013 10:50:21 +0900
Message-ID: <1369101025-28335-2-git-send-email-tj@kernel.org>
References: <1369101025-28335-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=If5Tn5BebMxTMCxtgehcGueMZRMvKnY+DKfsvwaPnrs=;
        b=hz4N+JvgF3/7Sv3ukF6mFi/xeq85DkmMjKMO7S8NwT5hW2wy/GRXEYmMrlZzL84iMX
         d3nFojYyJkk0gzF3AY5LID+YucwHc7urEcnVlK9qxlUl19A7o+8DlZJcP7p8SxafiKke
         yAwjdC6QmFP5ocxyzQOd4DaIhkXy7oNl5I/GDIcYoVNGhXcNbWi4ojD+gw9hkwLPztZw
         w1pD78Q3mTauikEA8uBmxSYjgFQluMNzegk7WVbf9k/Lwv9nnGkc0WDcs5fhFNb32etc
         i6tUCqtGAYuxo3b/E8sSv/+1EmpJJURDeBNGv4jRB/5fsNbMFQMuz2l0LygigAJBEkEK
         8uag==
In-Reply-To: <1369101025-28335-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When cgroup_next_descendant_pre() initiates a walk, it checks whether
the subtree root doesn't have any children and if not returns NULL.
Later code assumes that the subtree isn't empty.  This is broken
because the subtree may become empty inbetween, which can lead to the
traversal escaping the subtree by walking to the sibling of the
subtree root.

There's no reason to have the early exit path.  Remove it along with
the later assumption that the subtree isn't empty.  This simplifies
the code a bit and fixes the subtle bug.

While at it, fix the comment of cgroup_for_each_descendant_pre() which
was incorrectly referring to ->css_offline() instead of
->css_online().

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 include/linux/cgroup.h | 2 +-
 kernel/cgroup.c        | 9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 4f6f513..1df5f69 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -709,7 +709,7 @@ struct cgroup *cgroup_rightmost_descendant(struct cgroup *pos);
  *
  * If a subsystem synchronizes against the parent in its ->css_online() and
  * before starting iterating, and synchronizes against @pos on each
- * iteration, any descendant cgroup which finished ->css_offline() is
+ * iteration, any descendant cgroup which finished ->css_online() is
  * guaranteed to be visible in the future iterations.
  *
  * In other words, the following guarantees that a descendant can't escape
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6b2b1d9..f20f80c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2990,11 +2990,8 @@ struct cgroup *cgroup_next_descendant_pre(struct cgroup *pos,
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
 	/* if first iteration, pretend we just visited @cgroup */
-	if (!pos) {
-		if (list_empty(&cgroup->children))
-			return NULL;
+	if (!pos)
 		pos = cgroup;
-	}
 
 	/* visit the first child if exists */
 	next = list_first_or_null_rcu(&pos->children, struct cgroup, sibling);
@@ -3002,14 +2999,14 @@ struct cgroup *cgroup_next_descendant_pre(struct cgroup *pos,
 		return next;
 
 	/* no child, visit my or the closest ancestor's next sibling */
-	do {
+	while (pos != cgroup) {
 		next = list_entry_rcu(pos->sibling.next, struct cgroup,
 				      sibling);
 		if (&next->sibling != &pos->parent->children)
 			return next;
 
 		pos = pos->parent;
-	} while (pos != cgroup);
+	}
 
 	return NULL;
 }
-- 
1.8.1.4
