From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 2/3] sched/core: Forced idle accounting per-cpu
Date: Wed, 12 Jan 2022 13:27:39 +0100
Message-ID: <Yd7JO1UYlRXR0dWE@hirez.programming.kicks-ass.net>
References: <1641894961-9241-1-git-send-email-CruzZhao@linux.alibaba.com>
 <1641894961-9241-3-git-send-email-CruzZhao@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aJdQ3WfBr8szpr2DYItlqsfb9rRoIL3kxZXhJL3L8aU=; b=bjjePTTHviZfIwg1tJnjLcwgzq
        xwRs1BQRnIuvC9fEfyAbETRcppiCmDzGfV4S3UpUf5YKhDqZeEdbflYzTx9efKxCuDuf1xVvfV3KZ
        IMT6nxP55MioxAOHwZ68Ie1+TQRP68nc2jy9Ur9RoDlAX5IxBJPhipI2cUpaSMzrq75VVik6YEY0c
        3ltXPVRvJ8JSYw2XTljbUt26BDi0gZFGns1P+tGSSfyAVjGKVpe+lhoH/YzNUdRwsnGHhDRZBeiC+
        xxTMbLUmKAu6NSftSa+T8zGRAUA3xmyAm3GXAHCx72setLknaxvqasqnV6MlGn0cXFlnJpNmZafjh
        HeWKFCxQ==;
Content-Disposition: inline
In-Reply-To: <1641894961-9241-3-git-send-email-CruzZhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cruz Zhao <CruzZhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 11, 2022 at 05:56:00PM +0800, Cruz Zhao wrote:

> @@ -1115,6 +1118,7 @@ struct rq {
>  	unsigned int		core_forceidle_seq;
>  	unsigned int		core_forceidle_occupation;
>  	u64			core_forceidle_start;
> +	bool			in_forcedidle;

naming is wrong

>  #endif
>  };
>  
> diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
> index 07dde29..ea22a8c 100644
> --- a/kernel/sched/stats.c
> +++ b/kernel/sched/stats.c
> @@ -108,6 +108,16 @@ void __update_stats_enqueue_sleeper(struct rq *rq, struct task_struct *p,
>  	}
>  }
>  
> +#ifdef CONFIG_SCHED_CORE
> +static inline u64 get_rq_forceidle_time(struct rq *rq) {
> +	return rq->rq_forceidle_time;
> +}
> +#else
> +static inline u64 get_rq_forceidle_time(struct rq *rq) {
> +	return 0;
> +}
> +#endif

indent is wrong, and if you put the #ifdef inside the function it'll be
smaller.
