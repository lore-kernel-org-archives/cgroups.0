From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 6/5] iocost: consider iocgs with active delays for debt
 forgiveness
Date: Fri, 18 Sep 2020 14:41:27 -0400
Message-ID: <20200918184127.GB4247@mtj.thefacebook.com>
References: <20200918004456.593983-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RyuK5UieZne+pKhpGinbT1xLnPtjZ4n2yvvqOQQR/RM=;
        b=bijR7TvXbgX48PfH9waDRVC/Tbn3PSFLH/s/gHvqLfGFatnCdUy9xUMEhd8hR+12c6
         bM4G7PDeskHdUznZLA0Y1RXttv8Zf5Kc4gWb0xfOf7BiW2JvYcY8zQoWk/EWjxWDr9Co
         F6lzPp0d/WanDs+PEy5McGVjmqp9J4aOu1Mj6fu/oo7Zb28uMf6HGPvK3eQekiroIocI
         qgnEXOWua96Vs6spW1iBrlpEY1kxchcSzIEAAer60R4lQGVJsXv55z2V/a4PjsGPbf7R
         0pHxW2in/M7Xd1ZBpmWUarETt52ESRjqTDHazLcEMmOk0JD1lIYUj0mqE7Idd144OnLF
         94sQ==
Content-Disposition: inline
In-Reply-To: <20200918004456.593983-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

An iocg may have 0 debt but non-zero delay. The current debt forgiveness
logic doesn't act on such iocgs. This can lead to unexpected behaviors - an
iocg with a little bit of debt will have its delay canceled through debt
forgiveness but one w/o any debt but active delay will have to wait out
until its delay decays out.

This patch updates the debt handling logic so that it treats delays the same
as debts. If either debt or delay is active, debt forgiveness logic kicks in
and acts on both the same way.

Also, avoid turning the debt and delay directly to zero as that can confuse
state transitions.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Jens, a follow up patch to the series. The git tree is also updated.

Thanks.

 block/blk-iocost.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2048,7 +2048,7 @@ static void ioc_forgive_debts(struct ioc
 	list_for_each_entry(iocg, &ioc->active_iocgs, active_list) {
 		u64 __maybe_unused old_debt, __maybe_unused old_delay;
 
-		if (!iocg->abs_vdebt)
+		if (!iocg->abs_vdebt && !iocg->delay)
 			continue;
 
 		spin_lock(&iocg->waitq.lock);
@@ -2056,8 +2056,11 @@ static void ioc_forgive_debts(struct ioc
 		old_debt = iocg->abs_vdebt;
 		old_delay = iocg->delay;
 
-		iocg->abs_vdebt >>= nr_cycles;
-		iocg->delay = 0; /* kick_waitq will recalc */
+		if (iocg->abs_vdebt)
+			iocg->abs_vdebt = iocg->abs_vdebt >> nr_cycles ?: 1;
+		if (iocg->delay)
+			iocg->delay = iocg->delay >> nr_cycles ?: 1;
+
 		iocg_kick_waitq(iocg, true, now);
 
 		TRACE_IOCG_PATH(iocg_forgive_debt, iocg, now, usage_pct,
@@ -2129,7 +2132,7 @@ static void ioc_timer_fn(struct timer_li
 		    iocg->delay) {
 			/* might be oversleeping vtime / hweight changes, kick */
 			iocg_kick_waitq(iocg, true, &now);
-			if (iocg->abs_vdebt)
+			if (iocg->abs_vdebt || iocg->delay)
 				nr_debtors++;
 		} else if (iocg_is_idle(iocg)) {
 			/* no waiter and idle, deactivate */
