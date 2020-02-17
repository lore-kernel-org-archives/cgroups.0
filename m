From: Dave Chiluk <chiluk+linux-Ad+Cokg7I4LQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] sched/fair: add burst to cgroup cpu bandwidth controller
Date: Mon, 17 Feb 2020 13:56:29 -0600
Message-ID: <CAC=E7cUgALi4g19GsDZQemHafQfaSpjY1XUo3Swrv_g1PaWejQ@mail.gmail.com>
References: <157476581065.5793.4518979877345136813.stgit@buzz>
 <CAC=E7cU8TeNHDRnrHiFxmiHUKviVU9KaDvMq-U16VRgcohg6-w@mail.gmail.com> <xm268sl5uhgo.fsf@bsegall-linux.svl.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=anZc7OW31U8MO5ygkvDDyIY0GQBGMdLs3iSe01Jj7l0=;
        b=sGkUgr2hS2qh3wTv0ktQzRELdeLNVOJRw8PZLR83DdUf9jRoBChFnzmLtAXvRX0ad9
         C4Vpbg4AjpwXtzZGSDBzumuHuXBm77L3DHxhhI4bCkVQkbZZHcIkB0lMVmzQJM/WKLFk
         YOMXm8H4OMQC1q+U1UmngJUHT7IGElm9QTtHI=
In-Reply-To: <xm268sl5uhgo.fsf-M9t8jLq8akVytAvllHb3VjMT+SY0ea6hE+xayQeTSWMAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Cong Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>

On Fri, Feb 14, 2020 at 12:55 PM <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> I'm not sure that starting with full burst runtime is best, though it
> definitely seems likely to be one of those things where sometimes it's
> what you want and sometimes it's not.

We (Indeed) definitely want to start with a full burst bank in most
cases, as this would help with slow/throttled start-up times for our
Jitted and interpreter-based language applications.  I agree that it
would be nice to have it be configurable.

Dave.
fyi.  Unfortunately, this e-mail may be temporarily turned off for the
next few weeks, I apologize in advance for any bounced messages to me.
