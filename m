From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/1] cgroup: make per-cgroup pressure stall tracking configurable
Date: Tue, 8 Jun 2021 12:01:54 -0700
Message-ID: <CAJuCfpFKBpz10eMaPjcycoLrJ=m68U9=hoEZAG=02Pa+zuBVZg@mail.gmail.com>
References: <20210524195339.1233449-1-surenb@google.com> <YL++cWuetMvfx9Tf@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Q62ke2XWkCOB5xI489ufG7OUF/C+vGscmBTXHr5cls=;
        b=JefvDSOvRlIAhXCAScJI3MkrvZhUIqoSdi6+Zz2+X+DhJhDkZGIb/RKdsWCOR4WEtZ
         tF7RtQv54pePx1GdKw4blv5HZiO6Z+lQKXXIlkM4+J2ovC5QPJv2Sb7qhE6oFEBKV4gH
         eOFrb4Hd9QdANKsb8iQUrZgkWOo9+QjRdiK1KDejN9LfyG3XLhosv9XRuSbvmKi9AsrS
         CAlZXeQeb7D73fVptUQ1IgolesraCPWKtmlUw38fv7/MZZERWznE9GnfY1NBzpLWunA9
         X9aOnqH7ZcssaOPiLi1NyvLnqcwaa5HORPlh/7FDqQWHu9NO7/J8QgryUQ4CoHgt4rTP
         c/vA==
In-Reply-To: <YL++cWuetMvfx9Tf-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E . McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, macro-fOkVWZO6G+f10XsdtD+oqA@public.gmane.org, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, M

On Tue, Jun 8, 2021 at 12:01 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Mon, May 24, 2021 at 12:53:39PM -0700, Suren Baghdasaryan wrote:
> > PSI accounts stalls for each cgroup separately and aggregates it at each
> > level of the hierarchy. This causes additional overhead with psi_avgs_work
> > being called for each cgroup in the hierarchy. psi_avgs_work has been
> > highly optimized, however on systems with large number of cgroups the
> > overhead becomes noticeable.
> > Systems which use PSI only at the system level could avoid this overhead
> > if PSI can be configured to skip per-cgroup stall accounting.
> > Add "cgroup_disable=pressure" kernel command-line option to allow
> > requesting system-wide only pressure stall accounting. When set, it
> > keeps system-wide accounting under /proc/pressure/ but skips accounting
> > for individual cgroups and does not expose PSI nodes in cgroup hierarchy.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> Applied to cgroup/for-5.14.
>
> Thanks.

Thanks folks!

>
> --
> tejun
