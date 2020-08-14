From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] mm: Drop use of test_and_set_skip in favor of
 just setting skip
Date: Fri, 14 Aug 2020 14:15:08 -0700
Message-ID: <CAKgT0Ue=DwVAr+dG8Ff04mUY5ZCG6cpvHCG=bP1w=HujiCp0BQ@mail.gmail.com>
References: <20200813035100.13054.25671.stgit@localhost.localdomain>
 <20200813040232.13054.82417.stgit@localhost.localdomain> <6c072332-ff16-757d-99dd-b8fbae131a0c@linux.alibaba.com>
 <CAKgT0Uf0TbRBVsuGZ1bgh5rdFp+vARkP=+GgD4-DP3Gy6cj+pA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tJMVJBnaXmXqh981RH/h7+Q4BiQVvI3wCXGlTjz6EWg=;
        b=bYyuaTEqbGMUDbMQT1N3adh8ZXqau382QojThewnW//4qEz3eZ/zrAaDMQ2DyZdy5S
         zy3hUU8M7NHVx+aHkrthzP7rx9gfHneJI0nSdRH9Ckd5lxNps3aL683LKaDWNsKgnYZM
         Lt+XpG2yMuTdQt8MznPtkrXzYmYBSamAHiQN0gr/ZKTOQNhfnS7FBtOsdNBgsXegXw43
         TAgtcMLOko7OxUnCkBxGuIogU9IzzqRw3UAHDFpS3HbUFvqlslWZEjTR+rnWF0tc8VNO
         9PavoPblmc7OTQ7XIa/bqusD5Dw8UajLsvr3Pqjx3usFzgELflUYZN+4bZqMnmJRkg7f
         yYag==
In-Reply-To: <CAKgT0Uf0TbRBVsuGZ1bgh5rdFp+vARkP=+GgD4-DP3Gy6cj+pA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

On Fri, Aug 14, 2020 at 7:24 AM Alexander Duyck
<alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Fri, Aug 14, 2020 at 12:19 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wr=
ote:
> >
> >
> >
> > =E5=9C=A8 2020/8/13 =E4=B8=8B=E5=8D=8812:02, Alexander Duyck =E5=86=99=
=E9=81=93:
> > >
> > > Since we have dropped the late abort case we can drop the code that w=
as
> > > clearing the LRU flag and calling page_put since the abort case will =
now
> > > not be holding a reference to a page.
> > >
> > > Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >
> > seems the case-lru-file-mmap-read case drop about 3% on this patch in a=
 rough testing.
> > on my 80 core machine.
>
> I'm not sure how it could have that much impact on the performance
> since the total effect would just be dropping what should be a
> redundant test since we tested the skip bit before we took the LRU
> bit, so we shouldn't need to test it again after.
>
> I finally got my test setup working last night. I'll have to do some
> testing in my environment and I can start trying to see what is going
> on.

So I ran the case-lru-file-mmap-read a few times and I don't see how
it is supposed to be testing the compaction code. It doesn't seem like
compaction is running at least on my system as a result of the test
script. I wonder if testing this code wouldn't be better done using
something like thpscale from the
mmtests(https://github.com/gormanm/mmtests)? It seems past changes to
the compaction code were tested using that, and the config script for
the test explains that it is designed specifically to stress the
compaction code. I have the test up and running now and hope to
collect results over the weekend.

There is one change I will probably make to this patch and that is to
place the new code that is setting skip_updated where the old code was
calling test_and_set_skip_bit. By doing that we can avoid extra checks
and it should help to reduce possible collisions when setting the skip
bit in the pageblock flags.

Thanks.

- Alex
