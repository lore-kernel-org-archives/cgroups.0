From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [patch] mm, memcg: do not allow tasks to be attached with zero
 limit
Date: Fri, 9 Mar 2012 10:57:06 +0900
Message-ID: <20120309105706.4001646a.kamezawa.hiroyu@jp.fujitsu.com>
References: <alpine.DEB.2.00.1203071914150.15244@chino.kir.corp.google.com>
	<20120308122951.2988ec4e.akpm@linux-foundation.org>
	<20120309102255.bbf94164.kamezawa.hiroyu@jp.fujitsu.com>
	<20120308173818.ae5f621b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120308173818.ae5f621b.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, 8 Mar 2012 17:38:18 -0800
Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:

> On Fri, 9 Mar 2012 10:22:55 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> 
> > On Thu, 8 Mar 2012 12:29:51 -0800
> > Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > 
> > > On Wed, 7 Mar 2012 19:14:49 -0800 (PST)
> > > David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > 
> > > > This patch prevents tasks from being attached to a memcg if there is a
> > > > hard limit of zero.
> > > 
> > > We're talking about the memcg's limit_in_bytes here, yes?
> > > 
> > > > Additionally, the hard limit may not be changed to
> > > > zero if there are tasks attached.
> > > 
> > > hm, well...  why?  That would be user error, wouldn't it?  What is
> > > special about limit_in_bytes=0?  The memcg will also be unviable if
> > > limit_in_bytes=1, but we permit that.
> > > 
> > > IOW, confused.
> > > 
> > Ah, yes. limit_in_bytes < some small size can cause the same trouble.
> > Hmm... should we have configurable min_limit_in_bytes as sysctl or root memcg's
> > attaribute.. ?
> 
> Why do *anything*?  If the operator chose an irrational configuration
> then things won't work correctly and the operator will then fix the
> configuration?
> 

Because the result of 'error operaton' is SIGKILL to a task, which may be
owned by very importang customer of hosting service.

Isn't this severe punishment for error operation ?

Considering again, I have 2 thoughts.

- it should be guarded by MiddleWare, it's not kernel job !
- memcg should be more easy-to-use, friendly to users.

If the result is just an error as EINVAL or EBUSY, I may not be nervous....

Thanks,
-Kame 
