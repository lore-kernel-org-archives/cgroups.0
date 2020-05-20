From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH mm v4 3/4] mm: move cgroup high memory limit setting into
 struct page_counter
Date: Tue, 19 May 2020 17:21:52 -0700
Message-ID: <CALvZod52fmmdcXOCBEW=yE_nSxiJv5PrUV_jALOHC0wh47zVAg@mail.gmail.com>
References: <20200519171938.3569605-1-kuba@kernel.org> <20200519171938.3569605-4-kuba@kernel.org>
 <CALvZod4i2sBWcbKe3MHMuSMV3ywWwQx1Xr-abEqPS6n8vioC7w@mail.gmail.com> <20200519161438.4f11ddec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yTql++3gFASshPrg+T0nmbJwBgbfv14jSHy1pTffRhU=;
        b=NiUCaCohQuLliM+U2l50qqLl57m8zQFJsQk3xhIisLLSkrO4qnnyY4emxRxJ5aAruF
         PjefQUYiKxx5vRTksxhTvVAiq5LGu6NPL/tKYyIAzl1NQj+qX2YWvoWRbQ3XtE66OCMs
         dnJqRiiOUfnMr7z+qZXG3oJ2wGUgaki2nxodtQIEGJMybq8cxprMZ4brtnXlhmtqh/kQ
         TS682Hpjz6G/JybgJ3AhDnMwqldcFpPE1CAzWXuY1tz4QyxI6pn4i6MZE976sZ9W0wFa
         3kGFcrvISClJst13OMTGf4Qj9hfJhMx4G1Y/XGxZcGxQw1Fj6N3BJJXOtO4sMqM6MHJX
         xw1w==
In-Reply-To: <20200519161438.4f11ddec-CbGlpYbfshD2+ikPA6JUzH8MC5kE+Go+7OQnqPW8cmTNHmdVIy2bbWItS4zQEDct@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue, May 19, 2020 at 4:14 PM Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Tue, 19 May 2020 15:15:41 -0700 Shakeel Butt wrote:
> > > --- a/mm/page_counter.c
> > > +++ b/mm/page_counter.c
> > > @@ -198,6 +198,11 @@ int page_counter_set_max(struct page_counter *counter, unsigned long nr_pages)
> > >         }
> > >  }
> > >
> > > +void page_counter_set_high(struct page_counter *counter, unsigned long nr_pages)
> > > +{
> > > +       WRITE_ONCE(counter->high, nr_pages);
> > > +}
> > > +
> >
> > Any reason not to make this static inline like
> > page_counter_is_above_high() and in page_counter.h?
>
> My reason was consistency with other page_counter_set_xyz() helpers,
> but obviously happy to change if needed...

I think it should be in the header and inlined.
