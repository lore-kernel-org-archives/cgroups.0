From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 03/12] mm: huge_memory: use GFP_TRANSHUGE when charging
 huge pages
Date: Tue, 17 Jun 2014 11:30:18 -0400
Message-ID: <20140617153018.GA7331@cmpxchg.org>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
 <1402948472-8175-4-git-send-email-hannes@cmpxchg.org>
 <20140617134745.GB19886@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=DZYmVJTqxe6uBmGTNQ7gTk4vwL+o2BVbXcOyHAKK0qQ=;
	b=a+u22Ai8Lszavo+e2MKl1quKEZjf6XNDT3F9vpwRQtMfZurHRGpNjZvP+AJ2s09O0qUvkrvzxDjPwBRepDlkv9Q2hmZUrjKF2Mvs0QbTUVhKLLh13yTBzEhB6zp/aYptIzej5YPq6/xNU19AazZJ8NYL2RJ9EEO8IqmTFroD1uc=;
Content-Disposition: inline
In-Reply-To: <20140617134745.GB19886@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 03:47:45PM +0200, Michal Hocko wrote:
> On Mon 16-06-14 15:54:23, Johannes Weiner wrote:
> > Transparent huge page charges prefer falling back to regular pages
> > rather than spending a lot of time in direct reclaim.
> > 
> > Desired reclaim behavior is usually declared in the gfp mask, but THP
> > charges use GFP_KERNEL and then rely on the fact that OOM is disabled
> > for THP charges, and that OOM-disabled charges currently skip reclaim.
> 
> OOM-disabled charges do one round of reclaim currently.

Oops, fixed in v4.

> > Needless to say, this is anything but obvious and quite error prone.
> > 
> > Convert THP charges to use GFP_TRANSHUGE instead, which implies
> > __GFP_NORETRY, to indicate the low-latency requirement.
> 
> OK, this makes sense. It would be ideal if we could use the same gfp as
> for allocation but that would be too much churn I guess because some
> allocator use a allocation helper which deduces proper gfp flags without
> giving them back to the caller.
> 
> Nevertheless, I would still prefer if 05/12 was moved before
> this patch because this is strictly speaking a behavior change.

Yes, that's bungled up, thanks for catching that.  So here is the
order I put it in (reverse git history order of course):

commit d0d31c8d4f4cf91edcffa704e8c65ca62af24cf8
Author: Johannes Weiner <hannes@cmpxchg.org>
Date:   Mon Apr 14 08:16:09 2014 -0400

    mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL charges
    
    There is no reason why oom-disabled and __GFP_NOFAIL charges should
    try to reclaim only once when every other charge tries several times
    before giving up.  Make them all retry the same number of times.
    
    Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

commit 69f5c6c1a6553a04d7701012a73b2477df8d5a19
Author: Johannes Weiner <hannes@cmpxchg.org>
Date:   Thu Jun 5 22:02:26 2014 -0400

    mm: huge_memory: use GFP_TRANSHUGE when charging huge pages
    
    Transparent huge page charges prefer falling back to regular pages
    rather than spending a lot of time in direct reclaim.
    
    Desired reclaim behavior is usually declared in the gfp mask, but THP
    charges use GFP_KERNEL and then rely on the fact that OOM is disabled
    for THP charges, and that OOM-disabled charges don't retry reclaim.
    Needless to say, this is anything but obvious and quite error prone.
    
    Convert THP charges to use GFP_TRANSHUGE instead, which implies
    __GFP_NORETRY, to indicate the low-latency requirement.
    
    Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
    Acked-by: Michal Hocko <mhocko@suse.cz>

commit d485e6b4ed62885d54c57c18c5427e2f174c9012
Author: Johannes Weiner <hannes@cmpxchg.org>
Date:   Tue May 27 15:23:18 2014 -0400

    mm: memcontrol: reclaim at least once for __GFP_NORETRY
    
    Currently, __GFP_NORETRY tries charging once and gives up before even
    trying to reclaim.  Bring the behavior on par with the page allocator
    and reclaim at least once before giving up.
    
    Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
    Acked-by: Michal Hocko <mhocko@suse.cz>

This first changes __GFP_NORETRY to provide THP-required semantics,
then switches THP over to it, then fixes oom-disabled/NOFAIL charges.

Does that make more sense?

> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Anyway
> Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
