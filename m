From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v14 15/20] mm/swap: serialize memcg changes during
 pagevec_lru_move_fn
Date: Sat, 4 Jul 2020 14:33:30 +0100
Message-ID: <20200704133330.GP25523@casper.infradead.org>
References: <1593752873-4493-1-git-send-email-alex.shi@linux.alibaba.com>
 <1593752873-4493-16-git-send-email-alex.shi@linux.alibaba.com>
 <CALYGNiOkA_ZsycF_hqm3XLk55Ek1Mo9w1gO=6EeE35fUtA0i_w@mail.gmail.com>
 <56e395c6-81e7-7163-0d4f-42b91573289f@linux.alibaba.com>
 <20200704113944.GN25523@casper.infradead.org>
 <b6caf0d7-266e-55ea-0c88-656c800af1e3@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=WX43RKw0+FGdp9bNmImS/2sAa8MNXnNJwwbZw51kMdQ=; b=P6cgPErml8i03xIAD2T2msZxIG
        m8LjhA4KE1VmUJ/jww8W5OIDqMwXNvGXmLJGm4V84vgiHw1Q1sLRBY/KET+hmBWm6YagHqDZOxy1S
        1Cl5YP8V6suzo6wGWC78gJS46MGJpjwrQBxUv7MUsIRJcX5aG7Y+vlV7q/wTWzQA54upC4dU6oywQ
        vNfwjiOvGOpXyTBDyxyFo9KCpqLv4grXWw6HZGrK8fRYYgmfV9wk7OjDtMPRq144R4RlYp+6bxG0r
        b8KTCgPZUJhUs9VACBdSKb2OCv3N6WdQNjMqc6ky2TBcBYCmQnMTCLhZTAfd9qaKHaEari7D+2tOb
        do6pVwFg==;
Content-Disposition: inline
In-Reply-To: <b6caf0d7-266e-55ea-0c88-656c800af1e3-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?utf-8?B?0JrQvtC90YHRgtCw0L3RgtC40L0g0KXQu9C10LHQvdC40LrQvtCy?= <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Sat, Jul 04, 2020 at 09:12:46PM +0800, Alex Shi wrote:
> 在 2020/7/4 下午7:39, Matthew Wilcox 写道:
> > On Sat, Jul 04, 2020 at 07:34:59PM +0800, Alex Shi wrote:
> >> That's a great idea! Guess what the new struct we need would be like this?
> >> I like to try this. :)
> >>
> >>
> >> diff --git a/include/linux/pagevec.h b/include/linux/pagevec.h
> >> index 081d934eda64..d62778c8c184 100644
> >> --- a/include/linux/pagevec.h
> >> +++ b/include/linux/pagevec.h
> >> @@ -20,7 +20,7 @@
> >>  struct pagevec {
> >>         unsigned char nr;
> >>         bool percpu_pvec_drained;
> >> -       struct page *pages[PAGEVEC_SIZE];
> >> +       struct list_head veclist;
> >>  };
> > 
> > pagevecs are used not just for LRU.  If you want to use a list_head for
> > LRU then define a new structure.
> 
> yes, there are much page don't use page->lru, like slab etc. we need a new struct.

That's not what I mean.  Slab pages aren't on the LRU anyway.

Consider the callers of page_cache_delete_batch().  These use a pagevec
for a non-LRU purpose, and they will be much slower with a list_head than
with an array.
