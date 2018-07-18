From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Wed, 18 Jul 2018 17:56:44 -0400
Message-ID: <20180718215644.GB2838@cmpxchg.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
 <20180717100347.GD2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=97AZiZvtK6lsL3fru/ZpGGEtAAQ5rvikpgO5M2WEQLY=;
        b=cOQbwKhNq/HEGZyKB8wNjyAhCcmvzk5lptyZTs2+HOjnhPunJDnykUjHRybl84kZJf
         FiNt+HZo8pLQp+T2T/LGoQkZ94ro5XbE5k3XUKok3W15mYDDI/JCmtM9c1Czav/GdMy9
         +3lEI2n5ywsU6ItSZLybGe9aEylVoyBRy1hMIKaYvvGDHiCCI/i5gCEU4Aawzbv3S9K0
         mWGpJplcJGmix3S+7FC8lrBcNZsL2Uo3gJtDW7Gf+adIGwFb+R2K6zgZWAcL13SnvhQT
         bxgaJsaoMnRUOUXV1kb5/Qe7aMrVbVMXwIpV+hZ5NnAEoGulNidM++07Mm5UPXgsv1Fx
         a+YQ==
Content-Disposition: inline
In-Reply-To: <20180717100347.GD2494@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Jul 17, 2018 at 12:03:47PM +0200, Peter Zijlstra wrote:
> This is still a scary amount of accounting; not to mention you'll be
> adding O(cgroup-depth) to this in a later patch.
> 
> Where are the performance numbers for all this?

I benchmarked it using our two most scheduling sensitive workloads:
memcache and webserver. They handle a ton of small requests - lots of
wakeups and sleeps with little actual work in between - so they tend
to be canaries for scheduler regressions.

In the tests, the boxes were handling live traffic over the course of
several hours. Half the machines, the control, ran with CONFIG_PSI=n.

For memcache I used eight machines total. They're 2-socket, 14 core,
56 thread boxes. The test runs for half the test period, flips the
test and control kernels on the hardware to rule out HW factors, DC
location etc., then runs the other half of the test.

For the webservers, I used 32 machines total. They're single socket,
16 core, 32 thread machines.

During the memcache test, CPU load was nopsi=78.05% psi=78.98% in the
first half and nopsi=77.52% psi=78.25%, so psi added between 0.7 and
0.9 percentage points to the CPU load, a difference of about 1%.

As far as end-to-end request latency from the client perspective goes,
we don't sample those finely enough to capture the requests going to
those particular machines during the test, but we know the p50
turnaround time in this workload is 54us, and perf bench sched pipe on
those machines show nopsi=5.232666 us/op and psi=5.587347 us/op, so
this doesn't add much here either.

The profile for the pipe benchmark shows:

     0.87%  sched-pipe  [kernel.vmlinux]    [k] psi_group_change
     0.83%  perf.real   [kernel.vmlinux]    [k] psi_group_change
     0.82%  perf.real   [kernel.vmlinux]    [k] psi_task_change
     0.58%  sched-pipe  [kernel.vmlinux]    [k] psi_task_change


The webserver load is running inside 4 nested cgroup levels. The CPU
load with both nopsi and psi kernels was indistinguishable at 81%.

For comparison, we had to disable the cgroup cpu controller on the
webservers because it added 4 percentage points to the CPU% during
this same exact test.

Versions of this accounting code now run on 80% of our fleet. None of
our workloads have reported regressions during the rollout.

[ Also note that the webservers that tested the nopsi kernel were
  during that time susceptible to swap storms, memory livelocks, and
  eventual hardresets because without psi they couldn't run our full
  resource isolation stack that would prevent that ;) ]

Let me know if there are other tests I could run.
