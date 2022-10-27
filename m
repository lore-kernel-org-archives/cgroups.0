From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Thu, 27 Oct 2022 10:01:33 +0200
Message-ID: <Y1o63SWD2KmQkT3v@dhcp22.suse.cz>
References: <20221026074343.6517-1-feng.tang@intel.com>
 <dc453287-015d-fd1c-fe7f-6ee45772d6aa@linux.ibm.com>
 <Y1jpDfwBQId3GkJC@feng-clx>
 <Y1j7tsj5M0Md/+Er@dhcp22.suse.cz>
 <Y1kl8VbPE0RYdyEB@feng-clx>
 <Y1lZV6qHp3gIINGc@dhcp22.suse.cz>
 <87wn8lkbk5.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1ou5DGHrEsKnhri@dhcp22.suse.cz>
 <87o7txk963.fsf@yhuang6-desk2.ccr.corp.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1666857694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qa6sD3OJX290NYnGc0ulUW01Mac/lvuPb2vaepZWVak=;
        b=GOfRQdi/m0WYSTD5CYAhkOmN4NswRTwudSaHgtIJ1oHw16QVwyrpau8AnA+4eYPePOcGhe
        4VPRB2hWHIuofx9bzVfEvuQ+PfHUE5qM3DhDGpewPt3/bELf+bC3WB+x4DEvQu67yIfq1O
        IKDmab7lHY5SApO2WVHdJr/goa+3CBw=
Content-Disposition: inline
In-Reply-To: <87o7txk963.fsf-fFUE1NP8JkzwuUmzmnQr+vooFf0ArEBIu+b9c/7xato@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Thu 27-10-22 15:39:00, Huang, Ying wrote:
> Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> writes:
> 
> > On Thu 27-10-22 14:47:22, Huang, Ying wrote:
> >> Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> writes:
> > [...]
> >> > I can imagine workloads which wouldn't like to get their memory demoted
> >> > for some reason but wouldn't it be more practical to tell that
> >> > explicitly (e.g. via prctl) rather than configuring cpusets/memory
> >> > policies explicitly?
> >> 
> >> If my understanding were correct, prctl() configures the process or
> >> thread.
> >
> > Not necessarily. There are properties which are per adddress space like
> > PR_[GS]ET_THP_DISABLE. This could be very similar.
> >
> >> How can we get process/thread configuration at demotion time?
> >
> > As already pointed out in previous emails. You could hook into
> > folio_check_references path, more specifically folio_referenced_one
> > where you have all that you need already - all vmas mapping the page and
> > then it is trivial to get the corresponding vm_mm. If at least one of
> > them has the flag set then the demotion is not allowed (essentially the
> > same model as VM_LOCKED).
> 
> Got it!  Thanks for detailed explanation.
> 
> One bit may be not sufficient.  For example, if we want to avoid or
> control cross-socket demotion and still allow demoting to slow memory
> nodes in local socket, we need to specify a node mask to exclude some
> NUMA nodes from demotion targets.

Isn't this something to be configured on the demotion topology side? Or
do you expect there will be per process/address space usecases? I mean
different processes running on the same topology, one requesting local
demotion while other ok with the whole demotion topology?
 
> >From overhead point of view, this appears similar as that of VMA/task
> memory policy?  We can make mm->owner available for memory tiers
> (CONFIG_NUMA && CONFIG_MIGRATION).  The advantage is that we don't need
> to introduce new ABI.  I guess users may prefer to use `numactl` than a
> new ABI?

mm->owner is a wrong direction. It doesn't have a strong meaning because
there is no one task explicitly responsible for the mm so there is no
real owner (our clone() semantic is just to permissive for that). The
memcg::owner is a crude and ugly hack and it should go away over time
rather than build new uses.

Besides that, and as I have already tried to explain, per task demotion
policy is what makes this whole thing expensive. So this better be a per
mm or per vma property. Whether it is a on/off knob like PR_[GS]ET_THP_DISABLE
or there are explicit requirements for fine grain control on the vma
level I dunno. I haven't seen those usecases yet and it is really easy
to overengineer this.

To be completely honest I would much rather wait for those usecases
before adding a more complex APIs.  PR_[GS]_DEMOTION_DISABLED sounds
like a reasonable first step. Should we have more fine grained
requirements wrt address space I would follow the MADV_{NO}HUGEPAGE
lead.

If we really need/want to give a fine grained control over demotion
nodemask then we would have to go with vma->mempolicy interface. In
any case a per process on/off knob sounds like a reasonable first step
before we learn more about real usecases.
-- 
Michal Hocko
SUSE Labs
