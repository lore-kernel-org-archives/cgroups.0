From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v7 00/10] per lruvec lru_lock for memcg
Date: Tue, 14 Jan 2020 17:29:17 +0800
Message-ID: <39a72184-c864-4a40-49fd-c27893dd2002@linux.alibaba.com>
References: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com>
 <20191231150514.61c2b8c8354320f09b09f377@linux-foundation.org>
 <944f0f6a-466a-7ce3-524c-f6db86fd0891@linux.alibaba.com>
 <d2efad94-750b-3298-8859-84bccc6ecf06@linux.alibaba.com>
 <alpine.LSU.2.11.2001130032170.1103@eggly.anvils>
 <24d671ac-36ef-8883-ad94-1bd497d46783@linux.alibaba.com>
 <alpine.LSU.2.11.2001131157500.1084@eggly.anvils>
 <641e4c96-c79f-fbdd-9762-f4608961423c@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <641e4c96-c79f-fbdd-9762-f4608961423c-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org



在 2020/1/14 下午5:14, Alex Shi 写道:
> Anyway, although I didn't reproduced the bug. but I found a bug in my
> debug function:
> 	VM_BUG_ON_PAGE(lruvec_memcg(lruvec) != page->mem_cgroup, page);
> 
>  if !page->mem_cgroup, the bug could be triggered, so, seems it's a bug
> for debug function, not real issue. The 9th patch should be replaced by
> the following new patch. 

If !page->mem_cgroup, means the page is on root_mem_cgroup, so lurvec's
memcg is root_mem_cgroup, not NULL. that trigger the issue.


Hi Johannes,

So I have a question about the lock_page_memcg in this scenario, Should
we lock the page to root_mem_cgroup? or there is no needs as no tasks
move to a leaf memcg from root?

Thanks
Alex
