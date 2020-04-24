From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 18/18] mm: memcontrol: update page->mem_cgroup stability
 rules
Date: Fri, 24 Apr 2020 09:48:03 +0900
Message-ID: <20200424004802.GH13929@js1304-desktop>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-19-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zMf6cL1D7YLD6iKlsLUtZolXbcpW+JOh8oh3DueIiGs=;
        b=PXqYHe3fZr6F5VO5PPWJRdaX2re6I1g9UbEo9QM37Hn0kGaTttdie8rMhVReN9olrZ
         mj3+Ef0v8a3XQSPAy053pkkFrikfZjRCT2Jv5Sh4f4gU/d+iyAZ66puFzr5nLojFlZ2I
         tXzQ8xlKFsayg+zOrwrUhyDcRUZKYVhrqsXPGihrVqSvC474hoNk2qnfuw3XHtfvdAZO
         jxi3NYcXf4yLR9KZv3pTHXVb84HwVxx+cqXSiMO8ZbF/5bRl4R14tiIfYA556cGqakEU
         CJa4TitRC2rE5XkA6TiJ4A7/w4t7SOGDdgYqtFWx/pounou3MUkeeKOCD77arEOVqZUu
         yiHA==
Content-Disposition: inline
In-Reply-To: <20200420221126.341272-19-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Apr 20, 2020 at 06:11:26PM -0400, Johannes Weiner wrote:
> The previous patches have simplified the access rules around
> page->mem_cgroup somewhat:
> 
> 1. We never change page->mem_cgroup while the page is isolated by
>    somebody else. This was by far the biggest exception to our rules
>    and it didn't stop at lock_page() or lock_page_memcg().
> 
> 2. We charge pages before they get put into page tables now, so the
>    somewhat fishy rule about "can be in page table as long as it's
>    still locked" is now gone and boiled down to having an exclusive
>    reference to the page.
> 
> Document the new rules. Any of the following will stabilize the
> page->mem_cgroup association:
> 
> - the page lock
> - LRU isolation
> - lock_page_memcg()
> - exclusive access to the page
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
