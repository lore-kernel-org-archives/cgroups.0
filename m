From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v7 5/5] mm, oom: cgroup v2 mount option to disable cgroup-aware
 OOM killer
Date: Wed, 6 Sep 2017 13:59:42 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709061355001.70553@chino.kir.corp.google.com>
References: <20170904142108.7165-1-guro@fb.com> <20170904142108.7165-6-guro@fb.com> <20170905134412.qdvqcfhvbdzmarna@dhcp22.suse.cz> <20170905143021.GA28599@castle.dhcp.TheFacebook.com> <20170905151251.luh4wogjd3msfqgf@dhcp22.suse.cz>
 <20170905191609.GA19687@castle.dhcp.TheFacebook.com> <20170906084242.l4rcx6n3hdzxvil6@dhcp22.suse.cz> <20170906174043.GA12579@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=cCR4MaPURrTKLtfb0JDW5fvWRfCgM2qwd17iPnK3Da4=;
        b=MaPtF9kPITV41g1OAekMvQ+uo2YwHOzhy0mUIM/nk7z5gqsa9b2sEAUvqCBe0iotGi
         2wbL9kMeI8O2IdqrBsphZLFWZUlPxx1LUeH0WwEdOWLXFA6a8A8x2l63R/7amXI2Dap9
         JJTKcUxQ2+2Gg1BD1gCaDUsKSUdJILVbqzJ0G6qWz66ukeFdnsAQf+5cD20c1hU1PoWH
         4mIN0vlBDoOqC5vilAQi9rBOm/5+wFWhv34D3jvAj3ga33k0dvetBBkYooS1CTsxv6bK
         LmC01i9Cjm4WXp0LRn3gC/GIV/UCfwjWPWE7g3mu3jesCTPssQp7uyevmPV9qnRjAwGv
         CemQ==
In-Reply-To: <20170906174043.GA12579-B3w7+ongkCiLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, nzimmer-sJ/iWh9BUns@public.gmane.org, holt-sJ/iWh9BUns@public.gmane.org
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 6 Sep 2017, Roman Gushchin wrote:

> From f6e2339926a07500834d86548f3f116af7335d71 Mon Sep 17 00:00:00 2001
> From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Date: Wed, 6 Sep 2017 17:43:44 +0100
> Subject: [PATCH] mm, oom: first step towards oom_kill_allocating_task
>  deprecation
> 
> The oom_kill_allocating_task sysctl which causes the OOM killer
> to simple kill the allocating task is useless. Killing the random
> task is not the best idea.
> 
> Nobody likes it, and hopefully nobody uses it.
> We want to completely deprecate it at some point.
> 

SGI required it when it was introduced simply to avoid the very expensive 
tasklist scan.  Adding Christoph Lameter to the cc since he was involved 
back then.

I attempted to deprecate the old /proc/pid/oom_adj in this same manner; we 
warned about it for over a year and then finally removed it, one person 
complained of breakage, and it was reverted with a strict policy that 
Linux doesn't break userspace.

Although it would be good to do, I'm not sure that this is possible unless 
it can be shown nobody is using it.  Talking to SGI would be the first 
step.

I'm not sure what this has to do with the overall patchset though :)

> To make a first step towards deprecation, let's warn potential
> users about deprecation plans.
> 
> Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  kernel/sysctl.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 655686d546cb..9158f1980584 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -220,6 +220,17 @@ static int sysrq_sysctl_handler(struct ctl_table *table, int write,
>  
>  #endif
>  
> +static int proc_oom_kill_allocating_tasks(struct ctl_table *table, int write,
> +				   void __user *buffer, size_t *lenp,
> +				   loff_t *ppos)
> +{
> +	pr_warn_once("The oom_kill_allocating_task sysctl will be deprecated.\n"
> +		     "If you're using it, please, report to "
> +		     "linux-mm-Ja57EE8LTNBzeIdxy0IIJ+G/Ez6ZCGd0@public.gmane.org\n");
> +
> +	return proc_dointvec(table, write, buffer, lenp, ppos);
> +}
> +
>  static struct ctl_table kern_table[];
>  static struct ctl_table vm_table[];
>  static struct ctl_table fs_table[];
> @@ -1235,7 +1246,7 @@ static struct ctl_table vm_table[] = {
>  		.data		= &sysctl_oom_kill_allocating_task,
>  		.maxlen		= sizeof(sysctl_oom_kill_allocating_task),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec,
> +		.proc_handler	= proc_oom_kill_allocating_tasks,
>  	},
>  	{
>  		.procname	= "oom_dump_tasks",
