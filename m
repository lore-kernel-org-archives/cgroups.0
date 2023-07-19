From: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] cgroup/rstat: record the cumulative
 per-cpu time of cgroup and its descendants
Date: Wed, 19 Jul 2023 11:01:48 +0800
Message-ID: <b4424767-dce7-08a9-3759-43cc9dfa4273@bytedance.com>
References: <20230717093612.40846-1-jiahao.os@bytedance.com>
 <ZLWb-LsBD041hMvr@slm.duckdns.org>
 <2655026d-6ae4-c14c-95b0-4177eefa434f@bytedance.com>
 <ZLcJ1nH8KzWzoQWj@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1689735713; x=1692327713;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=irp3EPa33LK85QAbTktFpig5JEBTIWbUT4zOa4f8pKI=;
        b=B76s3XuCZrrPV4rWry1FvWh5MrG3pQP4cQK0XiWE+UaqR5NoSB6OcVsURRvVhqwujr
         4HcIOY1tuqZauHG+Z3H+EyGTqw5NfFK0nSMuIAYjNmwRMw4NoWEUHO88XEYAKGaXDKLR
         4LeexLiowvf11fQ5xGQrSNVQKmsESazLiHQo4Y7J+OOa6kfjoFP+v5Hbgd4TF4kjxMQJ
         IV7lHdZbBMgWsdR5PimtHWmeuo+Sc5D4LhaFJrr/opbxUdHUvHQSHn2sZ8800PEf1HXn
         17rUqRAm01DJV2Cm9PZG45JI+a+31nYWdkzv0qGsNYNS163N7PziWMMMeGBlNl/9gQTP
         uAhg==
In-Reply-To: <ZLcJ1nH8KzWzoQWj-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2023/7/19 Tejun Heo wrote:
> On Tue, Jul 18, 2023 at 06:08:50PM +0800, Hao Jia wrote:
>> https://github.com/jiaozhouxiaojia/cgv2-stat-percpu_test/tree/main
> 
> So, we run `stress -c 1` for 1 second in the asdf/test0 cgroup and
> asdf/cpu.stat correctly reports the cumulative usage. After removing
> asdf/test0 cgroup, asdf's usage_usec is still there. What's missing here?

Sorry, some of my expressions may have misled you.

Yes, cpu.stat will display the cumulative **global** cpu time of the 
cgroup and its descendants (the corresponding kernel variable is 
"cgrp->bstat"), and it will not be lost when the child cgroup is removed.

Similarly, we need a **per-cpu** variable to record the accumulated 
per-cpu time of cgroup and its descendants.
The existing kernel variable "cgroup_rstat_cpu(cgrp, cpu)->bstat" is not 
satisfied, it only records the per-cpu time of cgroup itself,
So I try to add "cgroup_rstat_cpu(cgrp, cpu)->cumul_bstat" to record 
per-cpu time of cgroup and its descendants.

In order to verify the correctness of my patch, I wrote a kernel module 
to compare the results of calculating the per-cpu time of cgroup and its 
descendants in two ways:
   Method 1. Traverse and add the per-cpu rstatc->bstat of cgroup and 
each of its descendants.
   Method 2. Directly read "cgroup_rstat_cpu(cgrp, cpu)->cumul_bstat" in 
the kernel.

When the child cgroup is not removed, the results calculated by the two 
methods should be equal.

> What are you adding?
I want to add a **per-cpu variable** to record the cumulative per-cpu 
time of cgroup and its descendants, which is similar to the variable 
"cgrp->bstat", but it is a per-cpu variable.
It is very useful and convenient for calculating the usage of cgroup on 
each cpu, and its behavior is similar to the "cpuacct.usage*" interface 
of cgroup v1.

Thanks,
Hao
