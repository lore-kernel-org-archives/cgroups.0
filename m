From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v17 03/21] mm/compaction: correct the comments of compact_defer_shift
Date: Tue, 28 Jul 2020 07:17:47 -0700
Message-ID: <CAKgT0UdyVKS00UzSGuVL7WASkz5h3MpnWT4VnYPa7Par08XxAg@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-4-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0UfmbdhpUdGy+4VircovmJfiJy9m-MN_o0LChNT_kWRUng@mail.gmail.com> <3bd60e1b-a74e-050d-ade4-6e8f54e00b92@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uiRcDeb6ox2yLj5fXNdoo05VO5CcXhShAkGVYjl04bA=;
        b=Ys6zUE87HGooZo1PtEgKd0uJDkaEkHFGsY1EOydtoSvjPDQl51Ix2N7rg4aqhB71lC
         j2VW2HZTKNWlVWHcU7VD2D5+PhV6cpWsdtKKe1/SK8sNiTxNDTNjkGR4BS0y22ANyoCC
         4aHYx2avcGsIGwy2/PotHxNQwmXTqKRa2HRaUcQWN3yeLutu0lSdYw3Yx73YEYag5hPu
         QdgUT4EjVX27slSACOg8fzHrZP3TWN0F7LvKm5bkNOY9GRgQr+OVwFVrevJrsqF+FkCR
         q/sCLBF+MDkBqYZuWXN0ov2yL64I7sPhzA9kdFAHZulnJ9VKWgvOi5PKdoH56dAwi1m3
         +Vmw==
In-Reply-To: <3bd60e1b-a74e-050d-ade4-6e8f54e00b92-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Tue, Jul 28, 2020 at 4:59 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
>
>
> >>   * Compaction is deferred when compaction fails to result in a page
> >> - * allocation success. 1 << compact_defer_limit compactions are skipped up
> >> + * allocation success. compact_defer_shift++, compactions are skipped up
> >>   * to a limit of 1 << COMPACT_MAX_DEFER_SHIFT
> >>   */
> >>  void defer_compaction(struct zone *zone, int order)
> >
> > So this doesn't read right. I wouldn't keep the "++," in the
> > explanation, and if we are going to refer to a limit of "1 <<
> > COMPACT_MAX_DEFER_SHIFT" then maybe this should be left as "1 <<
> > compact_defer_shift".
> >
>
> Thanks for comments! So is the changed patch fine?
> --
>
> From 80ffde4c8e13ba2ad1ad5175dbaef245c2fe49bc Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Date: Tue, 26 May 2020 09:47:01 +0800
> Subject: [PATCH] mm/compaction: correct the comments of compact_defer_shift
>
> There is no compact_defer_limit. It should be compact_defer_shift in
> use. and add compact_order_failed explanation.
>
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  include/linux/mmzone.h | 1 +
>  mm/compaction.c        | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index f6f884970511..14c668b7e793 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -512,6 +512,7 @@ struct zone {
>          * On compaction failure, 1<<compact_defer_shift compactions
>          * are skipped before trying again. The number attempted since
>          * last failure is tracked with compact_considered.
> +        * compact_order_failed is the minimum compaction failed order.
>          */
>         unsigned int            compact_considered;
>         unsigned int            compact_defer_shift;
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 86375605faa9..4950240cd455 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -136,7 +136,7 @@ void __ClearPageMovable(struct page *page)
>
>  /*
>   * Compaction is deferred when compaction fails to result in a page
> - * allocation success. 1 << compact_defer_limit compactions are skipped up
> + * allocation success. 1 << compact_defer_shift, compactions are skipped up
>   * to a limit of 1 << COMPACT_MAX_DEFER_SHIFT
>   */
>  void defer_compaction(struct zone *zone, int order)

Yes, that looks better to me.

Reviewed-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
