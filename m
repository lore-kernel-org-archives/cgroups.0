From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: prevent starvation when writing
 memory.high
Date: Tue, 12 Jan 2021 14:45:43 -0500
Message-ID: <X/38ZwyOE96SAfa9@cmpxchg.org>
References: <20210112163011.127833-1-hannes@cmpxchg.org>
 <20210112170322.GA99586@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uREbXCwcyfpXNTx7ee7MudJLRW7UlYdjL+1cYZJdpQ8=;
        b=VBloEoCXCTkXhKEoW6IimofV0vg//Z0tXPoFnD6d5P94UevYTSdCMdq3LpxHSjRomX
         ProBumOzdn1ADj+XaPlwbnPOszyLly/YhmI79DIYyxrOnUUuUEIrgwOtFG/dBOIWi9eF
         nuu6nW0Kp+46ypeKukLzOpH4mqYWonf7ji/d8eKn2HKwUDNi3LvuEUx7bZ5qsL0ufKE9
         kSKZSUtMg7qij3kLitiVEy4DBY9dlt1HQH5VoIJpNulRRXo3lS6k1zM7hv/mprTcH1yc
         /cR1A7M9TdQkuMaB97kg9iAXvPsf4HOydPsIsA0bpAvS0JcziMziwUg/xSDNVJ1CSY9l
         6pMw==
Content-Disposition: inline
In-Reply-To: <20210112170322.GA99586-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Jan 12, 2021 at 09:03:22AM -0800, Roman Gushchin wrote:
> On Tue, Jan 12, 2021 at 11:30:11AM -0500, Johannes Weiner wrote:
> > When a value is written to a cgroup's memory.high control file, the
> > write() context first tries to reclaim the cgroup to size before
> > putting the limit in place for the workload. Concurrent charges from
> > the workload can keep such a write() looping in reclaim indefinitely.
> > 
> > In the past, a write to memory.high would first put the limit in place
> > for the workload, then do targeted reclaim until the new limit has
> > been met - similar to how we do it for memory.max. This wasn't prone
> > to the described starvation issue. However, this sequence could cause
> > excessive latencies in the workload, when allocating threads could be
> > put into long penalty sleeps on the sudden memory.high overage created
> > by the write(), before that had a chance to work it off.
> > 
> > Now that memory_high_write() performs reclaim before enforcing the new
> > limit, reflect that the cgroup may well fail to converge due to
> > concurrent workload activity. Bail out of the loop after a few tries.
> > 
> > Fixes: 536d3bf261a2 ("mm: memcontrol: avoid workload stalls when lowering memory.high")
> > Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 5.8+
> > Reported-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > ---
> >  mm/memcontrol.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 605f671203ef..63a8d47c1cd3 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6275,7 +6275,6 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
> >  
> >  	for (;;) {
> >  		unsigned long nr_pages = page_counter_read(&memcg->memory);
> > -		unsigned long reclaimed;
> >  
> >  		if (nr_pages <= high)
> >  			break;
> > @@ -6289,10 +6288,10 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
> >  			continue;
> >  		}
> >  
> > -		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
> > -							 GFP_KERNEL, true);
> > +		try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
> > +					     GFP_KERNEL, true);
> >  
> > -		if (!reclaimed && !nr_retries--)
> > +		if (!nr_retries--)
> 
> Shouldn't it be (!reclaimed || !nr_retries) instead?
> 
> If reclaimed == 0, it probably doesn't make much sense to retry.

We usually allow nr_retries worth of no-progress reclaim cycles to
make up for intermittent reclaim failures.

The difference to OOMs/memory.max is that we don't want to loop
indefinitely on forward progress, but we should allow the usual number
of no-progress loops.
