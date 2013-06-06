From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 05/11] cpuacct: don't actually do anything.
Date: Thu, 6 Jun 2013 16:16:07 -0700
Message-ID: <20130606231607.GO5045@htj.dyndns.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
 <1369825402-31046-6-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=b6W04TY4nqR1I5AvWYP8oO9GA3B1IURI/qee/N7vKdY=;
        b=EVddspUi/piAiCoYY9i9FRr3RhWXawQ8tzRxnInvCSHnMi4kMpPUMeUXfBf+YM3EUT
         6zaCrxkDNlJQcnA7HjRKFxLNj1eAHNO9Nc0+wPg2i7TqWaJFOnxa9MT8RDb1hau/GSI1
         K/W2wZoX7AB+v12vYpbcawBH1QKvMGkGLpoiibg68tazYxDHoN+kEFVBcO5xSZqaxKqt
         S4+z5/ec+mL4yOxAZIOhN35W2tCl0PKwdDf3HxkBq2drLKs2PPAvuZ0hdt/w+8W+ME+l
         3klpc8Dwn0+ghfXIo507ifpICz0IS8Cg/vhJu8btGj1ZVcwViRZVedb/5MGX5y3eNxIY
         T4MA==
Content-Disposition: inline
In-Reply-To: <1369825402-31046-6-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>

Hello, Glauber.

I think the patch title / description are a bit confusing.  This is
about pcpuacct stats provided by cpu controller, right?

> +#ifdef CONFIG_SCHEDSTATS
> +#ifdef CONFIG_FAIR_GROUP_SCHED
...
>  #else
...
> +#endif
> +#ifdef CONFIG_RT_GROUP_SCHED
...
> +#else
...
>  #endif
...
> +#else
> +#endif

This is getting rather messy.  Maybe CONFIG_CGROUP_SCHED should just
select CONFIG_SCHEDSTATS?

Thanks.

-- 
tejun
