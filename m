From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 02/11] memcg: Reclaim when more than one page needed.
Date: Tue, 26 Jun 2012 02:17:45 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206260214310.16020@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-3-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206252106430.26640@chino.kir.corp.google.com> <4FE960D6.4040409@parallels.com>
 <alpine.DEB.2.00.1206260146010.16020@chino.kir.corp.google.com> <4FE97C20.8010500@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=ZRSNLiWPt0IiVRG0SzGeFyXLdio8QkIovvQZEXu8x7g=;
        b=H5Pye0d3LPVoOZpQ730cIg2Fa+/dRL0UvB7ve/9b2Y0sNCP1tiJQgyi9zAl7VWFRyZ
         iaR0nUfd8bOHja2TytH1c0U2nT4UO6OG3lpvrdb7LT/tQ93M8e5InkXC2toF9OWyGlap
         /P02gXn80mBHEkyAy1TsJyUGERWye47Mjb/yMzEtn7i5w6QLSY2LrxPlPYnRjaXb4cZU
         8YCY6otbtNdWCntU6KGF5DlS8OLogBDLW5IBYW0syK40NTp3WgiyvRZ+pNzpsArch2Jw
         LKRsNKhe82s1QTMd3wfVM1bwObV6Ub4iRmobSgTUFUbf2WbtYTVMlR+b2Me4l1Gu4kqY
         smiQ==
In-Reply-To: <4FE97C20.8010500@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Suleiman Souhlal <suleiman@google.com>

On Tue, 26 Jun 2012, Glauber Costa wrote:

> > Nope, have you checked the output of /sys/kernel/slab/.../order when
> > running slub?  On my workstation 127 out of 316 caches have order-2 or
> > higher by default.
> > 
> 
> Well, this is still on the side of my argument, since this is still a majority
> of them being low ordered.

Ok, so what happens if I pass slub_min_order=2 on the command line?  We 
never retry?

> The code here does not necessarily have to retry -
> if I understand it correctly - we just retry for very small allocations
> because that is where our likelihood of succeeding is.
> 

Well, the comment for NR_PAGES_TO_RETRY says

	/*
	 * We need a number that is small enough to be likely to have been
	 * reclaimed even under pressure, but not too big to trigger unnecessary 
	 * retries
	 */

and mmzone.h says

	/*
	 * PAGE_ALLOC_COSTLY_ORDER is the order at which allocations are deemed
	 * costly to service.  That is between allocation orders which should
	 * coalesce naturally under reasonable reclaim pressure and those which
	 * will not.
	 */
	#define PAGE_ALLOC_COSTLY_ORDER 3

so I'm trying to reconcile which one is correct.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
