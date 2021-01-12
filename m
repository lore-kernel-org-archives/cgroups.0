From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm: memcontrol: prevent starvation when writing
 memory.high
Date: Tue, 12 Jan 2021 13:45:12 -0800
Message-ID: <20210112214512.GC99586@carbon.dhcp.thefacebook.com>
References: <20210112163011.127833-1-hannes@cmpxchg.org>
 <20210112170322.GA99586@carbon.dhcp.thefacebook.com>
 <X/38ZwyOE96SAfa9@cmpxchg.org>
 <20210112201237.GB99586@carbon.dhcp.thefacebook.com>
 <X/4Qfxe1OKXACDLM@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=zy2Ra99zxj2w3tnSLq9kjegLjUfMyCheRbE4VSZFWVQ=;
 b=m7T4ZMnlHMmgV/1tiUUV6a3G/X5M7/4wxLpRd3nviHHVVtPdq6c90fdq+KuZwPt0lvMT
 LoQ44/jwqzh0YB0x8jM9+xiKSTnm41yc1AF+vJ/O+t74PkXa7xOYhuLt0USfpnzoiKSB
 8q9nQIuOuznAa3BZfOE9DGyY9lXfYJKaKY0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zy2Ra99zxj2w3tnSLq9kjegLjUfMyCheRbE4VSZFWVQ=;
 b=IOEI0jKmeIO5z23pcCSjB524prSbEJJ1x7oHXD5mKBzpFDPU7fKq6WML0jAkL/6EPAwi5UX014Bp3CmQJo9/iK5U8zAJQQ+WG866oJm4rjji8EoCWIaYPuCYvVshvqwUDCxhfw+7jCAx/mS0cr10lpP29+m7D3hyiw3/9N/nCtI=
Content-Disposition: inline
In-Reply-To: <X/4Qfxe1OKXACDLM@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Jan 12, 2021 at 04:11:27PM -0500, Johannes Weiner wrote:
> On Tue, Jan 12, 2021 at 12:12:37PM -0800, Roman Gushchin wrote:
> > On Tue, Jan 12, 2021 at 02:45:43PM -0500, Johannes Weiner wrote:
> > > On Tue, Jan 12, 2021 at 09:03:22AM -0800, Roman Gushchin wrote:
> > > > On Tue, Jan 12, 2021 at 11:30:11AM -0500, Johannes Weiner wrote:
> > > > > When a value is written to a cgroup's memory.high control file, the
> > > > > write() context first tries to reclaim the cgroup to size before
> > > > > putting the limit in place for the workload. Concurrent charges from
> > > > > the workload can keep such a write() looping in reclaim indefinitely.
> > > > > 
> > > > > In the past, a write to memory.high would first put the limit in place
> > > > > for the workload, then do targeted reclaim until the new limit has
> > > > > been met - similar to how we do it for memory.max. This wasn't prone
> > > > > to the described starvation issue. However, this sequence could cause
> > > > > excessive latencies in the workload, when allocating threads could be
> > > > > put into long penalty sleeps on the sudden memory.high overage created
> > > > > by the write(), before that had a chance to work it off.
> > > > > 
> > > > > Now that memory_high_write() performs reclaim before enforcing the new
> > > > > limit, reflect that the cgroup may well fail to converge due to
> > > > > concurrent workload activity. Bail out of the loop after a few tries.
> > > > > 
> > > > > Fixes: 536d3bf261a2 ("mm: memcontrol: avoid workload stalls when lowering memory.high")
> > > > > Cc: <stable@vger.kernel.org> # 5.8+
> > > > > Reported-by: Tejun Heo <tj@kernel.org>
> > > > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > > > > ---
> > > > >  mm/memcontrol.c | 7 +++----
> > > > >  1 file changed, 3 insertions(+), 4 deletions(-)
> > > > > 
> > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > index 605f671203ef..63a8d47c1cd3 100644
> > > > > --- a/mm/memcontrol.c
> > > > > +++ b/mm/memcontrol.c
> > > > > @@ -6275,7 +6275,6 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
> > > > >  
> > > > >  	for (;;) {
> > > > >  		unsigned long nr_pages = page_counter_read(&memcg->memory);
> > > > > -		unsigned long reclaimed;
> > > > >  
> > > > >  		if (nr_pages <= high)
> > > > >  			break;
> > > > > @@ -6289,10 +6288,10 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
> > > > >  			continue;
> > > > >  		}
> > > > >  
> > > > > -		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
> > > > > -							 GFP_KERNEL, true);
> > > > > +		try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
> > > > > +					     GFP_KERNEL, true);
> > > > >  
> > > > > -		if (!reclaimed && !nr_retries--)
> > > > > +		if (!nr_retries--)
> > > > 
> > > > Shouldn't it be (!reclaimed || !nr_retries) instead?
> > > > 
> > > > If reclaimed == 0, it probably doesn't make much sense to retry.
> > > 
> > > We usually allow nr_retries worth of no-progress reclaim cycles to
> > > make up for intermittent reclaim failures.
> > > 
> > > The difference to OOMs/memory.max is that we don't want to loop
> > > indefinitely on forward progress, but we should allow the usual number
> > > of no-progress loops.
> > 
> > Re memory.max: trying really hard makes sense because we are OOMing otherwise.
> > With memory.high such an idea is questionable: if were not able to reclaim
> > a single page from the first attempt, it's unlikely that we can reclaim many
> > from repeating 16 times.
> > 
> > My concern here is that we can see CPU regressions in some cases when there is
> > no reclaimable memory. Do you think we can win something by trying harder?
> > If so, it's worth mentioning in the commit log. Because it's really a separate
> > change to what's described in the log, to some extent it's a move into an opposite
> > direction.
> 
> Hm, I'm confused what change you are referring to.
> 
> Current upstream allows:
> 
>     a. unlimited progress loops
>     b. 16 no-progress loops
> 
> My patch is fixing the issue resulting from the unlimited progress
> loops in a). This is described in the changelog.
> 
> You seem to be advocating for an unrelated change to the no-progress
> loops condition in b).

Fair enough.

But still the question remains: what are we gaining by trying again after not
being able to reclaim a single page? If you want, it can be done separately,
but it looks like a good idea to me to bail out if we can't reclaim a single
page.

Thanks!
