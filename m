From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v17 21/21] mm/lru: revise the comments of lru_lock
Date: Tue, 4 Aug 2020 18:04:34 +0800
Message-ID: <f34e790f-50e6-112c-622f-d7ab804c6d22@linux.alibaba.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-22-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0UfpHjBTHvtZz7=WMhZZAunVYuNMpuYBQCiorERb5seFUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgT0UfpHjBTHvtZz7=WMhZZAunVYuNMpuYBQCiorERb5seFUQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>



在 2020/8/4 上午6:37, Alexander Duyck 写道:
>>
>>  shrink_inactive_list() also diverts any unevictable pages that it finds on the
>> -inactive lists to the appropriate zone's unevictable list.
>> +inactive lists to the appropriate node's unevictable list.
>>
>>  shrink_inactive_list() should only see SHM_LOCK'd pages that became SHM_LOCK'd
>>  after shrink_active_list() had moved them to the inactive list, or pages mapped
> Same here.

lruvec is used per memcg per node actually, and it fallback to node if memcg disabled.
So the comments are still right.

And most of changes just fix from zone->lru_lock to pgdat->lru_lock change.
> 
>> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
>> index 64ede5f150dc..44738cdb5a55 100644
>> --- a/include/linux/mm_types.h
>> +++ b/include/linux/mm_types.h
>> @@ -78,7 +78,7 @@ struct page {
>>                 struct {        /* Page cache and anonymous pages */
>>                         /**
>>                          * @lru: Pageout list, eg. active_list protected by
>> -                        * pgdat->lru_lock.  Sometimes used as a generic list
>> +                        * lruvec->lru_lock.  Sometimes used as a generic list
>>                          * by the page owner.
>>                          */
>>                         struct list_head lru;
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 8af956aa13cf..c92289a4e14d 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -115,7 +115,7 @@ static inline bool free_area_empty(struct free_area *area, int migratetype)
>>  struct pglist_data;
>>
>>  /*
>> - * zone->lock and the zone lru_lock are two of the hottest locks in the kernel.
>> + * zone->lock and the lru_lock are two of the hottest locks in the kernel.
>>   * So add a wild amount of padding here to ensure that they fall into separate
>>   * cachelines.  There are very few zone structures in the machine, so space
>>   * consumption is not a concern here.
> So I don't believe you are using ZONE_PADDING in any way to try and
> protect the LRU lock currently. At least you aren't using it in the
> lruvec. As such it might make sense to just drop the reference to the
> lru_lock here. That reminds me that we still need to review the
> placement of the lru_lock and determine if there might be a better
> placement and/or padding that might improve performance when under
> heavy stress.
> 

Right, is it the following looks better?

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ccc76590f823..0ed520954843 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -113,8 +113,7 @@ static inline bool free_area_empty(struct free_area *area, int migratetype)
 struct pglist_data;

 /*
- * zone->lock and the lru_lock are two of the hottest locks in the kernel.
- * So add a wild amount of padding here to ensure that they fall into separate
+ * Add a wild amount of padding here to ensure datas fall into separate
  * cachelines.  There are very few zone structures in the machine, so space
  * consumption is not a concern here.
  */

Thanks!
Alex
