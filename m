From: Tianchen Ding <dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [RFC PATCH v2 0/4] Introduce group balancer
Date: Thu, 10 Mar 2022 13:47:34 +0800
Message-ID: <014c8afe-e57f-0f31-32bb-cf4ff3d3cb95@linux.alibaba.com>
References: <20220308092629.40431-1-dtcccc@linux.alibaba.com>
 <YieOvaqJeEW2lta/@slm.duckdns.org>
 <defa02c1-9660-f335-a764-d89dbe2f502e@linux.alibaba.com>
 <YijrVmzG8/yT9a0f@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <YijrVmzG8/yT9a0f-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michael Wang <yun.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Cruz Zhao <cruzzhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Masahiro Yamada <masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nathan Chancellor <nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <ar>

On 2022/3/10 02:00, Tejun Heo wrote:
> Hello,
>=20
> On Wed, Mar 09, 2022 at 04:30:51PM +0800, Tianchen Ding wrote:
>> "the sched domains and the load balancer" you mentioned are the ways to
>> "balance" tasks on each domains. However, this patchset aims to "group" =
them
>> together to win hot cache and less competition, which is different from =
load
>> balancer. See commit log of the patch 3/4 and this link:
>> https://lore.kernel.org/all/11d4c86a-40ef-6ce5-6d08-e9d0bc9b512a-KPsoFbN=
s7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org/
>=20
> I read that but it doesn't make whole lot of sense to me. As Peter noted,=
 we
> already have issues with cross NUMA node balancing interacting with in-no=
de
> balancing, which likely indicates that it needs more unified solution rat=
her
> than more fragmented. I have a hard time seeing how adding yet another la=
yer
> on top helps the situation.
>=20
>>> * If, for some reason, you need more customizable behavior in terms of =
cpu
>>>     allocation, which is what cpuset is for, maybe it'd be better to bu=
ild the
>>>     load balancer in userspace. That'd fit way better with how cgroup i=
s used
>>>     in general and with threaded cgroups, it should fit nicely with eve=
rything
>>>     else.
>>>
>>
>> We put group balancer in kernel space because this new policy does not
>> depend on userspace apps. It's a "general" feature.
>=20
> Well, it's general for use cases which are happy with the two knobs that =
you
> defined for your use case.
>=20
>> Doing "dynamic cpuset" in userspace may also introduce performance issue,
>> since it may need to bind and unbind different cpusets for several times,
>> and is too strict(compared with our "soft bind").
>=20
> My bet is that you're gonna be able to get just about the same bench resu=
lts
> with userspace diddling with thread cgroup membership. Why not try that
> first? The interface is already there. I have a hard time seeing the
> justification for hard coding this into the kernel at this stage.
>=20
> Thanks.
>=20

Well, I understand your point is putting this in userspace. However,=20
we've considered about that but found it hard to do so. If you have any=20
better idea, please share with us. :-)

If we want to build group balancer in userspace, we need:
   1) gather load info from each rq periodically
   2) make decision to set cpuset.cpus of each cgroup

However, there're some problems about this way.

For 1), we need to consider how frequently collecting these info, which=20
may impact performance and accuracy. If the load changes hugely right=20
after we get it once, our data are expired and then the decision may be=20
wrong. (If we are in kernel, faster action can be taken.)

We believe 2) is harder. The specific policy may be complex and alter=20
according to different scenes. There's not a general method.
e.g., with 16cpus and 4 cgroups, how to decide when we set one of them=20
0-3(when busy)or 0-7(when some of other cgroups are idle)? If there are=20
much more threads in cgroupA than cgroupB/C/D , and we want to satisfy=20
cgroupA as far as possible(on the premise of fairness of B/C/D)=EF=BC=8C=20
dynamically enlarging(when B/C/D partly idle) and shrinking(when B/C/D=20
busy) cpuset of cgroupA requires complex policy. In this example,=20
fairness and performance can be provided by existing scheduler, but when=20
it comes to grouping hot cache or decreasing competion, both scheduler=20
in kernel and action in userspace are hard to solve.
What's more, in many cloud computing scenes, there may be hundreds or=20
thousands of containers, which are much larger than partition number.=20
These containers may be dynamically created and destroyed at any time.=20
Making policy to manage them from userspace will not be practical.

These problems become easy when going to kernelspace. We get info=20
directly from scheduler, and help revising its decision at some key=20
points, or do some support work(e.g., task migration if possible).

Thanks.
