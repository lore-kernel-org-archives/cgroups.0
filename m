Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4421C34B40F;
	Mon,  8 Jun 2026 03:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780890205; cv=none; b=gn3nDvz+Qk+u6K+7sxo0yWMy7EPGWnQYF3Zgwrmwvk4+Kullibgl3rnUk5WcUq1z9SZ33Z5WXNEcUAMSJVCVT9dyt39o/+XNHHSVQHnyRn6QPB5pzbzLoqwf3vzEwLqKM+xdjOnUPShx4bTAdT1U/MmxBWhFVrTqYUcajmR0E5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780890205; c=relaxed/simple;
	bh=beZmdZikQXET/D02NhLAATlqIxrVh17Rm0EVrQmSyMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZC5gwEYBnohvpsvuHuh6xZFZrdBoU+jScelQAdGWOX/lXSy4A3/6Twn2vrTXhVpKNEFRhaGY35Ci1QMCE/W49S92V4kjJrt1GkiWys4p50GANXr8mmTBqvofRrMACxb34GzBPkzB7Qz88mX8C4VsdmLXvX7zTvlvSoDanAd+P88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ilSao1YB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ilSao1YB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7AD1F00898;
	Mon,  8 Jun 2026 03:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780890204;
	bh=+GGMH6tty5FLIeZM+POYH+qzK23yhtXmMhvkWYu3LDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ilSao1YBHviA+H3l+VdOSbhmDAN2xxeZYpIZV8xr1Au1go4gQR5Sq1gFk3or2Kl50
	 OZo0qnAylTCra8E+swhFiOTCCUFdE8lM65WpM+WgUQY1EhOaM06vWeO9pba77JZNDT
	 DIlz3gA0WQ0GLOGJikvft+Zabgn6VyTpM/YKeUIjPAfZ/Y6nO8tg5fohWyo31TsNLY
	 RNXjrjqyZQBb44UdFOXRs0c+apDVKdaofrG2SNg/WC25YtAdf28oU2sxaozXJNTvHC
	 hIVXG2PJPG18e62kckP0o3G1O4XiRB06o0XZQk0lxeiIYNm/XfvpXl5KKMs8Qpi4Xq
	 klZxVCVqWnqSg==
From: Yu Kuai <yukuai@kernel.org>
To: nilay@linux.ibm.com,
	tom.leiming@gmail.com,
	bvanassche@acm.org,
	tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk,
	yukuai@fygo.io
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/8] blk-cgroup: don't nest queue_lock under blkcg->lock in blkcg_destroy_blkgs()
Date: Mon,  8 Jun 2026 11:42:47 +0800
Message-ID: <00b03cf74a9937cb4d6dd67a189ddc00a3de0451.1780621988.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1780621988.git.yukuai@fygo.io>
References: <cover.1780621988.git.yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

The correct lock order is q->queue_lock before blkcg->lock, and in order
to prevent deadlock from blkcg_destroy_blkgs(), trylock is used for
q->queue_lock while blkcg->lock is already held, this is hacky.

Refactor blkcg_destroy_blkgs() to hold blkcg->lock only long enough to
get the first blkg and then release it. Then take q->queue_lock and
blkcg->lock in the correct order to destroy the blkg. This is a very cold
path, so the extra lock/unlock cycles are acceptable.

Also prepare to convert protecting blkcg with blkcg_mutex instead of
queue_lock.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 8c9ca52a54f4..d1f69a23c9d6 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1289,10 +1289,25 @@ struct list_head *blkcg_get_cgwb_list(struct cgroup_subsys_state *css)
  *
  * 3. Once the blkcg ref count goes to zero, blkcg_css_free() is called.
  *    This finally frees the blkcg.
  */
 
+static struct blkcg_gq *blkcg_get_first_blkg(struct blkcg *blkcg)
+{
+	struct blkcg_gq *blkg = NULL;
+
+	spin_lock_irq(&blkcg->lock);
+	if (!hlist_empty(&blkcg->blkg_list)) {
+		blkg = hlist_entry(blkcg->blkg_list.first, struct blkcg_gq,
+				   blkcg_node);
+		blkg_get(blkg);
+	}
+	spin_unlock_irq(&blkcg->lock);
+
+	return blkg;
+}
+
 /**
  * blkcg_destroy_blkgs - responsible for shooting down blkgs
  * @blkcg: blkcg of interest
  *
  * blkgs should be removed while holding both q and blkcg locks.  As blkcg lock
@@ -1302,36 +1317,28 @@ struct list_head *blkcg_get_cgwb_list(struct cgroup_subsys_state *css)
  *
  * This is the blkcg counterpart of ioc_release_fn().
  */
 static void blkcg_destroy_blkgs(struct blkcg *blkcg)
 {
-	might_sleep();
+	struct blkcg_gq *blkg;
 
-	spin_lock_irq(&blkcg->lock);
+	might_sleep();
 
-	while (!hlist_empty(&blkcg->blkg_list)) {
-		struct blkcg_gq *blkg = hlist_entry(blkcg->blkg_list.first,
-						struct blkcg_gq, blkcg_node);
+	while ((blkg = blkcg_get_first_blkg(blkcg))) {
 		struct request_queue *q = blkg->q;
 
-		if (need_resched() || !spin_trylock(&q->queue_lock)) {
-			/*
-			 * Given that the system can accumulate a huge number
-			 * of blkgs in pathological cases, check to see if we
-			 * need to rescheduling to avoid softlockup.
-			 */
-			spin_unlock_irq(&blkcg->lock);
-			cond_resched();
-			spin_lock_irq(&blkcg->lock);
-			continue;
-		}
+		spin_lock_irq(&q->queue_lock);
+		spin_lock(&blkcg->lock);
 
 		blkg_destroy(blkg);
-		spin_unlock(&q->queue_lock);
-	}
 
-	spin_unlock_irq(&blkcg->lock);
+		spin_unlock(&blkcg->lock);
+		spin_unlock_irq(&q->queue_lock);
+
+		blkg_put(blkg);
+		cond_resched();
+	}
 }
 
 /**
  * blkcg_pin_online - pin online state
  * @blkcg_css: blkcg of interest
-- 
2.51.0
