From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: BUG: HANG_DETECT waiting for migration_cpu_stop() complete
Date: Tue, 6 Sep 2022 08:30:41 -1000
Message-ID: <YxeR0RoiTdm8sWCJ@slm.duckdns.org>
References: <88b2910181bda955ac46011b695c53f7da39ac47.camel@mediatek.com>
 <b605c3ec-94ab-a55f-5825-9b370d77ecf3@quicinc.com>
 <203d4614c1b2a498a240ace287156e9f401d5395.camel@mediatek.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=XgR/VP7NAhWauMOsrwcgIw4hBbhzAc1gPVaPVW58FU4=;
        b=S0fGy3Amy4jLKzuOHjKtRyPXTXPwsHuseA5jDpGwgXLMWKnDw9zRiwSKKo7O5Q/hOS
         LouY1sFAeHQBoDjypEXbFeLyxrjIzIiq//XsVdH9HR8vYwJl9TsrdpKS3ETQdJR7SAcb
         LDXBubAEA2lklGik3H1FSYpdt7J2XoaJlUr7sH3ht/xkgT2hAlWId1cjanJn4WNCSYkD
         qwA+UwuSZoYf5J1TeqNALYVszB4PYXcjVbLXWs7E91eAKhvFPM2byJ8TUSIrdcFZOQ1R
         xZIXH+U3kSC5zEdIPoL3lCrE1nPLx2y4A1djzpPAPsIwaqBXqYM9BuRC7NvWENr09cCq
         bLhQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <203d4614c1b2a498a240ace287156e9f401d5395.camel-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jing-Ting Wu <jing-ting.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Cc: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jonathan.JMChen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, "chris.redpath-5wv7dgnIgG8@public.gmane.org" <chris.redpath-5wv7dgnIgG8@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Vincent Donnefort <vdonnefort-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lixiong.liu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, wenju.xu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, Waiman Long <longman@re>

Hello,

(cc'ing Waiman in case he has a better idea)

On Mon, Sep 05, 2022 at 04:22:29PM +0800, Jing-Ting Wu wrote:
> https://lore.kernel.org/lkml/YvrWaml3F+x9Dk+T-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org/ is for
> fix cgroup_threadgroup_rwsem <-> cpus_read_lock() deadlock.
> But this issue is cgroup_threadgroup_rwsem <-> cpuset_rwsem deadlock.

If I'm understanding what you're writing correctly, this isn't a deadlock.
The cpuset_hotplug_workfn simply isn't being woken up while holding
cpuset_rwsem and others are just waiting for that lock to be released.

Thanks.

-- 
tejun
