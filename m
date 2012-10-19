From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v5 06/14] memcg: kmem controller infrastructure
Date: Fri, 19 Oct 2012 13:34:04 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1210191331400.17804@chino.kir.corp.google.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-7-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1210171515290.20712@chino.kir.corp.google.com> <507FCA90.8060307@parallels.com>
 <alpine.DEB.2.00.1210181454100.30894@chino.kir.corp.google.com> <5081269B.5000603@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=zqwIb9BppTXaEw2IShDqBt8AqcBM/LUoYTMf3a59X4w=;
        b=dcdlkq1SV7VVSTvZ5MmEqlpv+rOjS8bZVMHrXO4vd3OZcMIt/3DyRR7cmQsQR9Lmrt
         97mPhtrrv8GiEkaa45p+BkE8bMGvj/4jcZWasd6eTw/i0uBbZ7moi29sCpjL0T+plcMJ
         xBxMorU+agTXPcO5jFWX0SmUlH8q5cAc/ECEdjpy3bW5p2SAT6nYqdTMNVI85+CgvGqA
         oVY6OJIfPfLFyoGWZx5yGZHdv/cM4W9aketRooaxmSW4mXohQ4z9gC5LrnrDhggvxoiO
         msr2AiBU+rdFl1mwfRDaDH7tIecnBPOedZgNQCIsfP/ptDW4M9UFP8oKHpIGWMpCYDBw
         193Q==
In-Reply-To: <5081269B.5000603@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, devel@openvz.org, linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>

On Fri, 19 Oct 2012, Glauber Costa wrote:

> >>> What about gfp & __GFP_FS?
> >>>
> >>
> >> Do you intend to prevent or allow OOM under that flag? I personally
> >> think that anything that accepts to be OOM-killed should have GFP_WAIT
> >> set, so that ought to be enough.
> >>
> > 
> > The oom killer in the page allocator cannot trigger without __GFP_FS 
> > because direct reclaim has little chance of being very successful and 
> > thus we end up needlessly killing processes, and that tends to happen 
> > quite a bit if we dont check for it.  Seems like this would also happen 
> > with memcg if mem_cgroup_reclaim() has a large probability of failing?
> > 
> 
> I can indeed see tests for GFP_FS in some key locations in mm/ before
> calling the OOM Killer.
> 
> Should I test for GFP_IO as well?

It's not really necessary, if __GFP_IO isn't set then it wouldn't make 
sense for __GFP_FS to be set.

> If the idea is preventing OOM to
> trigger for allocations that can write their pages back, how would you
> feel about the following test:
> 
> may_oom = (gfp & GFP_KERNEL) && !(gfp & __GFP_NORETRY) ?
> 

I would simply copy the logic from the page allocator and only trigger oom 
for __GFP_FS and !__GFP_NORETRY.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
