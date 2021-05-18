From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v2 1/1] cgroup: make per-cgroup pressure stall tracking configurable
Date: Tue, 18 May 2021 11:23:04 -0700
Message-ID: <CAJuCfpHXhncetUziX=RS0kYTEQKHkeNXZA-hnz26bKkEJrHYzA@mail.gmail.com>
References: <20210518020200.1790058-1-surenb@google.com> <CALvZod7VBQMyftOffc8maCKtDwybLWGQNkk+R0M2SJPy2BuEjg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XVc3DguSfxxYVXN0x5EkHPuQLUSzK1Aah2uiT3qFU3o=;
        b=Eq/h3JfOdyqBY6BBO5kopAzTdIl0PltU1tMCHbexs2XtJruCLS1NvHNDaPu1TNILLK
         LHW5iZ0PyiH/o5kSjrNNGuJn5VLbno2vPoiX3TrYdYpPP+dfPyq0fl8p/fZbukNNcqit
         ec/bdh3lmKUH+XySetmyMsKvkdVT/1tfFwUM9MU75ZB+b3JCX898BSNR6vDFJaTtPVjG
         AjM2bern9kVDfDrFDzOmq9lZG5sCHq1Ebvu2v21Jqbd5GRRFTiu7k52IrwDexYDAcjcF
         qfiKoeaWruQbbSWciPbQN4CxIsaciRekjAsII29RgOcSM/QpaHM3jd9fk/j+AifNXOvX
         SCtQ==
In-Reply-To: <CALvZod7VBQMyftOffc8maCKtDwybLWGQNkk+R0M2SJPy2BuEjg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>, Ingo Molnar <mingo@redhat.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Benjamin Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Daniel Bristot de Oliveira <bristot@redhat.com>, "Paul E . McKenney" <paulmck@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, macro@orcam.me.uk, Viresh Kumar <viresh.kumar@linaro.org>, Mike

On Tue, May 18, 2021 at 11:08 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Mon, May 17, 2021 at 7:02 PM Suren Baghdasaryan <surenb@google.com> wrote:
> >
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
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> I am assuming that this is for Android and at the moment Android is
> only interested in system level pressure. I am wondering if there is
> any plan for Android to have cgroup hierarchies with explicit limits
> in future?

Correct and yes, we would like to use memcgs to limit memory in the
future, however we do not plan on using per-cgroup psi so far.

>
> If yes, then I think we should follow up (this patch is fine
> independently) with making this feature more general by explicitly
> enabling psi for each cgroup level similar to how we enable
> controllers through cgroup.subtree_control.
>
> Something like:
>
> $ echo "+psi" > cgroup.subtree_control
>
> This definitely would be helpful for server use cases where jobs do
> sub-containers but might not be interested in psi but the admin is
> interested in the top level job's psi.

Haven't thought about it before but that makes sense to me.
