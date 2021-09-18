From: Wang Jianchao <jianchao.wan9-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Memcached with cfs quota 400% performance boost after bind to 4
 cpus
Date: Sat, 18 Sep 2021 09:19:11 +0800
Message-ID: <a5404b12-b1f1-db87-2836-7974a6878cb3@gmail.com>
References: <9f907d99-1cdb-37db-49ae-8e31c7ea8fe7@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zyJvMDxoHAwCNjMlc0L2z6IcTBSzl1epSdqJhT+EKUA=;
        b=QhnXKrJbOO4zesM9YlaaYQ/sqQel7Z+oBxBZ2yp9Fqbv6gyLGpecz3bAVayyihvEiE
         rautM/r6vn2xUpBZ13Y4qZx/h3gFFMOrx03UE4jIC0dHmBm4ooUbtQVZuxrKco/Gf7Do
         mkfRyO2EJRDCb1NFSo4vLqSQw3N1SbF8leWzYzmychtf3uGHbbKqgjYcmnDQvGwiqxP6
         lGftKAe/GeZkjPXl7lcLnKtf/iyo94JYmi43R9joFwd7l85CONKVHdZ25i3HQicAoXoB
         kwPPzzrZgkw/z8zANMamqIUUiyYAXXPAQ7MK5By/I9l9wPtEMYdbJL8zdU/S4TQpDTMH
         31lw==
In-Reply-To: <9f907d99-1cdb-37db-49ae-8e31c7ea8fe7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Peter

The hardware information is as following

On 2021/9/17 8:35 下午, Wang Jianchao wrote:
> Hi list
> 
> I have a test environment with following,> A memcached (memcached -d -m 50000 -u root -p 12301 -c 1000000 -t 16) in cpu cgroup with following config,
> cpu.cfs_quota_us = 400000
> cpu.cfs_period_us = 100000
Model name:            Intel(R) Xeon(R) Gold 5218 CPU @ 2.30GHz
Stepping:              7
CPU MHz:               2800.033
CPU max MHz:           3900.0000
CPU min MHz:           1000.0000
BogoMIPS:              4600.00
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              1024K
L3 cache:              22528K
NUMA node0 CPU(s):     0-15,32-47
NUMA node1 CPU(s):     16-31,48-63
> 
> And a mutilate loop (mutilate -s x.x.x.x:12301 -T 40 -c 20 -t 60 -W 5 -q 1000000) running on another host
> w/o any cgroup config,
Model name:            Intel(R) Xeon(R) Gold 5218R CPU @ 2.10GHz
Stepping:              7
CPU MHz:               2900.155
CPU max MHz:           4000.0000
CPU min MHz:           800.0000
BogoMIPS:              4200.00
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              1024K
L3 cache:              28160K
NUMA node0 CPU(s):     0-19,40-59
NUMA node1 CPU(s):     20-39,60-79

The memory on both machine is bigger than 100G and most of them is free.

> 
> When bind memcached to  0-15 with cpuset, 
> ==========================================
> mutilate showed,
> #type       avg     std     min     5th    10th    90th    95th    99th
> read     1275.8  6358.9    49.8   378.2   418.5   767.2   841.4 53998.5
> update      0.0     0.0     0.0     0.0     0.0     0.0     0.0     0.0
> op_q        1.0     0.0     1.0     1.0     1.0     1.1     1.1     1.1
> 
> Total QPS = 626566.2 (37594133 / 60.0s)
> 
> Misses = 0 (0.0%)
> Skipped TXs = 0 (0.0%)
> 
> RX 9288150851 bytes :  147.6 MB/s
> TX 1353390552 bytes :   21.5 MB/s
> 
> And perf on memcached showed,
>    635,602,955,852      cycles                                                        (30.07%)
>    479,554,401,177      instructions              #    0.75  insn per cycle           (40.02%)
>     12,585,059,799      L1-dcache-load-misses     #    9.31% of all L1-dcache hits    (50.07%)
>    135,140,424,785      L1-dcache-loads                                               (49.96%)
>     76,849,156,759      L1-dcache-stores                                              (50.02%)
>     45,700,267,543      L1-icache-load-misses                                         (49.97%)
>        495,149,862      LLC-load-misses           #   24.96% of all LL-cache hits     (39.95%)
>      1,984,134,589      LLC-loads                                                     (39.97%)
>        327,130,920      LLC-store-misses                                              (20.06%)
>      1,397,111,117      LLC-stores                                                    (20.06%)
> 
> 
> When bind memcached to 0-3 with cpuset,
> ========================================
> mutilate showed,
> #type       avg     std     min     5th    10th    90th    95th    99th
> read      934.7  3669.3    41.1   112.8   129.5   385.3  3321.9 21923.7
> update      0.0     0.0     0.0     0.0     0.0     0.0     0.0     0.0
> op_q        1.0     0.0     1.0     1.0     1.0     1.1     1.1     1.1
> 
> Total QPS = 852885.6 (51173140 / 60.0s)
> 
> Misses = 0 (0.0%)
> Skipped TXs = 0 (0.0%)
> 
> RX 12642165580 bytes :  200.9 MB/s
> TX 1842259932 bytes :   29.3 MB/s
> 
> And perf on memcached showed,
> 
>    621,311,916,151      cycles                                                        (30.01%)
>    599,835,965,997      instructions              #    0.97  insn per cycle           (40.02%)
>     12,585,889,988      L1-dcache-load-misses     #    7.59% of all L1-dcache hits    (50.00%)
>    165,750,518,361      L1-dcache-loads                                               (50.01%)
>     93,588,611,989      L1-dcache-stores                                              (50.00%)
>     44,445,213,037      L1-icache-load-misses                                         (50.01%)
>        568,410,466      LLC-load-misses           #   26.91% of all LL-cache hits     (40.03%)
>      2,112,218,392      LLC-loads                                                     (40.00%)
>        261,202,604      LLC-store-misses                                              (19.97%)
>      1,484,886,714      LLC-stores 
> 
> 
> We can see the IPC raised from 0.75 to 0.97, this should be the reason of the performance boost.
> What does cause the IPC boost ?
> 
> Thanks a million for any help
> Jianchao
> 
