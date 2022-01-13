From: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: add cpu.stat_percpu
Date: Wed, 12 Jan 2022 17:55:05 -0800
Message-ID: <CABk29NtNhj2=6gHLSRp6XK4+BVtoSk3QgKdTbf4dKxTRdvgNtQ@mail.gmail.com>
References: <20220107234138.1765668-1-joshdon@google.com> <Yd189wHB2LJcK1Pv@hirez.programming.kicks-ass.net>
 <CABk29NuGs_9uxgbv678W=BGGinZNiUHO5T57FHGbOG+HP-FT2g@mail.gmail.com> <Yd8429VrPCay9cn4@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D2ktKUT0ZtiLTHav2IC7fy3Mir2Izcd/4dm2wCkI22w=;
        b=SY3ePgM97yidgxNWldi+d7gM+PpsH5FPjvc7229u0dHcM9x2xvBhxPBpCtbkIE8Mvn
         v3x0YpkJFKLpCIrxhFVDZ6qjg95luIe25UpohM3gMidzhz8xsTXuE7u2PPaL6JnO4A1q
         z+jne8C4detQHzRIWzEnj9GkiW55QYLmEDsWux7GVjcfcNvBhMVa3cA/ZFwJ3A7lYry5
         6lFbDsMOwSAuOSDFSPBOr94L4scOLs7aYtKsJck9UWZJqooB+0mGPZxinnHJEE+y/aSO
         sO36FUF+VOnSRMlgUEclnbaVbjOyMAdirr4fngkngenpD87g7Nclp9i4b4uvPwWn3oH7
         k/Tg==
In-Reply-To: <Yd8429VrPCay9cn4-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hi Tejun,

On Wed, Jan 12, 2022 at 12:24 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Tue, Jan 11, 2022 at 03:38:20PM -0800, Josh Don wrote:
> > Is the concern there just the extra overhead from making multiple
> > trips into this handler and re-allocating the buffer until it is large
> > enough to take all the output? In that case, we could pre-allocate
> > with a size of the right order of magnitude, similar to /proc/stat.
> >
> > Lack of per-cpu stats is a gap between cgroup v1 and v2, for which v2
> > can easily support this interface given that it already tracks the
> > stats percpu internally. I opted to dump them all in a single file
> > here, to match the consolidation that occurred from cpuacct->cpu.stat.
>
> Yeah, nack on this. That part was dropped intentionally. These text pseudo
> files aren't a great medium for this sort of (potentially large) data dump
> and they scale really badly with new fields which we may want to expose in
> the future. For detailed introspection, a better route would be using bpf
> and if that's inconvenient for some reason trying to make them more
> convenient.

Fair enough. Apart from needing to expose an rstat flush mechanism to
BPF, the main issues that come to mind are conveniently associating
with a particular cgroup, and allowing non-root to collect stats
independently. Hao's patch series
(https://lkml.kernel.org/r/%3C20220112192547.3054575-1-haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org%3E)
makes this particularly convenient, but that's a topic for a separate
conversation :)
