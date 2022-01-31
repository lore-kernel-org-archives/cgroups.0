From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] mm, memcg: Don't put offlined memcg into local stock
Date: Mon, 31 Jan 2022 10:00:24 -0800
Message-ID: <CALvZod6_L1Q1xnjx26cgNgXHhpH=Mvdkk98f2=AAo=euwYY62Q@mail.gmail.com>
References: <20211001190938.14050-1-longman@redhat.com> <20211001190938.14050-2-longman@redhat.com>
 <YVefHLo1+6lgw3aB@carbon.dhcp.thefacebook.com> <f7026256-4086-6632-569e-5b13594cb3fc@redhat.com>
 <YfgV2iiaVlR0hozD@carbon.dhcp.thefacebook.com> <95ba1931-e9c9-45c3-b080-d28f2ad368a7@redhat.com>
 <c950a93d-bb70-9a97-dabe-a1d58d755dad@redhat.com> <YfgaIcSJhqEOnh65@carbon.dhcp.thefacebook.com>
 <9abc9cb8-8734-90b0-c495-8df89c7bb579@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZDAib+Bb/dH824cDSeLWITIJZuwoFHO7+dlyhfyg7SU=;
        b=bnGr1AtWDiuxZ4vCWPPtTrf0rCqdtKwtwCLDhRqdlmk/VByNX7ZDiYGlLu9UpojJuk
         cmrsI6WYoRXCN5xMdZW/vwApSpcBGKGj/vyMWBkkg8/4ABU8qzFO8Z8Ytq+nyV8L5rAx
         bPz29zv8jlQQT4kwtfAsG28PDsrgq0akpP0/bJ47B8d+kCcbZMc6nvW/gDsEiDHlBPgR
         SpXeezyCMttodSaARcOLP4wnQZLtSA0c5gtAiq+gH1S+CkUz36zRT2ZhKOvy5O1UMhsg
         eyVEFe4mMhm1ogImTdcQh+c2UYLHF0DdNC/kApoDZHqKhHscWYijtUUJ2JjSYLbGGpMK
         p37Q==
In-Reply-To: <9abc9cb8-8734-90b0-c495-8df89c7bb579-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Mon, Jan 31, 2022 at 9:25 AM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> On 1/31/22 12:19, Roman Gushchin wrote:
> > On Mon, Jan 31, 2022 at 12:15:19PM -0500, Waiman Long wrote:
> >> On 1/31/22 12:09, Waiman Long wrote:
> >>> On 1/31/22 12:01, Roman Gushchin wrote:
> >>>> On Sun, Jan 30, 2022 at 10:55:56PM -0500, Waiman Long wrote:
> >>>>> On 10/1/21 19:51, Roman Gushchin wrote:
> >>>>>> On Fri, Oct 01, 2021 at 03:09:36PM -0400, Waiman Long wrote:
> >>>>>>> When freeing a page associated with an offlined memcg, refill_stock()
> >>>>>>> will put it into local stock delaying its demise until another memcg
> >>>>>>> comes in to take its place in the stock. To avoid that, we now check
> >>>>>>> for offlined memcg and go directly in this case to the slowpath for
> >>>>>>> the uncharge via the repurposed cancel_charge() function.
> >>>>>> Hi Waiman!
> >>>>>>
> >>>>>> I'm afraid it can make a cleanup of a dying cgroup slower: for every
> >>>>>> released page we'll potentially traverse the whole cgroup tree and
> >>>>>> decrease atomic page counters.
> >>>>>>
> >>>>>> I'm not sure I understand the benefits we get from this change which
> >>>>>> do justify the slowdown on the cleanup path.
> >>>>>>
> >>>>>> Thanks!
> >>>>> I was notified of a lockdep splat that this patch may help to prevent.
> >>>> Would you mind to test this patch:
> >>>> https://www.spinics.net/lists/cgroups/msg31244.html  ?
> >>>>
> >>>> It should address this dependency.
> >>> Thanks for the pointer. I believe that your patch should be able to
> >>> address this circular locking dependency.
> >>>
> >>> Feel free to add my
> >>>
> >>> Reviewed-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> BTW, have you posted it to lkml? If not, would you mind doing so?
> > Not yet.
> >
> > I was waiting for Alexander to confirm that it resolves the originally reported
> > issue. I just pinged him, will wait for tomorrow and post the patch in any case.
> >
> > Thanks!
>
> I see. This is not a problem that is easily reproducible. You need to
> hit the right timing for the lockdep splat to appear.

I agree here. The patch on its own has merits as it is reducing
dependency on an unrelated lock.
