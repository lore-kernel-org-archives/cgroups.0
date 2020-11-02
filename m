From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v20 17/20] mm/swap.c: serialize memcg changes in
 pagevec_lru_move_fn
Date: Mon, 2 Nov 2020 10:20:45 -0500
Message-ID: <20201102152045.GJ724984@cmpxchg.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-18-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PZfLygvPchTUSgGMmFZPk8zJRPc7y3a0+u5vclYWa+g=;
        b=bAkYwaocuGeef7r/WOYoDUSYpYjQDgRDpirAbBQA4pgs0hzQ0GiYmrYxa29dxnVHRF
         WxZ+s5OiKNjfk7VuV+xQNYKlAGD4juHOKsM0ZetbZkYA9t1Tbh1k2izLHb7ERccLcgHm
         GCCABAf8ThtuwtqKtEcG6HvFonuEEIP0GHWjilwMZYs78mM8ItctpBi0UBxTd5qcNaAs
         QdZ7tgIjuj20hncEA5VgCavYzeW6I9e9gAOIUgoiUtVovsIhhie+0DjaKZnVF0kJxI0J
         Jf02bfDygNUlJuqZ865wjaIfGmJK7DpfTtDj0KZDfr56i5YflC13w1YJT5czGz7ws46t
         JTtQ==
Content-Disposition: inline
In-Reply-To: <1603968305-8026-18-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Thu, Oct 29, 2020 at 06:45:02PM +0800, Alex Shi wrote:
> Hugh Dickins' found a memcg change bug on original version:
> If we want to change the pgdat->lru_lock to memcg's lruvec lock, we have
> to serialize mem_cgroup_move_account during pagevec_lru_move_fn. The
> possible bad scenario would like:
> 
> 	cpu 0					cpu 1
> lruvec = mem_cgroup_page_lruvec()
> 					if (!isolate_lru_page())
> 						mem_cgroup_move_account
> 
> spin_lock_irqsave(&lruvec->lru_lock <== wrong lock.
> 
> So we need TestClearPageLRU to block isolate_lru_page(), that serializes
> the memcg change. and then removing the PageLRU check in move_fn callee
> as the consequence.
> 
> __pagevec_lru_add_fn() is different from the others, because the pages
> it deals with are, by definition, not yet on the lru.  TestClearPageLRU
> is not needed and would not work, so __pagevec_lru_add() goes its own
> way.
> 
> Reported-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
