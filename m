From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2 4.19 0/3] Backport patches to fix threadgroup_rwsem
 <-> cpus_read_lock() deadlock
Date: Mon, 3 Apr 2023 15:30:51 +0200
Message-ID: <2023040343-dingbat-undermine-3b2d@gregkh>
References: <20230320011507.129441-1-caixinchen1@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680528653;
        bh=gkl9GJzTmsB5rcAcfYLEeF2AGlRRvqNK46WjzttEC+Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y4heVgHxnHHk+SR9DYW1yfI1s8uJMUtEql8IsErHkwN1QcZvm9puL+Hl/9ZV53BUk
         cE3mH8laTXfuRBwINC4vjQHrNcbwzi6IFO+1bmRSNc9blc9TsGYZRknRJj1g+VuEtf
         V2/EXiWZVsxSsaQyDDBHAl+1vxspuWjraNrsv5Qs=
Content-Disposition: inline
In-Reply-To: <20230320011507.129441-1-caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cai Xinchen <caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 20, 2023 at 01:15:04AM +0000, Cai Xinchen wrote:
> I am very sorry. My gcc version is 7.5 and it does not report error.
> 
> We have a deadlock problem which can be solved by commit 4f7e7236435ca
> ("cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock").
> However, it makes lock order of cpus_read_lock and cpuset_mutex
> wrong in v4.19. The call sequence is as follows:
> cgroup_procs_write()
>         cgroup_procs_write_start()
>                 get_online_cpus(); // cpus_read_lock()
>                 percpu_down_write(&cgroup_threadgroup_rwsem)
>         cgroup_attach_task
>                 cgroup_migrate
>                         cgroup_migrate_execute
>                                 ss->attach (cpust_attach)
>                                         mutex_lock(&cpuset_mutex)
> it seems hard to make cpus_read_lock is locked before
> cgroup_threadgroup_rwsem and cpuset_mutex is locked before
> cpus_read_lock unless backport the commit d74b27d63a8beb
> ("cgroup/cpuset: Change cpuset_rwsem and hotplug lock order")
> 
> Changes in v2:
>         * Add #include <linux/cpu.h> in kernel/cgroup/cgroup.c to
>          avoid some compile error.
>         * Exchange get_online_cpus() location in cpuset_attach to
>          keep cpu_hotplug_lock->cpuset_mutex order, although it will
>           be remove by ("cgroup: Fix threadgroup_rwsem <->
>          cpus_read_lock() deadlock")
> 
> Juri Lelli (1):
>   cgroup/cpuset: Change cpuset_rwsem and hotplug lock order
> 
> Tejun Heo (1):
>   cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock
> 
> Tetsuo Handa (1):
>   cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()
> 
>  include/linux/cpuset.h    |  8 +++----
>  kernel/cgroup/cgroup-v1.c |  3 +++
>  kernel/cgroup/cgroup.c    | 50 +++++++++++++++++++++++++++++++++++----
>  kernel/cgroup/cpuset.c    | 25 ++++++++++++--------
>  4 files changed, 67 insertions(+), 19 deletions(-)

Now queued up, thanks.

greg k-h
