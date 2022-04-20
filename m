From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/15] nvme-fc: fold t fc_update_appid into fc_appid_store
Date: Wed, 20 Apr 2022 06:27:11 +0200
Message-ID: <20220420042723.1010598-4-hch@lst.de>
References: <20220420042723.1010598-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=y/ovE2zEN2kLE1A2FRhhKOcbowUkSDsa75PAEbmLpG0=; b=DOLgdQusEBimK3YMZin66R/BjH
        KIRbmuSDM431VciG1e+sHRmUmEJugXKLLuYU0opQ6vCOSlhXMD61pZTijh1pLp2D6HqCYHj4dOoVA
        1aSheLwYo2wRPaY7OoXnoXSvxO+f+8BaosjWBlbP2S/I9iIbRmm8BYezQCvXuutIxIvA+TnsrRVCG
        ErhmbmsIu0ylBSu6HsHJkDbf/VkBmNN3fGWgy1ycMqiil+m2ICbNMhlgUcElPyS9085V54ijOiU1J
        uVzgoOvSXJMRoLHMkkMM6lLG7F8SFLajpZZyyamt4pij31J78UapbHHe+WJOueO34ANbLEvC76q4E
        BI4fq2xg==;
In-Reply-To: <20220420042723.1010598-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@linaro.org>, Tejun Heo <tj@kernel.org>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-nvme@lists.infradead.org, linux-mm@kvack.org

No need for this wrapper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/fc.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index caa0fff7bf1f5..7ae72c7a211b9 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3857,12 +3857,10 @@ static int fc_parse_cgrpid(const char *buf, u64 *id)
 }
 
 /*
- * fc_update_appid: Parse and update the appid in the blkcg associated with
- * cgroupid.
- * @buf: buf contains both cgrpid and appid info
- * @count: size of the buffer
+ * Parse and update the appid in the blkcg associated with the cgroupid.
  */
-static int fc_update_appid(const char *buf, size_t count)
+static ssize_t fc_appid_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
 {
 	u64 cgrp_id;
 	int appid_len = 0;
@@ -3890,17 +3888,6 @@ static int fc_update_appid(const char *buf, size_t count)
 		return ret;
 	return count;
 }
-
-static ssize_t fc_appid_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
-{
-	int ret  = 0;
-
-	ret = fc_update_appid(buf, count);
-	if (ret < 0)
-		return -EINVAL;
-	return count;
-}
 static DEVICE_ATTR(appid_store, 0200, NULL, fc_appid_store);
 #endif /* CONFIG_BLK_CGROUP_FC_APPID */
 
-- 
2.30.2

