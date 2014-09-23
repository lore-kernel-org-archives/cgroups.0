From: David Rientjes <rientjes@google.com>
Subject: Re: [patch] mm: memcontrol: lockless page counters
Date: Tue, 23 Sep 2014 15:33:45 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1409231527040.22630@chino.kir.corp.google.com>
References: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org> <20140922144436.GG336@dhcp22.suse.cz> <20140922155049.GA6630@cmpxchg.org> <20140922172800.GA4343@dhcp22.suse.cz> <20140922195829.GA5197@cmpxchg.org> <20140923132553.GB10046@dhcp22.suse.cz>
 <20140923140526.GA15014@cmpxchg.org> <20140923142816.GC10046@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=kQ1fGXc/6pnqBqYr5PL16j1F7JHOn7Stk3i9CwAY/PQ=;
        b=Q9HGHVIZSUrOqHU7/T9pRvsjdN2N09tMa44+09XKBqCkw2vydEt9bIKzVcW+Ogl3qj
         shAgO4bABZmy6/quRiRHHPXkDxFT+wdSfIhjzySaO/GwD0MK9eP91IqDUYMJ/wKEjzt6
         NAgZlIATqCbdBGTbD8/LOBW33CAYsabq6iNzJdkqNfhqHwmaqypiecD5qu+v95X/A1ra
         5bj6ztRqwho/LDkyGNVgBQu53roqCdTCatcqU9hUvk9Dh6wfzz9nOJkRTMFQZPFs1+Qe
         o2BOr8u5x+FpT+ZvujGttOv4VrY5rdBywq9OeqT8S9STpuIEq5C9Q8FDnFUyKBFfWZ7l
         cSBA==
In-Reply-To: <20140923142816.GC10046@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, Greg Thelen <gthelen@google.com>, Dave Hansen <dave@sr71.net>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014, Michal Hocko wrote:

> On Tue 23-09-14 10:05:26, Johannes Weiner wrote:
> [...]
> > That's one way to put it.  But the way I see it is that I remove a
> > generic resource counter and replace it with a pure memory counter
> > which I put where we account and limit memory - with one exception
> > that is hardly worth creating a dedicated library file for.
> 
> So you completely seem to ignore people doing CONFIG_CGROUP_HUGETLB &&
> !CONFIG_MEMCG without any justification and hiding it behind performance
> improvement which those users even didn't ask for yet.
> 
> All that just to not have one additional header and c file hidden by
> CONFIG_PAGE_COUNTER selected by both controllers. No special
> configuration option is really needed for CONFIG_PAGE_COUNTER.
> 

I'm hoping that if there is a merge that there is not an implicit reliance 
on struct page_cgroup for the hugetlb cgroup.  We boot a lot of our 
machines with very large numbers of hugetlb pages on the kernel command 
line (>95% of memory) and can save hundreds of megabytes (meaning more 
overcommit hugepages!) by freeing unneeded and unused struct page_cgroup 
for CONFIG_SPARSEMEM.

> > I only explained my plans of merging all memory controllers because I
> > assumed we could ever be on the same page when it comes to this code.
> 
> I doubt this is a good plan but I might be wrong here. The main thing
> stays there is no good reason to make hugetlb depend on memcg right now
> and such a change _shouldn't_ be hidden behind an unrelated change. From
> hugetlb container point of view this is just a different counter which
> doesn't depend on memcg. I am really surprised you are pushing for this
> so hard right now because it only distracts from the main motivation of
> your patch.
> 

I could very easily imagine a user who would like to use hugetlb cgroup 
without memcg if hugetlb cgroup would charge reserved but unmapped hugetlb 
pages to its cgroup as well.  It's quite disappointing that the hugetlb 
cgroup allows a user to map 100% of a machine's hugetlb pages from the 
reserved pool while its hugetlb cgroup limit is much smaller since this 
prevents anybody else from using the global resource simply because 
someone has reserved but not faulted hugepages.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
