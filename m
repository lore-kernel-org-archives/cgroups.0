From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 6/6] zswap: memcg accounting
Date: Mon, 16 May 2022 16:34:59 +0200
Message-ID: <20220516143459.GA17557@blackbody.suse.cz>
References: <20220510152847.230957-1-hannes@cmpxchg.org>
 <20220510152847.230957-7-hannes@cmpxchg.org>
 <20220511173218.GB31592@blackbody.suse.cz>
 <YnwJUL90fuoHs3YW@cmpxchg.org>
 <20220513151426.GC16096@blackbody.suse.cz>
 <Yn6QfdouzkcrygTR@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652711700; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W7ceyTjxid5l9ZGGTqZ+wt/EPfbFdKSX+/F4lyNdDKg=;
        b=g3iVVHUtSyQWBN3Y59HjcBDj1p/IZFTO1o2s8CWmnszg6wBpymi4LOQIZAcNlK/seWQfW5
        OTdSKo9VL5YnbQyO5U7Jfrl+JZ6OG/lh8V2pkehTwaRN9l9VeiSd8KtqESYl+sNjIGZ0wr
        /r1jDJWacCJhVoSdrQMTgwD1CqqpyIo=
Content-Disposition: inline
In-Reply-To: <Yn6QfdouzkcrygTR-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, May 13, 2022 at 01:08:13PM -0400, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> Right, it's accounted as a subset rather than fully disjointed. But it
> is a limitable counter of its own, so I exported it as such, with a
> current and a max knob. This is comparable to the kmem counter in v1.

That counter and limit didn't turn out well. I liked the analogy to
writeback (and dirty limit) better.

> From an API POV it would be quite strange to have max for a counter
> that has no current. Likewise it would be strange for a major memory
> consumer to be missing from memory.stat.

My understanding would be to have all memory.stat entries as you
propose, no extra .current counter and the .max knob for zswap
configuration.

> It needs to be configured to the workload's access frequency curve,
> which can be done with trial-and-error (reasonable balance between
> zswpins and pswpins) or in a more targeted manner using tools such as
> page_idle, damon etc.
> [...]
> Because for load tuning, bytes make much more sense. That's how you
> measure the workingset, so a percentage is an awkward indirection. At
> the cgroup level, it makes even less sense: all memcg tunables are in
> bytes, it would be quite weird to introduce a "max" that is 0-100. Add
> the confusion of how percentages would propagate down the hierarchy...

Thanks for the explanation. I guess there's no simple tranformation of
in-kernel available information that'd allow a more semantic
configuration of this value. The rather crude absolute value requires
(but also simply allows) some calibration or responsive tuning.

> I don't traverse all ancestors, I bail on disabled groups and skip
> unlimited ones.

I admit I missed that.

> Flushing unnecessary groups with a ratelimit doesn't sound like an
> improvement to me.

Then I'm only concerned about a situation when there's a single deep
memcg that undergoes both workingset_refault() and zswap querying.
The latter (bare call to cgroup_rstat_flush()) won't reset
stats_flush_threshold, so the former (or the async flush more likely)
would attempt a flush too. The flush work (on the leaf memcg) would be
done twice even though it may be within the tolerance of cumulated
error the second time.

This is a thing that might require attention in the future (depending on
some data how it actually performs). I see how the current approach is
justified.


Regards,
Michal
