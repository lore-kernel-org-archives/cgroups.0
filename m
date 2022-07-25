From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/9] sched/psi: fix periodic aggregation shut off
Date: Mon, 25 Jul 2022 11:39:24 -0400
Message-ID: <Yt65LEyN83mTGxwF@cmpxchg.org>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-2-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q49/FuKBMY9BrFSyOdYu7NQvVCe0YeST3kjmGB5Jebc=;
        b=wMOPEo2m1JQMh3dBUqFbe5lY8LxfWG6fPXGDrdqEHSFUcJzQnUAVeC8JPzpmGhU2DD
         GmRQzqNKWqmcB+MBngjymjoTYeweUR+g6pdwuePAfwXPEzLdLiMynz4Op/QbILv0syfm
         HYESZLK0KUd96OJfMXrJo2Oojn9V9tW9oSYFsL0nWQFDupHFE+TcQg0/Hopixz2m0SKx
         hx160xziE1qr/k+/8PLHtIBOBl8nfno6jLrseP8rNA3dYUIjrWBbuokl2OrwW0RiNVsw
         JyUCrWzDh4+wTOey648I7qntYsxZ0n504171R6z9X9WXMd4Gph2zaHEegJ0Tyz2T0J1t
         msFQ==
Content-Disposition: inline
In-Reply-To: <20220721040439.2651-2-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 21, 2022 at 12:04:31PM +0800, Chengming Zhou wrote:
> @@ -871,13 +861,23 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>  				clear |= TSK_MEMSTALL_RUNNING;
>  			if (prev->in_iowait)
>  				set |= TSK_IOWAIT;
> +
> +			/*
> +			 * Periodic aggregation shuts off if there is a period of no
> +			 * task changes, so we wake it back up if necessary. However,
> +			 * don't do this if the task change is the aggregation worker
> +			 * itself going to sleep, or we'll ping-pong forever.
> +			 */
> +			if (unlikely((prev->flags & PF_WQ_WORKER) &&
> +				     wq_worker_last_func(prev) == psi_avgs_work))
> +				wake_clock = false;
>  		}
>  
>  		psi_flags_change(prev, clear, set);
>  
>  		iter = NULL;
>  		while ((group = iterate_groups(prev, &iter)) && group != common)
> -			psi_group_change(group, cpu, clear, set, now, true);
> +			psi_group_change(group, cpu, clear, set, now, wake_clock);
>  
>  		/*
>  		 * TSK_ONCPU is handled up to the common ancestor. If we're tasked

Wait, there is another psi_group_change() below this, which handles
the clearing of TSK_RUNNING for common ancestors. We don't want to
wake those either, so it needs s/true/wake_clock/ as well.
