From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v17 14/21] mm/compaction: do page isolation first in compaction
Date: Mon, 17 Aug 2020 15:58:15 -0700
Message-ID: <CAKgT0Uf-38mNQMN4PptyvL=Jzyooz-K-FsosaVv+P0ok-7R4Sw@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com> <1595681998-19193-15-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CUinOKHyVodz4jvTS1Tm95hUcIyZXDORsxNhMipeHNI=;
        b=byIpvA6PXapCvY4kbX9hsHPmMFKCY69IW6PMIvbws4/x8AN3hC6qzvqvx9OoH0NDvs
         K0+ur+V+gik/czeG85229oQgaJMslt/bpivK5ELrz0IRun/ymrxVU3pKlTz/rce9mJT5
         oQ+qmEmqZJ48NuA2NMUtEhzYNqRqAcKYfhLcV6LSxNzWtoCVDiosbiVVcrX7w+BkVx1w
         884NUizKW61AP8E0defZhjbkHF3jdtVA3osKGJbKcWwqHVB4nLH36OeiyJh5y2sxkp1Z
         XPcZiDkxup87SeHU138rtD0cipsLApPga25ffrPjsj7opfL3vKkN2yGeFCUprlbS0XDQ
         pbpA==
In-Reply-To: <1595681998-19193-15-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> @@ -1691,17 +1680,34 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
>                  * only when the page is being freed somewhere else.
>                  */
>                 scan += nr_pages;
> -               switch (__isolate_lru_page(page, mode)) {
> +               switch (__isolate_lru_page_prepare(page, mode)) {
>                 case 0:
> +                       /*
> +                        * Be careful not to clear PageLRU until after we're
> +                        * sure the page is not being freed elsewhere -- the
> +                        * page release code relies on it.
> +                        */
> +                       if (unlikely(!get_page_unless_zero(page)))
> +                               goto busy;
> +
> +                       if (!TestClearPageLRU(page)) {
> +                               /*
> +                                * This page may in other isolation path,
> +                                * but we still hold lru_lock.
> +                                */
> +                               put_page(page);
> +                               goto busy;
> +                       }
> +

So I was reviewing the code and came across this piece. It has me a
bit concerned since we are calling put_page while holding the LRU lock
which was taken before calling the function. We should be fine in
terms of not encountering a deadlock since the LRU bit is cleared the
page shouldn't grab the LRU lock again, however we could end up
grabbing the zone lock while holding the LRU lock which would be an
issue.

One other thought I had is that this might be safe because the
assumption would be that another thread is holding a reference on the
page, has already called TestClearPageLRU on the page and retrieved
the LRU bit, and is waiting on us to release the LRU lock before it
can pull the page off of the list. In that case put_page will never
decrement the reference count to 0. I believe that is the current case
but I cannot be certain.

I'm just wondering if we should just replace the put_page(page) with a
WARN_ON(put_page_testzero(page)) and a bit more documentation. If I am
not mistaken it should never be possible for the reference count to
actually hit zero here.

Thanks.

- Alex
