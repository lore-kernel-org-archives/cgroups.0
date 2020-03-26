From: Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] cpuset: Make cpusets get restored on hotplug
Date: Thu, 26 Mar 2020 13:05:04 -0700
Message-ID: <CAPz6YkVUsDz456z8-X2G_EDd-uet1rRNnh2sDUpdcoWp_fkDDw@mail.gmail.com>
References: <20200326191623.129285-1-joel@joelfernandes.org>
 <20200326192035.GO162390@mtj.duckdns.org> <20200326194448.GA133524@google.com>
 <972a5c1b-6721-ac20-cec5-617af67e617d@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qfpdmD90qfG4APoootzAo2/56jymRHsiOC00dP4g/fg=;
        b=B8luIsXtML5nPUmmER8cy/dMcB25Mm+18STwz7qhe3LIg5oodvflcMC6OCHR1gLICT
         N8yFdxR4jDyxjIcSflwl86YyKxOX/oUYtpSLJALHbJdvSgg/PObAmPqlFK1dH0xbkUlb
         pFaKp3kabNKrodxQRf4bBD2G0e/8iJ9AVuQvRoGWLlg2mSGrencs1H1/kY+Y6GgpGJ1r
         5rMTvNhLkVYdQfBgefau6Vpj1FYkJx6MTjN3czU8XBIC2eq/HLsL6vKjezqHuVXkkCg3
         MzJkfZIqvUGDSWEV4O9N6YdpF4H2ykDkStRRZ+oWBuFb54n06C01AnX7RLj9kph9dXhG
         b4Jw==
In-Reply-To: <972a5c1b-6721-ac20-cec5-617af67e617d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Jesse Barnes <jsbarnes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, vpillai-tWEdnPwa2b6ifxm/DiOjgA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Guenter Roeck <groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Greg Kerr <kerrnel-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, Mar 26, 2020 at 12:57 PM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> On 3/26/20 3:44 PM, Joel Fernandes wrote:
> > Hi Tejun,
> >
> > On Thu, Mar 26, 2020 at 03:20:35PM -0400, Tejun Heo wrote:
> >> On Thu, Mar 26, 2020 at 03:16:23PM -0400, Joel Fernandes (Google) wrote:
> >>> This deliberately changes the behavior of the per-cpuset
> >>> cpus file to not be effected by hotplug. When a cpu is offlined,
> >>> it will be removed from the cpuset/cpus file. When a cpu is onlined,
> >>> if the cpuset originally requested that that cpu was part of the cpuset,
> >>> that cpu will be restored to the cpuset. The cpus files still
> >>> have to be hierachical, but the ranges no longer have to be out of
> >>> the currently online cpus, just the physically present cpus.
> >> This is already the behavior on cgroup2 and I don't think we want to
> >> introduce this big a behavior change to cgroup1 cpuset at this point.
> > It is not really that big a change. Please go over the patch, we are not
> > changing anything with how ->cpus_allowed works and interacts with the rest
> > of the system and the scheduler. We have just introduced a new mask to keep
> > track of which CPUs were requested without them being affected by hotplug. On
> > CPU onlining, we restore the state of ->cpus_allowed as not be affected by
> > hotplug.
> >
> > There's 3 companies that have this issue so that should tell you something.
> > We don't want to carry this patch forever. Many people consider the hotplug
> > behavior to be completely broken.
> >
> I think Tejun is concerned about a change in the default behavior of
> cpuset v1.
>
> There is a special v2 mode for cpuset that is enabled by the mount
> option "cpuset_v2_mode". This causes the cpuset v1 to adopt some of the
> v2 behavior. I introduced this v2 mode a while back to address, I think,
> a similar concern. Could you try that to see if it is able to address
> your problem? If not, you can make some code adjustment within the
> framework of the v2 mode. As long as it is an opt-in, I think we are
> open to further change.

I am surprised if anyone actually wants this behavior, we (Chrome OS)
found out about it accidentally, and then found that Android had been
carrying a patch to fix it.  And if it were a desirable behavior then
why isn't it an option in v2?

>
> Cheers,
> Longman
>
