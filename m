From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/19] blk-cgroup: remove the !bdi->dev check in blkg_dev_name
Date: Wed,  1 Feb 2023 14:41:09 +0100
Message-ID: <20230201134123.2656505-6-hch@lst.de>
References: <20230201134123.2656505-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=FjfHshGZ/I3/AWcKqw46/+EWPEJqeZ1eXQFY486Qpkk=; b=xzF5AS5iacuUtE0bN67eHrYMXt
        ZAe5UHinnrTN8oxuABHzjHp18pvmtKyIQIsBkNeqDei1jV9QlZ1IbdKPivP5sj/hASyDo2gRrUoTS
        fBVNaDIBmrgU6hRjXpWmae0chhJpAuxMzCzH9OUAdXEaCR4ILlyUeKbQ/0nX2GLEbiAGWQRbR7gkd
        z2P8ZyMTSapRs4qCO4ifWn2DQhdejpkIfw2aTdv2wrTP2RIIA7JKYai9WCzg4+tDDu+YnmLm7iyk6
        UsUN4TMXo28B0P/OJuAg788C+2n4r7Gl4VlIs2pa9EF1dxLl7FWskySPjS950GErDJIUmAZAGSby3
        0UGMsGkw==;
In-Reply-To: <20230201134123.2656505-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

bdi_dev_name already performs the same check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 1038688568926e..0b3226cbf3f25d 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -572,7 +572,7 @@ static int blkcg_reset_stats(struct cgroup_subsys_state *css,
 
 const char *blkg_dev_name(struct blkcg_gq *blkg)
 {
-	if (!blkg->q->disk || !blkg->q->disk->bdi->dev)
+	if (!blkg->q->disk)
 		return NULL;
 	return bdi_dev_name(blkg->q->disk->bdi);
 }
-- 
2.39.0

