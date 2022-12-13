From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3] mm: Add nodes= arg to memory.reclaim
Date: Tue, 13 Dec 2022 09:33:24 +0100
Message-ID: <Y5g41HF2TcLzro4o@dhcp22.suse.cz>
References: <20221202223533.1785418-1-almasrymina@google.com>
 <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz>
 <CAHS8izM-XdLgFrQ1k13X-4YrK=JGayRXV_G3c3Qh4NLKP7cH_g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670920405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fBioyvD4vd7/35z0fjI4+FQj2kTkuRA99KUFhbZ2zqg=;
        b=uESRpWwH5XHQurdOjS16YAX9ouQKJDmxraaJbjVNNzt5yGgzi9VCBjM7Xsz+SJ/16Paho+
        NYeNI9T0S+fxT0pBvaSm7hsUKKbSzk2kMIFbTfq4A6SCdiMgIRHU87BX1boslH+MZmZTfP
        8pIFhUoiqU85Vjavt2/xU2nbuRHwxP0=
Content-Disposition: inline
In-Reply-To: <CAHS8izM-XdLgFrQ1k13X-4YrK=JGayRXV_G3c3Qh4NLKP7cH_g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina@google.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Huang Ying <ying.huang@intel.com>, Yang Shi <yang.shi@linux.alibaba.com>, Yosry Ahmed <yosryahmed@google.com>, weixugc@google.com, fvdl@google.com, bagasdotme@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Mon 12-12-22 16:54:27, Mina Almasry wrote:
> On Mon, Dec 12, 2022 at 12:55 AM Michal Hocko <mhocko@suse.com> wrote:
[...]
> > Let me summarize my main concerns here as well. The proposed
> > implementation doesn't apply the provided nodemask to the whole reclaim
> > process. This means that demotion can happen outside of the mask so the
> > the user request cannot really control demotion targets and that limits
> > the interface should there be any need for a finer grained control in
> > the future (see an example in [2]).
> > Another problem is that this can limit future reclaim extensions because
> > of existing assumptions of the interface [3] - specify only top-tier
> > node to force the aging without actually reclaiming any charges and
> > (ab)use the interface only for aging on multi-tier system. A change to
> > the reclaim to not demote in some cases could break this usecase.
> >
> 
> I think this is correct. My use case is to request from the kernel to
> do demotion without reclaim in the cgroup, and the reason for that is
> stated in the commit message:
> 
> "Reclaim and demotion incur different latency costs to the jobs in the
> cgroup. Demoted memory would still be addressable by the userspace at
> a higher latency, but reclaimed memory would need to incur a
> pagefault."
> 
> For jobs of some latency tiers, we would like to trigger proactive
> demotion (which incurs relatively low latency on the job), but not
> trigger proactive reclaim (which incurs a pagefault). I initially had
> proposed a separate interface for this, but Johannes directed me to
> this interface instead in [1]. In the same email Johannes also tells
> me that meta's reclaim stack relies on memory.reclaim triggering
> demotion, so it seems that I'm not the first to take a dependency on
> this. Additionally in [2] Johannes also says it would be great if in
> the long term reclaim policy and demotion policy do not diverge.

I do recognize your need to control the demotion but I argue that it is
a bad idea to rely on an implicit behavior of the memory reclaim and an
interface which is _documented_ to primarily _reclaim_ memory.

Really, consider that the current demotion implementation will change
in the future and based on a newly added heuristic memory reclaim or
compression would be preferred over migration to a different tier.  This
might completely break your current assumptions and break your usecase
which relies on an implicit demotion behavior.  Do you see that as a
potential problem at all? What shall we do in that case? Special case
memory.reclaim behavior?

Now to your specific usecase. If there is a need to do a memory
distribution balancing then fine but this should be a well defined
interface. E.g. is there a need to not only control demotion but
promotions as well? I haven't heard anybody requesting that so far
but I can easily imagine that like outsourcing the memory reclaim to
the userspace someone might want to do the same thing with the numa
balancing because $REASONS. Should that ever happen, I am pretty sure
hooking into memory.reclaim is not really a great idea.

See where I am coming from?

> [1] https://lore.kernel.org/linux-mm/Y35fw2JSAeAddONg@cmpxchg.org/
> [2] https://lore.kernel.org/linux-mm/Y36fIGFCFKiocAd6@cmpxchg.org/
-- 
Michal Hocko
SUSE Labs
