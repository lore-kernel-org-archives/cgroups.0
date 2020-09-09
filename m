From: Wei Yang <richard.weiyang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock: reviews
Date: Wed, 9 Sep 2020 10:24:18 +0800
Message-ID: <20200909022418.GA14584@L-31X9LVDL-1304.local>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
 <alpine.LSU.2.11.2008241231460.1065@eggly.anvils>
 <alpine.LSU.2.11.2008262301240.4405@eggly.anvils>
 <alpine.LSU.2.11.2009081640070.7256@eggly.anvils>
Reply-To: Wei Yang <richard.weiyang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2009081640070.7256-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cai-J5quhbR+WMc@public.gmane.org

On Tue, Sep 08, 2020 at 04:41:00PM -0700, Hugh Dickins wrote:
[...]
>[PATCH v18 06/32] mm/thp: narrow lru locking
>Why? What part does this play in the series? "narrow lru locking" can
>also be described as "widen page cache locking": you are changing the
>lock ordering, and not giving any reason to do so. This may be an
>excellent change, or it may be a terrible change: I find that usually
>lock ordering is forced upon us, and it's rare to meet an instance like
>this that could go either way, and I don't know myself how to judge it.
>
>I do want this commit to go in, partly because it has been present in
>all the testing we have done, and partly because I *can at last* see a
>logical advantage to it - it also nests lru_lock inside memcg->move_lock,
>allowing lock_page_memcg() to be used to stabilize page->mem_cgroup when
>getting per-memcg lru_lock - though only in one place, starting in v17,
>do you actually use that (and, warning: it's not used correctly there).
>
>I'm not very bothered by how the local_irq_disable() looks to RT: THP
>seems a very bad idea in an RT kernel.  Earlier I asked you to run this
>past Kirill and Matthew and Johannes: you did so, thank you, and Kirill
>has blessed it, and no one has nacked it, and I have not noticed any
>disadvantage from this change in lock ordering (documented in 23/32),
>so I'm now going to say
>
>Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
>But I wish you could give some reason for it in the commit message!
>
>Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>Is that correct? Or Wei Yang suggested some part of it perhaps?
>

If my memory is correct, we had some offline discussion about this change.

-- 
Wei Yang
Help you, Help me
