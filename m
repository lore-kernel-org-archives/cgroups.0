From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RESEND v12 0/6] cgroup-aware OOM killer
Date: Tue, 31 Oct 2017 08:54:08 +0100
Message-ID: <20171031075408.67au22uk6dkpu7vv@dhcp22.suse.cz>
References: <20171019185218.12663-1-guro@fb.com>
 <20171019194534.GA5502@cmpxchg.org>
 <alpine.DEB.2.10.1710221715010.70210@chino.kir.corp.google.com>
 <20171026142445.GA21147@cmpxchg.org>
 <alpine.DEB.2.10.1710261359550.75887@chino.kir.corp.google.com>
 <20171027093107.GA29492@castle.dhcp.TheFacebook.com>
 <alpine.DEB.2.10.1710301430170.105449@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1710301430170.105449-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 30-10-17 14:36:39, David Rientjes wrote:
> On Fri, 27 Oct 2017, Roman Gushchin wrote:
> 
> > The thing is that the hierarchical approach (as in v8), which are you pushing,
> > has it's own limitations, which we've discussed in details earlier. There are
> > reasons why v12 is different, and we can't really simple go back. I mean if
> > there are better ideas how to resolve concerns raised in discussions around v8,
> > let me know, but ignoring them is not an option.
> > 
> 
> I'm not ignoring them, I have stated that we need the ability to protect 
> important cgroups on the system without oom disabling all attached 
> processes.  If that is implemented as a memory.oom_score_adj with the same 
> semantics as /proc/pid/oom_score_adj, i.e. a proportion of available 
> memory (the limit), it can also address the issues pointed out with the 
> hierarchical approach in v8.

No it cannot and it would be a terrible interface to have as well. You
do not want to permanently tune oom_score_adj to compensate for
structural restrictions on the hierarchy.

> If this is not the case, could you elaborate 
> on what your exact concern is and why we do not care that users can 
> completely circumvent victim selection by creating child cgroups for other 
> controllers?
> 
> Since the ability to protect important cgroups on the system may require a 
> heuristic change, I think it should be solved now rather than constantly 
> insisting that we can make this patchset complete later and in the 
> meantime force the user to set all attached processes to be oom disabled.

I believe, and Roman has pointed that out as well already, that further
improvements can be implemented without changing user visible behavior
as and add-on. If you disagree then you better come with a solid proof
that all of us wrong and reasonable semantic cannot be achieved that
way.
-- 
Michal Hocko
SUSE Labs
