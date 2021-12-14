From: Tejun Heo <tj@kernel.org>
Subject: [PATCH for-5.16/block] iocost: Fix divide-by-zero on donation from
 low hweight cgroup
Date: Mon, 13 Dec 2021 14:14:43 -1000
Message-ID: <Ybfh86iSvpWKxhVM@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=tzFwrsyfocHR62i38nhleK4wzKa/CEfMJu2ZigK1O5w=;
        b=lcSCrjdeXb4OGQkRbBVLySQJpkDXJwxXgCrAq0PkB9/TVlnHoBsS9JKjUiLX7+PF8/
         bGTb2J6zGIa7VY9ZSbw3fmhyT8hBXv+fbZro2IpVkktck8BMChCNsOfBZLGgVxEAlxTf
         D9YRTBwpElF/PL7TCi3h07jiLIK2EKuqfSw1CBmp1+ITsyVeHpUn3zGy4BX0UrRITkcH
         jFEXNjNJTMDdPfAZLDRIchnQupvkmV8YmWB+emutN108nSrPU2M5t0sRurO1md/a7IFv
         1pTp4UlBFMxE5wT1AUwsSvDKLWlvBzHEppsoVB/1gb7vrUvQkqgzShLpUqRxvjZdCqT9
         r/iw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

The donation calculation logic assumes that the donor has non-zero
after-donation hweight, so the lowest active hweight a donating cgroup can
have is 2 so that it can donate 1 while keeping the other 1 for itself.
Earlier, we only donated from cgroups with sizable surpluses so this
condition was always true. However, with the precise donation algorithm
implemented, f1de2439ec43 ("blk-iocost: revamp donation amount
determination") made the donation amount calculation exact enabling even low
hweight cgroups to donate.

This means that in rare occasions, a cgroup with active hweight of 1 can
enter donation calculation triggering the following warning and then a
divide-by-zero oops.

 WARNING: CPU: 4 PID: 0 at block/blk-iocost.c:1928 transfer_surpluses.cold+0x0/0x53 [884/94867]
 ...
 RIP: 0010:transfer_surpluses.cold+0x0/0x53                                                 
 Code: 92 ff 48 c7 c7 28 d1 ab b5 65 48 8b 34 25 00 ae 01 00 48 81 c6 90 06 00 00 e8 8b 3f fe ff 48 c7 c0 ea ff ff ff e9 95 ff 92 ff <0f> 0b 48 c7 c7 30 da ab b5 e8 71 3f fe ff 4c 89 e8 4d 85 ed 74 0
4                                                    
 ...
 Call Trace:                           
  <IRQ>                                
  ioc_timer_fn+0x1043/0x1390           
  call_timer_fn+0xa1/0x2c0             
  __run_timers.part.0+0x1ec/0x2e0      
  run_timer_softirq+0x35/0x70          
 ...
 iocg: invalid donation weights in /a/b: active=1 donating=1 after=0

Fix it by excluding cgroups w/ active hweight < 2 from donating. Excluding
these extreme low hweight donations shouldn't affect work conservation in
any meaningful way.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: f1de2439ec43 ("blk-iocost: revamp donation amount determination")
Cc: stable@vger.kernel.org # v5.10+
---
 block/blk-iocost.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index a5b37cc65b171..769b643942989 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2311,7 +2311,14 @@ static void ioc_timer_fn(struct timer_list *timer)
 			hwm = current_hweight_max(iocg);
 			new_hwi = hweight_after_donation(iocg, old_hwi, hwm,
 							 usage, &now);
-			if (new_hwi < hwm) {
+			/*
+			 * Donation calculation assumes hweight_after_donation
+			 * to be positive, a condition that a donor w/ hwa < 2
+			 * can't meet. Don't bother with donation if hwa is
+			 * below 2. It's not gonna make a meaningful difference
+			 * anyway.
+			 */
+			if (new_hwi < hwm && hwa >= 2) {
 				iocg->hweight_donating = hwa;
 				iocg->hweight_after_donation = new_hwi;
 				list_add(&iocg->surplus_list, &surpluses);
