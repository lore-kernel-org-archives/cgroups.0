From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Wed, 26 Oct 2022 11:19:50 +0200
Message-ID: <Y1j7tsj5M0Md/+Er@dhcp22.suse.cz>
References: <20221026074343.6517-1-feng.tang@intel.com>
 <dc453287-015d-fd1c-fe7f-6ee45772d6aa@linux.ibm.com>
 <Y1jpDfwBQId3GkJC@feng-clx>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1666775991; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UJSIrhvBIpYg0Q5icEbLoO9eTA3cWeRbn/PlJQxhuBo=;
        b=VFpME5g2pfkFFViLcZNoofvXS+Tmw4rncRgBETSsWP7403402Z8wRLHmXCaj1s3XAjN4eP
        dLG+/q7e9UNVbysPDEFoYrwrgmkQOEKHhdUNSXH2h9KO3UeQp5rgTm5Q4o5MfKtD8IfYl0
        Bz9yn1QM+zxRckwTPgzjYfLmFfa58rg=
Content-Disposition: inline
In-Reply-To: <Y1jpDfwBQId3GkJC@feng-clx>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Wed 26-10-22 16:00:13, Feng Tang wrote:
> On Wed, Oct 26, 2022 at 03:49:48PM +0800, Aneesh Kumar K V wrote:
> > On 10/26/22 1:13 PM, Feng Tang wrote:
> > > In page reclaim path, memory could be demoted from faster memory tier
> > > to slower memory tier. Currently, there is no check about cpuset's
> > > memory policy, that even if the target demotion node is not allowd
> > > by cpuset, the demotion will still happen, which breaks the cpuset
> > > semantics.
> > > 
> > > So add cpuset policy check in the demotion path and skip demotion
> > > if the demotion targets are not allowed by cpuset.
> > > 
> > 
> > What about the vma policy or the task memory policy? Shouldn't we respect
> > those memory policy restrictions while demoting the page? 
>  
> Good question! We have some basic patches to consider memory policy
> in demotion path too, which are still under test, and will be posted
> soon. And the basic idea is similar to this patch.

For that you need to consult each vma and it's owning task(s) and that
to me sounds like something to be done in folio_check_references.
Relying on memcg to get a cpuset cgroup is really ugly and not really
100% correct. Memory controller might be disabled and then you do not
have your association anymore.

This all can get quite expensive so the primary question is, does the
existing behavior generates any real issues or is this more of an
correctness exercise? I mean it certainly is not great to demote to an
incompatible numa node but are there any reasonable configurations when
the demotion target node is explicitly excluded from memory
policy/cpuset?
-- 
Michal Hocko
SUSE Labs
