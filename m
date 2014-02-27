From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cpuset: fix a locking issue in cpuset_migrate_mm()
Date: Thu, 27 Feb 2014 18:29:38 +0800
Message-ID: <530F1392.2090407@huawei.com>
References: <530F1117.1020605@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <530F1117.1020605-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014/2/27 18:19, Li Zefan wrote:
> I can trigger a lockdep warning:
> 
>   # mount -t cgroup -o cpuset xxx /cgroup
>   # mkdir /cgroup/cpuset
>   # mkdir /cgroup/tmp
>   # echo 0 > /cgroup/tmp/cpuset.cpus
>   # echo 0 > /cgroup/tmp/cpuset.mems
>   # echo 1 > /cgroup/tmp/cpuset.memory_migrate
>   # echo $$ > /cgroup/tmp/tasks
>   # echo 1 > /cgruop/tmp/cpuset.mems
> 
>   ===============================
>   [ INFO: suspicious RCU usage. ]
>   3.14.0-rc1-0.1-default+ #32 Not tainted
>   -------------------------------
>   include/linux/cgroup.h:682 suspicious rcu_dereference_check() usage!
>   ...
>     [<ffffffff81582174>] dump_stack+0x72/0x86
>     [<ffffffff810b8f01>] lockdep_rcu_suspicious+0x101/0x140
>     [<ffffffff81105ba1>] cpuset_migrate_mm+0xb1/0xe0
>   ...
> 
> We used to hold cgroup_mutex when calling cpuset_migrate_mm(), but now
> we hold cpuset_mutex, which causes task_css() to complain.
> 
> This is not a false-positive but a real issue.
> 
> Holding cpuset_mutex won't prevent a task's cpuset from changing, and

I meant it won't prevent a task from migrating to another cpuset.

> it won't prevent the original task->cgroup from destroying during this
> change.

