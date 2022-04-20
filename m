From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/15] blk-cgroup: cleanup blk_cgroup_congested
Date: Wed, 20 Apr 2022 06:27:21 +0200
Message-ID: <20220420042723.1010598-14-hch@lst.de>
References: <20220420042723.1010598-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=uBBj2AcJgfyLk5vl6yMy/ZDB6vllaI3H675K6PqOsyQ=; b=1xpyMniEM6uPddNapXYQH3lsrf
        uQ8FHVFU6epKCrJesM60funTdloGK4Lj38f/1YUlrZYg1jcRYwOcfVvnVra47GgmXLwc2yJk2ngzo
        7fJbpKKhqynluq/Slayaraw9Iwdze8UspPcSpx/gp8bI8fxHd5F8lv8cjRkEhk3LOfYjm6nx5PVuv
        LSHK8XBCCW/amMP33ATMlPAmcUbCCSvbjTf1/GEd44sgb7cEIB30+xzYXKMXnx0t4EL5LheapE++M
        hbdBeIY3+sWmqLofRleMX/lXHREVYIG3BUXceGwIrzaCOXUAiECsotMux/PsxSxLm4yH3OxIBv5IT
        TaoAFc3w==;
In-Reply-To: <20220420042723.1010598-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@linaro.org>, Tejun Heo <tj@kernel.org>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-nvme@lists.infradead.org, linux-mm@kvack.org

Use blkcg_css instead of open coding it, and switch to a slightly
more natural for loop.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-cgroup.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 8da00ddc1766e..5684a8ce1f755 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -2038,15 +2038,11 @@ bool blk_cgroup_congested(void)
 	bool ret = false;
 
 	rcu_read_lock();
-	css = kthread_blkcg();
-	if (!css)
-		css = task_css(current, io_cgrp_id);
-	while (css) {
+	for (css = blkcg_css(); css; css = css->parent) {
 		if (atomic_read(&css->cgroup->congestion_count)) {
 			ret = true;
 			break;
 		}
-		css = css->parent;
 	}
 	rcu_read_unlock();
 	return ret;
-- 
2.30.2

