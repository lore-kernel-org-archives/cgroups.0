From: Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] sched/core: Fix wrong burst unit in cgroup2 cpu.max write
Date: Fri, 10 Sep 2021 13:43:39 -0700
Message-ID: <xm267dfonouc.fsf@google.com>
References: <20210910162509.622222-1-kailun.qin@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=lKqAYpYNlQ9hkuyrKjXk6bTpMchdOnzhQvx8SF/LD7o=;
        b=DlpN4wySBad/y9SQPx+P71ThJSo7FqyruNXODlhEZ1s3VW+7183RRa/2RPQdKA+x3C
         xHLFetRomChjnZ3c9CXts4FhRjtnNUDGvp7l9/XhuzSR31sm0fhUne3+cv1xX3y+Q4RT
         vnIiVPDc31WJZb8SkH5yokzl7SaZ1uqJS9NKc3tenwZeDy3QiLXYxoaP4efDPlRISMC+
         CYlX2+VJMkBkFXQBbBCTN9lLugiwuTAGkFQCLmpjlnMnC59LKz04aqsuDFkGQEPCI3L5
         9pIEOFG7qghiV+TfkNgunDkPDacmtSqxhqnLpI/X8vvrmedAWnxwvoBdNXFXB/Q9BWpF
         y48w==
In-Reply-To: <20210910162509.622222-1-kailun.qin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> (Kailun Qin's
        message of "Fri, 10 Sep 2021 12:25:09 -0400")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kailun Qin <kailun.qin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, changhuaixin-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org

Kailun Qin <kailun.qin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:

> In cpu_max_write(), as the eventual tg_set_cfs_bandwidth() operates on
> the burst in nsec which is input from tg_get_cfs_burst() in usec, it
> should be converted into nsec accordingly.
>
> If not, this may cause a write into cgroup2 cpu.max to unexpectedly
> change an already set cpu.max.burst.
>
> This patch addresses the above issue.
>
> Signed-off-by: Kailun Qin <kailun.qin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Oh, huh, cpu_period_quota_parse is confusing and changes the units in
period. (It might make more sense to make all that interaction clearer
somehow, but this is probably fine)

It's probably also better to just use tg->cfs_bandwidth.burst directly
rather than do an unnecessary div+multiply.

For whichever version:

Reviewed-by: Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> ---
>  kernel/sched/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index c4462c454ab9..fc9fcc56149f 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -10711,7 +10711,7 @@ static ssize_t cpu_max_write(struct kernfs_open_file *of,
>  {
>  	struct task_group *tg = css_tg(of_css(of));
>  	u64 period = tg_get_cfs_period(tg);
> -	u64 burst = tg_get_cfs_burst(tg);
> +	u64 burst = (u64)tg_get_cfs_burst(tg) * NSEC_PER_USEC;
>  	u64 quota;
>  	int ret;
