From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [syzbot] possible deadlock in throtl_pending_timer_fn
Date: Sat, 30 Jul 2022 19:17:38 +0800
Message-ID: <YuUTUkxYFTKr6Ih3@T590>
References: <000000000000921fd405db62096a@google.com>
 <0000000000004e96a405e4fd5051@google.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659179873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ajeH2EPldj0oFW5NJlh68z51lwf7zGjC5FfPekouKAo=;
        b=K/oqLsJR9vzL6Ns280aqnin31IffffEJsIMPO7a7pO05QDFXGlQUb0a1rm2h9zm7CQg1sD
        D65wEq9YJfj0/SR9s25f72Yicaricr34cb8tE158EX6u7QFOQ9yxQ7dzqA/NCGUy5n04oF
        S/ga0FS4peZqNgFl/u4kwiRoZ9wrxns=
Content-Disposition: inline
In-Reply-To: <0000000000004e96a405e4fd5051@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+934ebb67352c8a490bf3@syzkaller.appspotmail.com>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, hdanton@sina.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, tj@kernel.org, Yufen Yu <yuyufen@huawei.com>

On Fri, Jul 29, 2022 at 08:25:08PM -0700, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 0a9a25ca78437b39e691bcc3dc8240455b803d8d
> Author: Ming Lei <ming.lei@redhat.com>
> Date:   Fri Mar 18 13:01:43 2022 +0000
> 
>     block: let blkcg_gq grab request queue's refcnt
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16c3cfc2080000
> start commit:   cb71b93c2dc3 Add linux-next specific files for 20220628
> git tree:       linux-next
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=15c3cfc2080000
> console output: https://syzkaller.appspot.com/x/log.txt?x=11c3cfc2080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=badbc1adb2d582eb
> dashboard link: https://syzkaller.appspot.com/bug?extid=934ebb67352c8a490bf3
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17713dee080000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15d24952080000
> 
> Reported-by: syzbot+934ebb67352c8a490bf3@syzkaller.appspotmail.com
> Fixes: 0a9a25ca7843 ("block: let blkcg_gq grab request queue's refcnt")

No, this lockdep warning isn't related with the above commit, which
caused another regression, but fixed by commit d578c770c852
("block: avoid calling blkg_free() in atomic context"). Looks syzbot
can't recognize difference between the two different issues.

This specific issue of '[syzbot] possible deadlock in throtl_pending_timer_fn',
is actually introduced by commit ("27029b4b18aa blkcg: fix memleak for iolatency").

blk_throtl_exit() isn't safe to be called before blkg_destroy_all().

The following change should avoid the issue:


diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 869af9d72bcf..1606acb917fd 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1268,6 +1268,7 @@ static int blkcg_css_online(struct cgroup_subsys_state *css)
 int blkcg_init_queue(struct request_queue *q)
 {
 	struct blkcg_gq *new_blkg, *blkg;
+	bool need_exit_throtl = false;
 	bool preloaded;
 	int ret;
 
@@ -1301,7 +1302,7 @@ int blkcg_init_queue(struct request_queue *q)
 
 	ret = blk_iolatency_init(q);
 	if (ret) {
-		blk_throtl_exit(q);
+		need_exit_throtl = true;
 		blk_ioprio_exit(q);
 		goto err_destroy_all;
 	}
@@ -1310,6 +1311,8 @@ int blkcg_init_queue(struct request_queue *q)
 
 err_destroy_all:
 	blkg_destroy_all(q);
+	if (need_exit_throtl)
+		blk_throtl_exit(q);
 	return ret;
 err_unlock:
 	spin_unlock_irq(&q->queue_lock);



Thanks,
Ming

