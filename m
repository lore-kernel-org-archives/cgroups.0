From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch] mm: memcontrol: lockless page counters
Date: Tue, 23 Sep 2014 16:28:16 +0200
Message-ID: <20140923142816.GC10046@dhcp22.suse.cz>
References: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org>
 <20140922144436.GG336@dhcp22.suse.cz>
 <20140922155049.GA6630@cmpxchg.org>
 <20140922172800.GA4343@dhcp22.suse.cz>
 <20140922195829.GA5197@cmpxchg.org>
 <20140923132553.GB10046@dhcp22.suse.cz>
 <20140923140526.GA15014@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140923140526.GA15014-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 23-09-14 10:05:26, Johannes Weiner wrote:
[...]
> That's one way to put it.  But the way I see it is that I remove a
> generic resource counter and replace it with a pure memory counter
> which I put where we account and limit memory - with one exception
> that is hardly worth creating a dedicated library file for.

So you completely seem to ignore people doing CONFIG_CGROUP_HUGETLB &&
!CONFIG_MEMCG without any justification and hiding it behind performance
improvement which those users even didn't ask for yet.

All that just to not have one additional header and c file hidden by
CONFIG_PAGE_COUNTER selected by both controllers. No special
configuration option is really needed for CONFIG_PAGE_COUNTER.

> I only explained my plans of merging all memory controllers because I
> assumed we could ever be on the same page when it comes to this code.

I doubt this is a good plan but I might be wrong here. The main thing
stays there is no good reason to make hugetlb depend on memcg right now
and such a change _shouldn't_ be hidden behind an unrelated change. From
hugetlb container point of view this is just a different counter which
doesn't depend on memcg. I am really surprised you are pushing for this
so hard right now because it only distracts from the main motivation of
your patch.

> But regardless of that, my approach immediately simplifies Kconfig,
> Makefiles, #includes, and you haven't made a good point why the
> hugetlb controller depending on memcg would harm anybody in real life.

Usecases for hugetlb and memcg controllers have basically zero overlap
they simply manage different resources and so it is natural to use one
without the other.
-- 
Michal Hocko
SUSE Labs
