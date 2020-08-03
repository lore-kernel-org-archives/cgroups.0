From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v17 20/21] mm/pgdat: remove pgdat lru_lock
Date: Mon, 3 Aug 2020 15:45:50 -0700
Message-ID: <CAKgT0UciRJCPs_zrxri1pEJmJVKkHpEq=AFiVpJE99JJQe=Xrg@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-21-git-send-email-alex.shi@linux.alibaba.com> <CAKgT0UfZg5Wf2qNJ_=VPO1Cj8YuifZN8rG_X4Btq86ADmsVZFw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gbJLXIAhRA3ILjxJ/kOnaqM4fWJ/LpEX+iUTeUndPqc=;
        b=iXpmTJ6iTNHX5/0yQVDFwLIAFlMfeqBTpmWkw/+gdIlRTM53IBjEPiTdOr2WqHCjf1
         /ngIOpPdDMnmF2xOP6HHwk+9yO6JRwHBhmEVmtCeryvi401SbANXAXdxqxr/kDqXwT7a
         aVsVubcmq1syeWSWgj5QeG6iBGgl3zE15WTocvZ9qmYIvLIJDw/kaAeSJRCaFFSLh3s6
         +tfjoW3jE7RnVGlBtZ1M1r5sGFLFxuDy4hEJq3VAfoN9EqPy+dV135AaJDrqRsY6Vtes
         OFWRY8PISjNVEERbRNnZQpHElFL71u2bADXCdsR1RpkNR/8z/Lta+ZJiVHfTGqxE0qeE
         /eRw==
In-Reply-To: <CAKgT0UfZg5Wf2qNJ_=VPO1Cj8YuifZN8rG_X4Btq86ADmsVZFw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Just to correct a typo, I meant patch 17, not 18. in the comment below.


On Mon, Aug 3, 2020 at 3:42 PM Alexander Duyck
<alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Sat, Jul 25, 2020 at 6:00 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
> >
> > Now pgdat.lru_lock was replaced by lruvec lock. It's not used anymore.
> >
> > Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> > Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> > Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
> > Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> > Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>
> I really think this would be better just squashed into patch 18
> instead of as a standalone patch since you were moving all of the
> locking anyway so it would be more likely to trigger build errors if
> somebody didn't move a lock somewhere that was referencing this.
>
> That said this change is harmless at this point.
>
> Reviewed-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
