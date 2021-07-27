From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 6/9] cgroup/cpuset: Add a new isolated cpus.partition
 type
Date: Tue, 27 Jul 2021 11:56:25 -0400
Message-ID: <fe3d9fcb-c3af-9214-c69f-00ef36521c5c@redhat.com>
References: <20210720141834.10624-1-longman@redhat.com>
 <20210720141834.10624-7-longman@redhat.com>
 <20210727114241.GA283787@lothringen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627401389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M3++Uh/orxff5EIZBKy/srZv4TUlnGzA4HSvE27QDsA=;
        b=A8b2TbZd0oiRs1et6u0tkufC8um05yBWjj1hy5MbxtGAvDGwvB5ZfzgMUZMZoQ6HbXqJlJ
        CilyZ55K2oTdXPWHb1EMNG9tfzbUUtSV9ni05BMmDwX2HfpNK4117XPt3NS/ErVSqENJlX
        IZnagZuSizTEwaWwelIC+i2PjPWhkK0=
In-Reply-To: <20210727114241.GA283787@lothringen>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On 7/27/21 7:42 AM, Frederic Weisbecker wrote:
> On Tue, Jul 20, 2021 at 10:18:31AM -0400, Waiman Long wrote:
>> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=TBD
>>
>> commit 994fb794cb252edd124a46ca0994e37a4726a100
>> Author: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Date:   Sat, 19 Jun 2021 13:28:19 -0400
>>
>>      cgroup/cpuset: Add a new isolated cpus.partition type
>>
>>      Cpuset v1 uses the sched_load_balance control file to determine if load
>>      balancing should be enabled.  Cpuset v2 gets rid of sched_load_balance
>>      as its use may require disabling load balancing at cgroup root.
>>
>>      For workloads that require very low latency like DPDK, the latency
>>      jitters caused by periodic load balancing may exceed the desired
>>      latency limit.
>>
>>      When cpuset v2 is in use, the only way to avoid this latency cost is to
>>      use the "isolcpus=" kernel boot option to isolate a set of CPUs. After
>>      the kernel boot, however, there is no way to add or remove CPUs from
>>      this isolated set. For workloads that are more dynamic in nature, that
>>      means users have to provision enough CPUs for the worst case situation
>>      resulting in excess idle CPUs.
>>
>>      To address this issue for cpuset v2, a new cpuset.cpus.partition type
>>      "isolated" is added which allows the creation of a cpuset partition
>>      without load balancing. This will allow system administrators to
>>      dynamically adjust the size of isolated partition to the current need
>>      of the workload without rebooting the system.
>>
>>      Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Nice! And while we are adding a new ABI, can we take advantage of that and
> add a specific semantic that if a new isolated partition matches a subset of
> "isolcpus=", it automatically maps to it. This means that any further
> modification to that isolated partition will also modify the associated
> isolcpus= subset.
>
> Or to summarize, when we create a new isolated partition, remove the associated
> CPUs from isolcpus= ?

We can certainly do that as a follow-on. Another idea that I have been 
thinking about is to automatically generating a isolated partition under 
root to match the given isolcpus parameter when the v2 filesystem is 
mounted. That needs more experimentation and testing to verify that it 
can work.

Cheers,
Longman

