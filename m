From: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 4/4] cpuset: Add cpusets.quiesce option
Date: Thu, 27 Mar 2014 09:59:21 +0530
Message-ID: <CAKohpom-OAcvhQqVv9Vy9aMHFEZNaO=sGrF=C=OFYuDv2RgQJQ@mail.gmail.com>
References: <cover.1395322529.git.viresh.kumar@linaro.org>
	<e643acf71086db239254d44c77d4966b2a4a01e5.1395322529.git.viresh.kumar@linaro.org>
	<53339153.70708@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53339153.70708-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lists linaro-kernel <linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 27 March 2014 08:17, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> This doesn't look like a complete solution, because newer timers/workqueues can
> still run in those CPUs.

The initial idea was to disable load balance between CPUs and then do this.
So, that new timers and workqueues from other CPUs would never get
queued on this CPU..

But I think we can just modify get_nohz_timer_target() for making sure this
for timers..

> Seems like the proposal discussed is to support setting
> cpu affinity for workqueues through sysfs. If so, we can migrate workqueues when
> affinity is set, so we don't need this cpuset.quiesce ?

That was another thread just for workqueues, but this one is about migrating
everything else as well.. Probably some more additions apart from timers/
hrtimers/wqs in future. So, for us it is still required :)
