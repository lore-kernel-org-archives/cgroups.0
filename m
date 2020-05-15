From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] memcg: expose root cgroup's memory.stat
Date: Fri, 15 May 2020 08:00:26 -0700
Message-ID: <20200515150026.GA94522@carbon.DHCP.thefacebook.com>
References: <20200508170630.94406-1-shakeelb@google.com>
 <20200508214405.GA226164@cmpxchg.org>
 <CALvZod5VHHUV+_AXs4+5sLOPGyxm709kQ1q=uHMPVxW8pwXZ=g@mail.gmail.com>
 <20200515082955.GJ29153@dhcp22.suse.cz>
 <20200515132421.GC591266@cmpxchg.org>
 <CALvZod7SdgXv0Dmm3q5H=EH4dzg8pXZenMUaDObfoRv5EX-Pkw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=FXFoHMcftAIBfyNkY53nBPS4LdgInjr/xrQffhf24K0=;
 b=peCNMd+/qci3NvmEQOI2kBqhxxywoWn0pZjQ5W7s89K006cxKDkjkgPqrRjEzSHBLGtO
 ZS1cxJqn752AMFs1DFVIKfilNs/X/Q/jbLblRu6hYf/DQVbaMksuSclCHHUIuJaGDIdh
 2fZxc22B+OcdVqEMIcTV4HEwpQH1OBMz2EA= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FXFoHMcftAIBfyNkY53nBPS4LdgInjr/xrQffhf24K0=;
 b=EdiXJgHSKPV/6gtXdM7sOScafdrVk4Qb7u3cuubR6eG/wn9F2YzAXc8NpgY3pSbeqeFwCdC4Xub+BdTYSfkJwV+8zd9XX/feTtJZ+CLuqALzv8e3ZCpDE5UDITwDgxzV+HppSOXRuZAADIdyQaKxlOpbxChoFmQmBmhYmXZaHYs=
Content-Disposition: inline
In-Reply-To: <CALvZod7SdgXv0Dmm3q5H=EH4dzg8pXZenMUaDObfoRv5EX-Pkw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, May 15, 2020 at 06:44:44AM -0700, Shakeel Butt wrote:
> On Fri, May 15, 2020 at 6:24 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> >
> > On Fri, May 15, 2020 at 10:29:55AM +0200, Michal Hocko wrote:
> > > On Sat 09-05-20 07:06:38, Shakeel Butt wrote:
> > > > On Fri, May 8, 2020 at 2:44 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > > > >
> > > > > On Fri, May 08, 2020 at 10:06:30AM -0700, Shakeel Butt wrote:
> > > > > > One way to measure the efficiency of memory reclaim is to look at the
> > > > > > ratio (pgscan+pfrefill)/pgsteal. However at the moment these stats are
> > > > > > not updated consistently at the system level and the ratio of these are
> > > > > > not very meaningful. The pgsteal and pgscan are updated for only global
> > > > > > reclaim while pgrefill gets updated for global as well as cgroup
> > > > > > reclaim.
> > > > > >
> > > > > > Please note that this difference is only for system level vmstats. The
> > > > > > cgroup stats returned by memory.stat are actually consistent. The
> > > > > > cgroup's pgsteal contains number of reclaimed pages for global as well
> > > > > > as cgroup reclaim. So, one way to get the system level stats is to get
> > > > > > these stats from root's memory.stat, so, expose memory.stat for the root
> > > > > > cgroup.
> > > > > >
> > > > > >       from Johannes Weiner:
> > > > > >       There are subtle differences between /proc/vmstat and
> > > > > >       memory.stat, and cgroup-aware code that wants to watch the full
> > > > > >       hierarchy currently has to know about these intricacies and
> > > > > >       translate semantics back and forth.
> > >
> > > Can we have those subtle differences documented please?
> > >
> > > > > >
> > > > > >       Generally having the fully recursive memory.stat at the root
> > > > > >       level could help a broader range of usecases.
> > > > >
> > > > > The changelog begs the question why we don't just "fix" the
> > > > > system-level stats. It may be useful to include the conclusions from
> > > > > that discussion, and why there is value in keeping the stats this way.
> > > > >
> > > >
> > > > Right. Andrew, can you please add the following para to the changelog?
> > > >
> > > > Why not fix the stats by including both the global and cgroup reclaim
> > > > activity instead of exposing root cgroup's memory.stat? The reason is
> > > > the benefit of having metrics exposing the activity that happens
> > > > purely due to machine capacity rather than localized activity that
> > > > happens due to the limits throughout the cgroup tree. Additionally
> > > > there are userspace tools like sysstat(sar) which reads these stats to
> > > > inform about the system level reclaim activity. So, we should not
> > > > break such use-cases.
> > > >
> > > > > > Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > > > Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > > > >
> > > > > Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > > >
> > > > Thanks a lot.
> > >
> > > I was quite surprised that the patch is so simple TBH. For some reason
> > > I've still had memories that we do not account for root memcg (likely
> > > because mem_cgroup_is_root(memcg) bail out in the try_charge. But stats
> > > are slightly different here.
> >
> > Yep, we skip the page_counter for root, but keep in mind that cgroup1
> > *does* have a root-level memory.stat, so (for the most part) we've
> > been keeping consumer stats for the root level the whole time.
> >
> > > counters because they are not really all the same. E.g.
> > > - mem_cgroup_charge_statistics accounts for each memcg
> >
> > Yep, that's heritage from cgroup1.
> >
> > > - memcg_charge_kernel_stack relies on pages being associated with a
> > >   memcg and that in turn relies on __memcg_kmem_charge_page which bails
> > >   out on root memcg
> >
> > You're right. It should only bypass the page_counter, but still set
> > page->mem_cgroup = root_mem_cgroup, just like user pages.

What about kernel threads? We consider them belonging to the root memory
cgroup. Should their memory consumption being considered in root-level stats?

I'm not sure we really want it, but I guess we need to document how
kernel threads are handled.

> >
> > This counter also doesn't get exported on cgroup1, so it would indeed
> > be a new bug. It needs to be fixed before this patch here.
> >
> > > - memcg_charge_slab (NR_SLAB*) skips over root memcg as well
> >
> > Same thing with these two.
> 
> Yes, we skip page_counter for root but not the stats. I will go over
> all the stats and make sure we are not skipping the stats for root.
