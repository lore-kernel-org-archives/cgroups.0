From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v17 14/21] mm/compaction: do page isolation first in compaction
Date: Mon, 10 Aug 2020 07:41:10 -0700
Message-ID: <CAKgT0UdK-fy+yYGLFK=YgE+maa_0_uecq0_8S_0kM8BiVgRO7g@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-15-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0UcbBv=QBK9ErqLKXoNLYxFz52L4fiiHy4h6zKdBs=YPOg@mail.gmail.com>
 <241ca157-104f-4f0d-7d5b-de394443788d@linux.alibaba.com> <CAKgT0UdSrarC8j+G=LYRSadcaG6yNCoCfeVpFjEiHRJb4A77-g@mail.gmail.com>
 <8dbd004e-8eba-f1ec-a5eb-5dc551978936@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AidFlRL4Ug1HXYYI29mKf2liuKC4nCVYEFXiYCfw8vA=;
        b=CnzTfUG1SpGkNdLlwHUtFMtEAs/lYxwUd5HQM1e687MC6Hx2DVg0XbIOvx3VGO/z74
         /BRzNFMM9NnDz2jGQ2eASuxPpT/aB1AR3sUY0B97X9ZHGQols8ol6MIVMfMib/g48r13
         +dOLOiywM+Fr6cEXRyNvtKTpvkt+vkdJGpS12tNiDQHg2E6/oVBCkQt5kLDzQO++FKwV
         Zwa8lmALUMlCqBfNzCEQDtTttA1A9PzbVF4AwYgmbywQm+6czKeFZ5vEr8+0JbKwwxts
         sbFCWoV2tT9H22iM4NLHNgkJvREVNYHhnlEWB8Dlv9Z67SOBGa1vmez+KhDjL99Dr6uA
         yZxA==
In-Reply-To: <8dbd004e-8eba-f1ec-a5eb-5dc551978936-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Mon, Aug 10, 2020 at 6:10 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote=
:
>
>
>
> =E5=9C=A8 2020/8/7 =E4=B8=8B=E5=8D=8810:51, Alexander Duyck =E5=86=99=E9=
=81=93:
> > I wonder if this entire section shouldn't be restructured. This is the
> > only spot I can see where we are resetting the LRU flag instead of
> > pulling the page from the LRU list with the lock held. Looking over
> > the code it seems like something like that should be possible. I am
> > not sure the LRU lock is really protecting us in either the
> > PageCompound check nor the skip bits. It seems like holding a
> > reference on the page should prevent it from switching between
> > compound or not, and the skip bits are per pageblock with the LRU bits
> > being per node/memcg which I would think implies that we could have
> > multiple LRU locks that could apply to a single skip bit.
>
> Hi Alexander,
>
> I don't find problem yet on compound or skip bit usage. Would you clarify=
 the
> issue do you concerned?
>
> Thanks!

The point I was getting at is that the LRU lock is being used to
protect these and with your changes I don't think that makes sense
anymore.

The skip bits are per-pageblock bits. With your change the LRU lock is
now per memcg first and then per node. As such I do not believe it
really provides any sort of exclusive access to the skip bits. I still
have to look into this more, but it seems like you need a lock per
either section or zone that can be used to protect those bits and deal
with this sooner rather than waiting until you have found an LRU page.
The one part that is confusing though is that the definition of the
skip bits seems to call out that they are a hint since they are not
protected by a lock, but that is exactly what has been happening here.

The point I was getting at with the PageCompound check is that instead
of needing the LRU lock you should be able to look at PageCompound as
soon as you call get_page_unless_zero() and preempt the need to set
the LRU bit again. Instead of trying to rely on the LRU lock to
guarantee that the page hasn't been merged you could just rely on the
fact that you are holding a reference to it so it isn't going to
switch between being compound or order 0 since it cannot be freed. It
spoils the idea I originally had of combining the logic for
get_page_unless_zero and TestClearPageLRU into a single function, but
the advantage is you aren't clearing the LRU flag unless you are
actually going to pull the page from the LRU list.

My main worry is that this is the one spot where we appear to be
clearing the LRU bit without ever actually pulling the page off of the
LRU list, and I am thinking we would be better served by addressing
the skip and PageCompound checks earlier rather than adding code to
set the bit again if either of those cases are encountered. This way
we don't pseudo-pin pages in the LRU if they are compound or supposed
to be skipped.

Thanks.

- Alex
