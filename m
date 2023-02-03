From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 05/19] blk-cgroup: remove the !bdi->dev check in blkg_dev_name
Date: Fri,  3 Feb 2023 16:03:46 +0100
Message-ID: <20230203150400.3199230-6-hch@lst.de>
References: <20230203150400.3199230-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=p6drb38Fk8RdhNordfPyoAUltaGgb0aSqtldVyTVQaQ=; b=aQ/AH2M5M8OC+lwn5yKRLql2jo
        +bfcQzcrzfQESEsKUsWNeeSv6iiYsxfnWZ2YIFG2Dd95SfHpXNfMfDN5tAcvuZtmPGRqReTr0UQcg
        nYlJu5VNlM0IIcQpPh32aV+ttKyJbvT+yubmJz2INMmX4k7TwrtCMQWq7sNftx0jbi7iUsJ1j7bVs
        GGWbWp1n/OKVaVV8wlin668+n8DVK04HCpMXoLr1GRl+cbbIJ4EAlMCt6DkMTwkcYKpdtEge82HPd
        +xSJUT8cVjFO2ctdokbeYz67n39v8iVkDlkj5a5VLlF8lJ7q19Me9D80Ky3xd3xiubZ3oV4Ozl9Pc
        /67UcfHw==;
In-Reply-To: <20230203150400.3199230-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

bdi_dev_name already performs the same check.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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

