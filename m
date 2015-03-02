From: Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH 1/3] cpuset: initialize effective masks when clone_children
 is enabled
Date: Mon, 2 Mar 2015 14:16:35 +0800
Message-ID: <54F40043.9050201@huawei.com>
References: <54DD6D55.2070603@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54DD6D55.2070603@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Christian Brauner <christianvanbrauner@gmail.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, =?GB2312?B?U3SopnBoYW5lIEdyYWJlcg==?= <stgraber@ubuntu.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Hi Tejun,

Could you pick up those bug fixes? Or should I ask Ingo/akpm to take
care of them?

On 2015/2/13 11:19, Zefan Li wrote:
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
> 
