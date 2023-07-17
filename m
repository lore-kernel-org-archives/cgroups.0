From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: use get_page() for device private pages in
 mc_handle_swap_pte()
Date: Mon, 17 Jul 2023 10:28:50 +0800
Message-ID: <73b5d7c2-783d-3d75-2c1b-4b91a039df94@huawei.com>
References: <20230715032802.2508163-1-linmiaohe@huawei.com>
 <ZLIY+ZwrLvpapGE6@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ZLIY+ZwrLvpapGE6-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2023/7/15 11:56, Matthew Wilcox wrote:
> On Sat, Jul 15, 2023 at 11:28:02AM +0800, Miaohe Lin wrote:
>> When page table locked is held, the page can't be freed from under us.
> 
> But the page isn't mapped into the page table ... there's a swap entry
> in the page table, so I don't think your logic holds.
> 

IIUC, device_private_entry will hold one page refcnt when it's set to page table.
And there's similar code in do_swap_page():

  vm_fault_t do_swap_page(struct vm_fault *vmf)
    if (unlikely(non_swap_entry(entry))) {
      if (is_device_private_entry(entry))
        /*
         * Get a page reference while we know the page can't be
         * freed.
         */
        get_page(vmf->page);
        pte_unmap_unlock(vmf->pte, vmf->ptl);
        ret = vmf->page->pgmap->ops->migrate_to_ram(vmf);
        put_page(vmf->page);
    ...

If my logic doesn't hold, do_swap_page() will need to fix the code. Or am I miss something?

Thanks Matthew.

