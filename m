From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] oom_kill: add option to disable dump_stack()
Date: Tue, 1 Dec 2015 16:02:54 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1512011602170.15908@chino.kir.corp.google.com>
References: <1445634150-27992-1-git-send-email-arozansk@redhat.com> <20151201154353.87e2200b5cd1a99289ce6653@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=wtRU32gV14l/2zcEK86sKFXEWUhtCGvyd1/mOI68qPo=;
        b=dN9C1+jN/DkKBC+pT/V9uLd9xvOsUKOokRL2Z9kVwjd6X+z+e0ySP5yvcEfRUxDZE1
         t6R8UjUmG7g62/DgP/yAsC6Mx1b0CZt2n+FeWtWggvJi+LfZmXrBPqAHYxeKBhkj9TQV
         +cMPkIda2TcV7Habqv9pRPKrNZawmaiNpCuiTvcHEJF9oy5CFC+8aX29pcbm8uvwdJ9x
         8n+lq7jBLhz6uaGwmju9bhdm7uH7rXlzyckdxH4diPJgxOT/wjt2zLU9HT3RNpDxmj17
         yy6qTcMkPQBGr3EK3qkWZgZiclCD+IUFcqTQ0O3YQ5YgcjLQH1pQ64uGM69N4Qpl6lgf
         BEzg==
In-Reply-To: <20151201154353.87e2200b5cd1a99289ce6653-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 1 Dec 2015, Andrew Morton wrote:

> > --- a/include/linux/oom.h
> > +++ b/include/linux/oom.h
> > @@ -115,6 +115,7 @@ static inline bool task_will_free_mem(struct task_struct *task)
> >  
> >  /* sysctls */
> >  extern int sysctl_oom_dump_tasks;
> > +extern int sysctl_oom_dump_stack;
> >  extern int sysctl_oom_kill_allocating_task;
> >  extern int sysctl_panic_on_oom;
> >  #endif /* _INCLUDE_LINUX_OOM_H */
> > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > index e69201d..c812523 100644
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -1176,6 +1176,13 @@ static struct ctl_table vm_table[] = {
> >  		.proc_handler	= proc_dointvec,
> >  	},
> >  	{
> > +		.procname	= "oom_dump_stack",
> > +		.data		= &sysctl_oom_dump_stack,
> > +		.maxlen		= sizeof(sysctl_oom_dump_stack),
> > +		.mode		= 0644,
> > +		.proc_handler	= proc_dointvec,
> > +	},
> > +	{
> >  		.procname	= "overcommit_ratio",
> >  		.data		= &sysctl_overcommit_ratio,
> >  		.maxlen		= sizeof(sysctl_overcommit_ratio),
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 1ecc0bc..bdbf83b 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -42,6 +42,7 @@
> >  int sysctl_panic_on_oom;
> >  int sysctl_oom_kill_allocating_task;
> >  int sysctl_oom_dump_tasks = 1;
> > +int sysctl_oom_dump_stack = 1;
> >  
> >  DEFINE_MUTEX(oom_lock);
> >  
> > @@ -384,7 +385,8 @@ static void dump_header(struct oom_control *oc, struct task_struct *p,
> >  		current->signal->oom_score_adj);
> >  	cpuset_print_task_mems_allowed(current);
> >  	task_unlock(current);
> > -	dump_stack();
> > +	if (sysctl_oom_dump_stack)
> > +		dump_stack();
> >  	if (memcg)
> >  		mem_cgroup_print_oom_info(memcg, p);
> >  	else
> 
> The patch seems reasonable to me, but it's missing the required update
> to Documentation/sysctl/vm.txt.
> 

Not sure why we'd want yet-another-sysctl for something that can trivially 
filtered from the log, but owell.
