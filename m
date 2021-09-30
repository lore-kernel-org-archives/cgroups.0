From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup-v1: Grant CAP_SYS_NICE holders permission to
 move tasks between cgroups
Date: Thu, 30 Sep 2021 14:20:53 -0700
Message-ID: <CAJuCfpHvRuapSMa2KMdF4_-8fKdqtx_gYVKyw5dYT6XjfRrDfg@mail.gmail.com>
References: <20210617090941.340135-1-lee.jones@linaro.org> <YMs08Ij8PZ/gemLL@slm.duckdns.org>
 <YMs5ssb50B208Aad@dell>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c+ez2fuj6x2arikU4FELGnLHBGOaPBSZKyEOfKhurP0=;
        b=Vjck3gCd3Rwg2cn5LKRjQog78fLTppRrQ4DyI31rbFU8aucgUnMYfxuS+Sq30YpzRT
         RhDZXELtttMX+dNOY/hYQgHdjzJdsgRnbwAdl8zRc5AMFMFNWa+TxLyaobvvFzafzbQp
         IbcMay1giYTIjiJwwjQy/W7o+Tr20zAjm6w9r9al838MBHHNlHzAY3Uhgmwj6fj/qDGj
         FrHGFt639+INeUtXdPbeeVB9HOQMTP4uA1pCyIqjEBE+mi3haLKx0S4uQHUPP9UvVm6O
         aG0tRL+7/tE8RVnGzPeUWQVdP+WhFbJ1sinaB8TpJk8/yEkatmPnIjuGVISSwB/Hz4GM
         j4AA==
In-Reply-To: <YMs5ssb50B208Aad@dell>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jun 17, 2021 at 5:02 AM Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
> Hi Tejun,
>
> Thanks for your reply.
>
> On Thu, 17 Jun 2021, Tejun Heo wrote:
> > On Thu, Jun 17, 2021 at 10:09:41AM +0100, Lee Jones wrote:
> > > It should be possible for processes with CAP_SYS_NICE capabilities
> > > (privileges) to move lower priority tasks within the same namespace t=
o
> > > different cgroups.
> >
> > I'm not sure that "should" is justified that easily given that cgroup c=
an
> > affect things like device access permissions and basic system organizat=
ion.
>
> The latter part of that sentence does provide some additional caveats.
>
> > > One extremely common example of this is Android's 'system_server',
> > > which moves processes around to different cgroups/cpusets, but should
> > > not require any other root privileges.
> >
> > Why is this being brought up now after all the years?

Currently Android uses an out-of-tree patch to work around this issue.

>
> This has been discussed before?
>
> I didn't find any evidence of that on the lists.

IIRC, John Stultz from Linaro tried to upstream a similar patch before.

>
> > Isn't android moving onto cgroup2 anyway?
>
> That I would have to check.

Some of the controllers are moving to cgroup v2 but not all of them
are there yet. For example, there are still some issues with moving
the cpu controller to v2 which I believe were discussed during Android
Microconference at LPC 2021.

>
> --
> Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]
> Senior Technical Lead - Developer Services
> Linaro.org =E2=94=82 Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
