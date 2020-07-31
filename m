From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v17 00/21] per memcg lru lock
Date: Fri, 31 Jul 2020 14:31:09 -0700
Message-ID: <CAKgT0UfMD1GytjJKYLQNCYzNFs1trdYFCtPkAhqnFhkW5ppYOg@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IPQ4YxQDiIfVNt/lLYL1uBZHZt0DN0r5SckeWlUL42o=;
        b=ZqlUeZYlm3G5RmGJ/gBq3usEdl293NPeNsf49vRwQFLjpkFcMWw+/wHHQF6OC4lnEP
         UYDZlF8vFK8pP7i3LP5yfgXYgTcpyUR4UwcUnE6SMXnXfcK4/ymgbvAloDaeW1XQ/7sF
         mIoGy57n/qQO2ubYE7SWThSVcKDv9ygK/qFBuHnT+K103p4/RMBjdNGuzR8h/3BotrLk
         SnIDwhtP7EWGGpssFryMLmnyNz0ZvHxRrqEA7eBsskIgqQkumayrOCdAFLfOvEnNbK1W
         FNwJP/oozmm4xtxuJ+f8VMzsh2DtO8LvNBSg3tUjEuW/ft6bstP8wUjPiuE/+DZsY7Lz
         n/ag==
In-Reply-To: <1595681998-19193-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Sat, Jul 25, 2020 at 6:00 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
>
> The new version which bases on v5.8-rc6. It includes Hugh Dickins fix in
> mm/swap.c and mm/mlock.c fix which Alexander Duyck pointed out, then
> removes 'mm/mlock: reorder isolation sequence during munlock'
>
> Hi Johanness & Hugh & Alexander & Willy,
>
> Could you like to give a reviewed by since you address much of issue and
> give lots of suggestions! Many thanks!
>

I just finished getting a test pass done on the patches. I'm still
seeing a regression on the will-it-scale/page_fault3 test but it is
now only 3% instead of the 20% that it was so it may just be noise at
this point.

I'll try to make sure to get my review feedback wrapped up early next week.

Thanks.

- Alex
