From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RESEND v12 0/6] cgroup-aware OOM killer
Date: Mon, 23 Oct 2017 13:49:48 +0200
Message-ID: <20171023114948.qzmo7emqbigfff7h@dhcp22.suse.cz>
References: <20171019185218.12663-1-guro@fb.com>
 <20171019194534.GA5502@cmpxchg.org>
 <alpine.DEB.2.10.1710221715010.70210@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1710221715010.70210-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Sun 22-10-17 17:24:51, David Rientjes wrote:
> On Thu, 19 Oct 2017, Johannes Weiner wrote:
> 
> > David would have really liked for this patchset to include knobs to
> > influence how the algorithm picks cgroup victims. The rest of us
> > agreed that this is beyond the scope of these patches, that the
> > patches don't need it to be useful, and that there is nothing
> > preventing anyone from adding configurability later on. David
> > subsequently nacked the series as he considers it incomplete. Neither
> > Michal nor I see technical merit in David's nack.
> > 
> 
> The nack is for three reasons:
> 
>  (1) unfair comparison of root mem cgroup usage to bias against that mem 
>      cgroup from oom kill in system oom conditions,

Most users who are going to use this feature right now will have
most of the userspace in their containers rather than in the root
memcg. The root memcg will always be special and as such there will
never be a universal best way to handle it. We should to satisfy most of
usecases. I would consider this something that is an open for a further
discussion but nothing that should stand in the way.
 
>  (2) the ability of users to completely evade the oom killer by attaching
>      all processes to child cgroups either purposefully or unpurposefully,
>      and

This doesn't differ from the current state where a task can purposefully
or unpurposefully hide itself from the global memory killer by spawning
new processes.
 
>  (3) the inability of userspace to effectively control oom victim  
>      selection.

this is not requested by the current usecase and it has been pointed out
that this will be possible to implement on top of the foundation of this
patchset.

So again, nothing to nack the work as is.
-- 
Michal Hocko
SUSE Labs
