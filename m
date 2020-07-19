From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v16 13/22] mm/lru: introduce TestClearPageLRU
Date: Sun, 19 Jul 2020 19:24:06 +0800
Message-ID: <c189ebf6-47a8-bb8f-2c99-a7ddb159b9c9@linux.alibaba.com>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
 <1594429136-20002-14-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0UfLbVRQ4+TOw-XnjuyZqoVmRmWb5_rbEZZ0povYv-n_Lg@mail.gmail.com>
 <072b39ac-b95a-94f1-67a2-3293d4550ff8@linux.alibaba.com>
 <CAKgT0UdDQp_bptKAjG4A4fJQgS5gJuvu6D7LJfKw_wETLtLG_w@mail.gmail.com>
 <530c222e-dfd4-f78e-e9d4-315fad6f816a@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <530c222e-dfd4-f78e-e9d4-315fad6f816a-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>



在 2020/7/19 下午12:45, Alex Shi 写道:
>>>
>>>> It might make it more readable to pull in the later patch that
>>>> modifies isolate_lru_pages that has it using TestClearPageLRU.
>>> As to this change, It has to do in this patch, since any TestClearPageLRU may
>>> cause lru bit miss in the lru list, so the precondication check has to
>>> removed here.
>> So I think some of my cognitive dissonance is from the fact that you
>> really are doing two different things here. You aren't really
>> implementing the full TestClearPageLRU until patch 15. So this patch
>> is doing part of 2a and 2b, and then patch 15 is following up and
>> completing the 2a cases. I still think it might make more sense to
>> pull out the pieces related to 2b and move them into a patch before
>> this with documentation explaining that there should be no competition
>> for the LRU flag because the page has transitioned to a reference
>> count of zero. Then take the remaining bits and combine them with
>> patch 15 since the description for the two is pretty similar.
>>


As to the patch split suggest, actually, Hugh and I talked about a few weeks 
ago when he give me these changes. We both thought keep these changes in this
patch looks better at that time.
If it make you confuse, don't know a changed commit log make it better?

Thanks
Alex

    mm/lru: introduce TestClearPageLRU

    Currently lru_lock still guards both lru list and page's lru bit, that's
    ok. but if we want to use specific lruvec lock on the page, we need to
    pin down the page's lruvec/memcg during locking. Just taking lruvec
    lock first may be undermined by the page's memcg charge/migration. To
    fix this problem, we could take out the page's lru bit clear and use
    it as pin down action to block the memcg changes. That's the reason
    for new atomic func TestClearPageLRU. So now isolating a page need both
    actions: TestClearPageLRU and hold the lru_lock.

    This patch combines PageLRU check and ClearPageLRU into a macro func
    TestClearPageLRU. This function will be used as page isolation
    precondition to prevent other isolations some where else.
    Then there are may non PageLRU page on lru list, need to remove BUG
    checking accordingly.

    There 2 rules for lru bit:
    1, the lru bit still indicate if a page on lru list, just
    in some temporary moment(isolating), the page may have no lru bit when
    it's on lru list.  but the page still must be on lru list when the
    lru bit is set.
    2, have to remove lru bit before delete it from lru list.

    Hugh Dickins pointed that when a page is in freeing path and no one is
    possible to take it, non atomic lru bit clearing is better, like in
    __page_cache_release and release_pages.
    ANd no need get_page() before lru bit clear in isolate_lru_page,
    since it '(1) Must be called with an elevated refcount on the page'.

    As Andrew Morton mentioned this change would dirty cacheline for page
    isn't on LRU. But the lost would be acceptable with Rong Chen
    <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> report:
    https://lkml.org/lkml/2020/3/4/173

    Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
    Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
    Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
    Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
    Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
    Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
    Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
    Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
    Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org


