From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH memcg 0/1] false global OOM triggered by memcg-limited task
Date: Mon, 18 Oct 2021 22:34:02 -0700
Message-ID: <CALvZod4BKvm=DoLPVMyAF6e8bSg2aa63PZ6Kq24GxrRnHNsOcg@mail.gmail.com>
References: <9d10df01-0127-fb40-81c3-cc53c9733c3e@virtuozzo.com>
 <YW04jWSv6pQb2Goe@dhcp22.suse.cz> <6b751abe-aa52-d1d8-2631-ec471975cc3a@virtuozzo.com>
 <YW1gRz0rTkJrvc4L@dhcp22.suse.cz> <27dc0c49-a0d6-875b-49c6-0ef5c0cc3ac8@virtuozzo.com>
 <YW1oMxNkUCaAimmg@dhcp22.suse.cz> <CALvZod42uwgrg83CCKn6JgYqAQtR1RLJSuybNYjtkFo4wVgT1w@mail.gmail.com>
 <153f7aa6-39ef-f064-8745-a9489e088239@virtuozzo.com> <4a30aa18-e2a2-693c-8237-b75fffac9838@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RMl6loCX4NFJfsa056nJx2CwFXuES2+tyFDbKn9//yc=;
        b=hTuEcyIcrJwowhVFmr1Ryqylewdeyhe839N+rtYyyw854YKwj82YG8tP3ZrEIcyUj5
         3nBKlC3W5LVY6eQAImanPJUjibQ2OFhlBjIXWvcj2b550FKbwFt67vooTKvLoWjRuFz+
         vb66bneS468dgNCIaTDlsyxaW8tRR74sxQXupOSnhApyXlJrCGorx2qEVSZzrHLJOcg4
         7DJeN1Rb8uMxygEDTe9aPIOPDEEIox9moleQaYtIuNRyEX3FrwitftCf088a/A3nVgse
         nI1z4VydJxhIZ4l+CA5FkztaMVms9AWrRNAnd89DDLG0OEi9tvgc+rLPZVB/KtClHEcA
         9PJA==
In-Reply-To: <4a30aa18-e2a2-693c-8237-b75fffac9838-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Mon, Oct 18, 2021 at 12:19 PM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> On 18.10.2021 21:52, Vasily Averin wrote:
> > On 18.10.2021 18:07, Shakeel Butt wrote:
> >> On Mon, Oct 18, 2021 at 5:27 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >>>
> >>> [restore the cc list]
> >>>
> >>> On Mon 18-10-21 15:14:26, Vasily Averin wrote:
> >>>> On 18.10.2021 14:53, Michal Hocko wrote:
> >>>>> On Mon 18-10-21 13:05:35, Vasily Averin wrote:
> >>>>>> On 18.10.2021 12:04, Michal Hocko wrote:
> >>>>>> Here we call try_charge_memcg() that return success and approve the allocation,
> >>>>>> however then we hit into kmem limit and fail the allocation.
> >>>>>
> >>>>> Just to make sure I understand this would be for the v1 kmem explicit
> >>>>> limit, correct?
> >>>>
> >>>> yes, I mean this limit.
> >>>
> >>> OK, thanks for the clarification. This is a known problem. Have a look
> >>> at I think we consider that one to 0158115f702b ("memcg, kmem: deprecate
> >>> kmem.limit_in_bytes"). We are reporting the deprecated and to-be removed
> >>> status since 2019 without any actual report sugested by the kernel
> >>> message. Maybe we should try and remove it and see whether that prompts
> >>> some pushback.
> >>>
> >>
> >> Yes, I think now should be the right time to take the next step for
> >> deprecation of kmem limits:
> >> https://lore.kernel.org/all/20201118175726.2453120-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
> >
> > Are you going to push it to stable kernels too?
>
> Btw CONFIG_MEMCG_KMEM=y is set both in RHEL8 kernels and in ubuntu 20.04 LTS kernel 5.11.0-37.
>

CONFIG_MEMCG_KMEM is orthogonal to setting kmem limits. We are not
disabling the kmem accounting.
