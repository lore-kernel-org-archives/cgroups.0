Received: from mta0.migadu.com (out-227.mta0.migadu.com [91.218.175.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3223911A2
	for <cgroups@vger.kernel.org>; Sun, 23 Aug 2026 14:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787496756; cv=none; b=NWsr2MN7Pmnt62rZTHVbF3gkt9teBl8f6sj7oRzAaantvRTYvtr/YqVnPwzNGJtRxw3CrwKqZcQfz9uqjmNNc3/vJLHnIaUl9hxgMM0ppn2vgJ9G7ymYjDHSgXusGY5p16sxu5vTjLCeeb7P6tM6DyegnAw8MVl2zoJnMgWwXxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787496756; c=relaxed/simple;
	bh=9oZ/GVF5ZnkfYq+PeS7hkUQ12oaf6Pk7QpDnKjKc234=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tD6iaihJ4LUUkWeiCuH3CDHCkGr6GJH784YiOzEPULo4UFr0RhVxYDCKFEfC/tCKM600D5et5gc2SCmR8umUY0goSoA9cO+pxwxbo8TXiB8FCDn8iF8b5kocKaoRv2tAD9RzStVR3/WBswXbavwIje0lbyGcF3EhfBkANQHSfHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PmsjAZCj; arc=none smtp.client-ip=91.218.175.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PmsjAZCj"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9oZ/GVF5ZnkfYq+PeS7hkUQ12oaf6Pk7QpDnKjKc234=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787496751; v=1; x=1788101551;
 b=PmsjAZCjeEhYTAYSW2SvlvqBwCZGLzX2/Kh+CuZoJALZDw1xA9jAe6gvXCii2v05AS5+m2FJ
 fvQgWxfkyUDbzzZWzQ/xp3xuaucDs9yXGGSVVfY9TivLXquCPTycWYi+u1HHMp3BbsXYU6J3e9g
 f6R3oE1rhrpBhDIle51TRLHc=
X-Envelope-To: cgroups@vger.kernel.org
Received: from three-body (240e:398:90:76f0:87b1:670e:21af:efaf)
	by smtp.migadu.com with ESMTPS id 2aef8cd3afc152ee;
	Sun, 23 Aug 2026 14:52:21 +0000
X-Mizu-Trace-ID: 2aef8cd3afc152ee
X-Migadu-Flow: FLOW_OUT
Date: Mon, 24 Aug 2026 22:51:51 +0800
From: Chen Yu <chen.yu@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Szabina Korbai <szkorbai@linux.ibm.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>, mingo@kernel.org,
	longman@redhat.com, chenridong@huaweicloud.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, jstultz@google.com,
	qyousef@layalina.io, euan@linux.ibm.com, huschle@linux.ibm.com,
	yu.c.chen@intel.com, tim.c.chen@intel.com, philip.li@intel.com
Subject: Re: [PATCH v3 0/7] sched: Flatten the pick
Message-ID: <aoxah90s0bQ4tcUW@three-body>
References: <20260605105513.354837583@infradead.org>
 <fecf5eb215b4b86bec11ca47eb6b5b17f5e0fea5.camel@linux.ibm.com>
 <d690a668-7bb2-4cd1-a229-295e556d4f28@amd.com>
 <ef9f077a6faafc747b3e144400dd3f5ad10e8e0a.camel@linux.ibm.com>
 <20260818091649.GC1247881@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818091649.GC1247881@noisy.programming.kicks-ass.net>

On Tue, Aug 18, 2026 at 11:16:49AM +0200, Peter Zijlstra wrote:
> > > 
> > > Are you using tip:sched/core at commit 68e3748781 ("sched/fair: Fix
> > > flat
> > > hierarchy") for the flat_cg numbers or did you checkout at
> > > 85570f10a4c6
> > > ("sched/eevdf: Move to a single runqueue")?
> > > 
> > > There are a couple fixes for vruntime update and Vincent's
> > > optimizations
> > > for preemption bits which might make a difference to the overall
> > > results.
> > 
> > 
> > Hi Prateek,
> > 
> > thank you, that's a good call. I did checkout at "Move to a single
> > runqueue". Let me try it with the fix included, see how the results are
> > affected.
> 
> I've not yet managed to digest your various benchmark results, but also
> double check that patch 6/7 from this series is not to 'blame' for the
> some of the changes.
> 
> The 0day robot fingered that patch for at least one issue.
> 
> In that case the benchmark threads ended up 'heavier' than before, which
> resulted in less preemptions. Probably ksoftirqd getting ran less and
> causing a regression in network throughput for that thing.
> 

The 0day' regression was triggered by running netperf/netserver using loopback,
so ksoftirqd was not really running very frequently IMO.

> I did suggest trying to change the slice of ksoftirqd down, such that it
> might be ran more readily, but I'm not sure that ever got tried.

The 0day regression was triggered by running netperf/netserver over loopback,
so ksoftirqd was not running very frequently IIUC.

I borrowed a similar machine(no-SMT, every 4 Cores share L2, 192 Cores) as 0day used.
I asked AI to generate a simple test script based on 0day's reproducer
(attached at the end of this email), and successfully reproduced the regression.

TL;DR,
The decision made by wake_affine_weight() seems to be affected by the increased
weight of the wakee under concur mode. As a result, wake_affine_weight() became less
likely to select this_cpu. This reduced preference for this_cpu leads to a higher
L2 miss rate on this platform, and consequently lower throughput.

Test summary:

| Config | Throughput (Mbps) | **L2 miss%** | **LLC miss%** |
| smp + WA_WEIGHT | **470249** | **19.37%** | 60.08% |
| smp + NO_WA_WEIGHT | 305360 | 32.67% | 60.46% |
| concur + WA_WEIGHT | 338770 | 31.45% | 62.85% |
| concur + NO_WA_WEIGHT | 259358 | 36.24% | 61.95% |

We can see if WA_WEIGHT is disabled in smp mode, the performance drops to concur. One
possible reason is that task_h_load(p) returns a very small value in smp mode(just the
issue that concur wants to fix), whereas it returns a "normal" value in concur mode.

In smp mode, the extremly small value returned by task_h_load(p) can be effectively ignored
in the comparison in wake_affine_weight(). As a result, the condition for returning this_cpu
becomes:

cpu_load(cpu_rq(this_cpu)) * 100 < cpu_load(cpu_rq(prev_cpu) * 108

As a result, this_cpu has a higher chance of being selected in smp mode. In concur mode,
task_h_load(p) is on par with cpu_load(), so it cannot be simply ignored and provides a fairer
basis for choosing between this_cpu and prev_cpu. Since netperf/netserver is a sync wakeup, it
prefers to be co-located on the same CPU/L2 domain for better L2 cache locality.

I'm not sure if this is the expected behavior before I further digging into the details,
a hack patch could restore part of the performance, because it increases the ratio to
return this_cpu:

thanks,
Chenyu

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6d881e530f89..8bff8b6698a9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8385,6 +8385,7 @@ wake_affine_weight(struct sched_domain *sd, struct task_struct *p,
        unsigned long task_load;
 
        this_eff_load = cpu_load(cpu_rq(this_cpu));
+       task_load = task_h_load(p);
 
        if (sync) {
                unsigned long current_load = task_h_load(current);
@@ -8392,11 +8393,13 @@ wake_affine_weight(struct sched_domain *sd, struct task_struct *p,
                if (current_load > this_eff_load)
                        return this_cpu;
 
+               /* replace current load with wakee load does no harm */
+               if (sched_feat(WA_SYNC_WEIGHT) && current_load >= task_load)
+                       return this_cpu;
+
                this_eff_load -= current_load;
        }
 
-       task_load = task_h_load(p);
-
        this_eff_load += task_load;
        if (sched_feat(WA_BIAS))
                this_eff_load *= 100;
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 8f0dee8fc475..99fabe53fb22 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -129,6 +129,7 @@ SCHED_FEAT(ATTACH_AGE_LOAD, true)
 SCHED_FEAT(WA_IDLE, true)
 SCHED_FEAT(WA_WEIGHT, true)
 SCHED_FEAT(WA_BIAS, true)
+SCHED_FEAT(WA_SYNC_WEIGHT, true)


test command:

NR=$(( $(nproc) * 2 ))
run() {
local mode=$1 waw=$2 tag=$3
echo $mode | sudo -n tee /sys/kernel/debug/sched/cgroup_mode >/dev/null
echo $waw  | sudo -n tee /sys/kernel/debug/sched/features    >/dev/null
sudo -n pkill -x netserver; sleep 1
netserver -4 >/dev/null 2>&1; sleep 1
rm -f /tmp/m4.$tag
for i in $(seq $NR); do
netperf -4 -H 127.0.0.1 -t TCP_MAERTS -l 70 -P 0 >> /tmp/m4.$tag 
2>/dev/null &
done
sleep 15
sudo -n ./tools/perf/perf stat -a \
-e 
l2_request.hit,l2_request.miss,longest_lat_cache.reference,longest_lat_cache.miss 
\
-x, -o /tmp/p4.$tag -- sleep 20
wait
} >/dev/null 2>&1
run smp    WA_WEIGHT    smp_waw
run smp    NO_WA_WEIGHT smp_nowaw
run concur WA_WEIGHT    con_waw
run concur NO_WA_WEIGHT con_nowaw
echo WA_WEIGHT | sudo -n tee /sys/kernel/debug/sched/features >/dev/null


printf "%-12s %10s %8s %10s %10s\n" CONFIG Mbps streams L2miss% LLCmiss%
for t in smp_waw smp_nowaw con_waw con_nowaw; do
   read TP NS < <(awk '{s+=$NF;n++} END{print s, n}' /tmp/m4.$t)
   awk -F, -v t=$t -v tp=$TP -v ns=$NS '
     $3=="l2_request.hit"{h=$1} $3=="l2_request.miss"{m=$1}
     $3=="longest_lat_cache.reference"{r=$1} 
$3=="longest_lat_cache.miss"{lm=$1}
     END{printf "%-12s %10.0f %8d %9.2f%% %9.2f%%\n", t, tp, ns, 
100*m/(h+m), 100*lm/r}' /tmp/p4.$t
done
