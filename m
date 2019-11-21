From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: fix unsafe page -> lruvec lookups with cgroup charge
 migration
Date: Thu, 21 Nov 2019 15:56:31 -0500
Message-ID: <20191121205631.GA487872@cmpxchg.org>
References: <20191120165847.423540-1-hannes@cmpxchg.org>
 <alpine.LSU.2.11.1911201836220.1090@eggly.anvils>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jo8ATEWyaSv/vLCn6HnPEaOlsTqvflPgdCXI72jAtAM=;
        b=cwuJLrMBZhPa5DBRo45PuWX50UB2Z5+gnbtBmxVA7l/W0adG0YbnCA+7EREee4ihMc
         /RtO2VS4M4autGBGzWZTC46Jv/LvU147g9Fe9ZrChLgdMY+2MhaYCoaBjmPAKML/GefK
         VsbDCS5rx0r5a8Yr8KgX4nvZa37JnXmMlmF9QekitglonB7f4EXFQTtRmVDQb2Zbltlx
         KwQpiRpPbM2LMBteWoe4r9FvgKpzKFjVlySacY13KC2eiNkTNw4bwv7DtJGh5FIwLoM2
         eD8G2mK3gounHPRVqZB7S/qn3WcDBAFP289D4mndKgQmZUjv19S70bmW84IqqAvtTHWJ
         c2Vg==
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1911201836220.1090@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@suse.com>, Alex Shi <alex.shi@linux.alibaba.com>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Nov 20, 2019 at 07:15:27PM -0800, Hugh Dickins wrote:
> It like the way you've rearranged isolate_lru_page() there, but I
> don't think it amounts to more than a cleanup.  Very good thinking
> about the odd "lruvec->pgdat = pgdat" case tucked away inside
> mem_cgroup_page_lruvec(), but actually, what harm does it do, if
> mem_cgroup_move_account() changes page->mem_cgroup concurrently?
> 
> You say use-after-free, but we have spin_lock_irq here, and the
> struct mem_cgroup (and its lruvecs) cannot be freed until an RCU
> grace period expires, which we rely upon in many places, and which
> cannot happen until after the spin_unlock_irq.

You are correct, I missed the rcu locking implied by the
spinlock. With this, the justification for this patch is wrong.

But all of this is way too fragile and error-prone for my taste. We're
looking up a page's lruvec in a scope that does not promise at all
that the lruvec will be the page's. Luckily we currently don't touch
the lruvec outside of the PageLRU branch, but this subtlety is
entirely non-obvious from the code.

I will put more thought into this. Let's scrap this patch for now.
