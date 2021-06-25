From: Ronny Meeus <ronny.meeus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Short process stall after assigning it to a cgroup
Date: Fri, 25 Jun 2021 13:34:53 +0200
Message-ID: <CAMJ=MEfCpY-ZRq_mXUOU6=w9vvgNpF3DWGBWbGz6GzoY6bYtSQ@mail.gmail.com>
References: <CAMJ=MEegYBi_G=_nk1jaJh-dtJj59EFs6ehCwP5qSBqEKseQ-Q@mail.gmail.com>
 <YNNvK0koEdkuD/z3@blackbook> <CAMJ=MEfMSX06-mcKuv54T7_VCCrv8uZsN-e-QiHe8-sx-sXVoA@mail.gmail.com>
 <YNWZW/WhdP50F4xy@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CvU9SJEajbsXtfHda6+kKDOJRbuR3DlWfO4uCMK/qPI=;
        b=Ds0LgUziVbhxE9Pg2UM2H+gxbvMESW5DSHxWrgkyl/gSNhV/VEHUikNS5JtUac4mzQ
         kSHeXy3mNAxUOARUomSr8brTzYoZDZ3XRZOaUAkZO6d/VprbI2cHoF0CVZfC8uWeau6r
         nAEsfkx0r42HUCcxMgrr/vEnoCE5prmU3UeA7HXMFfVmbjnCssqP/o4BS5pfMzf+bhsB
         CyhKA6nkZKF5TWSu3CwWw/wIgMKYmcuMslUtNYYMGL0t7MoUR+io7A43ExDXIpf/lZOi
         w63O3sUgnX3r3FNmSJRFqr+4pAjfqvTYZT/3PxfmqxASTtRe4IeH647HdEDcT9yN7A63
         3Mwg==
In-Reply-To: <YNWZW/WhdP50F4xy@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Op vr 25 jun. 2021 om 10:52 schreef Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org>:
>
> On Fri, Jun 25, 2021 at 09:32:59AM +0200, Ronny Meeus <ronny.meeus@gmail.=
com> wrote:
> > The application does not have strict RT requirements.
>
> Can you even use the normal non-RT scheduling policy? ...

No since we want certain functions (like packet processing) to have a
higher priority than for example management activities.

>
> > We were working with fixed croups initially but this has the big
> > disadvantage that the unused budget configured in one group cannot be
> > used by another group and as such the processing power is basically
> > lost.
>
> ...then your problem may be solvable with mere weights to adjust prioriti=
es
> of competitors. (Or if you need to stick with RT policies you can assign
> different priorities on task basis, I wouldn't use RT groups for that.)
>
> > About the stack: it is difficult to know from the SW when the issue
> > happens so dumping the stack is not easy I think but it is a good
> > idea.
> > I will certainly think about it.
>
> You may sample it periodically or start prior a migration to get more
> insights what's causing the delay.
>

I observed that when I create the cgroups dynamically (at the moment I
need them) and immediately assign the threads to it, the symptom seems
to be gone.
I'm going to observe the system some more to confirm that the problem
is really solved in this way.

Thanks Michal for the time you spent on this.

> Regards,
> Michal
>
