From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL
 allocations
Date: Fri, 29 Nov 2013 15:46:16 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1311291543400.22413@chino.kir.corp.google.com>
References: <1385140676-5677-1-git-send-email-hannes@cmpxchg.org> <alpine.DEB.2.02.1311261658170.21003@chino.kir.corp.google.com> <alpine.DEB.2.02.1311261931210.5973@chino.kir.corp.google.com> <20131127163916.GB3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271336220.9222@chino.kir.corp.google.com> <20131127225340.GE3556@cmpxchg.org> <alpine.DEB.2.02.1311271526080.22848@chino.kir.corp.google.com> <20131128102049.GF2761@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=LnQayGAN11BSdtkFQfv4TlCapJZSStc6y6/pXoR35/U=;
        b=VQfuoXyqQb64XznhaWW+6ZHpsPpfuj73eaJVvumchMMgOSacTzG/D+ixrT0Aepsapx
         qsGz1nXaeTK6XYnSK6OfQ7udTR8S2HZvIQxPD+Iik9lOTe2xiuyFN0LpeR8tPAmTJMfU
         KCZDb7AbLevKQ8HEpoPDFuCwCeBNLHktW7FfqxkRC+VGh1fIJZqd0R8xBcAXoZyFcRml
         HBb0G/PX9eMzAXoA9LG746LHzXtXgvbGXpbq3FB7uKckBn19BbXCsXkLB9fJxcqIbgED
         QxcHnUWE1jTRcuEvQ9wMITrLAsEizJrdPv093azorAySgTQycS/z3VeeToOPmTAKCTvg
         TBfg==
In-Reply-To: <20131128102049.GF2761-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 28 Nov 2013, Michal Hocko wrote:

> > Ok, so let's forget about GFP_KERNEL | __GFP_NOFAIL since anything doing 
> > __GFP_FS should not be holding such locks, we have some of those in the 
> > drivers code and that makes sense that they are doing GFP_KERNEL.
> > 
> > Focusing on the GFP_NOFS | __GFP_NOFAIL allocations in the filesystem 
> > code, the kernel oom killer independent of memcg never gets called because 
> > !__GFP_FS and they'll simply loop around the page allocator forever.
> > 
> > In the past, Andrew has expressed the desire to get rid of __GFP_NOFAIL 
> > entirely since it's flawed when combined with GFP_NOFS (and GFP_KERNEL | 
> > __GFP_NOFAIL could simply be reimplemented in the caller) because of the 
> > reason you point out in addition to making it very difficult in the page 
> > allocator to free memory independent of memcg.
> > 
> > So I'm wondering if we should just disable the oom killer in memcg for 
> > __GFP_NOFAIL as you've done here, but not bypass to the root memcg and 
> > just allow them to spin?  I think we should be focused on the fixing the 
> > callers rather than breaking memcg isolation.
> 
> What if the callers simply cannot deal with the allocation failure?
> 84235de394d97 (fs: buffer: move allocation failure loop into the
> allocator) describes one such case when __getblk_slow tries desperately
> to grow buffers relying on the reclaim to free something. As there might
> be no reclaim going on we are screwed.
> 

My suggestion is to spin, not return NULL.  Bypassing to the root memcg 
can lead to a system oom condition whereas if memcg weren't involved at 
all the page allocator would just spin (because of !__GFP_FS).

> That being said, while I do agree with you that we should strive for
> isolation as much as possible there are certain cases when this is
> impossible to achieve without seeing much worse consequences. For now,
> we hope that __GFP_NOFAIL is used very scarcely.

If that's true, why not bypass the per-zone min watermarks in the page 
allocator as well to allow these allocations to succeed?
