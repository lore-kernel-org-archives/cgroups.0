From: Morten Rasmussen <morten.rasmussen@arm.com>
Subject: Re: [PATCH 0/7] introduce cpu.headroom knob to cpu controller
Date: Wed, 10 Apr 2019 12:59:07 +0100
Message-ID: <20190410115907.GE19434@e105550-lin.cambridge.arm.com>
References: <20190408214539.2705660-1-songliubraving@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190408214539.2705660-1-songliubraving@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Song Liu <songliubraving@fb.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, tglx@linutronix.de, kernel-team@fb.com

Hi,

On Mon, Apr 08, 2019 at 02:45:32PM -0700, Song Liu wrote:
> Servers running latency sensitive workload usually aren't fully loaded for 
> various reasons including disaster readiness. The machines running our 
> interactive workloads (referred as main workload) have a lot of spare CPU 
> cycles that we would like to use for optimistic side jobs like video 
> encoding. However, our experiments show that the side workload has strong
> impact on the latency of main workload:
> 
>   side-job   main-load-level   main-avg-latency
>      none          1.0              1.00
>      none          1.1              1.10
>      none          1.2              1.10 
>      none          1.3              1.10
>      none          1.4              1.15
>      none          1.5              1.24
>      none          1.6              1.74
> 
>      ffmpeg        1.0              1.82
>      ffmpeg        1.1              2.74
> 
> Note: both the main-load-level and the main-avg-latency numbers are
>  _normalized_.

Could you reveal what level of utilization those main-load-level numbers
correspond to? I'm trying to understand why the latency seems to
increase rapidly once you hit 1.5. Is that the point where the system
hits 100% utilization?

> In these experiments, ffmpeg is put in a cgroup with cpu.weight of 1 
> (lowest priority). However, it consumes all idle CPU cycles in the 
> system and causes high latency for the main workload. Further experiments
> and analysis (more details below) shows that, for the main workload to meet
> its latency targets, it is necessary to limit the CPU usage of the side
> workload so that there are some _idle_ CPU. There are various reasons
> behind the need of idle CPU time. First, shared CPU resouce saturation 
> starts to happen way before time-measured utilization reaches 100%. 
> Secondly, scheduling latency starts to impact the main workload as CPU 
> reaches full utilization. 
> 
> Currently, the cpu controller provides two mechanisms to protect the main 
> workload: cpu.weight and cpu.max. However, neither of them is sufficient 
> in these use cases. As shown in the experiments above, side workload with 
> cpu.weight of 1 (lowest priority) would still consume all idle CPU and add 
> unacceptable latency to the main workload. cpu.max can throttle the CPU 
> usage of the side workload and preserve some idle CPU. However, cpu.max 
> cannot react to changes in load levels. For example, when the main 
> workload uses 40% of CPU, cpu.max of 30% for the side workload would yield 
> good latencies for the main workload. However, when the workload 
> experiences higher load levels and uses more CPU, the same setting (cpu.max 
> of 30%) would cause the interactive workload to miss its latency target. 
> 
> These experiments demonstrated the need for a mechanism to effectively 
> throttle CPU usage of the side workload and preserve idle CPU cycles. 
> The mechanism should be able to adjust the level of throttling based on
> the load level of the main workload. 
> 
> This patchset introduces a new knob for cpu controller: cpu.headroom. 
> cgroup of the main workload uses cpu.headroom to ensure side workload to 
> use limited CPU cycles. For example, if a main workload has a cpu.headroom 
> of 30%. The side workload will be throttled to give 30% overall idle CPU. 
> If the main workload uses more than 70% of CPU, the side workload will only 
> run with configurable minimal cycles. This configurable minimal cycles is
> referred as "tolerance" of the main workload.

IIUC, you are proposing to basically apply dynamic bandwidth throttling to
side-jobs to preserve a specific headroom of idle cycles.

The bit that isn't clear to me, is _why_ adding idle cycles helps your
workload. I'm not convinced that adding headroom gives any latency
improvements beyond watering down the impact of your side jobs. AFAIK,
the throttling mechanism effectively removes the throttled tasks from
the schedule according to a specific duty cycle. When the side job is
not throttled the main workload is experiencing the same latency issues
as before, but by dynamically tuning the side job throttling you can
achieve a better average latency. Am I missing something?

Have you looked at your distribution of main job latency and tried to
compare with when throttling is active/not active?

I'm wondering if the headroom solution is really the right solution for
your use-case or if what you are really after is something which is
lower priority than just setting the weight to 1. Something that
(nearly) always gets pre-empted by your main job (SCHED_BATCH and
SCHED_IDLE might not be enough). If your main job consist
of lots of relatively short wake-ups things like the min_granularity
could have significant latency impact.

Morten
