From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [regression] cpuset: offlined CPUs removed from affinity masks
Date: Mon, 17 Feb 2020 11:03:07 -0500 (EST)
Message-ID: <1317969050.4131.1581955387909.JavaMail.zimbra@efficios.com>
References: <1251528473.590671.1579196495905.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 050D6246CD2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1581955388;
        bh=ItetYfhyUN3Od1AdIKdi+P2SdF7YtthR2OI+B/myaSg=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=LhaTpr8BYveOuIvueX4LsWIFOh7NNIGwzdgqHJlB/zVleyL1Yq+WK2EQ0hGrvkNCr
         GsHA058KjlCcv4mLuUpNiJbLhWT0gGVdKz0LLQ03k6iIYp1xAAQpEQQ3n3b1Zveed0
         x6GEbP9PqmxWxcpjngKkESyuehj2aPHE6626f1BKIB9LGTOYnG2sLx81Yci1g23HsM
         iUeS/S8MQ39/JoDFKW4x64yqmiRgMCSxdc5kotXu5C3oN3GnV4WtmuDAruGuPZqC7a
         v1JHihpoewGyMKQoaChVdOu9jujOmCoUk1d71pct0a5U9jpfYTRWzoWA9Xlu2bLbPt
         uh9KJV1vXVuVQ==
In-Reply-To: <1251528473.590671.1579196495905.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>

Hi,

Adding Tejun and the cgroups mailing list in CC for this cpuset regression I
reported last month.

Thanks,

Mathieu

----- On Jan 16, 2020, at 12:41 PM, Mathieu Desnoyers mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:

> Hi,
> 
> I noticed the following regression with CONFIG_CPUSET=y. Note that
> I am not using cpusets at all (only using the root cpuset I'm given
> at boot), it's just configured in. I am currently working on a 5.2.5
> kernel. I am simply combining use of taskset(1) (setting the affinity
> mask of a process) and cpu hotplug. The result is that with
> CONFIG_CPUSET=y, setting the affinity mask including an offline CPU number
> don't keep that CPU in the affinity mask, and it is never put back when the
> CPU comes back online. CONFIG_CPUSET=n behaves as expected, and puts back
> the CPU into the affinity mask reported to user-space when it comes back
> online.
> 
> 
> * With CONFIG_CPUSET=y (unexpected behavior):
> 
> # echo 0 > /sys/devices/system/cpu/cpu1/online
> 
> % taskset 0x7 ./loop &
> % taskset -p $!
> pid 1341's current affinity mask: 5
> 
> # echo 1 > /sys/devices/system/cpu/cpu1/online
> 
> taskset -p $!
> pid 1341's current affinity mask: 5
> 
> kill $!
> 
> 
> * With CONFIG_CPUSET=n (expected behavior):
> 
> (Offlining CPU, then start task)
> 
> # echo 0 > /sys/devices/system/cpu/cpu1/online
> 
> % taskset 0x7 ./loop &
> % taskset -p $!
> pid 1358's current affinity mask: 5
> 
> # echo 1 > /sys/devices/system/cpu/cpu1/online
> 
> taskset -p $!
> pid 1358's current affinity mask: 7
> 
> kill $!
> 
> 
> Test system lscpu output:
> 
> Architecture:        x86_64
> CPU op-mode(s):      32-bit, 64-bit
> Byte Order:          Little Endian
> CPU(s):              32
> On-line CPU(s) list: 0-31
> Thread(s) per core:  2
> Core(s) per socket:  8
> Socket(s):           2
> NUMA node(s):        2
> Vendor ID:           GenuineIntel
> CPU family:          6
> Model:               60
> Model name:          Intel Core Processor (Haswell, no TSX, IBRS)
> Stepping:            1
> CPU MHz:             2399.996
> BogoMIPS:            4799.99
> Hypervisor vendor:   KVM
> Virtualization type: full
> L1d cache:           32K
> L1i cache:           32K
> L2 cache:            4096K
> NUMA node0 CPU(s):   0-7,16-23
> NUMA node1 CPU(s):   8-15,24-31
> Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc
> rep_good nopl cpuid tsc_known_freq pni pclmulqdq ssse3 fma cx16 pcid sse4_1
> sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
> hypervisor lahf_lm abm cpuid_fault invpcid_single pti ibrs ibpb fsgsbase bmi1
> avx2 smep bmi2 erms invpcid xsaveopt
> 
> 
> 
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
