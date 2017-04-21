From: Joseph Qi <jiangqi903-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RESEND] blk-cgroup: fix wrong unlock order when parse per blkg
 config
Date: Fri, 21 Apr 2017 09:27:56 +0800
Message-ID: <f972bd1e-7318-e842-1fa4-613bf50c1578@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=D9TKMHKhbRyXr/tIf4nR3ViwnUAyTmaNubl8WUGe290=;
        b=J9LVeYSDWPf4HPjLFrzL9zOz82c5QgFj75xGZMkEtjVXGwz6UYUNa1csTVH1MZm2uA
         bdZVCWurgojPqCSGPWpNaYgyuh/Sz/XUat5gr8uuK0/Zltju7fP7B0SJ8BkeOrOS582c
         nKyNy1K6Z9mCPvY3C15pQZzY6XapJ/aZL+IzEteHSx5ow1dRWJHhP/zTOijJeLLWexPX
         Zo+yKI/N8nAjqoFCBCCWDApb8gzistcz238+qtZrIc16TyGY2wS3DjORYLJXkoxtlw3A
         FxvS68o5rCTRryA050YUwaPbX8uyk3xJcX1COWYhbsFxt/+aAAI+L4tT1m5oLFup33kZ
         4KlQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

In case of error blkg in blkg_conf_prep, we should unlock
queue->queue_lock first and then rcu, just like blkg_conf_finish.

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
