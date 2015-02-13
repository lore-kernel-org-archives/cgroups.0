From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 1/3] cpuset: initialize effective masks when
 clone_children is enabled
Date: Fri, 13 Feb 2015 07:19:02 +0100
Message-ID: <20150213061902.GA26332@mail.hallyn.com>
References: <54DD6D55.2070603@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54DD6D55.2070603@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Christian Brauner <christianvanbrauner@gmail.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Quoting Zefan Li (lizefan@huawei.com):
> If clone_children is enabled, effective masks won't be initialized
> due to the bug:
> 
>   # mount -t cgroup -o cpuset xxx /mnt
>   # echo 1 > cgroup.clone_children
>   # mkdir /mnt/tmp
>   # cat /mnt/tmp/
>   # cat cpuset.effective_cpus
> 
>   # cat cpuset.cpus
>   0-15
> 
> And then this cpuset won't constrain the tasks in it.
> 
> Either the bug or the fix has no effect on unified hierarchy, as
> there's no clone_chidren flag there any more.
> 
> Reported-by: Christian Brauner <christianvanbrauner@gmail.com>
> Reported-by: Serge Hallyn <serge.hallyn@ubuntu.com>

Thanks - this give sme the correct output in /proc/self/status and
cpuest.cpus.  (I didn't do a stress test but that seems unlikely to
be broken)

Tested-by: Serge Hallyn <serge.hallyn@canonical.com>

> Cc: <stable@vger.kernel.org> # 3.17+
> Signed-off-by: Zefan Li <lizefan@huawei.com>
> ---
>  kernel/cpuset.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 64b257f..7e9d711 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1992,7 +1992,9 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
>  
>  	spin_lock_irq(&callback_lock);
>  	cs->mems_allowed = parent->mems_allowed;
> +	cs->effective_mems = parent->mems_allowed;
>  	cpumask_copy(cs->cpus_allowed, parent->cpus_allowed);
> +	cpumask_copy(cs->effective_cpus, parent->cpus_allowed);
>  	spin_unlock_irq(&callback_lock);
>  out_unlock:
>  	mutex_unlock(&cpuset_mutex);
> -- 
> 1.8.0.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
