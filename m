From: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: [PATCH] memcg: set page->private before calling swap_readpage
Date: Thu, 18 Mar 2021 09:55:14 +0100
Message-ID: <YFMVcmRAnOwsYHRt@osiris>
References: <20210318015959.2986837-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=VVNmZbk4kEKIQ3os1j6YSdx22LOXyL+oojaGnuH+qVM=;
 b=TDyTFK/pxjAR41porRQsm58N1wJVCPDZNuNkvRfSdGbtGnQobNAeIDv9lab2od//II0V
 Gb9L7mjsEWPR9YDBMXYlXyyBqhT6/tjlzdleSvtOB+OLdpHMr46C7ko/sTQigwVnPaGc
 XnUfAIyhP5g2R3RaHYvry6MODB32dZzh2L2CEgI0QuRIzTeKdnpl5lXZrACn53VV2W52
 mNJHbV+qV5kv10e6t9DoiHdTAjlSBtxHPD7wZmgKueJQMAYk9E0Gg0LIqk6y+WOP20aB
 F2kdTR1GCTHeHEehOqF8c6lsCcTVN+2+xuI9e9VMOnrMgMr8Xwz9fGLy5PbrTNnacJIf sA== 
Content-Disposition: inline
In-Reply-To: <20210318015959.2986837-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 17, 2021 at 06:59:59PM -0700, Shakeel Butt wrote:
> The function swap_readpage() (and other functions it call) extracts swap
> entry from page->private. However for SWP_SYNCHRONOUS_IO, the kernel
> skips the swapcache and thus we need to manually set the page->private
> with the swap entry before calling swap_readpage().
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reported-by: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
> ---
> 
> Andrew, please squash this into "memcg: charge before adding to
> swapcache on swapin" patch.
> 
>  mm/memory.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index aefd158ae1ea..b6f3410b5902 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3324,7 +3324,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  					workingset_refault(page, shadow);
>  
>  				lru_cache_add(page);
> +
> +				/* To provide entry to swap_readpage() */
> +				set_page_private(page, entry.val);
>  				swap_readpage(page, true);
> +				set_page_private(page, 0);

Yes, this seems to fix it. Thanks a lot!

Tested-by: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
