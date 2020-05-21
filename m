From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 21 May 2020 19:37:01 +0200
Message-ID: <20200521173701.GX6462@dhcp22.suse.cz>
References: <20200520143712.GA749486@chrisdown.name>
 <20200520160756.GE6462@dhcp22.suse.cz>
 <20200520165131.GB630613@cmpxchg.org>
 <20200520170430.GG6462@dhcp22.suse.cz>
 <20200520175135.GA793901@cmpxchg.org>
 <20200521073245.GI6462@dhcp22.suse.cz>
 <20200521135152.GA810429@cmpxchg.org>
 <20200521143515.GU6462@dhcp22.suse.cz>
 <20200521163833.GA813446@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200521163833.GA813446-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu 21-05-20 12:38:33, Johannes Weiner wrote:
> On Thu, May 21, 2020 at 04:35:15PM +0200, Michal Hocko wrote:
> > On Thu 21-05-20 09:51:52, Johannes Weiner wrote:
> > > On Thu, May 21, 2020 at 09:32:45AM +0200, Michal Hocko wrote:
> > [...]
> > > > I am not saying the looping over try_to_free_pages is wrong. I do care
> > > > about the final reclaim target. That shouldn't be arbitrary. We have
> > > > established a target which is proportional to the requested amount of
> > > > memory. And there is a good reason for that. If any task tries to
> > > > reclaim down to the high limit then this might lead to a large
> > > > unfairness when heavy producers piggy back on the active reclaimer(s).
> > > 
> > > Why is that different than any other form of reclaim?
> > 
> > Because the high limit reclaim is a best effort rather than must to
> > either get over reclaim watermarks and continue allocation or meet the
> > hard limit requirement to continue.
> 
> It's not best effort. It's a must-meet or get put to sleep. You are
> mistaken about what memory.high is.

I do not see anything like that being documented. Let me remind you what
the documentation says:
  memory.high
        A read-write single value file which exists on non-root
        cgroups.  The default is "max".

        Memory usage throttle limit.  This is the main mechanism to
        control memory usage of a cgroup.  If a cgroup's usage goes
        over the high boundary, the processes of the cgroup are
        throttled and put under heavy reclaim pressure.

        Going over the high limit never invokes the OOM killer and
        under extreme conditions the limit may be breached.

My understanding is that breaching the limit is acceptable if the memory
is not reclaimable after placing a heavy reclaim pressure. We can
discuss what the heavy reclaim means but the underlying fact is that the
keeping the consumption under the limit is a best effort.

Please also let me remind you that the best effort implementation has
been there since the beginning when the memory.high has been introduced.
Now you seem to be convinced that the semantic is _obviously_ different.

It is not the first time when the high limit behavior has changed.
Mostly based on "what is currently happening in your fleet". And can see
why it is reasonable to adopt to a real life usage. That is OK most of
the time. But I haven't heard why keeping the existing approach and
enforcing the reclaim target is not working properly so far. All I can
hear is a generic statement that consistency matters much more than all
potential problem it might introduce.

Anyway, I do see that you are not really willing to have a
non-confrontational discussion so I do not bother to reply to the rest
and participate in the further discussion.

As usual, let me remind you that I haven't nacked the patch. I do not
plan to do that because "this is not black&white" as already said. But
if your really want to push this through then let's do it properly at
least. memcg->memcg_nr_pages_over_high has only very vague meaning if
the reclaim target is the high limit. The changelog should be also
explicit about a potentially large stalls so that people debugging such
a problem have a clue at least.
-- 
Michal Hocko
SUSE Labs
