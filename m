From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/6] cgroup: initialize cgrp->dentry before css_alloc()
Date: Wed, 23 Jan 2013 08:35:36 -0800
Message-ID: <20130123163536.GA2373@mtj.dyndns.org>
References: <50F7B040.2020906@huawei.com>
 <20130123002754.GB5359@htj.dyndns.org>
 <50FF4C4D.4020405@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=9scwAVPSz/toxMLiAgcjBJXF1v5mVWtG63a1NHfGJ0c=;
        b=BCGmXgZbqbBPHe7uExF0yle4SdrFbWkWtpuaBAbLWGfHGFp2xNbsjmkBR09A+tvY0V
         KO5/3emBJVgbud3oTFTH6kPrNydKlkgOPD4vfCWXRGfMz63W2kY8Ffbla83YHo7EMxJp
         Kd7OvJWst61UAZX69ttKiCgGxDi0qOGQ/ZOsWs9A/62pMX1pwecqvkg7Cr/CEFH15aar
         8YkhM9yHSRsdAIX1QD2U6UCSJB6tcyM/8SLjSlzLg6XdCV19nq4nlTOKSX6bLgmxERgd
         j6ztybAQziKzmNlNa5BLQPRuEZSM9ggsBfbFhEJW/99i4MBAt4vnQimZacVw3R/7fMuf
         1/xA==
Content-Disposition: inline
In-Reply-To: <50FF4C4D.4020405-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Li.

On Wed, Jan 23, 2013 at 10:34:53AM +0800, Li Zefan wrote:
> Scheduler changes made in patch #2 are preparation for #3 and #4.
> 
> - for #3:
> 
> After ss->css_alloc(), there's a small window that tg->css.cgroup is NULL.
> With the change, tg won't be seen before ss->css_online(), so the scheduler
> won't see NULL tg->css.cgroup.
> 
> - for #4:
> 
> If tg is unregistered and removed from global list in css_free(), and if
> we kfree cgroup right after ss->css_free(), the scheduler can access
> invalid tg->css.cgroup, because tg is also protected by RCU.

Can you please incorporate the above into the patch descriptions?

Thanks!

-- 
tejun
