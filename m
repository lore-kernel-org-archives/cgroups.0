From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH -next] cpuset: initialize cpuset a bit early
Date: Wed, 4 Mar 2015 13:40:27 +0300
Message-ID: <20150304104027.GC18131@esperanza>
References: <54F6CBCD.50009@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54F6CBCD.50009-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Mar 04, 2015 at 05:09:33PM +0800, Zefan Li wrote:
> Now we call ss->bind() in cgroup_init(), so cgroup_init() will
> call cpuset_bind() and then the latter will access top_cpuset's
> cpumask, which is NULL, because cpuset_init() is called after
> cgroup_init()
> 
> The simplest fix is to swap cgroup_init() and cpuset_init().
> 
> Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Fixes: 295458e67284 ("cgroup: call cgroup_subsys->bind on cgroup subsys initialization")
> Reported by: Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Thanks!
