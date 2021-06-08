From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 1/1] cgroup: make per-cgroup pressure stall tracking
 configurable
Date: Tue, 8 Jun 2021 14:51:32 -0400
Message-ID: <YL+8NG8xBJmA6lOq@cmpxchg.org>
References: <20210524195339.1233449-1-surenb@google.com>
 <YKz07nx3E8UEo1xa@cmpxchg.org>
 <CAJuCfpE2U3LAZP_42b7XV7rfQTdJWbTVw43TDcxGM95oW03upQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BHtJ01+O9MGfngUx/tkkUwGswFNUD5Vr6xavfI/bB+w=;
        b=v3P4A1Ia9fsZuLq0N6xEVC9DWIR7E5XQuvfED1xa+4ijHr+R0m5duY4PKJQvebPG15
         hRsCLgqHerQAPTwhfmwD7jTNb/ulH6gF+KGJ+w76AqRERi19GdhmSOj+dZ+2zYIxX57C
         uw4tKBJkwaiv6f2xuCQt+8NnVu5ChESNI3Z4Upi4KY8a6frhl+UguSbowW9snrC9grp6
         lqG8bEjshk27OswFtIzW06u2agWPAgiLdpeKcMkkXteZHMGasVnfRVvEUt5AH4H23uMd
         LFi9PFcCnOjOrPCZOr5VVTCXC7q9GaoKD79JiY+vGKpDQIqEBAZDqHWTraY1bruDCPsV
         Uycw==
Content-Disposition: inline
In-Reply-To: <CAJuCfpE2U3LAZP_42b7XV7rfQTdJWbTVw43TDcxGM95oW03upQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E . McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, macro-fOkVWZO6G+f10XsdtD+oqA@public.gmane.org, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mike Kravetz <mike.k>

On Tue, Jun 08, 2021 at 09:25:08AM -0700, Suren Baghdasaryan wrote:
> On Tue, May 25, 2021 at 6:00 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> >
> > On Mon, May 24, 2021 at 12:53:39PM -0700, Suren Baghdasaryan wrote:
> > > PSI accounts stalls for each cgroup separately and aggregates it at each
> > > level of the hierarchy. This causes additional overhead with psi_avgs_work
> > > being called for each cgroup in the hierarchy. psi_avgs_work has been
> > > highly optimized, however on systems with large number of cgroups the
> > > overhead becomes noticeable.
> > > Systems which use PSI only at the system level could avoid this overhead
> > > if PSI can be configured to skip per-cgroup stall accounting.
> > > Add "cgroup_disable=pressure" kernel command-line option to allow
> > > requesting system-wide only pressure stall accounting. When set, it
> > > keeps system-wide accounting under /proc/pressure/ but skips accounting
> > > for individual cgroups and does not expose PSI nodes in cgroup hierarchy.
> > >
> > > Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> Gentle ping for cgroup folks to please take a look at the cgroup interface part.

Tejun, this is more in cgroups territory than it is psi/scheduler, and
should go through the cgroup tree.

Both the psi and the cgroup side look good to me, and we have Peter's
ack from the scheduler too.

Do you have concerns about the cgroup side? If not, would you mind
picking this up for 5.14?

Thanks
