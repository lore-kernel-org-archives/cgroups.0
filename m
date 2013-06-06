From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 07/11] sched: account guest time per-cgroup as well.
Date: Thu, 6 Jun 2013 16:48:32 -0700
Message-ID: <20130606234832.GQ5045@htj.dyndns.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
 <1369825402-31046-8-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=aMxqMqM+i19McvrowSStRaPQHnpPw+Aofq7nZ3QXFDY=;
        b=pvLEhSo/5vL39/MYcYRlFuR713yrESju/wVB9yQ2uZcM4yJ1lS8fFcUUXTTfpuADeB
         cnSwpOIgPDDfFxTGW3y6cmLJ5OIrqyQvSdrNc+68qPDe5tZ20UivsW4vrHwSFw1GT6lo
         uAuJyxz1Dz5IJ4LRX8NuoV3Tm1g6MIZqQqi9Kjo/t7NIFfDBzJaBnwZM6hy4cuh112Cd
         r7Hty8+dKKLg7Bb6HmVitBCQIbItezcZKNTDMIJLDH55PvQxkNFrPOsCepyJrEyZ76eM
         i1ThB4ufd2HbYdU/PGiPeYti7YuOLigG0k4qWc9FuyZvAntFS29xTmB6uFqmVi2+RS1j
         91lg==
Content-Disposition: inline
In-Reply-To: <1369825402-31046-8-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Wed, May 29, 2013 at 03:03:18PM +0400, Glauber Costa wrote:
> We already track multiple tick statistics per-cgroup, using
> the task_group_account_field facility. This patch accounts
> guest_time in that manner as well.
> 
> Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> CC: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
> CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/sched/cputime.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index 74a44ef..e653e52 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -183,8 +183,6 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
>  static void account_guest_time(struct task_struct *p, cputime_t cputime,
>  			       cputime_t cputime_scaled)
>  {
> -	u64 *cpustat = kcpustat_this_cpu->cpustat;
> -
>  	/* Add guest time to process. */
>  	p->utime += cputime;
>  	p->utimescaled += cputime_scaled;
> @@ -193,11 +191,11 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
>  
>  	/* Add guest time to cpustat. */
>  	if (TASK_NICE(p) > 0) {
> -		cpustat[CPUTIME_NICE] += (__force u64) cputime;
> -		cpustat[CPUTIME_GUEST_NICE] += (__force u64) cputime;
> +		task_group_account_field(p, CPUTIME_NICE, (__force u64) cputime);
> +		task_group_account_field(p, CPUTIME_GUEST, (__force u64) cputime);
>  	} else {
> -		cpustat[CPUTIME_USER] += (__force u64) cputime;
> -		cpustat[CPUTIME_GUEST] += (__force u64) cputime;
> +		task_group_account_field(p, CPUTIME_USER, (__force u64) cputime);
> +		task_group_account_field(p, CPUTIME_GUEST, (__force u64) cputime);

This is a behavior change, right?  It seems sane to me but maybe the
patch description should be more explicit?

Thanks.

-- 
tejun
