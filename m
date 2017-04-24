From: Joseph Qi <jiangqi903-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] blk-cgroup: fix wrong unlock order when parse per blkg config
Date: Mon, 24 Apr 2017 18:52:05 +0800
Message-ID: <be8d9709-84fe-d2df-f294-a12701675e27@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=/wKtdaizoWzbZ3jnv04hNUIEvjzD6M6uKH849ToXZb0=;
        b=XKT1HNxG9s0dnoDip4lszzj65Ssyq+8np2X9CSN7xMA51DZyc3wQHK3CmNHQNLGn1z
         UJAN7YfWslk3mqK+gkNZnMeaRveFXASLoZYO5j+tq9XsIzawitdypjJIX3edav43fWW+
         6BGTT/lsdFwkkzo3jK8BVO1KZ34E1yyHtK9KJqBs5C3orUNJX+mmAWrU06FLu0WEBx3y
         DrP5A6yReiJQDAwmwWV66AyafSxKOVpDbtUpoTQ6AkiZj/ARAlzXN6G82PL0wwSCDpoF
         qrWL20szDLoie5YK+46fI2fDFPs1zlJXnZARX59Xd+87ZlXMfpywc0ha/Z3mnKDXV/M/
         1GHw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wenqing.lz-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, boyu.mt-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, qijiang.qj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org

From: Joseph Qi <qijiang.qj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>

In case of error blkg in blkg_conf_prep, we should unlock
queue->queue_lock first and then rcu, just like blkg_conf_finish.

Signed-off-by: Joseph Qi <qijiang.qj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>
Signed-off-by: Joseph Qi <jiangqi903-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 block/blk-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bbe7ee0..cc017b2 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -823,8 +823,8 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 
 	if (IS_ERR(blkg)) {
 		ret = PTR_ERR(blkg);
-		rcu_read_unlock();
 		spin_unlock_irq(disk->queue->queue_lock);
+		rcu_read_unlock();
 		owner = disk->fops->owner;
 		put_disk(disk);
 		module_put(owner);
-- 
1.9.4
