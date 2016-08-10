From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH] cgroup_threadgroup_rwsem - affects scalability and
 OOM
Date: Wed, 10 Aug 2016 09:31:42 +0800
Message-ID: <57AA83FE.1050809@huawei.com>
References: <4717ef90-ca86-4a34-c63a-94b8b4bfaaec@gmail.com>
 <57A99BCB.6070905@huawei.com> <20160809135703.GA11823@350D>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160809135703.GA11823@350D>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

>> For example, I'm trying to fix a race. See https://lkml.org/lkml/2016/8/8/900
>>
>> And the fix kind of relies on the fact that cgroup_post_fork() is placed
>> inside the read section of cgroup_threadgroup_rwsem, so that cpuset_fork()
>> won't race with cgroup migration.
>>
> 
> My patch retains that behaviour, before ss->fork() is called we hold
> the cgroup_threadgroup_rwsem, in fact it is held prior to ss->can_fork()
> 

I read the patch again and now I see only threadgroup_change_begin() is moved
downwards, and threadgroup_change_end() remains intact. Then I have no problem
with it.

Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
