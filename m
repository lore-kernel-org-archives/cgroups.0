From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v20 00/20] per memcg lru lock
Date: Wed, 4 Nov 2020 11:59:35 -0500
Message-ID: <20201104165935.GA744831@cmpxchg.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <811216d4-4972-4721-d6b9-1028c02f4290@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=etqFAurUJDSd19LJRgQeMrJKrf7mPzvCgyUjOeBZwDk=;
        b=ES+N86515B56XodKDYWHJ6tTw+f4nct5ajluD4TsKqk6ihVSOr3ho3WXDMqBsc1nH6
         k08i2yVKNfYWndRFpSgEOLsmfnjHftjDfID7V/1kviFzkyAXE4cSwlspsMdANTYqCrhF
         uTIjSURiPNH3jNp0zyCLAnL7z0A6cYHNx8sFjmGuJtUj6+xy/zRrWzAX8lql8mBtIDb9
         dm5TvYpbBO8y9H+NI4o+Tp2FaBP4aWVkM3LxevBq0q0WwhB/Mc1gAGvcj0Q405XUs1Ly
         WVZSd6WgDkmEuy0DpgwhI9qDKyKkYSlR+XBiZ7AVLZxpWup5vJfx/cNJuYMoaS5wQ124
         SHFw==
Content-Disposition: inline
In-Reply-To: <811216d4-4972-4721-d6b9-1028c02f4290-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Wed, Nov 04, 2020 at 07:55:39PM +0800, Alex Shi wrote:
> @@ -1380,6 +1383,14 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgd
>         return lruvec;
>  }
> 
> +/**
> + * lock_page_lruvec - return lruvec for the locked page.

I would say "lock and return the lruvec for a given page"

> + * @page: the page
> + *
> + * This series functions should be used in either conditions:
> + * PageLRU is cleared or unset
> + * or, page->_refcount is zero

or page is locked

The other changes look good to me, thanks!
