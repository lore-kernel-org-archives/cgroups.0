From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Mon, 25 Sep 2017 22:25:21 +0200
Message-ID: <20170925202442.lmcmvqwy2jj2tr5h@dhcp22.suse.cz>
References: <20170913215607.GA19259@castle>
 <20170914134014.wqemev2kgychv7m5@dhcp22.suse.cz>
 <20170914160548.GA30441@castle>
 <20170915105826.hq5afcu2ij7hevb4@dhcp22.suse.cz>
 <20170915152301.GA29379@castle>
 <20170918061405.pcrf5vauvul4c2nr@dhcp22.suse.cz>
 <20170920215341.GA5382@castle>
 <20170925122400.4e7jh5zmuzvbggpe@dhcp22.suse.cz>
 <20170925170004.GA22704@cmpxchg.org>
 <20170925181533.GA15918@castle>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170925181533.GA15918@castle>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 25-09-17 19:15:33, Roman Gushchin wrote:
[...]
> I'm not against this model, as I've said before. It feels logical,
> and will work fine in most cases.
> 
> In this case we can drop any mount/boot options, because it preserves
> the existing behavior in the default configuration. A big advantage.

I am not sure about this. We still need an opt-in, ragardless, because
selecting the largest process from the largest memcg != selecting the
largest task (just consider memcgs with many processes example).

> The only thing, I'm slightly concerned, that due to the way how we calculate
> the memory footprint for tasks and memory cgroups, we will have a number
> of weird edge cases. For instance, when putting a single process into
> the group_oom memcg will alter the oom_score significantly and result
> in significantly different chances to be killed. An obvious example will
> be a task with oom_score_adj set to any non-extreme (other than 0 and -1000)
> value, but it can also happen in case of constrained alloc, for instance.

I am not sure I understand. Are you talking about root memcg comparing
to other memcgs?
-- 
Michal Hocko
SUSE Labs
