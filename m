From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup/cpuset: Allow only one active attach
 operation per cpuset
Date: Thu, 6 Apr 2023 11:44:20 +0200
Message-ID: <20230406-haselnuss-baumhaus-83dc05f869df@brauner>
References: <20230331145045.2251683-1-longman@redhat.com>
 <20230331145045.2251683-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680774266;
        bh=mH5FA82ZmBZCk3OyomF15pnwwOXhYUZvWscsCw1LcYU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cu2ZM7g4q/pBTzeZyybOsqrI1YACcXxFg+9Ssl85A9DaoaGBcMU3dF85fmPzAli5n
         7t/biEsqtZRFCn9qONpvQzPKoKF02/R/tH8i9Ho4Yo3ePolMpdN67xGvk9Ab4m/krQ
         psOvWpDwYDAQE3hgtEPegn3dq9Axd5XV5jFFP7nju/KQW2coFx9XVxgMG4zZOSZWhn
         GuKGE5XWZX4H7bDetPxbNtQ+pk8iRKcBcodIVnDm5ouDyM+2sIrGPfKCbiC1ryVI1l
         t05wme3n786TnyTs3UzlVsEldRzBFdSkjZ5h4D4D/eoyeeW6K3IZX70Ei4sKbmXirJ
         r5tHKmvmN6Jew==
Content-Disposition: inline
In-Reply-To: <20230331145045.2251683-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Fri, Mar 31, 2023 at 10:50:45AM -0400, Waiman Long wrote:
> The current cpuset code uses the global cpuset_attach_old_cs variable
> to store the old cpuset value between consecutive cpuset_can_attach()
> and cpuset_attach() calls. Since a caller of cpuset_can_attach() may
> not need to hold the global cgroup_threadgroup_rwsem, parallel cpuset
> attach operations are possible.
> 
> When there are concurrent cpuset attach operations in progress,
> cpuset_attach() may fetch the wrong value from cpuset_attach_old_cs
> causing incorrect result.  To avoid this problem while still allowing
> certain level of parallelism, drop cpuset_attach_old_cs and use a
> per-cpuset attach_old_cs value. Also restrict to at most one active
> attach operation per cpuset to avoid corrupting the value of the
> per-cpuset attach_old_cs value.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup/cpuset.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 2367de611c42..3f925c261513 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -198,6 +198,8 @@ struct cpuset {
>  
>  	/* Handle for cpuset.cpus.partition */
>  	struct cgroup_file partition_file;
> +
> +	struct cpuset *attach_old_cs;
>  };
>  
>  /*
> @@ -2456,22 +2458,27 @@ static int fmeter_getrate(struct fmeter *fmp)
>  	return val;
>  }
>  
> -static struct cpuset *cpuset_attach_old_cs;
> -
>  /* Called by cgroups to determine if a cpuset is usable; cpuset_rwsem held */
>  static int cpuset_can_attach(struct cgroup_taskset *tset)
>  {
>  	struct cgroup_subsys_state *css;
> -	struct cpuset *cs;
> +	struct cpuset *cs, *oldcs;
>  	struct task_struct *task;
>  	int ret;
>  
>  	/* used later by cpuset_attach() */
> -	cpuset_attach_old_cs = task_cs(cgroup_taskset_first(tset, &css));
> +	oldcs = task_cs(cgroup_taskset_first(tset, &css));
>  	cs = css_cs(css);
>  
>  	percpu_down_write(&cpuset_rwsem);
>  
> +	/*
> +	 * Only one cpuset attach operation is allowed for each cpuset.
> +	 */
> +	ret = -EBUSY;
> +	if (cs->attach_in_progress)
> +		goto out_unlock;

That'll mean CLONE_INTO_CGROUP becomes even more interestig because it
isn't subject to this restriction in contrast to fork()+migrate, right?
