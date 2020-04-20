From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Mon, 20 Apr 2020 09:12:54 -0700
Message-ID: <CALvZod6M4OsM-t8m_KX9wCkEutdwUMgbP9682eHGQor9JvO_BQ@mail.gmail.com>
References: <20200417010617.927266-1-kuba@kernel.org> <CALvZod78ZUhU+yr2x1h_gv+VgVGTPnSSGKh_+fd+MeiAKreJvg@mail.gmail.com>
 <20200417162355.GA43469@mtj.thefacebook.com> <CALvZod4ftvXCu8SbQUXwTGVvx5K2+at9h30r28chZLXEB1JdfQ@mail.gmail.com>
 <20200417173615.GB43469@mtj.thefacebook.com> <CALvZod7-r0OrJ+-_uCy_p3BU3348ve2+YatiSdLvFaVqcqCs=w@mail.gmail.com>
 <20200417193539.GC43469@mtj.thefacebook.com> <CALvZod6LT25t9aAA1KHmf1U4-L8zSjUXQ4VQvX4cMT1A+R_g+w@mail.gmail.com>
 <20200417225941.GE43469@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dfnbaRIAsllucTJQqQcadbN8F/8KsJlw6FggVLdXySc=;
        b=RExdkPNluxT8pywLn0mtot2iKfm78aU0yPMPN3JNMBc8hy69Jb74NTwJ9/mDzYEJJM
         70Vy46SFhMEz2tYTGzL4RnmZPsCYPMcBs/f/MnY39ZeU6R/nbXjgZYtKn50ehe9Tm5yB
         1Yn4Kt6WA2bvJ2Rc5ayjUpyoiPNE1HQRcpCD/xcLLH9T7yVmC2ri9Vs69gIQeqmMGatc
         zorcuCdFsSoQfj2FhDBVAE2NB6FURZVGBAtPIf5fTiTG8dwbldca3AFT/xnz+egLIwHV
         KV5uGCstV5LzALGPFVaNN8GJO4P5HygcgphYyX1uw17aG4HScrTAed8yooDnTtWscXUm
         M2Jw==
In-Reply-To: <20200417225941.GE43469-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Tejun,

On Fri, Apr 17, 2020 at 3:59 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello, Shakeel.
>
> On Fri, Apr 17, 2020 at 02:51:09PM -0700, Shakeel Butt wrote:
> > > > In this example does 'B' have memory.high and memory.max set and by A
> > >
> > > B doesn't have anything set.
> > >
> > > > having no other restrictions, I am assuming you meant unlimited high
> > > > and max for A? Can 'A' use memory.min?
> > >
> > > Sure, it can but 1. the purpose of the example is illustrating the
> > > imcompleteness of the existing mechanism
> >
> > I understand but is this a real world configuration people use and do
> > we want to support the scenario where without setting high/max, the
> > kernel still guarantees the isolation.
>
> Yes, that's the configuration we're deploying fleet-wide and at least the
> direction I'm gonna be pushing towards for reasons of generality and ease of
> use.
>
> Here's an example to illustrate the point - consider distros or upstream
> desktop environments wanting to provide basic resource configuration to
> protect user sessions and critical system services needed for user
> interaction by default. That is something which is clearly and immediately
> useful but also is extremely challenging to achieve with limits.
>
> There are no universally good enough upper limits. Any one number is gonna
> be both too high to guarantee protection and too low for use cases which
> legitimately need that much memory. That's because the upper limits aren't
> work-conserving and have a high chance of doing harm when misconfigured
> making figuring out the correct configuration almost impossible with
> per-use-case manual tuning.
>
> The whole idea behind memory.low and related efforts is resolving that
> problem by making memory control more work-conserving and forgiving, so that
> users can say something like "I want the user session to have at least 25%
> memory protected if needed and possible" and get most of the benefits of
> carefully crafted configuration. We're already deploying such configuration
> and it works well enough for a wide variety of workloads.
>

I got the high level vision but I am very skeptical that in terms of
memory and performance isolation this can provide anything better than
best effort QoS which might be good enough for desktop users. However,
for a server environment where multiple latency sensitive interactive
jobs are co-hosted with multiple batch jobs and the machine's memory
may be over-committed, this is a recipe for disaster. The only
scenario where I think it might work is if there is only one job
running on the machine.

I do agree that finding the right upper limit is a challenge. For us,
we have two types of users, first, who knows exactly how much
resources they want and second ask us to set the limits appropriately.
We have a ML/history based central system to dynamically set and
adjust limits for jobs of such users.

Coming back to this path series, to me, it seems like the patch series
is contrary to the vision you are presenting. Though the users are not
setting memory.[high|max] but they are setting swap.max and this
series is asking to set one more tunable i.e. swap.high. The approach
more consistent with the presented vision is to throttle or slow down
the allocators when the system swap is near full and there is no need
to set swap.max or swap.high.

thanks,
Shakeel
