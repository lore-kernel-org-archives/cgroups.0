From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Fix a race between cpuset_attach() and
 cpu hotplug
Date: Mon, 14 Feb 2022 09:50:39 -1000
Message-ID: <Ygqyj7nns+mxH81t@slm.duckdns.org>
References: <20220121101210.84926-1-zhangqiao22@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8eI79aPTVtqYQhM0bTcpnqJ4UdG4+AWyiT8hNcdyv7Q=;
        b=ZSV4ZqXKji33uFcHmgvE05zjLOm9kEVHG6oWJ7eZKZPZ4kZ2nggGrMqLqKlPL34Ek1
         /u/NM4futt7QdWUDzgYKzfBFqB3ZZBZkwOMzOMhGC7cko+Qztmw8XHcfcb0gNwQq8MkU
         7507ocXVBAmsp48WPhA5XpPf/bn2aWqzt0WtH8bdY9cWxbZexhWBaUs3sZd0U5bp1e3T
         ruHrM+VNwVpvBmLdyRZvIgDd/7i3XcHwZsLkaOtpINL3arjnaQdH3B8XpxaFk+Fyctd1
         shUZRC0TnpWCQftQMjh+GxGmupgih3F576KJYbNUbrq4yUWvlv3OvixikVZXYjiUMish
         slvw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220121101210.84926-1-zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, bblum-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, zhaogongyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Fri, Jan 21, 2022 at 06:12:10PM +0800, Zhang Qiao wrote:
> As previously discussed(https://lkml.org/lkml/2022/1/20/51),
> cpuset_attach() is affected with similar cpu hotplug race,
> as follow scenario:
> 
>      cpuset_attach()				cpu hotplug
>     ---------------------------            ----------------------
>     down_write(cpuset_rwsem)
>     guarantee_online_cpus() // (load cpus_attach)
> 					sched_cpu_deactivate
> 					  set_cpu_active()
> 					  // will change cpu_active_mask
>     set_cpus_allowed_ptr(cpus_attach)
>       __set_cpus_allowed_ptr_locked()
>        // (if the intersection of cpus_attach and
>          cpu_active_mask is empty, will return -EINVAL)
>     up_write(cpuset_rwsem)
> 
> To avoid races such as described above, protect cpuset_attach() call
> with cpu_hotplug_lock.
> 
> Fixes: be367d099270 ("cgroups: let ss->can_attach and ss->attach do whole threadgroups at a time")
> Reported-by: Zhao Gongyi <zhaogongyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-5.17-fixes w/ stable cc'd.

Thanks and sorry about the delay.

-- 
tejun
