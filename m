From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm: page_counter: rearrange struct page_counter fields
Date: Thu, 25 Aug 2022 08:24:02 -0700
Message-ID: <CALvZod6tFce5Ld9rh-xt495S+A-vi4Curkja2YYyf0VizKw1tw@mail.gmail.com>
References: <20220825000506.239406-1-shakeelb@google.com> <20220825000506.239406-3-shakeelb@google.com>
 <20220824173330.2a15bcda24d2c3c248bc43c7@linux-foundation.org>
 <CALvZod6+Y1yvp8evMLTeEwKnQyoXJmzjO7xLN9w=EPcOUH6BHQ@mail.gmail.com> <20220824222150.61c516a83bfe0ecb6c9b5348@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Sjxu1KZYU3KDG78+cZAn5+zrZMruhm46V6F/elCTC6I=;
        b=cgdSCg/G5MIqnMdtGF27PjSCoHoxA2BsgT02jo7Ty55H5CD+J3M0vHpW6lHr8NcHWU
         X4d85j0jzRSVoQQ1MCpo3IQxt2FbpJcglk7ukGEyRJIhQszVQ9wx2i35z97DqqSPd8oC
         VCP76agWwaX+4eMZ+QIx3J3v9Nver8Y2hT/qeJt1TMaAprapOxqq9WUzYpSdGmHshkAY
         GfaP+h3+0CtF8cAYQQM3KgFAd8WHhKHivvxwKgX45zfRGdSEJ/wxeU6tfT/4yjg6gHiJ
         kPNYCejF6P/dRAtVBxvPeyL9+3p/YImkl2YVTcNEsoYooOr0nt/CrL9psmY7f6J0bNqd
         Y+dw==
In-Reply-To: <20220824222150.61c516a83bfe0ecb6c9b5348-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Aug 24, 2022 at 10:21 PM Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> On Wed, 24 Aug 2022 21:41:42 -0700 Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> > > Did you evaluate the effects of using a per-cpu counter of some form?
> >
> > Do you mean per-cpu counter for usage or something else?
>
> percpu_counter, perhaps.  Or some hand-rolled thing if that's more suitable.
>
> > The usage
> > needs to be compared against the limits and accumulating per-cpu is
> > costly particularly on larger machines,
>
> Well, there are tricks one can play.  For example, only run
> __percpu_counter_sum() when `usage' is close to its limit.
>
> I'd suggest flinging together a prototype which simply uses
> percpu_counter_read() all the time.  If the performance testing results
> are sufficiently promising, then look into the accuracy issues.
>

Thanks, I will take a stab at that in a week or so.
