From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] mm: Drop use of test_and_set_skip in favor of
 just setting skip
Date: Mon, 17 Aug 2020 08:38:02 -0700
Message-ID: <CAKgT0Ud5D3vAtC0_+3otdqzm+hfqR9xGBacjpuh5Qze5=J1=Vw@mail.gmail.com>
References: <20200813035100.13054.25671.stgit@localhost.localdomain>
 <20200813040232.13054.82417.stgit@localhost.localdomain> <6c072332-ff16-757d-99dd-b8fbae131a0c@linux.alibaba.com>
 <CAKgT0Uf0TbRBVsuGZ1bgh5rdFp+vARkP=+GgD4-DP3Gy6cj+pA@mail.gmail.com>
 <CAKgT0Ue=DwVAr+dG8Ff04mUY5ZCG6cpvHCG=bP1w=HujiCp0BQ@mail.gmail.com> <650ab639-e66f-5ca6-a9a5-31e61c134ae7@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4Bkdz+k72rLGRx5zfmph4t7mOQMS3PzCCK/DsnCmnNk=;
        b=IUxAnms4s7sSclWkvmw5QiiHjkg484hwDAcSl/TapXh0pQyfDNpoGhtsiLGdSP8sI/
         rJ3nFoUmNjxtIlAuvyzlLaT+dNCimN4koRcvtUfx34lpUMOAitgRZOoSGPR/faSU36+h
         W5P3Fnp/zOYblyl4nLFp35Nn3FWPjieLKlt0s279lug2G5pIov2EQZ456vEhAt+0gU2P
         UUNVf7+sJ7+D3VGcI1+FDJ0mRse6hzZ2N4+R64jBzVA5DRfFjeGhMTN8BHPrUAEyGdWU
         WAP7k37sKE7kIjzWuy+Wk4na9F1Am+y7QYk/VIDlyxwUKIKPvwVKQYDv+2+YYuiR+89Y
         rVTw==
In-Reply-To: <650ab639-e66f-5ca6-a9a5-31e61c134ae7-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

On Sat, Aug 15, 2020 at 2:51 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote=
:
>
>
>
> =E5=9C=A8 2020/8/15 =E4=B8=8A=E5=8D=885:15, Alexander Duyck =E5=86=99=E9=
=81=93:
> > On Fri, Aug 14, 2020 at 7:24 AM Alexander Duyck
> > <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >> On Fri, Aug 14, 2020 at 12:19 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>=
 wrote:
> >>>
> >>>
> >>>
> >>> =E5=9C=A8 2020/8/13 =E4=B8=8B=E5=8D=8812:02, Alexander Duyck =E5=86=
=99=E9=81=93:
> >>>>
> >>>> Since we have dropped the late abort case we can drop the code that =
was
> >>>> clearing the LRU flag and calling page_put since the abort case will=
 now
> >>>> not be holding a reference to a page.
> >>>>
> >>>> Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >>>
> >>> seems the case-lru-file-mmap-read case drop about 3% on this patch in=
 a rough testing.
> >>> on my 80 core machine.
> >>
> >> I'm not sure how it could have that much impact on the performance
> >> since the total effect would just be dropping what should be a
> >> redundant test since we tested the skip bit before we took the LRU
> >> bit, so we shouldn't need to test it again after.
> >>
> >> I finally got my test setup working last night. I'll have to do some
> >> testing in my environment and I can start trying to see what is going
> >> on.
> >
> > So I ran the case-lru-file-mmap-read a few times and I don't see how
> > it is supposed to be testing the compaction code. It doesn't seem like
> > compaction is running at least on my system as a result of the test
> > script.
>
> atteched my kernel config, it is used on mine machine,

I'm just wondering what the margin of error is on the tests you are
running. What is the variance between runs? I'm just wondering if 3%
falls into the range of noise or possible changes due to just code
shifting around?

In order for the code to have shown any change it needs to be run and
I didn't see the tests triggering compaction on my test system. I'm
wondering how much memory you have available in the system you were
testing on that the test was enough to trigger compaction?

> > I wonder if testing this code wouldn't be better done using
> > something like thpscale from the
> > mmtests(https://github.com/gormanm/mmtests)? It seems past changes to
> > the compaction code were tested using that, and the config script for
> > the test explains that it is designed specifically to stress the
> > compaction code. I have the test up and running now and hope to
> > collect results over the weekend.
>
> I did the testing, but a awkward is that I failed to get result,
> maybe leak some packages.

So one thing I noticed is that if you have over 128GB of memory in the
system it will fail unless you update the sysctl value
vm.max_map_count. It defaulted to somewhere close to 64K, and I
increased it 20X to 1280K in order for the test to run without failing
on the mmap calls. The other edit I had to make was the config file as
the test system I was on had about 1TB of RAM, and my home partition
only had about 800GB to spare so I had to reduce the map size from
8/10 to 5/8.

> # ../../compare-kernels.sh
>
> thpscale Fault Latencies
> Can't locate List/BinarySearch.pm in @INC (@INC contains: /root/mmtests/b=
in/lib /usr/local/lib64/perl5 /usr/local/share/perl5 /usr/lib64/perl5/vendo=
r_perl /usr/share/perl5/vend.
> BEGIN failed--compilation aborted at /root/mmtests/bin/lib/MMTests/Stat.p=
m line 13.
> Compilation failed in require at /root/mmtests/work/log/../../bin/compare=
-mmtests.pl line 13.
> BEGIN failed--compilation aborted at /root/mmtests/work/log/../../bin/com=
pare-mmtests.pl line 13.

I had to install List::BinarySearch.pm. It required installing the
cpan perl libraries.

> >
> > There is one change I will probably make to this patch and that is to
> > place the new code that is setting skip_updated where the old code was
> > calling test_and_set_skip_bit. By doing that we can avoid extra checks
> > and it should help to reduce possible collisions when setting the skip
> > bit in the pageblock flags.
>
> the problem maybe on cmpchxg pb flags, that may involved other blocks cha=
nges.

That is the only thing I can think of just based on code review.
Although that would imply multiple compact threads are running, and as
I said in my tests I never saw kcompactd wakeup so I don't think the
tests you were mentioning were enough to stress compaction.
