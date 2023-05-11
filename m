From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next 3/6] blk-wbt: don't enable wbt for bio based device
Date: Thu, 11 May 2023 09:45:06 +0800
Message-ID: <20230511014509.679482-4-yukuai1@huaweicloud.com>
References: <20230511014509.679482-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230511014509.679482-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch-jcswGhMUV9g@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Because rq_qos only make sense for rq based device. Instead of fail
from sysfs configuration, make wbt sysfs dentry invisible directly.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 6c1c4ba66bc0..c8e1f1462422 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -686,6 +686,10 @@ static umode_t queue_attr_visible(struct kobject *kobj, struct attribute *attr,
 	    !blk_queue_is_zoned(q))
 		return 0;
 
+#ifdef CONFIG_BLK_WBT
+	if (attr == &queue_wb_lat_entry.attr && !queue_is_mq(q))
+		return 0;
+#endif
 	return attr->mode;
 }
 
-- 
2.39.2

