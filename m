From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v14 15/20] mm/swap: serialize memcg changes during
 pagevec_lru_move_fn
Date: Sat, 4 Jul 2020 19:34:59 +0800
Message-ID: <56e395c6-81e7-7163-0d4f-42b91573289f@linux.alibaba.com>
References: <1593752873-4493-1-git-send-email-alex.shi@linux.alibaba.com>
 <1593752873-4493-16-git-send-email-alex.shi@linux.alibaba.com>
 <CALYGNiOkA_ZsycF_hqm3XLk55Ek1Mo9w1gO=6EeE35fUtA0i_w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALYGNiOkA_ZsycF_hqm3XLk55Ek1Mo9w1gO=6EeE35fUtA0i_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?0JrQvtC90YHRgtCw0L3RgtC40L0g0KXQu9C10LHQvdC40LrQvtCy?= <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



在 2020/7/3 下午5:13, Konstantin Khlebnikov 写道:
>> @@ -976,7 +983,7 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec)
>>   */
>>  void __pagevec_lru_add(struct pagevec *pvec)
>>  {
>> -       pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn);
>> +       pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn, true);
>>  }
> It seems better to open code version in lru_add than adding a bool
> argument which is true just for one user.

Right, I will rewrite this part as your suggestion. Thanks!

> 
> Also with this new lru protection logic lru_add could be optimized:
> It could prepare a list of pages and under lru_lock do only list
> splice and bumping counter.
> Since PageLRU isn't set yet nobody could touch these pages in lru.
> After that lru_add could iterate pages from first to last without
> lru_lock to set PageLRU and drop reference.
> 
> So, lru_add will do O(1) operations under lru_lock regardless of the
> count of pages it added.
> 
> Actually per-cpu vector for adding could be replaced with per-cpu
> lists and\or per-lruvec atomic slist.
> Thus incommig pages will be already in list structure rather than page vector.
> This allows to accumulate more pages and offload adding to kswapd or
> direct reclaim.
> 

That's a great idea! Guess what the new struct we need would be like this?
I like to try this. :)


diff --git a/include/linux/pagevec.h b/include/linux/pagevec.h
index 081d934eda64..d62778c8c184 100644
--- a/include/linux/pagevec.h
+++ b/include/linux/pagevec.h
@@ -20,7 +20,7 @@
 struct pagevec {
        unsigned char nr;
        bool percpu_pvec_drained;
-       struct page *pages[PAGEVEC_SIZE];
+       struct list_head veclist;
 };
