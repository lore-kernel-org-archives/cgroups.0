From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] vmpressure: in-kernel notifications
Date: Tue, 23 Apr 2013 12:22:08 +0400
Message-ID: <1366705329-9426-2-git-send-email-glommer@openvz.org>
References: <1366705329-9426-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366705329-9426-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

During the past weeks, it became clear to us that the shrinker interface
we have right now works very well for some particular types of users,
but not that well for others. The later are usually people interested in
one-shot notifications, that were forced to adapt themselves to the
count+scan behavior of shrinkers. To do so, they had no choice than to
greatly abuse the shrinker interface producing little monsters all over.

During LSF/MM, one of the proposals that popped out during our session
was to reuse Anton Voronstsov's vmpressure for this. They are designed
for userspace consumption, but also provide a well-stablished,
cgroup-aware entry point for notifications.

This patch extends that to also support in-kernel users. Events that
should be generated for in-kernel consumption will be marked as such,
and for those, we will call a registered function instead of triggering
an eventfd notification.

Please note that due to my lack of understanding of each shrinker user,
I will stay away from converting the actual users, you are all welcome
to do so.

Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 include/linux/vmpressure.h |  6 ++++++
 mm/vmpressure.c            | 48 ++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
index 76be077..1862012 100644
--- a/include/linux/vmpressure.h
+++ b/include/linux/vmpressure.h
@@ -19,6 +19,9 @@ struct vmpressure {
 	/* Have to grab the lock on events traversal or modifications. */
 	struct mutex events_lock;
 
+	/* false if only kernel users want to be notified, true otherwise */
+	bool notify_userspace;
+
 	struct work_struct work;
 };
 
@@ -36,6 +39,9 @@ extern struct vmpressure *css_to_vmpressure(struct cgroup_subsys_state *css);
 extern int vmpressure_register_event(struct cgroup *cg, struct cftype *cft,
 				     struct eventfd_ctx *eventfd,
 				     const char *args);
+
+extern int vmpressure_register_kernel_event(struct cgroup *cg,
+					    void (*fn)(void));
 extern void vmpressure_unregister_event(struct cgroup *cg, struct cftype *cft,
 					struct eventfd_ctx *eventfd);
 #else
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 736a601..8d77ad0 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -135,8 +135,12 @@ static enum vmpressure_levels vmpressure_calc_level(unsigned long scanned,
 }
 
 struct vmpressure_event {
-	struct eventfd_ctx *efd;
+	union {
+		struct eventfd_ctx *efd;
+		void (*fn)(void);
+	};
 	enum vmpressure_levels level;
+	bool kernel_event;
 	struct list_head node;
 };
 
@@ -152,7 +156,9 @@ static bool vmpressure_event(struct vmpressure *vmpr,
 	mutex_lock(&vmpr->events_lock);
 
 	list_for_each_entry(ev, &vmpr->events, node) {
-		if (level >= ev->level) {
+		if (ev->kernel_event)
+			ev->fn();
+		else if (vmpr->notify_userspace && (level >= ev->level)) {
 			eventfd_signal(ev->efd, 1);
 			signalled = true;
 		}
@@ -227,7 +233,7 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
 	 * we account it too.
 	 */
 	if (!(gfp & (__GFP_HIGHMEM | __GFP_MOVABLE | __GFP_IO | __GFP_FS)))
-		return;
+		goto schedule;
 
 	/*
 	 * If we got here with no pages scanned, then that is an indicator
@@ -238,14 +244,16 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
 	 * through vmpressure_prio(). But so far, keep calm.
 	 */
 	if (!scanned)
-		return;
+		goto schedule;
 
 	mutex_lock(&vmpr->sr_lock);
 	vmpr->scanned += scanned;
 	vmpr->reclaimed += reclaimed;
+	vmpr->notify_userspace = true;
 	scanned = vmpr->scanned;
 	mutex_unlock(&vmpr->sr_lock);
 
+schedule:
 	if (scanned < vmpressure_win || work_pending(&vmpr->work))
 		return;
 	schedule_work(&vmpr->work);
@@ -328,6 +336,38 @@ int vmpressure_register_event(struct cgroup *cg, struct cftype *cft,
 }
 
 /**
+ * vmpressure_register_kernel_event() - Register kernel-side notification
+ * @cg:		cgroup that is interested in vmpressure notifications
+ * @fn:		function to be called when pressure happens
+ *
+ * This function register in-kernel users interested in receiving notifications
+ * about pressure conditions. Pressure notifications will be triggered at the
+ * same time as userspace notifications (with no particular ordering relative
+ * to it).
+ *
+ * Pressure notifications are a alternative method to shrinkers and will serve
+ * well users that are interested in a one-shot notification, with a
+ * well-defined cgroup aware interface.
+ */
+int vmpressure_register_kernel_event(struct cgroup *cg, void (*fn)(void))
+{
+	struct vmpressure *vmpr = cg_to_vmpressure(cg);
+	struct vmpressure_event *ev;
+
+	ev = kzalloc(sizeof(*ev), GFP_KERNEL);
+	if (!ev)
+		return -ENOMEM;
+
+	ev->kernel_event = true;
+	ev->fn = fn;
+
+	mutex_lock(&vmpr->events_lock);
+	list_add(&ev->node, &vmpr->events);
+	mutex_unlock(&vmpr->events_lock);
+	return 0;
+}
+
+/**
  * vmpressure_unregister_event() - Unbind eventfd from vmpressure
  * @cg:		cgroup handle
  * @cft:	cgroup control files handle
-- 
1.8.1.4
