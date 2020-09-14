From: Qian Cai <cai-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/8] mm: Optimise madvise WILLNEED
Date: Mon, 14 Sep 2020 15:44:39 -0400
Message-ID: <05803c18b64db8a811c692bcbdc03172935ea483.camel@redhat.com>
References: <20200910183318.20139-1-willy@infradead.org>
         <20200910183318.20139-4-willy@infradead.org>
         <c48c5eaa09d1ea5b78b12b545c034d1e937c49ba.camel@redhat.com>
         <20200914165032.GS6583@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600112690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A/DjrjveF5/2wA8RTl0T9a0Cox1J1OLY+rMuhaYpfao=;
        b=iU4h2vv/M1zUWJJz3Pm72a/wlgb/ICjPAbhhKRyOKH64W14MyQnKrWpLxLP/bp+H4sXp63
        QxHNa9MkaaBA/+HL5IM82Kll7c4Tj4Ta+th02dHDNj1ynlbZrV2izvmZYL0VHEt1F3LO4X
        UHIH2ObFAXPo+z1V/z4LuGGARwz5QTI=
In-Reply-To: <20200914165032.GS6583-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, William Kucharski <william.kucharski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Auld <matthew.auld-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Mon, 2020-09-14 at 17:50 +0100, Matthew Wilcox wrote:
> On Mon, Sep 14, 2020 at 12:17:07PM -0400, Qian Cai wrote:
> > Reverting the "Return head pages from find_*_entry" patchset [1] up to this
> > patch fixed the issue that LTP madvise06 test [2] would trigger endless
> > soft-
> > lockups below. It does not help after applied patches fixed other separate
> > issues in the patchset [3][4].
> 
> Thanks for the report.  Could you try this?

It works fine.

> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 96189acd6969..2d9ceccb338d 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -234,6 +234,7 @@ static void force_shm_swapin_readahead(struct
> vm_area_struct *vma,
>  
>  		if (!xa_is_value(page))
>  			continue;
> +		xas_pause(&xas);
>  		rcu_read_unlock();
>  
>  		swap = radix_to_swp_entry(page);
> @@ -243,7 +244,6 @@ static void force_shm_swapin_readahead(struct
> vm_area_struct *vma,
>  			put_page(page);
>  
>  		rcu_read_lock();
> -		xas_reset(&xas);
>  	}
>  	rcu_read_unlock();
>  
> 

