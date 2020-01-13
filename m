From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v7 02/10] mm/memcg: fold lru_lock in lock_page_lru
Date: Mon, 13 Jan 2020 20:47:25 +0800
Message-ID: <a095d80d-8e34-c84f-e4be-085a5aae1929@linux.alibaba.com>
References: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com>
 <1577264666-246071-3-git-send-email-alex.shi@linux.alibaba.com>
 <36d7e390-a3d1-908c-d181-4a9e9c8d3d98@yandex-team.ru>
 <952d02c2-8aa5-40bb-88bb-c43dee65c8bc@linux.alibaba.com>
 <2ba8a04e-d8e0-1d50-addc-dbe1b4d8e0f1@yandex-team.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2ba8a04e-d8e0-1d50-addc-dbe1b4d8e0f1-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>



在 2020/1/13 下午5:55, Konstantin Khlebnikov 写道:
>>>>
>>>> index c5b5f74cfd4d..0ad10caabc3d 100644
>>>> --- a/mm/memcontrol.c
>>>> +++ b/mm/memcontrol.c
>>>> @@ -2572,12 +2572,11 @@ static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
>>>>      static void lock_page_lru(struct page *page, int *isolated)
>>>>    {
>>>> -    pg_data_t *pgdat = page_pgdat(page);
>>>> -
>>>> -    spin_lock_irq(&pgdat->lru_lock);
>>>>        if (PageLRU(page)) {
>>>> +        pg_data_t *pgdat = page_pgdat(page);
>>>>            struct lruvec *lruvec;
>>>>    +        spin_lock_irq(&pgdat->lru_lock);
>>>
>>> That's wrong. Here PageLRU must be checked again under lru_lock.
>> Hi, Konstantin,
>>
>> For logical remain, we can get the lock and then release for !PageLRU.
>> but I still can figure out the problem scenario. Would like to give more hints?
> 
> That's trivial race: page could be isolated from lru between
> 
> if (PageLRU(page))
> and
> spin_lock_irq(&pgdat->lru_lock);

yes, it could be a problem. guess the following change could helpful:
I will update it in new version.

Thanks a lot!
Alex

-static void lock_page_lru(struct page *page, int *isolated)
-{
-       pg_data_t *pgdat = page_pgdat(page);
-
-       spin_lock_irq(&pgdat->lru_lock);
-       if (PageLRU(page)) {
-               struct lruvec *lruvec;
-
-               lruvec = mem_cgroup_page_lruvec(page, pgdat);
-               ClearPageLRU(page);
-               del_page_from_lru_list(page, lruvec, page_lru(page));
-               *isolated = 1;
-       } else
-               *isolated = 0;
-}
-
-static void unlock_page_lru(struct page *page, int isolated)
-{
-       pg_data_t *pgdat = page_pgdat(page);
-
-       if (isolated) {
-               struct lruvec *lruvec;
-
-               lruvec = mem_cgroup_page_lruvec(page, pgdat);
-               VM_BUG_ON_PAGE(PageLRU(page), page);
-               SetPageLRU(page);
-               add_page_to_lru_list(page, lruvec, page_lru(page));
-       }
-       spin_unlock_irq(&pgdat->lru_lock);
-}
-
 static void commit_charge(struct page *page, struct mem_cgroup *memcg,
                          bool lrucare)
 {
-       int isolated;
+       struct lruvec *lruvec = NULL;

        VM_BUG_ON_PAGE(page->mem_cgroup, page);

@@ -2612,8 +2617,16 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
         * In some cases, SwapCache and FUSE(splice_buf->radixtree), the page
         * may already be on some other mem_cgroup's LRU.  Take care of it.
         */
-       if (lrucare)
-               lock_page_lru(page, &isolated);
+       if (lrucare) {
+               lruvec = lock_page_lruvec_irq(page);
+               if (likely(PageLRU(page))) {
+                       ClearPageLRU(page);
+                       del_page_from_lru_list(page, lruvec, page_lru(page));
+               } else {
+                       unlock_page_lruvec_irq(lruvec);
+                       lruvec = NULL;
+               }
+       }

        /*
         * Nobody should be changing or seriously looking at
@@ -2631,8 +2644,15 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
         */
        page->mem_cgroup = memcg;

-       if (lrucare)
-               unlock_page_lru(page, isolated);
+       if (lrucare && lruvec) {
+               unlock_page_lruvec_irq(lruvec);
+               lruvec = lock_page_lruvec_irq(page);
+
+               VM_BUG_ON_PAGE(PageLRU(page), page);
+               SetPageLRU(page);
+               add_page_to_lru_list(page, lruvec, page_lru(page));
+               unlock_page_lruvec_irq(lruvec);
+       }
 }
