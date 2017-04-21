From: Joseph Qi <jiangqi903-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: blk-cgroup: fix wrong unlock order when parse per blkg config
Date: Fri, 21 Apr 2017 09:23:54 +0800
Message-ID: <d38c2fef-428e-9fb1-aee4-82490a359773@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=6Ec1uLbpdWew/mzDIST7adoFX/+jyqyT9MUH28bOapw=;
        b=BTXBtn2frjWeBfghL5gzndv+Tthku2okDeRf0GN0NDOQ/xy0MujaF8Wq336J72hr/N
         YHUSBtCh0Y2ZKWfhwL7Q5IfKC1CqZYFDx3jn+Sly/+y0OJTFj33EHHgLtCoR/K699C7S
         gI69DJcbm89Ot13Pz5qWazmHsD0oV/cFCYBWiaJSY+oc2hCA2/8MekJaj3qKW+FDA9UO
         Rqi7wfUBMtDsuQ2cXvQ+NuPuQPoQbZrGAK2r25ZugLuNcpZcKLzQYLwU298P2sCJBIwz
         Je1QYlzCnjnNj9tg6UyWrrx3cTL/0Ien+KEzC60YRxPRCT6Y4M/q1MMd64LQDfCb8tyw
         cLpw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

In case of error blkg in blkg_conf_prep, we should unlock
queue->queue_lock first and then rcu, just like blkg_conf_finish.

Signed-off-by: Joseph Qi <jiangqi903-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
