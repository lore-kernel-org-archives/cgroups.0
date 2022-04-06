From: Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Wed, 6 Apr 2022 13:16:27 -0700
Message-ID: <CAAPL-u8tHSPe03bDuU3+mXbEU-3dKgYQt=jFOHdMq8kwjQmGqQ@mail.gmail.com>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <YkcEMdsi9G5y8mX4@dhcp22.suse.cz> <CAAPL-u_i-Mp-Bo7LtP_4aJscY=1JHG_y1H_-A7N_HRAgtz+arg@mail.gmail.com>
 <87y20nzyw4.fsf@yhuang6-desk2.ccr.corp.intel.com> <CAAPL-u8wjtBRE7KZyZjoQ0eTJecnW35uEXAE3KU0M+AvL=5-ug@mail.gmail.com>
 <87o81fujdc.fsf@yhuang6-desk2.ccr.corp.intel.com> <CAAPL-u_6XqQYtLAMNFvEo+0XU2VR=XYm0T9btL=g6rVVW2h93w@mail.gmail.com>
 <87bkxfudrk.fsf@yhuang6-desk2.ccr.corp.intel.com> <CAAPL-u_FVEVE+wTBNYfDibLVKsRuOwEnpigYYRiZ2MbeUs1u8w@mail.gmail.com>
 <877d82vi13.fsf@yhuang6-desk2.ccr.corp.intel.com> <CAAPL-u8u77yazFpc2R216j6ObAiANb0Lfxt7DcT9P=3eg60u9Q@mail.gmail.com>
 <8735iqvbov.fsf@yhuang6-desk2.ccr.corp.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zeoWEqMCUxiyPlVz6AJGZgs8KEkBrSwU3l3ZTkJ4SDg=;
        b=TFkVz4+ZAUctG+Jq7AuN8uLpy3f4I7Drtohqwfg8l/R65Q4bXHLQE263Z/vO1xDAcS
         PY37fYo5q2/G0Qa6b+AUKPQPOpBCNryGYbnTnOrlkWYSN5gn0uYE1gZNuR4LMUidlJfs
         oebfXoVKkEgWG28+VmhQs3XWl5ZhJ6DjnJ2H92lsdt0IQnLfNM95ipTfpxyCD2PyeDHx
         k7+yikhlo8+Id719cmCpJOD1V14NULA0xESDyIk7knzX356T6eVKWfyBcZRBBK4CpaDt
         PzMCHpkYydAKVFWHz5yDgl5wmKNi8j7RXW/49RmGSVEtPB3mDs6GyASoeW/65GvwB2by
         cT4w==
In-Reply-To: <8735iqvbov.fsf-fFUE1NP8JkzwuUmzmnQr+vooFf0ArEBIu+b9c/7xato@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On Wed, Apr 6, 2022 at 1:49 AM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
>
> > On Tue, Apr 5, 2022 at 11:32 PM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >> Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
> >>
> >> > On Tue, Apr 5, 2022 at 7:50 PM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >> >>
> >> >> Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
> >> >>
> >> >> > On Tue, Apr 5, 2022 at 5:49 PM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >> >> >>
> >> >> >> Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
> >> >> >>
> >> >> >> > On Sat, Apr 2, 2022 at 1:13 AM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >> >> >> >>
> >> >> >> >> Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
> >> >> >> >>
> >> >> >> >> > On Fri, Apr 1, 2022 at 6:54 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >> >> >> >> >>
> >> >> >> >> >> On Thu 31-03-22 08:41:51, Yosry Ahmed wrote:
> >> >> >> >> >> > From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >> >> >> >> >> >
> >> >> >> >>
> >> >> >> >> [snip]
> >> >> >> >>
> >> >> >> >> >> > Possible Extensions:
> >> >> >> >> >> > --------------------
> >> >> >> >> >> >
> >> >> >> >> >> > - This interface can be extended with an additional parameter or flags
> >> >> >> >> >> >   to allow specifying one or more types of memory to reclaim from (e.g.
> >> >> >> >> >> >   file, anon, ..).
> >> >> >> >> >> >
> >> >> >> >> >> > - The interface can also be extended with a node mask to reclaim from
> >> >> >> >> >> >   specific nodes. This has use cases for reclaim-based demotion in memory
> >> >> >> >> >> >   tiering systens.
> >> >> >> >> >> >
> >> >> >> >> >> > - A similar per-node interface can also be added to support proactive
> >> >> >> >> >> >   reclaim and reclaim-based demotion in systems without memcg.
> >> >> >> >> >> >
> >> >> >> >> >> > For now, let's keep things simple by adding the basic functionality.
> >> >> >> >> >>
> >> >> >> >> >> Yes, I am for the simplicity and this really looks like a bare minumum
> >> >> >> >> >> interface. But it is not really clear who do you want to add flags on
> >> >> >> >> >> top of it?
> >> >> >> >> >>
> >> >> >> >> >> I am not really sure we really need a node aware interface for memcg.
> >> >> >> >> >> The global reclaim interface will likely need a different node because
> >> >> >> >> >> we do not want to make this CONFIG_MEMCG constrained.
> >> >> >> >> >
> >> >> >> >> > A nodemask argument for memory.reclaim can be useful for memory
> >> >> >> >> > tiering between NUMA nodes with different performance.  Similar to
> >> >> >> >> > proactive reclaim, it can allow a userspace daemon to drive
> >> >> >> >> > memcg-based proactive demotion via the reclaim-based demotion
> >> >> >> >> > mechanism in the kernel.
> >> >> >> >>
> >> >> >> >> I am not sure whether nodemask is a good way for demoting pages between
> >> >> >> >> different types of memory.  For example, for a system with DRAM and
> >> >> >> >> PMEM, if specifying DRAM node in nodemask means demoting to PMEM, what
> >> >> >> >> is the meaning of specifying PMEM node? reclaiming to disk?
> >> >> >> >>
> >> >> >> >> In general, I have no objection to the idea in general.  But we should
> >> >> >> >> have a clear and consistent interface.  Per my understanding the default
> >> >> >> >> memcg interface is for memory, regardless of memory types.  The memory
> >> >> >> >> reclaiming means reduce the memory usage, regardless of memory types.
> >> >> >> >> We need to either extending the semantics of memory reclaiming (to
> >> >> >> >> include memory demoting too), or add another interface for memory
> >> >> >> >> demoting.
> >> >> >> >
> >> >> >> > Good point.  With the "demote pages during reclaim" patch series,
> >> >> >> > reclaim is already extended to demote pages as well.  For example,
> >> >> >> > can_reclaim_anon_pages() returns true if demotion is allowed and
> >> >> >> > shrink_page_list() can demote pages instead of reclaiming pages.
> >> >> >>
> >> >> >> These are in-kernel implementation, not the ABI.  So we still have
> >> >> >> the opportunity to define the ABI now.
> >> >> >>
> >> >> >> > Currently, demotion is disabled for memcg reclaim, which I think can
> >> >> >> > be relaxed and also necessary for memcg-based proactive demotion.  I'd
> >> >> >> > like to suggest that we extend the semantics of memory.reclaim to
> >> >> >> > cover memory demotion as well.  A flag can be used to enable/disable
> >> >> >> > the demotion behavior.
> >> >> >>
> >> >> >> If so,
> >> >> >>
> >> >> >> # echo A > memory.reclaim
> >> >> >>
> >> >> >> means
> >> >> >>
> >> >> >> a) "A" bytes memory are freed from the memcg, regardless demoting is
> >> >> >>    used or not.
> >> >> >>
> >> >> >> or
> >> >> >>
> >> >> >> b) "A" bytes memory are reclaimed from the memcg, some of them may be
> >> >> >>    freed, some of them may be just demoted from DRAM to PMEM.  The total
> >> >> >>    number is "A".
> >> >> >>
> >> >> >> For me, a) looks more reasonable.
> >> >> >>
> >> >> >
> >> >> > We can use a DEMOTE flag to control the demotion behavior for
> >> >> > memory.reclaim.  If the flag is not set (the default), then
> >> >> > no_demotion of scan_control can be set to 1, similar to
> >> >> > reclaim_pages().
> >> >>
> >> >> If we have to use a flag to control the behavior, I think it's better to
> >> >> have a separate interface (e.g. memory.demote).  But do we really need b)?
> >> >>
> >> >
> >> > I am fine with either approach: a separate interface similar to
> >> > memory.reclaim, but dedicated to demotion, or multiplexing
> >> > memory.reclaim for demotion with a flag.
> >> >
> >> > My understanding is that with the "demote pages during reclaim"
> >> > support, b) is the expected behavior, or more precisely, pages that
> >> > cannot be demoted may be freed or swapped out.  This is reasonable.
> >> > Demotion-only can also be supported via some arguments to the
> >> > interface and changes to demotion code in the kernel.  After all, this
> >> > interface is being designed to be extensible based on the discussions
> >> > so far.
> >>
> >> I think we should define the interface not from the current
> >> implementation point of view, but from the requirement point of view.
> >> For proactive reclaim, per my understanding, the requirement is,
> >>
> >>   we found that there's some cold pages in some workloads, so we can
> >>   take advantage of the proactive reclaim to reclaim some pages so that
> >>   other workload can use the freed memory.
> >>
> >> For proactive demotion, per my understanding, the requirement could be,
> >>
> >>   We found that there's some cold pages in fast memory (e.g. DRAM) in
> >>   some workloads, so we can take advantage of the proactive demotion to
> >>   demote some pages so that other workload can use the freed fast
> >>   memory.  Given the DRAM partition support Tim (Cced) is working on.
> >>
> >> Why do we need something in the middle?
> >
> > Maybe there is some misunderstanding.  As you said, demotion is to
> > free up fast memory.  If pages on fast memory cannot be demoted, but
> > can still be reclaimed to free some fast memory, it is useful, too.
> > Certainly, we can also add the support and configure the policy to
> > only demote, not reclaim, from fast memory in such cases.
>
> Yes.  I think it may be better to demote from fast memory nodes only in
> such cases.  We just free some fast memory proactively.  But we may
> reclaim from the slow memory node (which are demotion targets) if
> necessary.

It can be a policy choice whether to reclaim from slow memory nodes
for demotion, or reclaim the pages directly from fast memory nodes, or
do nothing, if there isn't enough free space on slow memory nodes for
a proactive demotion request.  For example, if the file pages on fast
memory are clean and cold enough, they can be discarded, which should
be cheaper than reclaiming from slow memory nodes and then demoting
these pages.  A policy for such behaviors can be specified as an
argument to the proactive demotion interface when it is desired.

> > In any case, we will not reclaim from slow memory for demotion,
>
> If there's no free pages in the slow memory to accommodate the demoted
> pages, why not just reclaim some pages in the slow memory?  What are the
> disadvantages to do that?

We can certainly do what you have described through a policy argument.
What I meant is that we will not ask directly via the proactive
demotion interface to reclaim from slow memory nodes and count the
reclaimed bytes as part of the requested bytes.

> > if that is the middle thing you refer to.
>
> No.  I mean,
>
> If we reclaim "A" pages proactively, we will free "A" pages, maybe from
> slow memory firstly.  The target is the total memory size of a memcg.
>
> If we demote "A" pages proactively, we will demote "A" pages from fast
> memory to slow memory.  The target is the fast memory size of a memcg.
> In the process, some slow memory may be reclaimed to accommodate the
> demoted pages.
>
> For me, the middle thing is,
>
> If we demote some pages from fast memory to slow memory proactively and
> free some pages from slow memory at the same time, the total number
> (demote + free) is "A".  There's no clear target.  I think this is
> confusing.  Per my understanding, you don't suggest this too.

I agree and don't suggest this middle thing, either.

> > This is why nodemask is
> > proposed for memory.reclaim to support the demotion use case.  With a
> > separate memory.demote interface and memory tiering topology among
> > NUMA nodes being well defined by the kernel and shared with the
> > userspace, we can omit the nodemask argument.
>
> Yes.  Both seems work.
>
> Best Regards,
> Huang, Ying
>
> >>
> >> >> > The question is then whether we want to rename memory.reclaim to
> >> >> > something more general.  I think this name is fine if reclaim-based
> >> >> > demotion is an accepted concept.
> >> >>
> >> >> Best Regards,
> >> >> Huang, Ying
