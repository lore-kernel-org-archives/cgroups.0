From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
Date: Wed, 13 Jan 2021 11:12:54 -0800
Message-ID: <CALvZod4V3M=P8_Z14asBG8bKa=mYic4_OPLeoz5M7J5tsx=Gug@mail.gmail.com>
References: <20210112214105.1440932-1-shakeelb@google.com> <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
 <20210112234822.GA134064@carbon.dhcp.thefacebook.com> <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
 <CALvZod4am_dNcj2+YZmraCj0+BYHB9PnQqKcrhiOnV8gzd+S3w@mail.gmail.com> <20210113184302.GA355124@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U+qn9UKmISGqyuqrg148xyc55NGo3+P99P9eHwbXFks=;
        b=e1lWlrbSHGOadgLWl4yAg0TYAsrtiz9LRHk6SRNsnzPtIQqCuldKL1eq6Ryfk62/Lg
         HEqxNPjNuL2uJVZgjTuNsDb3sRYrPCu72vDogxVGm1xalOh7So+npokdRFzfAUgnxAKI
         AEGDGxQdnSMCtU3fAmR8N+90S/reL47zvPBpePRxPQuiI06xFzleYXPqhT+rhuSF3dgA
         ETEpN/5TZwmad6T52YfZbwSX1fyfEZV5qQKrSSED8hhFjuxq2Fy9krdE2ErAcGtjNIjX
         wuxVEABsyP1pJu1+J559gEfq3GbRwgFPWvEJE2wCGyS9M+Kt1lbDJmn5bvFmgBUXJsO1
         KUWA==
In-Reply-To: <20210113184302.GA355124@carbon.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Arjun Roy <arjunroy@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Eric Dumazet <edumazet@google.com>, Andrew Morton <akpm@linux-foundation.org>, "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, netdev <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Wed, Jan 13, 2021 at 10:43 AM Roman Gushchin <guro@fb.com> wrote:
>
> On Tue, Jan 12, 2021 at 04:18:44PM -0800, Shakeel Butt wrote:
> > On Tue, Jan 12, 2021 at 4:12 PM Arjun Roy <arjunroy@google.com> wrote:
> > >
> > > On Tue, Jan 12, 2021 at 3:48 PM Roman Gushchin <guro@fb.com> wrote:
> > > >
> > [snip]
> > > > Historically we have a corresponding vmstat counter to each charged page.
> > > > It helps with finding accounting/stastistics issues: we can check that
> > > > memory.current ~= anon + file + sock + slab + percpu + stack.
> > > > It would be nice to preserve such ability.
> > > >
> > >
> > > Perhaps one option would be to have it count as a file page, or have a
> > > new category.
> > >
> >
> > Oh these are actually already accounted for in NR_FILE_MAPPED.
>
> Well, it's confusing. Can't we fix this by looking at the new page memcg flag?

Yes we can. I am inclined more towards just using NR_FILE_PAGES (as
Arjun suggested) instead of adding a new metric.
