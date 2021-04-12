From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH V12 0/3] Charge loop device i/o to issuing cgroup
Date: Mon, 12 Apr 2021 09:50:17 -0600
Message-ID: <072a9ad4-b63e-e540-9314-f3e3763111f5@kernel.dk>
References: <20210402191638.3249835-1-schatzberg.dan@gmail.com>
 <YHRrJ9V6ivpH2QUN@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NZYZrqYCNCv2bxpNxPSl3nXWCQe4Fvp0PwQSK0b1hpU=;
        b=Vx5mpzCj+enoGx9KqcYEWgEiZhKJWzoqSUtR72eSgqZtcWN2ie+bYKb8MbLhjQRfM6
         qi1Dy0regakn0YcVsX5B9cGxYuAq3tDrFjwVp1DPcWASoXPSniF0Mv7BKr/CPQmr0yU9
         FFKABGEFgXaEFRuqUrTX+iEl6xvNJuRBCqHv6j9B+VRqNmX19gVn76JmwDAQqS0bUUN4
         RKSNOqQC4XgBif+68UagaWV8p+YicdH8v3bKF8rjZFqWH2i74qsek+wy3ElqA2Uvc9NI
         Cue4rBg3IVwo1TGS8CSWF00s1Z0W7oMecfJnU+7uxdDzfikV3sb+iskWOOIk0xY2w1Xq
         H/XQ==
In-Reply-To: <YHRrJ9V6ivpH2QUN-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On 4/12/21 9:45 AM, Johannes Weiner wrote:
> It looks like all feedback has been addressed and there hasn't been
> any new activity on it in a while.
> 
> As per the suggestion last time [1], Andrew, Jens, could this go
> through the -mm tree to deal with the memcg conflicts?

Yep, I think that would make it the most painless for everyone.

Dan/Andrew, you can add my Acked-by to the series.

-- 
Jens Axboe

