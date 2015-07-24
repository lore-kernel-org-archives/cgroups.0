From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/10] blkcg: refine error codes returned during blkcg configuration
Date: Fri, 24 Jul 2015 14:43:48 -0400
Message-ID: <1437763434-28699-5-git-send-email-tj@kernel.org>
References: <1437763434-28699-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XsS3H2CiWs3aBazVe7qQY+DoBt35V8/Q561+AR+W/HM=;
        b=QN5klIEu8cQDMCu9NSmSMcUOCv1W7QFN9TzcOeOjPfAg8CvI5jlO/n7j2/1tcDObdj
         gYfVJsVj8asb1g2sPXXffLlns7mqf2bRh6MKsOeTvIfV7S72HrrAZ5i62ruG5/sBESL3
         MhXPq5c68olR0B0N3tDCBwypWRwTI0lw/f2CBgeOURbvfVX47facRrYES97vzYzFX6Vz
         IUjUk14N1bpnia+53CnLdv+Kym6NYnpf1lKydS3LpGZQgVSoWBH+GiBpXSt+Azsq0a3c
         W/MdnML/u2ZbMmJyasXH9+gQgbaYBRys5V3WCFo+fYUpd1gRmyN1hKo74Na1D4qldH3I
         71Cw==
In-Reply-To: <1437763434-28699-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, avanzini.arianna@gmail.com, kernel-team@fb.com, hannes@cmpxchg.org, lizefan@huawei.com, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

blkcg currently returns -EINVAL for most errors which can be pretty
confusing given that the failure modes are quite varied.  Update the
error returns so that

* -EINVAL only for syntactic errors.
* -ERANGE if the value is out of range.
* -ENODEV if the target device can't be found.
* -EOPNOTSUPP if the policy is not enabled on the target device.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c  | 12 ++++++------
 block/cfq-iosched.c |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 63c0914..a192f98 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -179,7 +179,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 
 	/* blkg holds a reference to blkcg */
 	if (!css_tryget_online(&blkcg->css)) {
-		ret = -EINVAL;
+		ret = -ENODEV;
 		goto err_free_blkg;
 	}
 
@@ -205,7 +205,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 	if (blkcg_parent(blkcg)) {
 		blkg->parent = __blkg_lookup(blkcg_parent(blkcg), q, false);
 		if (WARN_ON_ONCE(!blkg->parent)) {
-			ret = -EINVAL;
+			ret = -ENODEV;
 			goto err_put_congested;
 		}
 		blkg_get(blkg->parent);
@@ -279,7 +279,7 @@ struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 	 * we shouldn't allow anything to go through for a bypassing queue.
 	 */
 	if (unlikely(blk_queue_bypass(q)))
-		return ERR_PTR(blk_queue_dying(q) ? -EINVAL : -EBUSY);
+		return ERR_PTR(blk_queue_dying(q) ? -ENODEV : -EBUSY);
 
 	blkg = __blkg_lookup(blkcg, q, true);
 	if (blkg)
@@ -792,10 +792,10 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 
 	disk = get_gendisk(MKDEV(major, minor), &part);
 	if (!disk)
-		return -EINVAL;
+		return -ENODEV;
 	if (part) {
 		put_disk(disk);
-		return -EINVAL;
+		return -ENODEV;
 	}
 
 	rcu_read_lock();
@@ -804,7 +804,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	if (blkcg_policy_enabled(disk->queue, pol))
 		blkg = blkg_lookup_create(blkcg, disk->queue);
 	else
-		blkg = ERR_PTR(-EINVAL);
+		blkg = ERR_PTR(-EOPNOTSUPP);
 
 	if (IS_ERR(blkg)) {
 		ret = PTR_ERR(blkg);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index bcf4026..38277e3 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1755,7 +1755,7 @@ static ssize_t __cfqg_set_weight_device(struct kernfs_open_file *of,
 	cfqg = blkg_to_cfqg(ctx.blkg);
 	cfqgd = blkcg_to_cfqgd(blkcg);
 
-	ret = -EINVAL;
+	ret = -ERANGE;
 	if (!ctx.v || (ctx.v >= CFQ_WEIGHT_MIN && ctx.v <= CFQ_WEIGHT_MAX)) {
 		if (!is_leaf_weight) {
 			cfqg->dev_weight = ctx.v;
-- 
2.4.3
