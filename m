From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/6] blk-cgroup: reimplement basic IO stats using cgroup
 rstat
Date: Wed, 13 Nov 2019 08:35:01 -0800
Message-ID: <20191113163501.GI4163745@devbig004.ftw2.facebook.com>
References: <20191107191804.3735303-1-tj@kernel.org>
 <20191107191804.3735303-6-tj@kernel.org>
 <cd3ebcee-6819-a09b-aeba-de6817f32cde@ti.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xw70SBRGAaKGorTOjyeR6fitBzy2xSe0xSXfhKyCYgw=;
        b=kj0MzPKjmxb6LkA5WODTubivaZMgIS8X26k0mzw6XP2i9yAcO04LIN9rVGgnfQmd6/
         f9TaOH9Bf4CAOxWZjNlkJlSKJHIJtWIhZyhkTC9be9KPdifLHL6H/Z7SR0kmc+/fz4Mw
         gga/oVwgGWwO6D4OfREV7QKGHXfKeu0IqA4GP7+h7VF/bKhv3p8NB6gS5XbWF4e1wod8
         chadrZd0U5tDrlWH3PWu+UBlzxeeVZ1d9PHmrR3fW9Wae1erjTeS66w0U0kxGhj2kqln
         0GHonYrvpvuOr9yHqFfjd1MKb7WZZan/VB5u1SZNjqrr/LC9Vculiqq24sz9vT+IAyRG
         ckvw==
Content-Disposition: inline
In-Reply-To: <cd3ebcee-6819-a09b-aeba-de6817f32cde@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Faiz Abbas <faiz_abbas@ti.com>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, kernel-team@fb.com, Dan Schatzberg <dschatzberg@fb.com>, Daniel Xu <dlxu@fb.com>

Hello,

Can you please see whether the following patch fixes the issue?

Thanks.

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
 
