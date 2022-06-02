From: Waiman Long <longman@redhat.com>
Subject: [PATCH v5 1/3] blk-cgroup: Correctly free percpu iostat_cpu in blkg on error exit
Date: Thu,  2 Jun 2022 09:35:41 -0400
Message-ID: <20220602133543.128088-2-longman@redhat.com>
References: <20220601211824.89626-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654176958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YXLuT1Yk9DAXTYl5NoX/oMeS35ik4rQo8uu3jun7bK8=;
        b=KHk8Q0w88jKlWb3n+xQS225haxcacaJ8aBPgvh4NmJKIPPUB1tIQhWpmDmDbnmAGzg4B68
        yW1QClx/IA8DbkKaBxR9UslDK0e9kXSaXdCzbgW3IWS/TFEJvS5dODtYQDEvfgB7iupY2E
        AX61bzFZnqPbitOdkUIOBbfNchcjEx0=
In-Reply-To: <20220601211824.89626-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Waiman Long <longman@redhat.com>

Commit f73316482977 ("blk-cgroup: reimplement basic IO stats using cgroup
rstat") changes block cgroup IO stats to use the rstat APIs. It added
a new percpu iostat_cpu field into blkg. The blkg_alloc() was modified
to allocate the new percpu iostat_cpu but didn't free it when an error
happened. Fix this by freeing the percpu iostat_cpu on error exit.

Fixes: f73316482977 ("blk-cgroup: reimplement basic IO stats using cgroup rstat")
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 40161a3f68d0..acd9b0aa8dc8 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -219,11 +219,11 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
 		return NULL;
 
 	if (percpu_ref_init(&blkg->refcnt, blkg_release, 0, gfp_mask))
-		goto err_free;
+		goto err_free_blkg;
 
 	blkg->iostat_cpu = alloc_percpu_gfp(struct blkg_iostat_set, gfp_mask);
 	if (!blkg->iostat_cpu)
-		goto err_free;
+		goto err_free_blkg;
 
 	if (!blk_get_queue(q))
 		goto err_free;
@@ -259,6 +259,9 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
 	return blkg;
 
 err_free:
+	free_percpu(blkg->iostat_cpu);
+
+err_free_blkg:
 	blkg_free(blkg);
 	return NULL;
 }
-- 
2.31.1

