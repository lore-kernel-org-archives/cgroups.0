From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/6] cgroup/cpuset: Add a new isolated cpus.partition
 type
Date: Thu, 24 Jun 2021 11:23:45 -0400
Message-ID: <58c87587-417b-1498-185f-1db6bb612c82@redhat.com>
References: <20210621184924.27493-1-longman@redhat.com>
 <20210621184924.27493-4-longman@redhat.com> <YNR/3fydXvAi3OsN@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624548229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V6782uv/lR78IFZdWPlWYnzNvjYHBRQ4Y4k+rewPDws=;
        b=cCJrE5diLfQTcZvUvuxVxrqaiOl4tKRDuZ7QNo3pMQzvXzERM3riKOa5h3B0Fhn0umEzmI
        1an5aPee9f+xm+C3k7DTEClH2veWkXtcyQIrL9zZdxp7zymd/gt8s8EXbTGnIX3zhFrRyP
        Ndnf0lQttVe4cck7T5M3MYbKwIGbFQg=
In-Reply-To: <YNR/3fydXvAi3OsN@blackbook>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 6/24/21 8:51 AM, Michal Koutn=FD wrote:
> Hello.
>
> On Mon, Jun 21, 2021 at 02:49:21PM -0400, Waiman Long <longman-H+wXaHxf7a=
LQT0dZR+AlfA@public.gmane.org> wrote:
>>      cgroup/cpuset: Add a new isolated cpus.partition type
>>
>>      Cpuset v1 uses the sched_load_balance control file to determine if =
load
>>      balancing should be enabled.  Cpuset v2 gets rid of sched_load_bala=
nce
>>      as its use may require disabling load balancing at cgroup root.
>>
>>      For workloads that require very low latency like DPDK, the latency
>>      jitters caused by periodic load balancing may exceed the desired
>>      latency limit.
>>
>>      When cpuset v2 is in use, the only way to avoid this latency cost i=
s to
>>      use the "isolcpus=3D" kernel boot option to isolate a set of CPUs. =
After
>>      the kernel boot, however, there is no way to add or remove CPUs from
>>      this isolated set. For workloads that are more dynamic in nature, t=
hat
>>      means users have to provision enough CPUs for the worst case situat=
ion
>>      resulting in excess idle CPUs.
>>
>>      To address this issue for cpuset v2, a new cpuset.cpus.partition ty=
pe
>>      "isolated" is added which allows the creation of a cpuset partition
>>      without load balancing. This will allow system administrators to
>>      dynamically adjust the size of isolated partition to the current ne=
ed
>>      of the workload without rebooting the system.
> I like this work.
> Would it be worth generalizing the API to be on par with what isolcpus=3D
> can configure? (I.e. not only load balancing but the other dimensions of
> isolation (like the flags nohz and managed_irq now).)
Good point, the isolated partition is equivalent to isolcpus=3Ddomain. I=20
will need to evaluate the nohz and managed_irq options to see if they=20
can be done dynamically without adding a lot of overhead. If so, we can=20
extend the functionality to cover that in future patches. Right now,=20
this is for the domain functionality only. If we can cover the nohz and=20
managed_irq options, we can deprecate isolcpus and advocate the use of=20
cgroup instead.
>
> I don't know if all such behaviors could be implemented dynamically
> (likely not easy) but the API could initially implement just what you do
> here with the "isolated" partition type.
>
> The variant I'm thinking of would keep just the "root" and "member"
> partitions type and the "root" type could be additionally configured via
> cpuset.cpus.partition.flags (for example).
>
> WDYT?

What I am thinking is that "isolated" means "isolated:domain" or one can=20
do "isolated:nohz,domain,manged_irq" just like the current isolcpus boot=20
option. I don't think we really need to add an extra flags control file.

Cheers,
Longman


