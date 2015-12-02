From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] oom_kill: add option to disable dump_stack()
Date: Wed, 2 Dec 2015 09:18:43 +0100
Message-ID: <20151202081842.GA25284@dhcp22.suse.cz>
References: <1445634150-27992-1-git-send-email-arozansk@redhat.com>
 <20151201154353.87e2200b5cd1a99289ce6653@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151201154353.87e2200b5cd1a99289ce6653-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 01-12-15 15:43:53, Andrew Morton wrote:
[...]
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

I thought we have agreed to go via KERN_DEBUG log level for the
backtrace. Aristeu has posted a patch for that already.
-- 
Michal Hocko
SUSE Labs
