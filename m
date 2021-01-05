From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: blk-iocost: fix NULL iocg deref from racing against initialization
Date: Tue, 5 Jan 2021 12:37:23 -0500
Message-ID: <X/Sj014x+U8ubiFT@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=bOiN/zd9h/CaIEMnPVzsFlx2JDr/hQqa7NqLbxPttmg=;
        b=A6Yuo3om6XcBhTEO/4ecawxwdtaAZUgoobIbMueTX0iyKN5I3/eZSh8b2H/H9cDex2
         DNgxYkpPOWU6ZWJyxvtFUYQYV25ZSDCFg4ocuHiarOztqojoRL1GML2sjQp4H95hu3Pe
         JKCFNqc0/UEQHIAEIeopDEVKMj93Viv8k5GQV24uR80o2JheusvN5HxBJkIH5gyu7Un6
         4vGn1EADmSXg+xHSlCuFCWDK9RiNFdrbVkB8oGgwyGKWMBQCaJ6EQRs2cpUK3NEmAv4i
         GnVoLS83odSpWLkHzklUVWxOTzE2p8AJFt4IkDWuatBTYKVfIwIkuRwTeBD/gNG2UXo6
         LuIA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bsd-b10kYP2dOMg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

When initializing iocost for a queue, its rqos should be registered before
the blkcg policy is activated to allow policy data initiailization to lookup
the associated ioc. This unfortunately means that the rqos methods can be
called on bios before iocgs are attached to all existing blkgs.

While the race is theoretically possible on ioc_rqos_throttle(), it mostly
happened in ioc_rqos_merge() due to the difference in how they lookup ioc.
The former determines it from the passed in @rqos and then bails before
dereferencing iocg if the looked up ioc is disabled, which most likely is
the case if initialization is still in progress. The latter looked up ioc by
dereferencing the possibly NULL iocg making it a lot more prone to actually
triggering the bug.

* Make ioc_rqos_merge() use the same method as ioc_rqos_throttle() to look
  up ioc for consistency.

* Make ioc_rqos_throttle() and ioc_rqos_merge() test for NULL iocg before
  dereferencing it.

* Explain the danger of NULL iocgs in blk_iocost_init().

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Jonathan Lemon <bsd-b10kYP2dOMg@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v5.4+
---
 block/blk-iocost.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index ac6078a349394..98d656bdb42b7 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2551,8 +2551,8 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 	bool use_debt, ioc_locked;
 	unsigned long flags;
 
-	/* bypass IOs if disabled or for root cgroup */
-	if (!ioc->enabled || !iocg->level)
+	/* bypass IOs if disabled, still initializing, or for root cgroup */
+	if (!ioc->enabled || !iocg || !iocg->level)
 		return;
 
 	/* calculate the absolute vtime cost */
@@ -2679,14 +2679,14 @@ static void ioc_rqos_merge(struct rq_qos *rqos, struct request *rq,
 			   struct bio *bio)
 {
 	struct ioc_gq *iocg = blkg_to_iocg(bio->bi_blkg);
-	struct ioc *ioc = iocg->ioc;
+	struct ioc *ioc = rqos_to_ioc(rqos);
 	sector_t bio_end = bio_end_sector(bio);
 	struct ioc_now now;
 	u64 vtime, abs_cost, cost;
 	unsigned long flags;
 
-	/* bypass if disabled or for root cgroup */
-	if (!ioc->enabled || !iocg->level)
+	/* bypass if disabled, still initializing, or for root cgroup */
+	if (!ioc->enabled || !iocg || !iocg->level)
 		return;
 
 	abs_cost = calc_vtime_cost(bio, iocg, true);
@@ -2863,6 +2863,12 @@ static int blk_iocost_init(struct request_queue *q)
 	ioc_refresh_params(ioc, true);
 	spin_unlock_irq(&ioc->lock);
 
+	/*
+	 * rqos must be added before activation to allow iocg_pd_init() to
+	 * lookup the ioc from q. This means that the rqos methods may get
+	 * called before policy activation completion, can't assume that the
+	 * target bio has an iocg associated and need to test for NULL iocg.
+	 */
 	rq_qos_add(q, rqos);
 	ret = blkcg_activate_policy(q, &blkcg_policy_iocost);
 	if (ret) {
