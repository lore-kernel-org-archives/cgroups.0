From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 1/5] cgroup: Enable
 task_under_cgroup_hierarchy() on cgroup1
Date: Wed, 6 Sep 2023 12:53:46 -0700
Message-ID: <20230906195346.ghrmpku47tmrgnsv@MacBook-Pro-8.local>
References: <20230903142800.3870-1-laoar.shao@gmail.com>
 <20230903142800.3870-2-laoar.shao@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694030031; x=1694634831; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a6RLg+POdRGD0L8+2lqSSropHtZ6QvcmXiJIAf4zj1Y=;
        b=srLzk93V7v3lv3920rpFLZD+/3cxcpPAgmCD3eeSeVw/x14HHkU01qvUbVa+/khkHf
         5Bqa275SvH7gKFHfUEBWNPMHr3NvF/2lRtblbio1MmbKsWHmOoerNqXGYi0dPBP1n0b/
         3Fa0xeOOpfZ5UCmrAZGYc6nPP3uxxvHU6N+L32qmfEpL/lOZr09+p7RnH00WR4l4okep
         JobC1UjvGcJwK0KY5Nv2brdAWVTs2KkAwLSnbmLce8HaBpBMPiegmY8FEhwJNolmsGnu
         3+fGr59MFwKb3CIILiB+MDgnLP1JRL3c6FpnLpg8zyQM9QP0xJQmv+8XDRgpDkKYvFjt
         5K6w==
Content-Disposition: inline
In-Reply-To: <20230903142800.3870-2-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Sep 03, 2023 at 02:27:56PM +0000, Yafang Shao wrote:
> Currently, the function task_under_cgroup_hierarchy() allows us to
> determine if a task resides exclusively within a cgroup2 hierarchy.
> Nevertheless, given the continued prevalence of cgroup1, it's useful that
> we make a minor adjustment to extend its functionality to cgroup1 as well.
> Once this modification is implemented, we will have the ability to
> effortlessly verify a task's cgroup membership within BPF programs. For
> instance, we can easily check if a task belongs to a cgroup1 directory,
> such as /sys/fs/cgroup/cpu,cpuacct/kubepods/burstable/ or
> /sys/fs/cgroup/cpu,cpuacct/kubepods/besteffort/.
> 
> Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  include/linux/cgroup.h | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index b307013..5414a2c 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -543,15 +543,33 @@ static inline struct cgroup *cgroup_ancestor(struct cgroup *cgrp,
>   * @ancestor: possible ancestor of @task's cgroup
>   *
>   * Tests whether @task's default cgroup hierarchy is a descendant of @ancestor.
> - * It follows all the same rules as cgroup_is_descendant, and only applies
> - * to the default hierarchy.
> + * It follows all the same rules as cgroup_is_descendant.
>   */
>  static inline bool task_under_cgroup_hierarchy(struct task_struct *task,
>  					       struct cgroup *ancestor)
>  {
>  	struct css_set *cset = task_css_set(task);
> +	struct cgroup *cgrp;
> +	bool ret = false;
> +	int ssid;
> +
> +	if (ancestor->root == &cgrp_dfl_root)
> +		return cgroup_is_descendant(cset->dfl_cgrp, ancestor);
> +
> +	for (ssid = 0; ssid < CGROUP_SUBSYS_COUNT; ssid++) {
> +		if (!ancestor->subsys[ssid])
> +			continue;

This looks wrong. I believe cgroup_mutex should be held to iterate.

Tejun ?

>  
> -	return cgroup_is_descendant(cset->dfl_cgrp, ancestor);
> +		cgrp = task_css(task, ssid)->cgroup;
> +		if (!cgrp)
> +			continue;
> +
> +		if (!cgroup_is_descendant(cgrp, ancestor))
> +			return false;
> +		if (!ret)
> +			ret = true;
> +	}
> +	return ret;
>  }
>  
>  /* no synchronization, the result can only be used as a hint */
> -- 
> 1.8.3.1
> 
