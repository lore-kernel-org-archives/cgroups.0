From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: Re: [PATCH] cgroup: remove for_each_e_css
Date: Tue, 14 Jan 2020 21:04:45 +0800
Message-ID: <285c371f-da93-1bf1-4ace-5a74bb08ca5b@hisilicon.com>
References: <1579003772-46038-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1579003772-46038-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

https://spinics.net/lists/cgroups/msg23131.html

Thanks,

On 2020/1/14 20:09, Alex Shi wrote:
> After commit 37ff9f8f4742 ("cgroup: make cgroup[_taskset]_migrate()
> take cgroup_r', No one use this macro.
> So it'e better to remove.
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: cgroups@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  kernel/cgroup/cgroup.c | 15 ---------------
>  1 file changed, 15 deletions(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 735af8f15f95..7d916ad33e59 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -663,21 +663,6 @@ struct cgroup_subsys_state *of_css(struct kernfs_open_file *of)
>  		else
>  
>  /**
> - * for_each_e_css - iterate all effective css's of a cgroup
> - * @css: the iteration cursor
> - * @ssid: the index of the subsystem, CGROUP_SUBSYS_COUNT after reaching the end
> - * @cgrp: the target cgroup to iterate css's of
> - *
> - * Should be called under cgroup_[tree_]mutex.
> - */
> -#define for_each_e_css(css, ssid, cgrp)					    \
> -	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT; (ssid)++)	    \
> -		if (!((css) = cgroup_e_css_by_mask(cgrp,		    \
> -						   cgroup_subsys[(ssid)]))) \
> -			;						    \
> -		else
> -
> -/**
>   * do_each_subsys_mask - filter for_each_subsys with a bitmask
>   * @ss: the iteration cursor
>   * @ssid: the index of @ss, CGROUP_SUBSYS_COUNT after reaching the end
> 

