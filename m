From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v20 13/20] mm/mlock: remove lru_lock on
 TestClearPageMlocked
Date: Mon, 2 Nov 2020 09:55:00 -0500
Message-ID: <20201102145500.GF724984@cmpxchg.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-14-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y0YbMA6MgS0VVP9wIqs606A+W5kzypLLo2uJ5yzWsp8=;
        b=1vhVi/TIRF7BDl6cNAGmMWQ9H4M2phsWWXLUY+8VngGCC6WkJ7vRPZNIkcIgeJ9jvM
         5tTwdWw/u00Bk92JyiLPxRLPS2Rt05dwhH2rAyGgzzzazKkXKAU+3yy37KckDYxXvGu3
         GZhiVeifeLhbd4cl833PsnioynbYERlWVuXrFXIBcgd2bpsFgWSNHUeP+a2aaWmIwBsM
         OHdTBVX/zEtZSuKU+cbInOiTtXvGRVLhUq7WMVe5cyjM54irjsvZPQsyw9JOpj72PPTK
         +QF/D3nTqK0nO8uQF4mXTohlgqWuEJTJWWhtVyeDiMRXtO9fo0k+jSoDtfkZldv0xd0I
         wJ6Q==
Content-Disposition: inline
In-Reply-To: <1603968305-8026-14-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

On Thu, Oct 29, 2020 at 06:44:58PM +0800, Alex Shi wrote:
> In the func munlock_vma_page, comments mentained lru_lock needed for
> serialization with split_huge_pages. But the page must be PageLocked
> as well as pages in split_huge_page series funcs. Thus the PageLocked
> is enough to serialize both funcs.
> 
> Further more, Hugh Dickins pointed: before splitting in
> split_huge_page_to_list, the page was unmap_page() to remove pmd/ptes
> which protect the page from munlock. Thus, no needs to guard
> __split_huge_page_tail for mlock clean, just keep the lru_lock there for
> isolation purpose.
> 
> LKP found a preempt issue on __mod_zone_page_state which need change
> to mod_zone_page_state. Thanks!
> 
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
