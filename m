From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH v3 1/3] vmpressure: change vmpressure::sr_lock to spinlock
Date: Mon, 15 Jul 2013 12:30:31 +0200
Message-ID: <1373884233-32441-1-git-send-email-mhocko@suse.cz>
References: <20130711154408.GA9229@mtj.dyndns.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130711154408.GA9229-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

There is nothing that can sleep inside critical sections protected by
this lock and those sections are really small so there doesn't make much
sense to use mutex for them. Change the log to a spinlock

Brought-up-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 include/linux/vmpressure.h |  2 +-
 mm/vmpressure.c            | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
index 76be077..2081680 100644
--- a/include/linux/vmpressure.h
+++ b/include/linux/vmpressure.h
@@ -12,7 +12,7 @@ struct vmpressure {
 	unsigned long scanned;
 	unsigned long reclaimed;
 	/* The lock is used to keep the scanned/reclaimed above in sync. */
-	struct mutex sr_lock;
+	struct spinlock sr_lock;
 
 	/* The list of vmpressure_event structs. */
 	struct list_head events;
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 736a601..f4ee6a1 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -180,12 +180,12 @@ static void vmpressure_work_fn(struct work_struct *work)
 	if (!vmpr->scanned)
 		return;
 
-	mutex_lock(&vmpr->sr_lock);
+	spin_lock(&vmpr->sr_lock);
 	scanned = vmpr->scanned;
 	reclaimed = vmpr->reclaimed;
 	vmpr->scanned = 0;
 	vmpr->reclaimed = 0;
-	mutex_unlock(&vmpr->sr_lock);
+	spin_unlock(&vmpr->sr_lock);
 
 	do {
 		if (vmpressure_event(vmpr, scanned, reclaimed))
@@ -240,11 +240,11 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
 	if (!scanned)
 		return;
 
-	mutex_lock(&vmpr->sr_lock);
+	spin_lock(&vmpr->sr_lock);
 	vmpr->scanned += scanned;
 	vmpr->reclaimed += reclaimed;
 	scanned = vmpr->scanned;
-	mutex_unlock(&vmpr->sr_lock);
+	spin_unlock(&vmpr->sr_lock);
 
 	if (scanned < vmpressure_win || work_pending(&vmpr->work))
 		return;
@@ -367,7 +367,7 @@ void vmpressure_unregister_event(struct cgroup *cg, struct cftype *cft,
  */
 void vmpressure_init(struct vmpressure *vmpr)
 {
-	mutex_init(&vmpr->sr_lock);
+	spin_lock_init(&vmpr->sr_lock);
 	mutex_init(&vmpr->events_lock);
 	INIT_LIST_HEAD(&vmpr->events);
 	INIT_WORK(&vmpr->work, vmpressure_work_fn);
-- 
1.8.3.2
