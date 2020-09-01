From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/27] blk-iocost: make iocg_kick_waitq() call iocg_kick_delay() after paying debt
Date: Tue,  1 Sep 2020 14:52:37 -0400
Message-ID: <20200901185257.645114-8-tj@kernel.org>
References: <20200901185257.645114-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x/aOqugodrjwVnz0DE4cksx9JmSppPabXXJ/nxfNtZc=;
        b=jev6cNZQ2D4dT1yLxz8wo59LUTrlGT9NjwNMYlSaOJupdSMIHQqhqkGoiFnV5DcNBK
         82fbqwvwQMUFuLRqhPkGGSwvv3LKRacsAvrU2//oJojY6uQjwKHPXl4oUzd6bvZUPwDM
         5mtWTRwLS1V9vgjxQMw5mx7y1Z/lRFe/g8xJUSHQvu9tZ41DR28jl9G6tgQ/LcBfbZug
         +Hqz6m94YZD2hYkG3Mxwrl2UcEUDSvls530wuFIPHkJAERESWx63gKPLBCstHpfDOBxc
         6oSzXm8fSrDVGHwA73FrNH0qrXs6X3t9b5TcerJ5aWpH8hk95SH+OeiI7iaouB4ZNTcm
         ndAw==
In-Reply-To: <20200901185257.645114-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, newella@fb.com, Tejun Heo <tj@kernel.org>

iocg_kick_waitq() is the function which pays debt and iocg_kick_delay()
updates the actual delay status accordingly. If iocg_kick_delay() is not
called after iocg_kick_delay() updated debt, unnecessarily large delays can
be applied temporarily.

Let's make sure such conditions don't occur by making iocg_kick_waitq()
always call iocg_kick_delay() after paying debt.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index ac22d761a350..b2b8dfbeee5a 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1226,6 +1226,8 @@ static void iocg_kick_waitq(struct ioc_gq *iocg, struct ioc_now *now)
 		atomic64_add(delta, &iocg->vtime);
 		atomic64_add(delta, &iocg->done_vtime);
 		iocg->abs_vdebt -= abs_delta;
+
+		iocg_kick_delay(iocg, now);
 	}
 
 	/*
@@ -1383,7 +1385,6 @@ static void ioc_timer_fn(struct timer_list *timer)
 		if (waitqueue_active(&iocg->waitq) || iocg->abs_vdebt) {
 			/* might be oversleeping vtime / hweight changes, kick */
 			iocg_kick_waitq(iocg, &now);
-			iocg_kick_delay(iocg, &now);
 		} else if (iocg_is_idle(iocg)) {
 			/* no waiter and idle, deactivate */
 			iocg->last_inuse = iocg->inuse;
-- 
2.26.2

