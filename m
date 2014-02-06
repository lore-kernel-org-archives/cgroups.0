From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: use an ordered workqueue for cgroup destruction
Date: Thu, 6 Feb 2014 15:56:01 -0800 (PST)
Message-ID: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=zQFKSQ8jffFU9JESzBget+N5hhvrD8Y5cfzNB9VmMas=;
        b=jH5++37asInks8MH5ZqUvc6oVAbGgcvziH2DjdeGAbrhcquCojq11hYtG8c3I11TyZ
         r6cuxp6aBvbg6pNJaYBj3f04O5eBGvi6w5wV3e8srxE6GAItcl/BAprXSoz1TookLNVL
         YueIrhdr7ClP5heSCcPz/5ya6wu3VzOV54UzvGYQjWMicHAGsxbwvWTOsCYXCvYX6gRI
         hbM8a9w7unxm4a0kPZAMeJaZsQ+3Ax7mnuX7NKv9J2ttg+PZCEH7vkQCQ/ukxjX4JCYB
         JFvpQjiZdyG8h0FBQwdYCh9i3Jqrf/fIrxBkpcX/4kkdAdwNeSX8A8V6BrfHEXU2f8cW
         AakQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Filipe Brandenburger <filbranden-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Sometimes the cleanup after memcg hierarchy testing gets stuck in
mem_cgroup_reparent_charges(), unable to bring non-kmem usage down to 0.

There may turn out to be several causes, but a major cause is this: the
workitem to offline parent can get run before workitem to offline child;
parent's mem_cgroup_reparent_charges() circles around waiting for the
child's pages to be reparented to its lrus, but it's holding cgroup_mutex
which prevents the child from reaching its mem_cgroup_reparent_charges().

Just use an ordered workqueue for cgroup_destroy_wq.

Fixes: e5fca243abae ("cgroup: use a dedicated workqueue for cgroup destruction")
Suggested-by: Filipe Brandenburger <filbranden-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.10+
---

 kernel/cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 3.14-rc1/kernel/cgroup.c	2014-02-02 18:49:07.737302111 -0800
+++ linux/kernel/cgroup.c	2014-02-06 15:20:35.548904965 -0800
@@ -4845,12 +4845,12 @@ static int __init cgroup_wq_init(void)
 	/*
 	 * There isn't much point in executing destruction path in
 	 * parallel.  Good chunk is serialized with cgroup_mutex anyway.
-	 * Use 1 for @max_active.
+	 * Must be ordered to make sure parent is offlined after children.
 	 *
 	 * We would prefer to do this in cgroup_init() above, but that
 	 * is called before init_workqueues(): so leave this until after.
 	 */
-	cgroup_destroy_wq = alloc_workqueue("cgroup_destroy", 0, 1);
+	cgroup_destroy_wq = alloc_ordered_workqueue("cgroup_destroy", 0);
 	BUG_ON(!cgroup_destroy_wq);
 
 	/*
