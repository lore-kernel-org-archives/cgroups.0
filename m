From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/3] cgroup: Implement cgroup2 basic CPU usage
 accounting
Date: Tue, 29 Aug 2017 14:06:24 -0400
Message-ID: <73f65285-867d-8ec0-d81a-000a2d16f611@redhat.com>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170811163754.3939102-4-tj@kernel.org>
 <20170829174325.GS491396@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170829174325.GS491396-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On 08/29/2017 01:43 PM, Tejun Heo wrote:
> In cgroup1, while cpuacct isn't actually controlling any resources, it
> is a separate controller due to combination of two factors -
> 1. enabling cpu controller has significant side effects, and 2. we
> have to pick one of the hierarchies to account CPU usages on.  cpuacct
> controller is effectively used to designate a hierarchy to track CPU
> usages on.
>
> cgroup2's unified hierarchy removes the second reason and we can
> account basic CPU usages by default.  While we can use cpuacct for
> this purpose, both its interface and implementation leave a lot to be
> desired - it collects and exposes two sources of truth which don't
> agree with each other and some of the exposed statistics don't make
> much sense.  Also, it propagates all the way up the hierarchy on each
> accounting event which is unnecessary.
>
> This patch adds basic resource accounting mechanism to cgroup2's
> unified hierarchy and accounts CPU usages using it.
>
> * All accountings are done per-cpu and don't propagate immediately.
>   It just bumps the per-cgroup per-cpu counters and links to the
>   parent's updated list if not already on it.
>
> * On a read, the per-cpu counters are collected into the global ones
>   and then propagated upwards.  Only the per-cpu counters which have
>   changed since the last read are propagated.
>
> * CPU usage stats are collected and shown in "cgroup.stat" with "cpu."
>   prefix.  Total usage is collected from scheduling events.  User/sys
>   breakdown is sourced from tick sampling and adjusted to the usage
>   using cputime_adjust().
>
> This keeps the accounting side hot path O(1) and per-cpu and the read
> side O(nr_updated_since_last_read).
>
> v2: Minor changes and documentation updates as suggested by Waiman and
>     Roman.
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Waiman Long <waiman.long-ZPxbGqLxI0U@public.gmane.org>

I just noticed that you have used my obsoleted email address in the cc
line. Would you mind changing it to the one that I am currently using?

Thanks,
Longman
