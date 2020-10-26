From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v19 18/20] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Mon, 26 Oct 2020 09:41:20 +0800
Message-ID: <c1f1d964-7a55-8126-36b8-617c546bb536@linux.alibaba.com>
References: <1600918115-22007-1-git-send-email-alex.shi@linux.alibaba.com>
 <1600918115-22007-19-git-send-email-alex.shi@linux.alibaba.com>
 <ef27dcbd-37fe-c16a-71ee-61709cc135f3@linux.alibaba.com>
 <alpine.LSU.2.11.2010251240030.2287@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.11.2010251240030.2287-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aaron.lwe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, "lkp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <lkp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>



在 2020/10/26 上午5:51, Hugh Dickins 写道:
> [PATCH] mm/lru: minimize workingset_age_nonresident() interference
> 
> 1. move_pages_to_lru() batch workingset_age_nonresident() (from Yu Zhao)
> 2. workingset_age_nonresident() after unlock of lru_lock (from Yu Zhao)
> 3. lru_note_cost_unlock_irq() to remove an unlock+lock of lru_lock
> 4. lru_note_cost_unlock_irq() include updates of nonresident_age
> 5. workingset_refault() use that OR workingset_age_nonresident()
> 
> Of those, I expect 1 & 2 (from Yu Zhao) to be the most significant,
> increasingly so with more cpus, increasingly so with more levels in
> the memcg hierarchy.
> 
> Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hi Hugh,

Thanks a lot for checking and patch. I am in traveling today. So
just can pick and put it as lruv21 branch on my github tree:
https://github.com/alexshi/linux.git

Hi Rong,

We will very appreciate if you could launch testing on the branch
and it'd better, if you have time to change the test case time as 1k
second as Hugh wanted. Many thanks!

Thanks
Alex
