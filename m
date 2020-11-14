From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] blk-cgroup: fix a hd_struct leak in blkcg_fill_root_iostats
Date: Sat, 14 Nov 2020 19:12:46 +0100
Message-ID: <20201114181246.107007-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=5Eexzr2a9Yf/fh6sHK18AOYOQ9Ow0gRnkkcLXSt5AXc=; b=Ve5OBmSQCIdrlcm6adCJMrZ0Ai
        g7NFyADO8YzKGJ9B5Oa0P5U42VBRVaMucfXHxvfd+oP3qBaEvse0VcwbgA51YWqD2/GQc4EWsdzid
        2pXmkk8/iIIgKERh9NY/T8zX+Rj+3Yp9LLD+rVMexwFUjtDY/8k2/xyDk8dUkMOUAISgbbmpbG++A
        VbxRqY3yC2g44RIYaUaEYJIBVgMdrTd4JEbg/aDTHKEixnDHLd2wPv2MGqNUig9WEW79Ywu5hgAgd
        yqChbkWdhSGErCCj4BAN9HzIuTTzjCqCLOsn6xGTMHeCZMCVdtIDjj1ODy6ZpIx/eVfIn4iKHeYig
        opMya+wQ==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk, tj@kernel.org
Cc: boris@bur.io, cgroups@vger.kernel.org, linux-block@vger.kernel.org

disk_get_part needs to be paired with a disk_put_part.

Fixes: ef45fe470e1 ("blk-cgroup: show global disk stats in root cgroup io.stat")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index c68bdf58c9a6e1..54fbe1e80cc41a 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -849,6 +849,7 @@ static void blkcg_fill_root_iostats(void)
 			blkg_iostat_set(&blkg->iostat.cur, &tmp);
 			u64_stats_update_end(&blkg->iostat.sync);
 		}
+		disk_put_part(part);
 	}
 }
 
-- 
2.28.0

