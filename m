From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v16 00/22] per memcg lru_lock
Date: Mon, 20 Jul 2020 11:01:10 +0800
Message-ID: <5f2401d3-dd4f-cbc6-8cb4-4e92fc64998c@linux.alibaba.com>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0UcKVyTXQ=tGv_uMV+fSvoH_-cuG9zA_zhE+S8Ou11gt=w@mail.gmail.com>
 <57c619e7-da7e-198e-3de8-530bf19b9450@linux.alibaba.com>
 <alpine.LSU.2.11.2007190801490.3521@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.11.2007190801490.3521-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>



在 2020/7/19 下午11:23, Hugh Dickins 写道:
> I noticed that 5.8-rc5, with lrulock v16 applied, took significantly
> longer to run loads than without it applied, when there should have been
> only slight differences in system time. Comparing /proc/vmstat, something
> that stood out was "pgrotated 0" for the patched kernels, which led here:
> 
> If pagevec_lru_move_fn() is now to TestClearPageLRU (I have still not
> decided whether that's good or not, but assume here that it is good),
> then functions called though it must be changed not to expect PageLRU!
> 
> Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Good catch!

Thanks a lot, Hugh! 
except 6 changes should apply, looks we add one more in swap.c file to stop
!PageRLU further actions!

Many Thanks!
Alex

@@ -649,7 +647,7 @@ void deactivate_file_page(struct page *page)
         * In a workload with many unevictable page such as mprotect,
         * unevictable page deactivation for accelerating reclaim is pointless.
         */
-       if (PageUnevictable(page))
+       if (PageUnevictable(page) || !PageLRU(page))
                return;

        if (likely(get_page_unless_zero(page))) {
