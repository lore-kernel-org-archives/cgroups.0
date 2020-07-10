From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v14 07/20] mm/thp: narrow lru locking
Date: Fri, 10 Jul 2020 22:09:42 +0800
Message-ID: <d4d8bbba-12af-45c2-a35d-58f962ca5f9a@linux.alibaba.com>
References: <1593752873-4493-1-git-send-email-alex.shi@linux.alibaba.com>
 <1593752873-4493-8-git-send-email-alex.shi@linux.alibaba.com>
 <124eeef1-ff2b-609e-3bf6-a118100c3f2a@linux.alibaba.com>
 <20200706113513.GY25523@casper.infradead.org>
 <alpine.LSU.2.11.2007062059420.2793@eggly.anvils>
 <20200709154816.wieg5thfejyv2h2l@box>
 <e87f7dd1-41c4-3392-f1df-982dd28c0617@linux.alibaba.com>
 <20200710112831.jrv4hzjzjqtxtc7u@box>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200710112831.jrv4hzjzjqtxtc7u@box>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



在 2020/7/10 下午7:28, Kirill A. Shutemov 写道:
>>   *           hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
>>   *           anon_vma->rwsem
>>   *             mm->page_table_lock or pte_lock
>> - *               pgdat->lru_lock (in mark_page_accessed, isolate_lru_page)
>>   *               swap_lock (in swap_duplicate, swap_info_get)
>>   *                 mmlist_lock (in mmput, drain_mmlist and others)
>>   *                 mapping->private_lock (in __set_page_dirty_buffers)
>> - *                   mem_cgroup_{begin,end}_page_stat (memcg->move_lock)
>> + *                   lock_page_memcg move_lock (in __set_page_dirty_buffers)
>>   *                     i_pages lock (widely used)
>> + *                       lock_page_lruvec_irq lruvec->lru_lock
> I think it has to be
> 			    lruvec->lru_lock (in lock_page_lruvec_irq)

Good catch! I will update it in next version.
Thanks!

> 
> No?

> 
>>   *                 inode->i_lock (in set_page_dirty's __mark_inode_dirty)
>>   *                 bdi.wb->list_lock (in set_page_dirty's __mark_inode_dirty)
>>   *                   sb_lock (within inode_lock in fs/fs-writeback.c)
>>
>>> local_irq_disable() also deserves a comment.
>>>
>> yes, I will add a comment for this. Do you mind give reviewed-by for this patch?
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Thanks a lot! :)

