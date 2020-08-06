From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v17 13/21] mm/lru: introduce TestClearPageLRU
Date: Thu, 6 Aug 2020 09:54:08 +0800
Message-ID: <f9fa46a4-b341-2470-ce18-03379b9ea5c2@linux.alibaba.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-14-git-send-email-alex.shi@linux.alibaba.com>
 <9b906469-38fb-8a4e-9a47-d617c7669579@linux.alibaba.com>
 <CAKgT0Ud1+FkJcTXR0MxZYFxd7mr=opdXfXKTqkmiu4NNMyT4bg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgT0Ud1+FkJcTXR0MxZYFxd7mr=opdXfXKTqkmiu4NNMyT4bg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>



在 2020/8/6 上午6:43, Alexander Duyck 写道:
>> @@ -878,9 +877,8 @@ void release_pages(struct page **pages, int nr)
>>                                 spin_lock_irqsave(&locked_pgdat->lru_lock, flags);
>>                         }
>>
>> -                       lruvec = mem_cgroup_page_lruvec(page, locked_pgdat);
>> -                       VM_BUG_ON_PAGE(!PageLRU(page), page);
>>                         __ClearPageLRU(page);
>> +                       lruvec = mem_cgroup_page_lruvec(page, locked_pgdat);
>>                         del_page_from_lru_list(page, lruvec, page_off_lru(page));
>>                 }
>>
> The more I look at this piece it seems like this change wasn't really
> necessary. If anything it seems like it could catch potential bugs as
> it was testing for the PageLRU flag before and then clearing it
> manually anyway. In addition it doesn't reduce the critical path by
> any significant amount so I am not sure these changes are providing
> any benefit.

Don't know hat kind of bug do you mean here, since the page is no one using, means
no one could ClearPageLRU in other place,  so if you like to keep the VM_BUG_ON_PAGE,
that should be ok.

Thanks!
Alex
