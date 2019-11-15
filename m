From: Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH v2] sched/topology, cpuset: Account for housekeeping CPUs
 to avoid empty cpumasks
Date: Fri, 15 Nov 2019 18:48:43 +0000
Message-ID: <c425c5cb-ba8a-e5f6-d91c-5479779cfb7a@arm.com>
References: <20191104003906.31476-1-valentin.schneider@arm.com>
 <d7ed40aa-1ac1-a42d-51eb-b1bd9f839fb1@arm.com>
 <20191115171807.GH19372@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191115171807.GH19372@blackbody.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org, mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org, Dietmar.Eggemann@arm.com, morten.rasmussen@arm.com, qperret@google.com

On 15/11/2019 17:18, Michal Koutn=FD wrote:
> Hello.
>=20
> On Thu, Nov 14, 2019 at 04:03:50PM +0000, Valentin Schneider <valentin.sc=
hneider@arm.com> wrote:
>> Michal, could I nag you for a reviewed-by? I'd feel a bit more confident
>> with any sort of approval from folks who actually do use cpusets.
> TL;DR I played with the v5.4-rc6 _without_ this fixup and I conclude it
> unnecessary (IOW my previous theoretical observation was wrong).
>=20

Thanks for going through the trouble of testing the thing.

>=20
> The original problem is non-issue with v2 cpuset controller, because
> effective_cpus are never empty. isolcpus doesn't take out cpuset CPUs,
> hotplug does. In the case, no online CPU remains in the cpuset, it
> inherits ancestor's non-empty cpuset.
>=20

But we still take out the isolcpus from the domain span before handing it
over to the scheduler:

	cpumask_or(dp, dp, b->effective_cpus);                              =20
	cpumask_and(dp, dp, housekeeping_cpumask(HK_FLAG_DOMAIN));

But...

> I reproduced the problem with v1 (before your fix). However, in v1
> effective =3D=3D allowed (we're destructive and overwrite allowed on
> hotunplug) and we already check the emptiness of=20
>=20
>   cpumask_intersects(cp->cpus_allowed, housekeeping_cpumask(HK_FLAG_DOMAI=
N)
>=20
> few lines higher. I.e. the fixup adds redundant check against the empty
> sched domain production.
>=20

...You're right, I've been misreading that as a '!is_sched_load_balance()'
condition ever since. Duh. So this condition will always catch cpusets than
only span outside the housekeeping domain, and my previous fixup will
catch newly-empty cpusets (due to HP). Perhaps it would've been cleaner to
merge the two, but as things stand this patch isn't needed (as you say).


I tried this out to really be sure (8 CPU SMP aarch64 qemu target):

  cd /sys/fs/cgroup/cpuset                                                 =
                           =20
                                                                           =
                         =20
  mkdir cs1                                                                =
                           =20
  echo 1 > cs1/cpuset.cpu_exclusive                                        =
                           =20
  echo 0 > cs1/cpuset.mems                                                 =
                           =20
  echo 0-4 > cs1/cpuset.cpus                                               =
                           =20
                                                                           =
                         =20
  mkdir cs2                                                                =
                           =20
  echo 1 > cs2/cpuset.cpu_exclusive                                        =
                           =20
  echo 0 > cs2/cpuset.mems                                                 =
                           =20
  echo 5-7 > cs2/cpuset.cpus                                               =
                           =20
                                                                           =
                         =20
  echo 0 > cpuset.sched_load_balance

booted with
 =20
  isolcpus=3D6-7

It seems that creating a cpuset with CPUs only outside the housekeeping
domain is forbidden, so I'm creating cs2 with *one* CPU in the domain. When
I hotplug it out, nothing dies horribly:

  echo 0 > /sys/devices/system/cpu/cpu5/online
  [   24.688145] CPU5: shutdown
  [   24.689438] psci: CPU5 killed.
  [   24.714168] allowed=3D0-4 effective=3D0-4 housekeeping=3D0-5
  [   24.714642] allowed=3D6-7 effective=3D6-7 housekeeping=3D0-5
  [   24.715416] CPU5 attaching NULL sched-domain.

> Sorry for the noise and HTH,

Sure does, thanks!

> Michal
>=20
