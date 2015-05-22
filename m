From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 01/19] memcg: make mem_cgroup_read_{stat|event}() iterate
 possible cpus instead of online
Date: Fri, 22 May 2015 19:12:49 -0400
Message-ID: <20150522231249.GA6485@cmpxchg.org>
References: <1432333416-6221-1-git-send-email-tj@kernel.org>
 <1432333416-6221-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432333416-6221-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Fri, May 22, 2015 at 06:23:18PM -0400, Tejun Heo wrote:
> cpu_possible_mask represents the CPUs which are actually possible
> during that boot instance.  For systems which don't support CPU
> hotplug, this will match cpu_online_mask exactly in most cases.  Even
> for systems which support CPU hotplug, the number of possible CPU
> slots is highly unlikely to diverge greatly from the number of online
> CPUs.  The only cases where the difference between possible and online
> caused problems were when the boot code failed to initialize the
> possible mask and left it fully set at NR_CPUS - 1.
> 
> As such, most per-cpu constructs allocate for all possible CPUs and
> often iterate over the possibles, which also has the benefit of
> avoiding the blocking CPU hotplug synchronization.
> 
> memcg open codes per-cpu stat counting for mem_cgroup_read_stat() and
> mem_cgroup_read_events(), which iterates over online CPUs and handles
> CPU hotplug operations explicitly.  This complexity doesn't actually
> buy anything.  Switch to iterating over the possibles and drop the
> explicit CPU hotplug handling.
> 
> Eventually, we want to convert memcg to use percpu_counter instead of
> its own custom implementation which also benefits from quick access
> w/o summing for cases where larger error margin is acceptable.
> 
> This will allow mem_cgroup_read_stat() to be called from non-sleepable
> contexts which will be used by cgroup writeback.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
