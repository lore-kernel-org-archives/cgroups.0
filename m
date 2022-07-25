From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 8/9] sched/psi: add kernel cmdline parameter
 psi_inner_cgroup
Date: Mon, 25 Jul 2022 12:52:17 -0400
Message-ID: <Yt7KQc0nnOypB2b2@cmpxchg.org>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-9-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j0BaZSzqD5eIgwyip/HS4aDnwW9Jp806htc77k2W+9I=;
        b=YrRC8+DcvcJ+j3/daDEZUkXI7wwrYxc1PEjLb5WJCKV4hOP1uHTC/ifMwxGxMiDkfx
         /A82VqK1LTw9pVhvRXWQeyXrrPJ2ZvCuG5iWP7cY8NmWkKUfWofwwTglQWitP4sLRpre
         NB5VpzmQIT0yR8C+q/8SpRe6N4qEXuOmhz9/zyJDdIRw6IQfETk2K2RZNRdauaalnISk
         ecXU6u6eJyO8O/HQW59YX4MJEK3q8L7+iGwgT+B0Xfmvz2s9vSCXiUlMoZjDizM7CmZj
         Pva3rt58bJXcA2sOVprKVekCrokJioAdbUfKQmHTFPMiKttfucAsODDHed2z6c5VspUe
         9oNA==
Content-Disposition: inline
In-Reply-To: <20220721040439.2651-9-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 21, 2022 at 12:04:38PM +0800, Chengming Zhou wrote:
> PSI accounts stalls for each cgroup separately and aggregates it
> at each level of the hierarchy. This may case non-negligible overhead
> for some workloads when under deep level of the hierarchy.
> 
> commit 3958e2d0c34e ("cgroup: make per-cgroup pressure stall tracking configurable")
> make PSI to skip per-cgroup stall accounting, only account system-wide
> to avoid this each level overhead.
> 
> For our use case, we also want leaf cgroup PSI accounted for userspace
> adjustment on that cgroup, apart from only system-wide management.

I hear the overhead argument. But skipping accounting in intermediate
levels is a bit odd and unprecedented in the cgroup interface. Once we
do this, it's conceivable people would like to do the same thing for
other stats and accounting, like for instance memory.stat.

Tejun, what are your thoughts on this?
