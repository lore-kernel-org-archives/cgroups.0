From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [External] Re: [RESEND PATCH v2 01/12] mm: memcontrol: fix
 NR_ANON_THPS account
Date: Fri, 11 Dec 2020 00:56:00 +0800
Message-ID: <CAMZfGtVqwUdXjS4WL97XUcrV4=U2si3pkcoeLbQbeS=k1uMgdA@mail.gmail.com>
References: <20201206101451.14706-1-songmuchun@bytedance.com>
 <20201206101451.14706-2-songmuchun@bytedance.com> <20201210160413.GH264602@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WNgKN7a4ded1LeBkq8RoIInVbovzz2QvQreFxC7eifA=;
        b=ngrw6r3STU/Y2YvnJY7eQsNYC2nhNp7w0fatD7eeX09k8h47QOCikE0TwWuSgtp318
         UpbWRrRKJw+AxR0sEi/HWSxsLXfRq8h5A6rL3xl/+vhPCJLuOKcE6PHAYgcX6CVcj96r
         ozPHOIebKkCQ2dasDIPUEULrRnSmQmY7edbwfV7AnRzgnQAd7Z4tGMVR+s+uNSdVjwoa
         3Ybb4So9apwKgYFpDY0Va15eDsYUnFOYSOA9122EdxeG8SAekN3QckiVt4NIIQ2p8ogh
         +LzA6FY+N50reiNcOrc0ywGp3fholP1Vxp1Lk6qEGtbrgH58W+2Rm7GEB7Pt5Mfs0l5R
         Ud6A==
In-Reply-To: <20201210160413.GH264602@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>, Roman Gushchin <guro@fb.com>, Mike Rapoport <rppt@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, esyr@redhat.com, peterx@redhat.com, krisman@collabora.com, Suren Baghdasaryan <surenb@google.com>, avagin@openvz.org, Marco Elver <elver@google.com>, Randy Dunlap <rdunlap@infradead.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>

On Fri, Dec 11, 2020 at 12:06 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Sun, Dec 06, 2020 at 06:14:40PM +0800, Muchun Song wrote:
> > The unit of NR_ANON_THPS is HPAGE_PMD_NR already. So it should inc/dec
> > by one rather than nr_pages.
> >
> > Fixes: 468c398233da ("mm: memcontrol: switch to native NR_ANON_THPS counter")
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>
> But please change the subject to
>
>         'mm: memcontrol: fix NR_ANON_THPS accounting in charge moving'

OK. Will do that. Thanks.

-- 
Yours,
Muchun
