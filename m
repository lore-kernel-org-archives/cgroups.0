From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 4/4] blk-cgroup: change BLKCG_MAX_POLS back to 5
Date: Tue, 28 Mar 2023 22:57:01 +0800
Message-ID: <20230328145701.33699-4-zhouchengming@bytedance.com>
References: <20230328145701.33699-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680015486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bq/FNHJyM6VL3GySeYH7whuNpSDOXfegBXORfrv0Wd0=;
        b=gjeUX9N/SZSVreSCgBBOw1Qw3SvaO9BulRKZFa9FyzIBnTyw04c02sekVQEgIM9rIX
         GBYeifm4ppvE4m2nrikaPAj3YSUKwne5xcZwXa1x08/SUo8pKH0jL/9uaE0YzjjJKWH5
         +IQ6UpCaQ0skcosDMsJ6DB9E/8AOPxqejhYko3LGCE/xwRl9jjGZFBWSzf7CHMnJW7Sn
         5ZvdrLMWzlSBrb1U6z1yXAtrL6G20+j5YfRsafiry3WpHRYLRKQnP/LZ1oBdlo9O0Xhm
         +eJLgX+JpPVZA045FloYbVpJecxawrYj1IP83C+8SMNjRfLs8X67VdNeK+gbWJkd6eu3
         qngQ==
In-Reply-To: <20230328145701.33699-1-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

BLKCG_MAX_POLS is changed from 5 to 6 when mq-deadline-cgroup introduced,
then commit 0f7839955114 ("Revert "block/mq-deadline: Add cgroup support"")
reverted it. So change BLKCG_MAX_POLS back to 5.

Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 include/linux/blkdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 941304f17492..398f288bcf30 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -54,7 +54,7 @@ extern struct class block_class;
  * Maximum number of blkcg policies allowed to be registered concurrently.
  * Defined here to simplify include dependency.
  */
-#define BLKCG_MAX_POLS		6
+#define BLKCG_MAX_POLS		5
 
 #define DISK_MAX_PARTS			256
 #define DISK_NAME_LEN			32
-- 
2.39.2

