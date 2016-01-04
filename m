From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: make /proc/cgroups aligned
Date: Mon, 4 Jan 2016 09:16:42 +0800
Message-ID: <5689C7FA.9000502@huawei.com>
References: <e814e0db26aa5a3662c1e98dc1410c6b3e9a4c12.1451837184.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e814e0db26aa5a3662c1e98dc1410c6b3e9a4c12.1451837184.git.geliangtang-9Onoh4P/yGk@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2016/1/4 0:08, Geliang Tang wrote:
> This patch makes /proc/cgroups aligned like this:
> $ cat /proc/cgroups
> #subsys_name    hierarchy       num_cgroups     enabled
>        cpuset           11                 1           1
>           cpu            2                 1           1
>       cpuacct            2                 1           1
>         blkio           12                 1           1
>        memory            3                 1           1
>       devices            4                83           1
>       freezer           10                 1           1
>    perf_event            9                 1           1
>       hugetlb            7                 1           1
>     intel_rdt            6                 1           1
>          pids            8                 1           1
>         debug            5                 1           1
>
> Signed-off-by: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>

This change is not acceptable because it may break userspace.

> ---
>   kernel/cgroup.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index f1603c1..063b28f 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -5411,7 +5411,7 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
>   	mutex_lock(&cgroup_mutex);
>
>   	for_each_subsys(ss, i)
> -		seq_printf(m, "%s\t%d\t%d\t%d\n",
> +		seq_printf(m, "%12s\t%9d\t%11d\t%7d\n",
>   			   ss->legacy_name, ss->root->hierarchy_id,
>   			   atomic_read(&ss->root->nr_cgrps),
>   			   cgroup_ssid_enabled(i));
>
