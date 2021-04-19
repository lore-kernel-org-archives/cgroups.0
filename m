From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC] docs/admin-guide/cgroup-v2: Add hugetlb rsvd files
Date: Mon, 19 Apr 2021 10:51:32 -0400
Message-ID: <YH2Y9FucBW2GLLLQ@cmpxchg.org>
References: <20210416141146.542786-1-odin@uged.al>
 <YHn3cifQv1FUOqfU@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YrZItNxcyVF3pVVkQf+v9BtikCFL0HmoCNCAuzegmSI=;
        b=OeaV6gvLZnnSgBj2hQod5raZF9ZCVqc92fxLKd1/xMoNPJ8BuhLxwWUWh8+peK+69U
         kI1zU+Mkv29pcKw8ycTns/9U9WSYJ5S0lLXBtik78Ge8J89sTvfInSRg7zaz2ionBo4n
         4/ZbXtklCKgJQsGKLDrpcG0VEV2Pn/ruArOnhvry0sjLSYDw6YJ4daItO8OQKpLcHcVF
         Gkx5U9d3BhiKjRxwCBT+XpjpBRWfajJm/aJMQ0cpLWChEy9HUks3monRWvAG7z8qog1B
         K+tc+tUPSqi9pwkYjzaOVkx0g0o0HyoxeFbTLiTANdgI7pnRZ2wdsg0zn1wIUNs5I7Rm
         PPeg==
Content-Disposition: inline
In-Reply-To: <YHn3cifQv1FUOqfU-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>, corbet-T1hC0tSOHrs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, Apr 16, 2021 at 04:45:38PM -0400, Tejun Heo wrote:
> (cc'ing memcg maintainers)
> 
> On Fri, Apr 16, 2021 at 04:11:46PM +0200, Odin Ugedal wrote:
> > Add missing docs about reservation accounting for hugetlb in cgroup v2.
> > 
> > Signed-off-by: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
> > ---
> > RFC: This is linking from cgroup-v1 docs, and that is probably not
> > optimal. The information about the difference between reservation
> > accounting and page fault accounting is pretty hard to make short.
> > 
> > I think we have four ways to do it, but I don't know what is
> > most optimal:
> > 
> > - Link from cgroup-v2 to cgroup-v1 (this patch)
> > - Have a separate description for both v1 and v2
> > - Move description from cgroup-v1 to cgroup-v2, and link from v1 to
> >   v2.
> 
> This would be my preference but I don't really mind the other way around
> that much.

v1/hugetlb.rst is quite verbose, and some things are implementation
details. I'm not sure we want all that in the cgroup2 documentation.

My preference would be to first try to write a version of the doc in
cgroup2's briefer style, and then, depending on how that works out,
see whether we can delete (replace with link) the cgroup1 text, or
keep it for archiving purposes.

v1/hugetlb doc items that seem unnecesary to keep in v2:

- how to mount the cgroupfs, create cgroups, and move tasks into it

- the page fault accounting description could be compressed a
  bit. maybe drop the part about it being the admin's job to avoid
  sigbus by being careful with the allocations. that's obvious imo
  when you simply describe the sigbus semantics.

- likewise, reservation accounting can be briefer too. there is quite
  a bit of opinion in there that could probably be cut short. maybe a
  one-liner that says "mmap-time accounting gives userspace easier
  error handling - if in doubt, use reservation accounting" or so.

- caveats with shared memory: not sure this is needed at all, but if
  so, it can be a one liner saying "hugetlb uses the same first-hit
  semantics as the memory controller (see Memory Ownership)"

- Caveats with HugeTLB cgroup offline: this is an implementation
  detail that i don't think is actionable information for users
