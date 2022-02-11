From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 4/4] memcg: synchronously enforce memory.high
Date: Thu, 10 Feb 2022 18:44:07 -0800
Message-ID: <YgXNd11XK94PM89+@carbon.dhcp.thefacebook.com>
References: <20220210081437.1884008-1-shakeelb@google.com>
 <20220210081437.1884008-5-shakeelb@google.com>
 <YgVyZrDPxVgP6OLG@carbon.dhcp.thefacebook.com>
 <CALvZod5xFmCVV_AZO1be8pYakmDvYh-QXmNYtTNT4zvCw-m4bQ@mail.gmail.com>
 <YgWf0wL5RoSpNrWn@carbon.dhcp.thefacebook.com>
 <CALvZod5XstvNB_=qprW6_bx33h8JeyE5TjvX3UDoqG8XHBr14w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ASp7tkiRac7NiliMWRsvvzTDctAxguEQSGC/PRhMxbs=;
 b=oSezFnCIM5/9LfGf/ZkXABeBT+dP+1ppuQF/pCxTGrZ9CPFQ8aN4DFPqWa1/QriXjbMm
 6Nu2d7ZWLvOOY2L/fw+Fh4/rntRdXdLmqN07nbdB2vZLrHBiyZe2zMJoLnn01IwGxC0+
 t5VAwyewq0iVb5u2Q4AvVxlFBg69j6CDZq4= 
Content-Disposition: inline
In-Reply-To: <CALvZod5XstvNB_=qprW6_bx33h8JeyE5TjvX3UDoqG8XHBr14w@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Thu, Feb 10, 2022 at 03:53:00PM -0800, Shakeel Butt wrote:
> On Thu, Feb 10, 2022 at 3:29 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Thu, Feb 10, 2022 at 02:22:36PM -0800, Shakeel Butt wrote:
> > > On Thu, Feb 10, 2022 at 12:15 PM Roman Gushchin <guro@fb.com> wrote:
> > > >
> > > [...]
> > > >
> > > > Has this approach been extensively tested in the production?
> > > >
> > > > Injecting sleeps at return-to-userspace moment is safe in terms of priority
> > > > inversions: a slowed down task will unlikely affect the rest of the system.
> > > >
> > > > It way less predictable for a random allocation in the kernel mode, what if
> > > > the task is already holding a system-wide resource?
> > > >
> > > > Someone might argue that it's not better than a system-wide memory shortage
> > > > and the same allocation might go into a direct reclaim anyway, but with
> > > > the way how memory.high is used it will happen way more often.
> > > >
> > >
> > > Thanks for the review.
> > >
> > > This patchset is tested in the test environment for now and I do plan
> > > to test this in production but that is a slow process and will take
> > > some time.
> > >
> > > Let me answer the main concern you have raised i.e. the safety of
> > > throttling a task synchronously in the charge code path. Please note
> > > that synchronous memory reclaim and oom-killing can already cause the
> > > priority inversion issues you have mentioned. The way we usually
> > > tackle such issues are through userspace controllers. For example oomd
> > > is the userspace solution for catering such issues related to
> > > oom-killing. Here we have a similar userspace daemon monitoring the
> > > workload and deciding if it should let the workload grow or kill it.
> > >
> > > Now should we keep the current high limit enforcement implementation
> > > and let it be ineffective for some real workloads or should we make
> > > the enforcement more robust and let the userspace tackle some corner
> > > case priority inversion issues. I think we should follow the second
> > > option as we already have precedence of doing the same for reclaim and
> > > oom-killing.
> >
> > Well, in a theory it sounds good and I have no intention to oppose the
> > idea. However in practice we might easily get quite serious problems.
> > So I think we should be extra careful here. In the end we don't want to
> > pull and then revert this patch.
> >
> > The difference between the system-wide direct reclaim and this case is that
> > usually kswapd is doing a good job of refilling the empty buffer, so we don't
> > usually work in the circumstances of the global memory shortage. And when we do,
> > often it's not working out quite well, this is why oomd and other similar
> > solutions are required.
> >.
> > Another option is to use your approach only for special cases (e.g. huge
> > allocations) and keep the existing approach for most other allocations.
> >
> 
> These are not necessarily huge allocations and can be a large number
> of small allocations. However I think we can make this idea work by
> checking current->memcg_nr_pages_over_high. If
> order(current->memcg_nr_pages_over_high) is, let's say, larger than
> PAGE_ALLOC_COSTLY_ORDER, then throttle synchronously. WDYT?

Yes, I really like this idea: the majority of allocations will be handled in
a proven way, however we'll have coverage for large outliers as well.

Not sure about PAGE_ALLOC_COSTLY_ORDER though, I'd probably chose a larger
constant, but we can discuss it separately.

Thanks!
