From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm v2 3/3] mm: automatically penalize tasks with high
 swap use
Date: Wed, 13 May 2020 10:32:49 +0200
Message-ID: <20200513083249.GS29153@dhcp22.suse.cz>
References: <20200511225516.2431921-1-kuba@kernel.org>
 <20200511225516.2431921-4-kuba@kernel.org>
 <20200512072634.GP29153@dhcp22.suse.cz>
 <20200512105536.748da94e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200512105536.748da94e-CbGlpYbfshD2+ikPA6JUzH8MC5kE+Go+7OQnqPW8cmTNHmdVIy2bbWItS4zQEDct@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Tue 12-05-20 10:55:36, Jakub Kicinski wrote:
> On Tue, 12 May 2020 09:26:34 +0200 Michal Hocko wrote:
> > On Mon 11-05-20 15:55:16, Jakub Kicinski wrote:
> > > Use swap.high when deciding if swap is full.  
> > 
> > Please be more specific why.
> 
> How about:
> 
>     Use swap.high when deciding if swap is full to influence ongoing
>     swap reclaim in a best effort manner.

This is still way too vague. The crux is why should we treat hard and
high swap limit the same for mem_cgroup_swap_full purpose. Please note
that I am not saying this is wrong. I am asking for a more detailed
explanation mostly because I would bet that somebody stumbles over this
sooner or later.

mem_cgroup_swap_full is an odd predicate. It doesn't really want to tell
that the swap is really full. I haven't studied the original intention
but it is more in line of mem_cgroup_swap_under_pressure based on the
current usage to (attempt) scale swap cache size.

> > > Perform reclaim and count memory over high events.  
> > 
> > Please expand on this and explain how this is working and why the
> > semantic is subtly different from MEMCG_HIGH. I suspect the reason
> > is that there is no reclaim for the swap so you are only emitting an
> > event on the memcg which is actually throttled. This is in line with
> > memory.high but the difference is that we do reclaim each memcg subtree
> > in the high limit excess. That means that the counter tells us how many
> > times the specific memcg was in excess which would be impossible with
> > your implementation.
> 
> Right, with memory all cgroups over high get penalized with the extra
> reclaim work. For swap we just have the delay, so the event is
> associated with the worst offender, anything lower didn't really matter.
> 
> But it's easy enough to change if you prefer. Otherwise I'll just add
> this to the commit message:
> 
>   Count swap over high events. Note that unlike memory over high events
>   we only count them for the worst offender. This is because the
>   delay penalties for both swap and memory over high are not cumulative,
>   i.e. we use the max delay.

Well, memory high penalty is in fact cumulative, because the reclaim
would happen for each memcg subtree up the hierarchy. Sure the
additional throttling is not cumulative but that is not really that
important because the exact amount of throttling is an implementation detail.
The swap high is an odd one here because we do not reclaim swap so the
cumulative effect of that is 0 and there is only the additional
throttling happening. I suspect that your current implementation is
exposing an internal implementation to the userspace but considering how
the current memory high event is documented
          high
                The number of times processes of the cgroup are
                throttled and routed to perform direct memory reclaim
                because the high memory boundary was exceeded.  For a
                cgroup whose memory usage is capped by the high limit
                rather than global memory pressure, this event's
                occurrences are expected.

it talks about throttling rather than excess (like max) so I am not
really sure. I believe that it would be much better if both events were
more explicit about counting an excess and a throttling is just a side
effect of that situation.

I do not expect that we will have any form of the swap reclaim anytime
soon (if ever) but I fail to see why to creat a small little trap like
this now.

> > I would also suggest to explain or ideally even separate the swap
> > penalty scaling logic to a seprate patch. What kind of data it is based
> > on?
> 
> It's a hard thing to get production data for since, as we mentioned we
> don't expect the limit to be hit. It was more of a process of
> experimentation and finding a gradual slope that "felt right"...
> 
> Is there a more scientific process we can follow here? We want the
> delay to be small at first for a first few pages and then grow to make
> sure we stop the task from going too much over high. The square
> function works pretty well IMHO.

If there is no data to showing this to be an improvement then I would
just not add an additional scaling factor. Why? Mostly because once we
have it there it would be extremely hard to change. MM is full of these
little heuristics that are copied over because nobody dares to touch
them. If a different scaling is really needed it can always be added
later with some data to back that.

-- 
Michal Hocko
SUSE Labs
