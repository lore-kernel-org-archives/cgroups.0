From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] mm: memcontrol: do not miss MEMCG_MAX events for
 enforced allocations
Date: Tue, 5 Jul 2022 13:55:17 -0700
Message-ID: <YsSlNbKuprI97TtF@castle>
References: <20220702033521.64630-1-roman.gushchin@linux.dev>
 <YsMDdjc5SXMAuV2l@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657054523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VhLg0Cla8ai3X3/kkktyXt1O9nP6eFUzBhnC95wXg1g=;
        b=boaUMGQrEYaa64Ejun5RDXRXFn8PWPBU1pEwrfi8rXGvOFIimvDtjTADvibcbOTMbTMh7C
        m1tF2o0DFhgshmtR/vEjYI1ipC8YECkYlXg0qma7hbvcvuvC00ejkH4eFLHO+KPFS7yp8i
        ieZLyzDLzT0sps0jmhOT0b7o4jzy4eU=
Content-Disposition: inline
In-Reply-To: <YsMDdjc5SXMAuV2l@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yafang Shao <laoar.shao@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Mon, Jul 04, 2022 at 05:12:54PM +0200, Michal Hocko wrote:
> On Fri 01-07-22 20:35:21, Roman Gushchin wrote:
> > Yafang Shao reported an issue related to the accounting of bpf
> > memory: if a bpf map is charged indirectly for memory consumed
> > from an interrupt context and allocations are enforced, MEMCG_MAX
> > events are not raised.
> 
> So I guess this will be a GFP_ATOMIC request failing due to the hard
> limit, right? I think it would be easier to understand if the specific
> allocation request type was mentioned.

It all started from the discussion here:
https://www.spinics.net/lists/linux-mm/msg302319.html

Please, take a look.

> 
> > It's not/less of an issue in a generic case because consequent
> > allocations from a process context will trigger the reclaim and
> > MEMCG_MAX events. However a bpf map can belong to a dying/abandoned
> > memory cgroup, so it might never happen. So the cgroup can
> > significantly exceed the memory.max limit without even triggering
> > MEMCG_MAX events.
> 
> More on that in other reply.
> 
> > Fix this by making sure that we never enforce allocations without
> > raising a MEMCG_MAX event.
> > 
> > Reported-by: Yafang Shao <laoar.shao@gmail.com>
> > Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Shakeel Butt <shakeelb@google.com>
> > Cc: Muchun Song <songmuchun@bytedance.com>
> > Cc: cgroups@vger.kernel.org
> > Cc: linux-mm@kvack.org
> > Cc: bpf@vger.kernel.org
> 
> The patch makes sense to me though even without the weird charge to a
> dead memcg aspect. It is true that a very calm memcg can trigger the
> even much later after a GFP_ATOMIC charge (or __GFP_HIGH in general)
> fails.

Good point!

> 
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!
