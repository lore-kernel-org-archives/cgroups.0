From: David Rientjes <rientjes@google.com>
Subject: Re: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL
 allocations
Date: Tue, 3 Dec 2013 22:10:15 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1312032204270.2597@chino.kir.corp.google.com>
References: <20131127225340.GE3556@cmpxchg.org> <alpine.DEB.2.02.1311271526080.22848@chino.kir.corp.google.com> <20131128102049.GF2761@dhcp22.suse.cz> <alpine.DEB.2.02.1311291543400.22413@chino.kir.corp.google.com> <20131202132201.GC18838@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312021452510.13465@chino.kir.corp.google.com> <20131203222511.GU3556@cmpxchg.org> <alpine.DEB.2.02.1312031531510.5946@chino.kir.corp.google.com> <20131204030101.GV3556@cmpxchg.org> <20131204043417.GM10988@dastard>
 <20131204052542.GY3556@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=V7wPbkFEAMEW1jWJUTqGqXTjB3U+l4SzBVjK/2idDZw=;
        b=RLJQRdYT5hG+Dkql3Annl6sMsVsbBISjoD38vbdTaV8RqwyqaPxNyib4cy/YHz8fns
         UhYkTJ4seScBE643nbplatmBVKfGAOFWdUKDyAXRedrxeDFyfbtVFc1VeHZiEt+fR890
         A2Xa02mMvJttXz5qMp5bo+Tnc74re+c8qj5dXuMFoRYxGoXoDJkO9ANCq29Vf/ypDBxY
         aDgzyeAhipSbUpbKbQwg+MvgsfnMOpwE1d77BUt5yrL1ViN1aqLLIQRNHBQaAQ0O5vuS
         0/GVREAmSVgTD2Tvfp/TQcJQJcFTNw3pjFkzdj9v09/89GhevEZRvJt3vp6Cv42Rt2Qw
         ZAow==
In-Reply-To: <20131204052542.GY3556@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013, Johannes Weiner wrote:

> However, the GFP_NOFS | __GFP_NOFAIL task stuck in the page allocator
> may hold filesystem locks that could prevent a third party from
> freeing memory and/or exiting, so we can not guarantee that only the
> __GFP_NOFAIL task is getting stuck, it might well trap other tasks.
> The same applies to open-coded GFP_NOFS allocation loops of course
> unless they cycle the filesystem locks while looping.
> 

Yup.  I think we should do this:

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2631,6 +2631,11 @@ rebalance:
 						pages_reclaimed)) {
 		/* Wait for some write requests to complete then retry */
 		wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
+
+		/* Allocations that cannot fail must allocate from somewhere */
+		if (gfp_mask & __GFP_NOFAIL)
+			alloc_flags |= ALLOC_HARDER;
+
 		goto rebalance;
 	} else {
 		/*

so that it gets the same behavior as GFP_ATOMIC and is allowed to allocate 
from memory reserves (although not enough to totally deplete memory).  We 
need to leave some memory reserves around in case another process with 
__GFP_FS invokes the oom killer and the victim needs memory to exit since 
the GFP_NOFS | __GFP_NOFAIL failure wasn't only because reclaim was 
limited due to !__GFP_FS.

The only downside of this is that it might become harder in the future to 
ever make a case to remove __GFP_NOFAIL entirely since the behavior of the 
page allocator is changed with this and it's not equivalent to coding the 
retry directly in the caller.

On a tangent, GFP_NOWAIT | __GFP_NOFAIL and GFP_ATOMIC | __GFP_NOFAIL 
actually allows allocations to fail.  Nothing currently does that, but I 
wonder if we should do this for correctness:

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2535,17 +2535,19 @@ rebalance:
 		}
 	}
 
-	/* Atomic allocations - we can't balance anything */
-	if (!wait)
-		goto nopage;
-
-	/* Avoid recursion of direct reclaim */
-	if (current->flags & PF_MEMALLOC)
-		goto nopage;
-
-	/* Avoid allocations with no watermarks from looping endlessly */
-	if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
-		goto nopage;
+	if (likely(!(gfp_mask & __GFP_NOFAIL))) {
+		/* Atomic allocations - we can't balance anything */
+		if (!wait)
+			goto nopage;
+
+		/* Avoid recursion of direct reclaim */
+		if (current->flags & PF_MEMALLOC)
+			goto nopage;
+
+		/* Avoid allocations without watermarks from looping forever */
+		if (test_thread_flag(TIF_MEMDIE))
+			goto nopage;
+	}
 
 	/*
 	 * Try direct compaction. The first pass is asynchronous. Subsequent

It can be likely() because the __GFP_NOFAIL restart from the first patch 
above will likely now succeed since there's access to memory reserves and 
we never actually get here but once for __GFP_NOFAIL.  Thoughts on either 
patch?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
