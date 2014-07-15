From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Date: Tue, 15 Jul 2014 18:07:35 +0200
Message-ID: <20140715160735.GB29269@dhcp22.suse.cz>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
 <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
 <20140715155537.GA19454@nhori.bos.redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QgxLQ9JpgU350X3q9ObQ2EKnzDrenvukIHOIYDusuWk=;
        b=0xdFGen3wanaENhAx+F2wMQgXdV7hgVFHQ6VE4RC717WpySRa6jVIfFfcNTwzRtK6o
         KJui3/X+6gqZwjj82BMnSB5toTjYRB3i55Li7J9nzdCDM7dk08qLbrUy02tcUP3OqKso
         Ijd9rsG1qriiUx3NoF9FGkv0hEUNq0CIhxtSBmXA36zwPk3LGjcPrBI3zKFht4crwtdS
         Z+tWimQPS7+mSlMYHeO4M9cGUr+STy0ScB1skG9lbfNE5oEanRpjB7M2MKH4qp/rURn3
         /Hu0Y8yYCd1k0n/zAiTS6/uqgsQdIApnk3CQtuaMBioV7QkDDSbL2YsbXgleprD8HlXY
         rlog==
Content-Disposition: inline
In-Reply-To: <20140715155537.GA19454@nhori.bos.redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue 15-07-14 11:55:37, Naoya Horiguchi wrote:
> On Wed, Jun 18, 2014 at 04:40:45PM -0400, Johannes Weiner wrote:
> ...
> > diff --git a/mm/swap.c b/mm/swap.c
> > index a98f48626359..3074210f245d 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -62,6 +62,7 @@ static void __page_cache_release(struct page *page)
> >  		del_page_from_lru_list(page, lruvec, page_off_lru(page));
> >  		spin_unlock_irqrestore(&zone->lru_lock, flags);
> >  	}
> > +	mem_cgroup_uncharge(page);
> >  }
> >  
> >  static void __put_single_page(struct page *page)
> 
> This seems to cause a list breakage in hstate->hugepage_activelist
> when freeing a hugetlbfs page.

This looks like a fall out from
http://marc.info/?l=linux-mm&m=140475936311294&w=2

I didn't get to review this one but the easiest fix seems to be check
HugePage and do not call uncharge.

> For hugetlbfs, we uncharge in free_huge_page() which is called after
> __page_cache_release(), so I think that we don't have to uncharge here.
> 
> In my testing, moving mem_cgroup_uncharge() inside if (PageLRU) block
> fixed the problem, so if that works for you, could you fold the change
> into your patch?
> 
> Thanks,
> Naoya Horiguchi
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
