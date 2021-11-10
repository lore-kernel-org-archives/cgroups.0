From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC] psi: Add additional PSI counters for each type of memory
 pressure
Date: Wed, 10 Nov 2021 17:14:02 +0100
Message-ID: <20211110161402.GB174703@worktop.programming.kicks-ass.net>
References: <1636558597-248294-1-git-send-email-quic_c_gdjako@quicinc.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NjWp/DEt+8bVHPs1gmDRocuQVRMShr5c3n+CoKHRG3Y=; b=FgTPGGCfgvuH/hxPJ+BKPW63ZY
        2h9xXsa8BCA8uE7nrHtXOFynwE/3wW600gdD7y23kFti+2gx0Or+nKJxcni9NEVgR0taz97mPYEwp
        +cNTH7BvpALxKGQpA4TsoBMFRlLoVyadyWiCwQ9vvSeW5hfnXKo50OoDN++CzUlZVDE3HjH23IcrL
        HK8VVB4CTu5vahV/VTUIQYs1Twx3h/kEYMVYls/xN4Zx0oWdCTc9we4AunzgYMPXeGO5uENnHDIX2
        jFW+u6R9AOPytdq+Oe9GnVSUx7948uS3hWAUxAWg3zy+Xr6uhbsOX+NS1tGx15JkaiUxUTYH1Lj8q
        gdv9DCKQ==;
Content-Disposition: inline
In-Reply-To: <1636558597-248294-1-git-send-email-quic_c_gdjako-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Georgi Djakov <quic_c_gdjako-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, djakov-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Wed, Nov 10, 2021 at 07:36:37AM -0800, Georgi Djakov wrote:
> @@ -21,7 +19,18 @@ enum psi_task_count {
>  	 * don't have to special case any state tracking for it.
>  	 */
>  	NR_ONCPU,
> -	NR_PSI_TASK_COUNTS = 4,
> +	NR_BLK_CGROUP_THROTTLE,
> +	NR_BIO,
> +	NR_COMPACTION,
> +	NR_THRASHING,
> +	NR_CGROUP_RECLAIM_HIGH,
> +	NR_CGROUP_RECLAIM_HIGH_SLEEP,
> +	NR_CGROUP_TRY_CHARGE,
> +	NR_DIRECT_COMPACTION,
> +	NR_DIRECT_RECLAIM,
> +	NR_READ_SWAPPAGE,
> +	NR_KSWAPD,
> +	NR_PSI_TASK_COUNTS = 16,
>  };
>  

> @@ -51,9 +80,20 @@ enum psi_states {
>  	PSI_MEM_FULL,
>  	PSI_CPU_SOME,
>  	PSI_CPU_FULL,
> +	PSI_BLK_CGROUP_THROTTLE,
> +	PSI_BIO,
> +	PSI_COMPACTION,
> +	PSI_THRASHING,
> +	PSI_CGROUP_RECLAIM_HIGH,
> +	PSI_CGROUP_RECLAIM_HIGH_SLEEP,
> +	PSI_CGROUP_TRY_CHARGE,
> +	PSI_DIRECT_COMPACTION,
> +	PSI_DIRECT_RECLAIM,
> +	PSI_READ_SWAPPAGE,
> +	PSI_KSWAPD,
>  	/* Only per-CPU, to weigh the CPU in the global average: */
>  	PSI_NONIDLE,
> -	NR_PSI_STATES = 7,
> +	NR_PSI_STATES = 18,
>  };

Have you considered what this does to psi_group_cpu's size and layout
and the impact thereof on performance?
