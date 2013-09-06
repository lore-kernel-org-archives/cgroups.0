From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.12-fixes] cgroup: fix cgroup post-order
 descendant walk of empty subtree
Date: Fri, 6 Sep 2013 15:31:08 -0400
Message-ID: <20130906193108.GH22763@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=iWH8yrz/Ea9lbdWhYnYQQD7kgZ9lL144Ooi0zheGYcE=;
        b=sqmmDhdUKFP/EL3f03fDzZMM+/ss3gfFLJUfphIbol9pcfoGR4lr7b4JtudexCGrYG
         xOQkFpfnKmO16QHhFyedn0yMqp2PkWYy3YIzGSTZuUuyx90bBqnPjoZvk5v6cT+3fxSk
         x/P7b+yuiakEcU3G4tVXXCi2Ck/qi8n79f6yZynR/RvaGj0/3Ra/QEJNGhiDLoeivi80
         eBoTJAZPkQNEH24XyOB9zbAzuZeJNl6lkCLHpzwowBg7WWD34BZBkoAuj1izN996wN1B
         4khDvcVOtFu2v3jnwUTQ5VBMeCEt3FkgNR776oHkl3sSYGSL4MKXQq3U5rOAou2wg4N2
         0qvw==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

bd8815a6d8 ("cgroup: make css_for_each_descendant() and friends
include the origin css in the iteration") updated cgroup descendant
iterators to include the origin css; unfortuantely, it forgot to drop
special case handling in css_next_descendant_post() for empty subtree
leading to failure to visit the origin css without any child.

Fix it by dropping the special case handling and always returning the
leftmost descendant on the first iteration.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e0aeb32..8075b72 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3187,11 +3187,9 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	/* if first iteration, visit the leftmost descendant */
-	if (!pos) {
-		next = css_leftmost_descendant(root);
-		return next != root ? next : NULL;
-	}
+	/* if first iteration, visit leftmost descendant which may be @root */
+	if (!pos)
+		return css_leftmost_descendant(root);
 
 	/* if we visited @root, we're done */
 	if (pos == root)
