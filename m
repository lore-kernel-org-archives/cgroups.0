From: Tejun Heo <tj@kernel.org>
Subject: [PATCH block/for-next] blk-cgroup: cgroup_rstat_updated() shouldn't
 be called on cgroup1
Date: Thu, 14 Nov 2019 14:31:28 -0800
Message-ID: <20191114223128.GM4163745@devbig004.ftw2.facebook.com>
References: <20191107191804.3735303-1-tj@kernel.org>
 <20191107191804.3735303-6-tj@kernel.org>
 <cd3ebcee-6819-a09b-aeba-de6817f32cde@ti.com>
 <20191113163501.GI4163745@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qyKgxDIoS90Bkq4dmLrHtgbONXS0B4JMDXYzM2TILvI=;
        b=GjsvHBt7MeaEC6ypDHcPMK+s4FU+jBrqyBph1dVSDP6GI5ClRgEmnDD2Hk2fNzRKfP
         z1IBWzaXJeLT1ubyYe0TtRTwRHibve7KSwuFU33vAAOEpobMcSrWuQ3RkD3VWfOXdiw+
         /F6IS2oY+rtMYJbeX32d60XzvRfhF6RTC+Yo7K8KSxkwrnBg+/QuORoDoyMOkTLoTiCS
         cYMhyizV/A9PpsvWwZCI7AtDdcMg+ynVXanL2cPjXHkTxdbe2sU7/EbnEdoX9XBFAdkT
         Ek/6EdXl/XqBOKYkXJzKA/M2VGzSA5+TFpXf43Fkow8BNPoSwm0aO5y6L6wtVTBapJo/
         0gSg==
Content-Disposition: inline
In-Reply-To: <20191113163501.GI4163745@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Faiz Abbas <faiz_abbas@ti.com>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, kernel-team@fb.com, Dan Schatzberg <dschatzberg@fb.com>, Daniel Xu <dlxu@fb.com>

Currently, cgroup rstat is supported only on cgroup2 hierarchy and
rstat functions shouldn't be called on cgroup1 cgroups.  While
converting blk-cgroup core statistics to rstat, f73316482977
("blk-cgroup: reimplement basic IO stats using cgroup rstat")
accidentally ended up calling cgroup_rstat_updated() on cgroup1
cgroups causing crashes.

Longer term, we probably should add cgroup1 support to rstat but for
now let's mask the call directly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: f73316482977 ("blk-cgroup: reimplement basic IO stats using cgroup rstat")
---
 include/linux/blk-cgroup.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 48a66738143d..19394c77ed99 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -626,7 +626,8 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 		bis->cur.ios[rwd]++;
 
 		u64_stats_update_end(&bis->sync);
-		cgroup_rstat_updated(blkg->blkcg->css.cgroup, cpu);
+		if (cgroup_subsys_on_dfl(io_cgrp_subsys))
+			cgroup_rstat_updated(blkg->blkcg->css.cgroup, cpu);
 		put_cpu();
 	}
 
