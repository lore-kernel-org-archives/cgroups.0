From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH v9 06/20] mm/thp: narrow lru locking
Date: Wed, 4 Mar 2020 11:02:48 +0300
Message-ID: <20200304080248.wuj3vqlz46ehhptg@box>
References: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
 <1583146830-169516-7-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NJwXQHOGfBvRfP8VBWg2bX3dJRR6Y/FuTLO1IQfTw1A=;
        b=Yz3sfhkQCsVRs2839qs1BfeyedHx2siPjrgeKySlIDpScCfojGKQCbXYvL39Fq3EYM
         HHQGJyPEuUTpxzf4IuJCTMQa8C2Gn3y1ANBqWZ4zlVXkkyoLFVlRGvWQ4LTj6mBNrHZU
         xOeDs9VQ4NyQhxwcungr9jQGvvJVT8rKEv72BnR3jOkYDQ9WzJY+wTzkBVKqf/lOyb/s
         lgZxU6z9GXgYBYPL5KJ2XcjhqcSfqSiyHtUFMLmLiCexiiZWysJzBYl6FpHvkJsQ1Z7r
         RQMUwPw8LxBzH/6ihsNX+3J1/vHGjtrOmbgn19h1VGvkNQrp+VNCRy1vb1zxbUV4G283
         XUYg==
Content-Disposition: inline
In-Reply-To: <1583146830-169516-7-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 02, 2020 at 07:00:16PM +0800, Alex Shi wrote:
> @@ -2564,6 +2565,9 @@ static void __split_huge_page(struct page *page, struct list_head *list,
>  		xa_lock(&swap_cache->i_pages);
>  	}
>  
> +	/* Lru list would be changed, don't care head's LRU bit. */
> +	spin_lock_irqsave(&pgdat->lru_lock, flags);
> +
>  	for (i = HPAGE_PMD_NR - 1; i >= 1; i--) {
>  		__split_huge_page_tail(head, i, lruvec, list);
>  		/* Some pages can be beyond i_size: drop them from page cache */

You change locking order WRT i_pages lock. Is it safe?

-- 
 Kirill A. Shutemov
