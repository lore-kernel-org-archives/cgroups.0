From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.19 0/3] Backport patches to fix threadgroup_rwsem <->
 cpus_read_lock() deadlock
Date: Wed, 15 Mar 2023 09:30:10 +0100
Message-ID: <ZBGCEgB7wEe0pCNk@kroah.com>
References: <20230303045050.139985-1-caixinchen1@huawei.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678869019;
        bh=hE3fyUKCNJmb98hi99Yf0nUKlq4P8XUaLti7/cHlkAo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WPz9bRlf9fJg6WWMO2QCT6ZiS+HD6KIaORlrD5kSzQHVsUyDsHDVCUkyChJRzcW53
         aiDdOSHkhfGaBKm3fV5Um97lcnuBwe6OysqlsaXKUEYChQDH6whtwEE6l7HmhsE489
         O7eszhammUP47bNxQ8lDeHipaWXJdrraqC8aA1JY=
Content-Disposition: inline
In-Reply-To: <20230303045050.139985-1-caixinchen1@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cai Xinchen <caixinchen1@huawei.com>
Cc: longman@redhat.com, lizefan.x@bytedance.com, tj@kernel.org, hannes@cmpxchg.org, sashal@kernel.org, mkoutny@suse.com, zhangqiao22@huawei.com, juri.lelli@redhat.com, penguin-kernel@i-love.sakura.ne.jp, stable@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Mar 03, 2023 at 04:50:47AM +0000, Cai Xinchen wrote:
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
> 
> it seems hard to make cpus_read_lock is locked before
> cgroup_threadgroup_rwsem and cpuset_mutex is locked before
> cpus_read_lock unless backport the commit d74b27d63a8beb
> ("cgroup/cpuset: Change cpuset_rwsem and hotplug lock order")
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
>  kernel/cgroup/cgroup.c    | 49 +++++++++++++++++++++++++++++++++++----
>  kernel/cgroup/cpuset.c    | 25 ++++++++++++--------
>  4 files changed, 66 insertions(+), 19 deletions(-)
> 
> -- 
> 2.17.1
> 

Now queued up, thanks.

greg k-h
