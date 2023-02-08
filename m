From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/2] sched/psi: simplify cgroup psi retrieving
Date: Wed, 8 Feb 2023 13:54:54 -0500
Message-ID: <Y+Pv/kIkUz/YlvNi@cmpxchg.org>
References: <20230208161654.99556-1-ryncsn@gmail.com>
 <20230208161654.99556-2-ryncsn@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h8wnkAyp+UT+1C4mbuuq7uAJNtmK6LABMEs9ejaKbmU=;
        b=D6besAl+jnXs8HL2wgkgbCj2qj3xJ9fr/H/QmgZCQOBl/ILNdsAnYnJz5z/T00IMUS
         0LjcTtS5QnJ0TqPgeMn3odKFuB1k7RURDlftGvJvo+M0cbC8W/TgfGGWUivhjQ02WfAL
         hH75lKyYjyXVvWK2I9cGrN8jkuWCEJxrLFUCUo6h3+mPqU280HNWG2VzpHjmXqrErVPu
         Dvuhm6cqJup7Slw5HCYXzdphjvFgXJpe5kkkWwrtB1WN9BwLThsX9bBAvaqbN9Rjn+Jw
         f/6Y7vKq4zhEWwPwKJou0IwNH/fOmSvBArEMpJLpctVxM0xtJhSKz1GfOfQpL+/c/kB1
         srYw==
Content-Disposition: inline
In-Reply-To: <20230208161654.99556-2-ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Hello Kairui,

On Thu, Feb 09, 2023 at 12:16:53AM +0800, Kairui Song wrote:
> From: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> 
> Since the only case where cgroup_psi should return psi_system instead of
> the cgroup's psi_group is the root cgroup, just set root cgroup's psi to
> point to psi_system to remove the if branch.
> 
> Signed-off-by: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Thanks for the patches. They overall look good, and the numbers even
better.

>  include/linux/psi.h    | 2 +-
>  kernel/cgroup/cgroup.c | 7 ++++++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/psi.h b/include/linux/psi.h
> index b029a847def1..9c3a1638b618 100644
> --- a/include/linux/psi.h
> +++ b/include/linux/psi.h
> @@ -33,7 +33,7 @@ __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
>  #ifdef CONFIG_CGROUPS
>  static inline struct psi_group *cgroup_psi(struct cgroup *cgrp)
>  {
> -	return cgroup_ino(cgrp) == 1 ? &psi_system : cgrp->psi;
> +	return cgrp->psi;
>  }
>  
>  int psi_cgroup_alloc(struct cgroup *cgrp);
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index c099cf3fa02d..1491d63b06b6 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -163,7 +163,12 @@ static struct static_key_true *cgroup_subsys_on_dfl_key[] = {
>  static DEFINE_PER_CPU(struct cgroup_rstat_cpu, cgrp_dfl_root_rstat_cpu);
>  
>  /* the default hierarchy */
> -struct cgroup_root cgrp_dfl_root = { .cgrp.rstat_cpu = &cgrp_dfl_root_rstat_cpu };
> +struct cgroup_root cgrp_dfl_root = {
> +	.cgrp.rstat_cpu = &cgrp_dfl_root_rstat_cpu,
> +#ifdef CONFIG_PSI
> +	.cgrp.psi = &psi_system
> +#endif

Nitpick: customary coding style is to keep a comma even after the last
entry in the struct. Somebody appending new things won't need to touch
the previous last line, which adds diff noise.

With that, please add:

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
