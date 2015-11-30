From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.4-fixes 1/2] cgroup_freezer: simplify
 propagation of CGROUP_FROZEN clearing in freezer_attach()
Date: Mon, 30 Nov 2015 17:42:05 -0500
Message-ID: <20151130224205.GA9039@mtj.duckdns.org>
References: <20151123195541.GA19072@mtj.duckdns.org>
 <56543C76.2050008@bmw-carit.de>
 <20151124144418.GB17033@mtj.duckdns.org>
 <56547B22.2020802@bmw-carit.de>
 <20151124145945.GF17033@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FQzmdLWeJT4hIe9b95lG1/6qdt/ODKNAYkNSYU1euuw=;
        b=gQfST463eT3H/o1Rt8gRDE3GZeez+TZyJIvqQYqQjuYtTk6PoXZNfnQMyADuG+KCJW
         WG6Wu8nA2WTioVbPeTO/s6ND6k8yOzC+XwkcpP3i8LvKIhtJLjHn4n0ZcQafVSQLpndp
         ywHPEWulDxCIzM4K6NHvQgc/Gkw19makeMngmFjNXJ0QCBWtnQWXsWxhR8UUEFDa9AfV
         dtgweF0CYOjPD26bdiYugbIYa+dlBaBqz2V9mqpe04ZVaz/wxWyy7f7XInk2oOQIj7SU
         GQixWyvqXnr1Kg7SV5auaU5+N/fVMm7A5YM7bHQiVgnCCF69k9VAmlvjxhqjzFylvAQd
         Hc8Q==
Content-Disposition: inline
In-Reply-To: <20151124145945.GF17033-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

From bafc993033ea01429effe50ec693def57154ebe4 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Mon, 30 Nov 2015 17:24:34 -0500

If one or more tasks get moved into a frozen css, the frozen state is
cleared up from the destination css so that it can be reasserted once
the migrated tasks are frozen.  freezer_attach() implements this in
two separate steps - clearing CGROUP_FROZEN on the target css while
processing each task and propagating the clearing upwards after the
task loop is done if necessary.

This patch merges the two steps.  Propagation now takes place inside
the task loop.  This simplifies the code and prepares it for the fix
of multi-destination migration.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup_freezer.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index f1b30ad..ff02a8e 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -158,9 +158,7 @@ static void freezer_css_free(struct cgroup_subsys_state *css)
 static void freezer_attach(struct cgroup_subsys_state *new_css,
 			   struct cgroup_taskset *tset)
 {
-	struct freezer *freezer = css_freezer(new_css);
 	struct task_struct *task;
-	bool clear_frozen = false;
 
 	mutex_lock(&freezer_mutex);
 
@@ -175,21 +173,20 @@ static void freezer_attach(struct cgroup_subsys_state *new_css,
 	 * be visible in a FROZEN cgroup and frozen tasks in a THAWED one.
 	 */
 	cgroup_taskset_for_each(task, tset) {
+		struct freezer *freezer = css_freezer(new_css);
+
 		if (!(freezer->state & CGROUP_FREEZING)) {
 			__thaw_task(task);
 		} else {
 			freeze_task(task);
-			freezer->state &= ~CGROUP_FROZEN;
-			clear_frozen = true;
+			/* clear FROZEN and propagate upwards */
+			while (freezer && (freezer->state & CGROUP_FROZEN)) {
+				freezer->state &= ~CGROUP_FROZEN;
+				freezer = parent_freezer(freezer);
+			}
 		}
 	}
 
-	/* propagate FROZEN clearing upwards */
-	while (clear_frozen && (freezer = parent_freezer(freezer))) {
-		freezer->state &= ~CGROUP_FROZEN;
-		clear_frozen = freezer->state & CGROUP_FREEZING;
-	}
-
 	mutex_unlock(&freezer_mutex);
 }
 
-- 
2.5.0
