From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v17 14/21] mm/compaction: do page isolation first in compaction
Date: Fri, 7 Aug 2020 07:51:11 -0700
Message-ID: <CAKgT0UdSrarC8j+G=LYRSadcaG6yNCoCfeVpFjEiHRJb4A77-g@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-15-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0UcbBv=QBK9ErqLKXoNLYxFz52L4fiiHy4h6zKdBs=YPOg@mail.gmail.com> <241ca157-104f-4f0d-7d5b-de394443788d@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j7YOCwyn015CH01DvuqygeICt/lkosNS0VPJxx8lTNk=;
        b=DZl9SjSAU9r2ocCJ25zl96LApqZMSw7v9QRevy/vcPN769EjunTsd/mxoDROifcfLh
         x1cV0CIGT6g0Xi8y8o6WulDNVEU3MgOjy374LzN50bwKA8qj5tfqhfRG9Q0nekJQju22
         GCXzILsDGgSQKEM3LcX5k/g1Xw3f41snt8i8oCINtSQ6N5YA/eiSfFTAreko0JF3PNtH
         J9p4yKgszZfUSwY6ChDo83EAwG/Mcts7/mmesRa55fDcCkl3YPCe0tulykRKtrpaxq9l
         jtyCfQeWNNNxCOjCAqiccXa6SPaZBiUkyk+VyHgZacF4AyPUX6DZFp/FbQH052q+PY5Y
         i1DA==
In-Reply-To: <241ca157-104f-4f0d-7d5b-de394443788d-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Thu, Aug 6, 2020 at 8:25 PM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
>
>
>
> =E5=9C=A8 2020/8/7 =E4=B8=8A=E5=8D=882:38, Alexander Duyck =E5=86=99=E9=
=81=93:
> >> +
> >>  isolate_abort:
> >>         if (locked)
> >>                 spin_unlock_irqrestore(&pgdat->lru_lock, flags);
> >> +       if (page) {
> >> +               SetPageLRU(page);
> >> +               put_page(page);
> >> +       }
> >>
> >>         /*
> >>          * Updated the cached scanner pfn once the pageblock has been =
scanned
> > We should probably be calling SetPageLRU before we release the lru
> > lock instead of before. It might make sense to just call it before we
> > get here, similar to how you did in the isolate_fail_put case a few
> > lines later. Otherwise this seems to violate the rules you had set up
> > earlier where we were only going to be setting the LRU bit while
> > holding the LRU lock.
>
> Hi Alex,
>
> Set out of lock here should be fine. I never said we must set the bit in =
locking.
> And this page is get by get_page_unless_zero(), no warry on release.
>
> Thanks
> Alex

I wonder if this entire section shouldn't be restructured. This is the
only spot I can see where we are resetting the LRU flag instead of
pulling the page from the LRU list with the lock held. Looking over
the code it seems like something like that should be possible. I am
not sure the LRU lock is really protecting us in either the
PageCompound check nor the skip bits. It seems like holding a
reference on the page should prevent it from switching between
compound or not, and the skip bits are per pageblock with the LRU bits
being per node/memcg which I would think implies that we could have
multiple LRU locks that could apply to a single skip bit.
