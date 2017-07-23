From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] cgroup: remove unnecessary empty check when enabling
 threaded mode
Date: Sun, 23 Jul 2017 08:18:26 -0400
Message-ID: <20170723121826.GC1498614@devbig577.frc2.facebook.com>
References: <1500669293-21792-1-git-send-email-longman@redhat.com>
 <1500669293-21792-2-git-send-email-longman@redhat.com>
 <20170722134358.GB3329631@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jUSZHTqpZiJlnMBj5mS1gIjM0hHL6/NZQ1rorxV2zL0=;
        b=VzFPdoi1jPm80DEhypnNEZrDayyKLpixItB6AH6GPuw3S8blv1zmX4+BtkkRbQGUFR
         w1bP9UzH2XXRF1vcT5gdV0lfxqEfRLttbOmWli9vfX0nRD2hLHyOHIgur4fnQddIvnDy
         wcUUG5sQbupcVwRQt1qeTRkASitLpxXSmSmwQJCgeIpDtKB4Vj7Ia0XBumRbUo8f4iFs
         h55AgvduJHWx2hCw96sayqa4uUC7lzExbpadoJXOWQZS+4GVG3VGC4WUFzC3ljjCVauB
         yh8fnWy9txblEtgXpQBGNakwLEgGPYf9qMt6Zad3rn9FvjmG99yfxmhOJyf8YPb3Da9e
         VZWg==
Content-Disposition: inline
In-Reply-To: <20170722134358.GB3329631-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

cgroup_enable_threaded() checks that the cgroup doesn't have any tasks
or children and fails the operation if so.  This test is unnecessary
because the first part is already checked by
cgroup_can_be_thread_root() and the latter is unnecessary.  The latter
actually cause a behavioral oddity.  Please consider the following
hierarchy.  All cgroups are domains.

    A
   / \
  B   C
       \
        D

If B is made threaded, C and D becomes invalid domains.  Due to the no
children restriction, threaded mode can't be enabled on C.  For C and
D, the only thing the user can do is removal.

There is no reason for this restriction.  Remove it.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
Hello,

So, the only thing inconsistent there was the extra restriction when
enabling threaded mode when all the necessary conditions are already
checked by when verifying the parent's domain.

Thanks.

 Documentation/cgroup-v2.txt |    5 +++--
 kernel/cgroup/cgroup.c      |    7 -------
 2 files changed, 3 insertions(+), 9 deletions(-)

--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -274,8 +274,9 @@ thread mode, the following conditions mu
 - As the cgroup will join the parent's resource domain.  The parent
   must either be a valid (threaded) domain or a threaded cgroup.
 
-- The cgroup must be empty.  No enabled controllers, child cgroups or
-  processes.
+- When the parent is an unthreaded domain, it must not have any domain
+  controllers enabled or populated domain children.  The root is
+  exempt from this requirement.
 
 Topology-wise, a cgroup can be in an invalid state.  Please consider
 the following toplogy::
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3147,13 +3147,6 @@ static int cgroup_enable_threaded(struct
 		return -EOPNOTSUPP;
 
 	/*
-	 * Allow enabling thread mode only on empty cgroups to avoid
-	 * implicit migrations and recursive operations.
-	 */
-	if (cgroup_has_tasks(cgrp) || css_has_online_children(&cgrp->self))
-		return -EBUSY;
-
-	/*
 	 * The following shouldn't cause actual migrations and should
 	 * always succeed.
 	 */
