From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v8 03/10] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 21 Jan 2020 11:00:05 -0500
Message-ID: <20200121160005.GA69293@cmpxchg.org>
References: <1579143909-156105-1-git-send-email-alex.shi@linux.alibaba.com>
 <1579143909-156105-4-git-send-email-alex.shi@linux.alibaba.com>
 <20200116215222.GA64230@cmpxchg.org>
 <9ee80b68-a78f-714a-c727-1f6d2b4f87ea@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=RGHqVegSf46OSrC+vq5Pv4eGAqLOtAwhyN30PfSx9gU=;
        b=zoinFZ0mYrahd5Hl1dR/pT8vt/qq41K+qA8Hu0uEzs6mlFAFNlvnAch12rsopzsna0
         MNXC+r7/nPCC9+9CUKJwbajVlDzmdO6Qgu+H3wuh85tZslqyxdccc4VrsLuTqhRfyDyd
         MGVpXxoWhYOpTRPzk6Z62zIvWWq9vGnpCkB/mRCo54/h0TzeVtku4lgq589YqsBHdkbJ
         dnHSE4oCmvIZnG4aEQ3l4mcwVPt9P7qoGGUTGBqLcU8WjhYHGZFAjN9MF1ZnenLyrxVD
         VMWieaMITU5HC9uhCOAsCsHkG3XVRElBFX2UKbnzLw9BhbBEG3q0JF9z3KxmQ6wWDu4Q
         GiaA==
Content-Disposition: inline
In-Reply-To: <9ee80b68-a78f-714a-c727-1f6d2b4f87ea-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Qian Cai <cai-J5quhbR+WMc@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aneesh Ku

On Mon, Jan 20, 2020 at 08:58:09PM +0800, Alex Shi wrote:
> 
> 
> 在 2020/1/17 上午5:52, Johannes Weiner 写道:
> 
> > You simply cannot serialize on page->mem_cgroup->lruvec when
> > page->mem_cgroup isn't stable. You need to serialize on the page
> > itself, one way or another, to make this work.
> > 
> > 
> > So here is a crazy idea that may be worth exploring:
> > 
> > Right now, pgdat->lru_lock protects both PageLRU *and* the lruvec's
> > linked list.
> > 
> > Can we make PageLRU atomic and use it to stabilize the lru_lock
> > instead, and then use the lru_lock only serialize list operations?
> > 
> 
> Hi Johannes,
> 
> I am trying to figure out the solution of atomic PageLRU, but is 
> blocked by the following sitations, when PageLRU and lru list was protected
> together under lru_lock, the PageLRU could be a indicator if page on lru list
> But now seems it can't be the indicator anymore.
> Could you give more clues of stabilization usage of PageLRU?

There are two types of PageLRU checks: optimistic and deterministic.

The check in activate_page() for example is optimistic and the result
unstable, but that's okay, because if we miss a page here and there
it's not the end of the world.

But the check in __activate_page() is deterministic, because we need
to be sure before del_page_from_lru_list(). Currently it's made
deterministic by testing under the lock: whoever acquires the lock
first gets to touch the LRU state. The same can be done with an atomic
TestClearPagLRU: whoever clears the flag first gets to touch the LRU
state (the lock is then only acquired to not corrupt the linked list,
in case somebody adds or removes a different page at the same time).

I.e. in my proposal, if you want to get a stable read of PageLRU, you
have to clear it atomically. But AFAICS, everybody who currently does
need a stable read either already clears it or can easily be converted
to clear it and then set it again (like __activate_page and friends).

> __page_cache_release/release_pages/compaction            __pagevec_lru_add
> if (TestClearPageLRU(page))                              if (!PageLRU())
>                                                                 lruvec_lock();
>                                                                 list_add();
>         			                                lruvec_unlock();
>         			                                SetPageLRU() //position 1
>         lock_page_lruvec_irqsave(page, &flags);
>         del_page_from_lru_list(page, lruvec, ..);
>         unlock_page_lruvec_irqrestore(lruvec, flags);
>                                                                 SetPageLRU() //position 2

Hm, that's not how __pagevec_lru_add() looks. In fact,
__pagevec_lru_add_fn() has a BUG_ON(PageLRU).

That's because only one thread can own the isolation state at a time.

If PageLRU is set, only one thread can claim it. Right now, whoever
takes the lock first and clears it wins. When we replace it with
TestClearPageLRU, it's the same thing: only one thread can win.

And you cannot set PageLRU, unless you own it. Either you isolated the
page using TestClearPageLRU, or you allocated a new page.

So you can have multiple threads trying to isolate a page from the LRU
list, hence the atomic testclear. But no two threads should ever be
racing to add a page to the LRU list, because only one thread can own
the isolation state.

With the atomic PageLRU flag, the sequence would be this:

__pagevec_lru_add:

  BUG_ON(PageLRU()) // Caller *must* own the isolation state

  lruvec_lock()     // The lruvec is stable, because changing
                    // page->mem_cgroup requires owning the
                    // isolation state (PageLRU) and we own it

  list_add()        // Linked list protected by lru_lock

  lruvec_unlock()

  SetPageLRU()      // The page has been added to the linked
                    // list, give up our isolation state. Once
                    // this flag becomes visible, other threads
                    // can isolate the page from the LRU list
