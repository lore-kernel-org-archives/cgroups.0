From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: introduce per-memcg reclaim interface
Date: Tue, 22 Sep 2020 15:38:01 -0700
Message-ID: <CALvZod5fi51AHhhTCftDfzK-3duCuiJxH0MkGazVLxXkem=XpA@mail.gmail.com>
References: <20200909215752.1725525-1-shakeelb@google.com> <20200921163055.GQ12990@dhcp22.suse.cz>
 <CALvZod43VXKZ3StaGXK_EZG_fKcW3v3=cEYOWFwp4HNJpOOf8g@mail.gmail.com>
 <20200922114908.GZ12990@dhcp22.suse.cz> <CALvZod4FvE12o53BpeH5WB_McTdCkFTFXgc9gcT1CEHXzQLy_A@mail.gmail.com>
 <20200922165527.GD12990@dhcp22.suse.cz> <CALvZod7K9g9mi599c5+ayLeC4__kckv155QQGVMVy2rXXOY1Rw@mail.gmail.com>
 <20200922190859.GH12990@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kz1r3HryQXkqiHLbeEAR38DUzaGNclbO2eXYvZIA+ds=;
        b=PEveOPJ4f+0wPNEXIsHG8QLe8dbfpf8OdIEE6qNAO3XlrxzsUHAu74xNxac3EcBv9t
         dwEq57/jrqdVV/9aTw+Th/XfWtRdyXU6PKI3/dnPQxVV2LGqgvaOgOJv5OqTMymOVSsy
         WdVlHiF28s/uN7WlQsIHt0hHAcWAF+djM4/XWns9QU/+dfQwFJMwSDmyLmZV7LHrGHfL
         BkPhiggvEhn1Flrys0yzy4GOf3iZkydCMQmK9XKRAzArQmezqLJgaZaHSd34Ti50coa2
         Nv4uQ3TAP3SKcOC5xbevm8k2P32aTTvTD2nCMQbFnwfCjdFPsCm9OOKvfE/fxbqDL7s7
         2/aw==
In-Reply-To: <20200922190859.GH12990-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, Sep 22, 2020 at 12:09 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Tue 22-09-20 11:10:17, Shakeel Butt wrote:
> > On Tue, Sep 22, 2020 at 9:55 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> [...]
> > > Last but not least the memcg
> > > background reclaim is something that should be possible without a new
> > > interface.
> >
> > So, it comes down to adding more functionality/semantics to
> > memory.high or introducing a new simple interface. I am fine with
> > either of one but IMO convoluted memory.high might have a higher
> > maintenance cost.
>
> One idea would be to schedule a background worker (which work on behalf
> on the memcg) to do the high limit reclaim with high limit target as
> soon as the high limit is reached. There would be one work item for each
> memcg. Userspace would recheck the high limit on return to the userspace
> and do the reclaim if the excess is larger than a threshold, and sleep
> as the fallback.
>
> Excessive consumers would get throttled if the background work cannot
> keep up with the charge pace and most of them would return without doing
> any reclaim because there is somebody working on their behalf - and is
> accounted for that.
>
> The semantic of high limit would be preserved IMHO because high limit is
> actively throttled. Where that work is done shouldn't matter as long as
> it is accounted properly and memcg cannot outsource all the work to the
> rest of the system.
>
> Would something like that (with many details to be sorted out of course)
> be feasible?
>

Well what about the proactive reclaim use-case? You are targeting only
uswapd/background-reclaim use-case.

> If we do not want to change the existing semantic of high and want a new
> api then I think having another limit for the background reclaim then
> that would make more sense to me. It would resemble the global reclaim
> and kswapd model and something that would be easier to reason about.
> Comparing to echo $N > reclaim which might mean to reclaim any number
> pages around N.
> --

I am not really against the approach you are proposing but "echo $N >
reclaim" allows more flexibility and enables more use-cases.
