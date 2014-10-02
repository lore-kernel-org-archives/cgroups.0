From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 1/3] mm: memcontrol: do not kill uncharge batching in
 free_pages_and_swap_cache
Date: Thu, 2 Oct 2014 11:57:50 -0400
Message-ID: <20141002155750.GB2035@cmpxchg.org>
References: <1411571338-8178-1-git-send-email-hannes@cmpxchg.org>
 <1411571338-8178-2-git-send-email-hannes@cmpxchg.org>
 <20140924124234.3fdb59d6cdf7e9c4d6260adb@linux-foundation.org>
 <20140924210322.GA11017@cmpxchg.org>
 <20140925134403.GA11080@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140925134403.GA11080@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Vladimir Davydov <vdavydov@parallels.com>, Dave Hansen <dave@sr71.net>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 03:44:03PM +0200, Michal Hocko wrote:
> On Wed 24-09-14 17:03:22, Johannes Weiner wrote:
> [...]
> > In release_pages, break the lock at least every SWAP_CLUSTER_MAX (32)
> > pages, then remove the batching from free_pages_and_swap_cache.
> 
> Actually I had something like that originally but then decided to
> not change the break out logic to prevent from strange and subtle
> regressions. I have focused only on the memcg batching POV and led the
> rest untouched.
> 
> I do agree that lru_lock batching can be improved as well. Your change
> looks almost correct but you should count all the pages while the lock
> is held otherwise you might happen to hold the lock for too long just
> because most pages are off the LRU already for some reason. At least
> that is what my original attempt was doing. Something like the following
> on top of the current patch:

Yep, that makes sense.

Would you care to send it in such that Andrew can pick it up?  Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
