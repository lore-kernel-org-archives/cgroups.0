From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: use get_page() for device private pages in
 mc_handle_swap_pte()
Date: Sat, 15 Jul 2023 04:56:41 +0100
Message-ID: <ZLIY+ZwrLvpapGE6@casper.infradead.org>
References: <20230715032802.2508163-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JCic63O1M6aYkUCxDH6pVswG6w/uXP8H7kVHZUpcD8Y=; b=rn/Rdd3d6xOw3B1ImjQ+HapFxr
        lt/TX5UX1qrW2XM1iHrPMCdLTGZiv1Y8rUHM5NGu2fyDwDJSQ2oFuCoQCaXZPnyXc4nW5sQzNoo9d
        8jZhwNO2CjnUqJzITZFx98Dp0IT6mvhZgCt9pfBx2pBQJU7r4mq9OQaX7VcnJWPKbULpDhiv/TfrB
        qNI6qO4/TPK9QX6y2l3+1J/zQ+dKAvFw/vfI2i0g9bmbHXf6wh4o+pHljfujxg+0bWL8ksL8QrxV4
        4d4/PuiFQFfjvwHnFoKfIUZzCmvP32VBUiqLAoHvS9B7ok7T6oSeyqkzkJ4gtjRK8Mh4ERDPuVvSW
        qR2ycr3Q==;
Content-Disposition: inline
In-Reply-To: <20230715032802.2508163-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jul 15, 2023 at 11:28:02AM +0800, Miaohe Lin wrote:
> When page table locked is held, the page can't be freed from under us.

But the page isn't mapped into the page table ... there's a swap entry
in the page table, so I don't think your logic holds.

> So use get_page() to get the extra page reference to simplify the code.
> No functional change intended.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 93e3cc581b51..4ca382efb1ca 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5670,8 +5670,9 @@ static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
>  	 */
>  	if (is_device_private_entry(ent)) {
>  		page = pfn_swap_entry_to_page(ent);
> -		if (!get_page_unless_zero(page))
> -			return NULL;
> +		/* Get a page reference while we know the page can't be freed. */
> +		get_page(page);
> +
>  		return page;
>  	}
>  
> -- 
> 2.33.0
> 
> 
