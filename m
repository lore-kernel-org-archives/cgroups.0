From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH memcg 0/1] false global OOM triggered by memcg-limited task
Date: Mon, 18 Oct 2021 10:13:22 -0700
Message-ID: <CALvZod4pET2ZYWwsEP3Q+uGpGNb+TEVgRg5yo1h+mRK-_ZB+Cw@mail.gmail.com>
References: <9d10df01-0127-fb40-81c3-cc53c9733c3e@virtuozzo.com>
 <YW04jWSv6pQb2Goe@dhcp22.suse.cz> <6b751abe-aa52-d1d8-2631-ec471975cc3a@virtuozzo.com>
 <YW1gRz0rTkJrvc4L@dhcp22.suse.cz> <27dc0c49-a0d6-875b-49c6-0ef5c0cc3ac8@virtuozzo.com>
 <YW1oMxNkUCaAimmg@dhcp22.suse.cz> <CALvZod42uwgrg83CCKn6JgYqAQtR1RLJSuybNYjtkFo4wVgT1w@mail.gmail.com>
 <YW2mDDYRkXkQbZAR@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DyNcrwLKTjtZ0VloCKphs+CNM4GqGJ0HGRhbR/SC9mk=;
        b=mijnuQhJ93hdYipWZXXygB5cY0SIRliRAWdWH3/kL+XbMVop56Aczh+/fs0SiJ4dTo
         1Jzme2KYKdg9zMBZ374t9j+jHm3BDMuePiHsAp43XySR+grbVlX7G+/IxLq8E/VDhRrf
         WkGghth9kDhfkSTT+6XINlNGdF89J7AvQIyRG4JrsOZcY94WatVDEuPklMLvBOmQGhYE
         RJbWGCaEyRLuT/L3C2y1WDN9KZe+1+5UKPx4GfqvCY/x1xeRxyXhtIkxYuq3knq0VGsZ
         okIJhAaFnB1/4Db26FYIwYsIepSIErmBT22pXILJNwPvl5f8TykZ59Qc4bLYd5U+j6A0
         fz9g==
In-Reply-To: <YW2mDDYRkXkQbZAR@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Vasily Averin <vvs@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Uladzislau Rezki <urezki@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@techsingularity.net>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, kernel@openvz.org

On Mon, Oct 18, 2021 at 9:51 AM Michal Hocko <mhocko@suse.com> wrote:
>
> On Mon 18-10-21 08:07:20, Shakeel Butt wrote:
> > On Mon, Oct 18, 2021 at 5:27 AM Michal Hocko <mhocko@suse.com> wrote:
> > >
> > > [restore the cc list]
> > >
> > > On Mon 18-10-21 15:14:26, Vasily Averin wrote:
> > > > On 18.10.2021 14:53, Michal Hocko wrote:
> > > > > On Mon 18-10-21 13:05:35, Vasily Averin wrote:
> > > > >> On 18.10.2021 12:04, Michal Hocko wrote:
> > > > >> Here we call try_charge_memcg() that return success and approve the allocation,
> > > > >> however then we hit into kmem limit and fail the allocation.
> > > > >
> > > > > Just to make sure I understand this would be for the v1 kmem explicit
> > > > > limit, correct?
> > > >
> > > > yes, I mean this limit.
> > >
> > > OK, thanks for the clarification. This is a known problem. Have a look
> > > at I think we consider that one to 0158115f702b ("memcg, kmem: deprecate
> > > kmem.limit_in_bytes"). We are reporting the deprecated and to-be removed
> > > status since 2019 without any actual report sugested by the kernel
> > > message. Maybe we should try and remove it and see whether that prompts
> > > some pushback.
> > >
> >
> > Yes, I think now should be the right time to take the next step for
> > deprecation of kmem limits:
> > https://lore.kernel.org/all/20201118175726.2453120-1-shakeelb@google.com/
>
> I completely forgot about your patch.  Anyway, it usually takes us years
> to deprecate something so let's stick with it and consider 2 years as
> years ;)
>

Sure, I will rebase and resend.
