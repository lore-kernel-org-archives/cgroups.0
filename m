From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v18 31/32] mm: Add explicit page decrement in exception
 path for isolate_lru_pages
Date: Wed, 9 Sep 2020 02:01:18 +0100
Message-ID: <20200909010118.GB6583@casper.infradead.org>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <1598273705-69124-32-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fVCZ2gAQlCOU+3FQ8zVoZg2a2/Nz/JlYFnCb9jL8Xz0=; b=SNQjPYWHMmaFL7LKw4GX4WfZlG
        jqCZi08dIMAMm78xsBxjzttVxrreGfM/VkZblsnmw7u/IjfZA+8cVbKcrhuXgKI68/lQkiNTvpJaA
        u1d9lIuxE++qMUdBjM8NP9Nl1GoK2hBFIkf0ewekXxEkrV+ppWkaOTpuGF6WRGAQxKWB6whYUtJpo
        aT0MUfU+Bo51JVvUpzB7d6JWHzb0XJcx7osuTkygosX4d9xlTPLYgjwCgGJzFdjocTow9gyLfIPAB
        PO3jgrUt0dAMTn/b7ZVGH2K+aFTTflDztYCCY98ocrpLwT6fUGwc1K6lN2N7IPFzDI4Azpo4w8Ylu
        H/nmn/kA==;
Content-Disposition: inline
In-Reply-To: <1598273705-69124-32-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On Mon, Aug 24, 2020 at 08:55:04PM +0800, Alex Shi wrote:
> +++ b/mm/vmscan.c
> @@ -1688,10 +1688,13 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
>  
>  			if (!TestClearPageLRU(page)) {
>  				/*
> -				 * This page may in other isolation path,
> -				 * but we still hold lru_lock.
> +				 * This page is being isolated in another
> +				 * thread, but we still hold lru_lock. The
> +				 * other thread must be holding a reference
> +				 * to the page so this should never hit a
> +				 * reference count of 0.
>  				 */
> -				put_page(page);
> +				WARN_ON(put_page_testzero(page));
>  				goto busy;

I read Hugh's review and that led me to take a look at this.  We don't
do it like this.  Use the same pattern as elsewhere in mm:

        page_ref_sub(page, nr);
        VM_BUG_ON_PAGE(page_count(page) <= 0, page);

