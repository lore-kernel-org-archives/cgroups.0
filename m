From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
Date: Mon, 11 Jun 2012 11:32:25 +0200
Message-ID: <20120611093225.GA14523@tiehlicka.suse.cz>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com>
 <20120527202848.GC7631@skywalker.linux.vnet.ibm.com>
 <87lik920h8.fsf@skywalker.in.ibm.com>
 <20120608160612.dea6d1ce.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120608160612.dea6d1ce.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri 08-06-12 16:06:12, Andrew Morton wrote:
> On Wed, 30 May 2012 20:13:31 +0530
> "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> 
> > >> 
> > >>  - code: seperating hugetlb bits out from memcg bits to avoid growing 
> > >>    mm/memcontrol.c beyond its current 5650 lines, and
> > >> 
> > >
> > > I can definitely look at spliting mm/memcontrol.c 
> > >
> > >
> > >>  - performance: not incurring any overhead of enabling memcg for per-
> > >>    page tracking that is unnecessary if users only want to limit hugetlb 
> > >>    pages.
> > >> 
> > 
> > Since Andrew didn't sent the patchset to Linus because of this
> > discussion, I looked at reworking the patchset as a seperate
> > controller. The patchset I sent here
> > 
> > http://thread.gmane.org/gmane.linux.kernel.mm/79230
> > 
> > have seen minimal testing. I also folded the fixup patches
> > Andrew had in -mm to original patchset.
> > 
> > Let me know if the changes looks good.
> 
> This is starting to be a problem.  I'm still sitting on the old version
> of this patchset and it will start to get in the way of other work.
> 
> We now have this new version of the patchset which implements a
> separate controller but it is unclear to me which way we want to go.
 
I guess you are talking about v7 which is mem_cgroup based. This one has
some drawbacks (e.g. the most user visible one is that if one wants to
disable memory overhead from memcg he has to disable hugetlb controller
as well).
v8 took a different approach ((ab)use lru.next on the 3rd page to store
the group pointer) which looks as a reasonable compromise.

> Can the memcg developers please drop everything else and make a
> decision here?

I think that v8 (+fixups) is the way to go.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
