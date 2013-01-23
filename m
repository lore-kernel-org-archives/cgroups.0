From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v5 11/11] sched: introduce cgroup file stat_percpu
Date: Wed, 23 Jan 2013 18:20:13 +0400
Message-ID: <50FFF19D.60007@parallels.com>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com> <1357731938-8417-12-git-send-email-glommer@parallels.com> <20130109124220.ad9f1a54.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------040503070806010104010109"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130109124220.ad9f1a54.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>

--------------040503070806010104010109
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 01/10/2013 12:42 AM, Andrew Morton wrote:
> Also, I'm not seeing any changes to Docmentation/ in this patchset. 
> How do we explain the interface to our users?

There is little point in adding any Documentation, since the cpu cgroup
itself is not documented. I took the liberty of doing this myself so to
provide a baseline for the upcoming changes. It would be very nice if
you guys could review the file as-is, since it would save me one
patchset iteration, at least.

When the contents are settled, I intend to then proceed into documenting
the new file in there.

Thanks.


--------------040503070806010104010109
Content-Type: text/plain; charset="UTF-8"; name="cpu.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cpu.txt"

CPU Controller
--------------

The CPU controller is responsible for grouping tasks together that will be
viewed by the scheduler as a single unit. The CFS scheduler will first divide
CPU time equally between all entities in the same level, and then proceed by
doing the same in the next level. Basic use cases for that are described in the
main cgroup documentation file, cgroups.txt.

Users of this functionality should be aware that deep hierarchies will of
course impose scheduler overhead, since the scheduler will have to take extra
steps and look up additional data structures to make its final decision.

Through the CPU controller, the scheduler is also able to cap the CPU
utilization of a particular group. This is particularly useful in environments
in which CPU is paid for by the hour, and one values predictability over
performance.

CPU Accounting
--------------

The CPU cgroup will also provide additional files under the prefix "cpuacct".
Those files provide accounting statistics and were previously provided by the
separate cpuacct controller. Although the cpuacct controller will still be kept
around for compatibility reasons, its usage is discouraged. If both the CPU and
cpuacct controllers are present in the system, distributors are encouraged to
always mount them together.

Files
-----

The CPU controller exposes the following files to the user:

cpu.shares:

 - cpu.cfs_period_us: The duration in microseconds of each scheduler period, for
 bandwidth decisions. This defaults to 100000us or 100ms. Larger periods will
 improve throughput at the expense of latency, since the scheduler will be able
 to sustain a cpu-bound workload for longer. The opposite of true for smaller
 periods. Note that this only affects non-RT tasks that are scheduled by the
 CFS scheduler.

- cpu.cfs_quota_us: The maximum time in microseconds during each cfs_period_us
  in for the current group will be allowed to run. For instance, if it is set to
  half of cpu_period_us, the cgroup will only be able to peak run for 50 % of
  the time. One should note that this represents aggregate time over all CPUs
  in the system. Therefore, in order to allow full usage of two CPUs, for
  instance, one should set this value to twice the value of cfs_period_us.

- cpu.stat: statistics about the bandwidth controls. No data will be presented
  if cpu.cfs_quota_us is not set. The file presents three
  numbers:
	nr_periods: how many full periods have been elapsed.
	nr_throttled: number of times we exausted the full allowed bandwidth
	throttled_time: total time the tasks were not run due to being overquota

 - cpu.rt_runtime_us and cpu.rt_period_us: Those files are the RT-tasks
   analogous to the CFS files cfs_quota_us and cfs_period_us. One important
   difference, though, is that while the cfs quotas are upper bounds that
   won't necessarily be met, the rt runtimes form a stricter guarantee.
   Therefore, no overlap is allowed. Implications of that are that given a
   hierarchy with multiple children, the sum of all rt_runtime_us may not exceed
   the runtime of the parent. Also, a rt_runtime_us of 0, means that no rt tasks
   can ever be run in this cgroup.

 - cpuacct.usage: The aggregate CPU time, in microseconds, consumed by all tasks
   in this group.

 - cpuacct.usage_percpu: The CPU time, in microseconds, consumed by all tasks in
   this group, separated by CPU. The format is an space-separated array of time
   values, one for each present CPU.

 - cpuacct.stat: aggregate user and system time consumed by tasks in this group.
   The format is user: x\nsystem: y.


--------------040503070806010104010109--
