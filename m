From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock: reviews
Date: Thu, 17 Sep 2020 08:39:34 -0700
Message-ID: <CAKgT0Ud8sYidvxtyrN3AFLs+-DiW7cuPGrKknaRicQsC8PLRtg@mail.gmail.com>
References: <alpine.LSU.2.11.2008262301240.4405@eggly.anvils>
 <alpine.LSU.2.11.2009081640070.7256@eggly.anvils> <61a42a87-eec9-e300-f710-992756f70de6@linux.alibaba.com>
 <alpine.LSU.2.11.2009091524260.10087@eggly.anvils> <855ad6ee-dba4-9729-78bd-23e392905cf6@linux.alibaba.com>
 <alpine.LSU.2.11.2009111634020.22739@eggly.anvils> <5cfc6142-752d-26e6-0108-38d13009268b@linux.alibaba.com>
 <alpine.LSU.2.11.2009150112130.1550@eggly.anvils> <20200915165807.kpp7uhiw7l3loofu@ca-dmjordan1.us.oracle.com>
 <c3362c0a-3707-3a3d-9955-960d95f3ad8c@linux.alibaba.com> <20200917143519.lhdfnoc47qrmbhaz@ca-dmjordan1.us.oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+9HU43KroNK5/x6wnhb2ZPEi6bPpfMElvU5+soOALQc=;
        b=WILyDFJqy/kKppDyOXiv0T0ZJeoRPbsBrW+7oCxHCSzypdd0t9S2MeYT/bSdApP/pK
         yDT3toE44n1//aXcVJqtiZALsGX6gYub0Lj2RthM0Eb8YPYutIppe3s+iJasQDNFdWxN
         x6vc4gQ0VnYI2VMMVKYHpBdbIxHQ8TleU96wpk4sjSOPC2SaPiBy1w5ccYTRNg6mu9kQ
         T5PtHr2DR/bv9S2bjQRnrQEYZOwsx+DOYWNC5wlf+K4A5m066MyWwa/eN58LHhXtnutz
         Mqx3V0JDt8c7JMIIap0P8HISCbbafv2ol/KoD4rSnLph5PIdCTR7M7/pGif4EaBTDFUX
         WwKw==
In-Reply-To: <20200917143519.lhdfnoc47qrmbhaz-S51bK0XF4qpuJJETbFA3a0B3C2bhBk7L0E9HWUfgJXw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Vlastimil Babka <vbabka@s>

On Thu, Sep 17, 2020 at 7:26 AM Daniel Jordan
<daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Thu, Sep 17, 2020 at 10:37:45AM +0800, Alex Shi wrote:
> > =E5=9C=A8 2020/9/16 =E4=B8=8A=E5=8D=8812:58, Daniel Jordan =E5=86=99=E9=
=81=93:
> > > On Tue, Sep 15, 2020 at 01:21:56AM -0700, Hugh Dickins wrote:
> > >> On Sun, 13 Sep 2020, Alex Shi wrote:
> > >>> Uh, I updated the testing with some new results here:
> > >>> https://lkml.org/lkml/2020/8/26/212
> > >> Right, I missed that, that's better, thanks.  Any other test results=
?
> > > Alex, you were doing some will-it-scale runs earlier.  Are you planni=
ng to do
> > > more of those?  Otherwise I can add them in.
> >
> > Hi Daniel,
> >
> > Does compaction perf scalable, like thpscale, I except they could get s=
ome benefit.
>
> Yep, I plan to stress compaction.  Reclaim as well.
>
> I should have said which Alex I meant.  I was asking Alex Duyck since he'=
d done
> some will-it-scale runs.

I probably won't be able to do any will-it-scale runs any time soon.
If I recall I ran them for this latest v18 patch set and didn't see
any regressions like I did with the previous set. However the system I
was using is tied up for other purposes and it may be awhile before I
can free it up to look into this again.

Thanks.

- Alex
