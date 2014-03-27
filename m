From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 4/4] cpuset: Add cpusets.quiesce option
Date: Thu, 27 Mar 2014 10:47:47 +0800
Message-ID: <53339153.70708@huawei.com>
References: <cover.1395322529.git.viresh.kumar@linaro.org> <e643acf71086db239254d44c77d4966b2a4a01e5.1395322529.git.viresh.kumar@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e643acf71086db239254d44c77d4966b2a4a01e5.1395322529.git.viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014/3/20 21:49, Viresh Kumar wrote:
> For networking applications platforms need to provide one CPU per each user
> space data plane thread. These CPUs should not be interrupted by kernel at all
> unless userspace has requested for some syscalls. Currently, there are
> background kernel activities that are running on almost every CPU, like:
> timers/hrtimers/watchdogs/etc, and these are required to be migrated to other
> CPUs.
> 
> To achieve that, this patch adds another option to cpusets, i.e. 'quiesce'.
> Writing '1' on this file would migrate these unbound/unpinned timers/workqueues
> away from the CPUs of the cpuset in question. Writing '0' has no effect and this
> file can't be read from userspace as we aren't maintaining a state here.
> 

This doesn't look like a complete solution, because newer timers/workqueues can
still run in those CPUs. Seems like the proposal discussed is to support setting
cpu affinity for workqueues through sysfs. If so, we can migrate workqueues when
affinity is set, so we don't need this cpuset.quiesce ?

> Currently, only timers are migrated. This would be followed by other kernel
> infrastructure later.
> 
> Suggested-by: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Signed-off-by: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
