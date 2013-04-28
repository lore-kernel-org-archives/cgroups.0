From: Li Zhong <zhong@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpuset: fix compile warning when CONFIG_SMP=n
Date: Sun, 28 Apr 2013 10:01:02 +0800
Message-ID: <1367114462.6391.25.camel@ThinkPad-T5421.cn.ibm.com>
References: <517C7F91.2030705@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <517C7F91.2030705@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Fengguang Wu <fengguang.wu@intel.com>

On Sun, 2013-04-28 at 09:46 +0800, Li Zefan wrote:
> Reported by Fengguang's kbuild test robot:

Thank you for the quick fix, Zefan. 

Strong robot :)

Thanks, Zhong

> 
> kernel/cpuset.c:787: warning: 'generate_sched_domains' defined but not used
> 
> Introduced by commit e0e80a02e5701c8790bd348ab59edb154fbda60b
> ("cpuset: use rebuild_sched_domains() in cpuset_hotplug_workfn()),
> which removed generate_sched_domains() from cpuset_hotplug_workfn().
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>  kernel/cpuset.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index ef05901..2422c5b 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -789,13 +789,6 @@ out:
>  static void rebuild_sched_domains_locked(void)
>  {
>  }
> -
> -static int generate_sched_domains(cpumask_var_t **domains,
> -			struct sched_domain_attr **attributes)
> -{
> -	*domains = NULL;
> -	return 1;
> -}
>  #endif /* CONFIG_SMP */
> 
>  void rebuild_sched_domains(void)

