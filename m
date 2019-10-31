From: Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH v4 1/2] sched/topology: Don't try to build empty sched
 domains
Date: Thu, 31 Oct 2019 18:23:12 +0100
Message-ID: <3752bca9-a670-f415-4aaa-e8ff75ea6fcc@arm.com>
References: <20191023153745.19515-1-valentin.schneider@arm.com>
 <20191023153745.19515-2-valentin.schneider@arm.com>
 <20191031162334.GA18570@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20191031162334.GA18570@blackbody.suse.cz>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org, mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org, Dietmar.Eggemann@arm.com, morten.rasmussen@arm.com, qperret@google.com, stable@vger.kernel.org

Hi Michal,

On 31/10/2019 17:23, Michal Koutn=FD wrote:
> On Wed, Oct 23, 2019 at 04:37:44PM +0100, Valentin Schneider <valentin.sc=
hneider@arm.com> wrote:
>> Prevent generate_sched_domains() from returning empty cpumasks, and add
>> some assertion in build_sched_domains() to scream bloody murder if it
>> happens again.
> Good catch. It makes sense to prune the empty domains in
> generate_sched_domains already.
>=20
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index c52bc91f882b..c87ee6412b36 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -798,7 +798,8 @@ static int generate_sched_domains(cpumask_var_t **do=
mains,
>>  		    cpumask_subset(cp->cpus_allowed, top_cpuset.effective_cpus))
>>  			continue;
>> =20
>> -		if (is_sched_load_balance(cp))
>> +		if (is_sched_load_balance(cp) &&
>> +		    !cpumask_empty(cp->effective_cpus))
>>  			csa[csn++] =3D cp;
> If I didn't overlook anything, cp->effective_cpus can contain CPUs
> exluded by housekeeping_cpumask(HK_FLAG_DOMAIN) later, i.e. possibly
> still returning domains with empty cpusets.
>=20
> I'd suggest moving the emptiness check down into the loop where domain
> cpumasks are ultimately constructed.
>=20

Ah, wasn't aware of this - thanks for having a look!

I think I need to have the check before the final cpumask gets built,
because at this point the cpumask array is already built and it's handed
off directly to the sched domain rebuild.

Do you reckon the following would work?=20

----8<----
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index c87ee6412b36..e4c10785dc7c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -798,8 +798,14 @@ static int generate_sched_domains(cpumask_var_t **doma=
ins,
 		    cpumask_subset(cp->cpus_allowed, top_cpuset.effective_cpus))
 			continue;
=20
+		/*
+		 * Skip cpusets that would lead to an empty sched domain.
+		 * That could be because effective_cpus is empty, or because
+		 * it's only spanning CPUs outside the housekeeping mask.
+		 */
 		if (is_sched_load_balance(cp) &&
-		    !cpumask_empty(cp->effective_cpus))
+		    cpumask_intersects(cp->effective_cpus,
+				       housekeeping_cpumask(HK_FLAG_DOMAIN)))
 			csa[csn++] =3D cp;
=20
 		/* skip @cp's subtree if not a partition root */
