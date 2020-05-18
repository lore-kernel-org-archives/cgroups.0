From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 01/19] mm: fix NUMA node file count error in
 replace_page_cache()
Date: Mon, 18 May 2020 11:18:50 +0000
Message-ID: <20200518111850.GA107644@dev-dsk-sblbir-1c-a524888b.ap-northeast-1.amazon.com>
References: <20200508183105.225460-1-hannes@cmpxchg.org>
 <20200508183105.225460-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fAEtST8it9y3Jfre9o9oyKCGxnCx5adRG8P+6yLwwis=;
        b=bYuxNSy0mFLe5uddMp3pxXj5gpk9EIwKmV2Jz6OmMfoKg0OLtKscTLNkYPsvHRrLzH
         ICl9UewF27897C1ez01XzJWRT8iQXzBMZ7X4fZEiZ7fbhWPZAwiD9tGjCaybIkrkq19o
         sKoPqKPJ9zyqUHx1TvUIlPZY2Ur/DsvbuBsU6hmOBoZn4X2mGdUjj36ENkq09q2LbH9a
         vmlpQMKhH/pHWLmyQDl41B+dnZRT0voT/JY+JZWRQ7nVENxmmNeGMsbT2iXkCb9q1VRZ
         +qObI95Vntet1/Zqz+H/TbQ93xr5G4rQht8eVKyk5ucfkk8oHR68PJAxAI4Mq6gWm55j
         yX+Q==
Content-Disposition: inline
In-Reply-To: <20200508183105.225460-2-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Shi <alex.shi@linux.alibaba.com>, Joonsoo Kim <js1304@gmail.com>, Shakeel Butt <shakeelb@google.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, May 08, 2020 at 02:30:48PM -0400, Johannes Weiner wrote:
> When replacing one page with another one in the cache, we have to
> decrease the file count of the old page's NUMA node and increase the
> one of the new NUMA node, otherwise the old node leaks the count and
> the new node eventually underflows its counter.
> 
> Fixes: 74d609585d8b ("page cache: Add and replace pages using the XArray")
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>  mm/filemap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index af1c6adad5bd..2b057b0aa882 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -808,11 +808,11 @@ int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
>  	old->mapping = NULL;
>  	/* hugetlb pages do not participate in page cache accounting. */
>  	if (!PageHuge(old))
> -		__dec_node_page_state(new, NR_FILE_PAGES);
> +		__dec_node_page_state(old, NR_FILE_PAGES);
>  	if (!PageHuge(new))
>  		__inc_node_page_state(new, NR_FILE_PAGES);
>  	if (PageSwapBacked(old))
> -		__dec_node_page_state(new, NR_SHMEM);
> +		__dec_node_page_state(old, NR_SHMEM);
>  	if (PageSwapBacked(new))
>  		__inc_node_page_state(new, NR_SHMEM);
>  	xas_unlock_irqrestore(&xas, flags);


Reviewed-by: Balbir Singh <bsingharora@gmail.com>
