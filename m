From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 02/15] nvme-fc: don't support the appid attribute without CONFIG_BLK_CGROUP_FC_APPID
Date: Wed, 20 Apr 2022 06:27:10 +0200
Message-ID: <20220420042723.1010598-3-hch@lst.de>
References: <20220420042723.1010598-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=IQ4ESgW0h9CMQrcwqxrNIrPn85MSIrk1H7//P0ImuCw=; b=PrEScC5s/tQxuu9heXFJwXhG7S
        NFpHoR4XLzL55dkcu7UMwI50gBtpf4k1P+uL5GaW6+9bwzG3j4zq1Y8/IQ/Ks6SK5ZFzcHxgVwdj5
        YQAH55VNCPdQ23V7w22PRIEL7sAXbRX9ENM57nJM/wBu5e9v5hqVNVp1Ed5P7q7NUYQGM3agmcnEj
        h8CIC4zC8nGgaf523aGgGuvEjzqzCGKzTT1dqAIt528WMiH93lmROrfiBcg9Eomeq/wqYni3EEoxY
        t1rC1wGpHQZAfAHMFjgzT1MurdfwOLKFX7+dKVrTjlvlJszZtYT4+wNeFXwZ5Go5Qsos2KlexkEyO
        cpxOH61A==;
In-Reply-To: <20220420042723.1010598-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Dick Kennedy <dick.kennedy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

nvme-fc appid support needs CONFIG_BLK_CGROUP_FC_APPID to work, so disable
the whole code if the option is not set.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/nvme/host/fc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 080f85f4105f3..caa0fff7bf1f5 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3831,6 +3831,9 @@ static ssize_t nvme_fc_nvme_discovery_store(struct device *dev,
 	return count;
 }
 
+static DEVICE_ATTR(nvme_discovery, 0200, NULL, nvme_fc_nvme_discovery_store);
+
+#ifdef CONFIG_BLK_CGROUP_FC_APPID
 /* Parse the cgroup id from a buf and return the length of cgrpid */
 static int fc_parse_cgrpid(const char *buf, u64 *id)
 {
@@ -3898,12 +3901,14 @@ static ssize_t fc_appid_store(struct device *dev,
 		return -EINVAL;
 	return count;
 }
-static DEVICE_ATTR(nvme_discovery, 0200, NULL, nvme_fc_nvme_discovery_store);
 static DEVICE_ATTR(appid_store, 0200, NULL, fc_appid_store);
+#endif /* CONFIG_BLK_CGROUP_FC_APPID */
 
 static struct attribute *nvme_fc_attrs[] = {
 	&dev_attr_nvme_discovery.attr,
+#ifdef CONFIG_BLK_CGROUP_FC_APPID
 	&dev_attr_appid_store.attr,
+#endif
 	NULL
 };
 
-- 
2.30.2

