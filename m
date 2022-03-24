From: Tianchen Ding <dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [RFC PATCH v2 0/4] Introduce group balancer
Date: Thu, 24 Mar 2022 14:50:50 +0800
Message-ID: <4529fa25-9497-b05c-90c0-42fb10841a22@linux.alibaba.com>
References: <20220308092629.40431-1-dtcccc@linux.alibaba.com>
 <YieOvaqJeEW2lta/@slm.duckdns.org>
 <defa02c1-9660-f335-a764-d89dbe2f502e@linux.alibaba.com>
 <YijrVmzG8/yT9a0f@slm.duckdns.org>
 <014c8afe-e57f-0f31-32bb-cf4ff3d3cb95@linux.alibaba.com>
 <YjjA+vyQuh5fNeLG@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <YjjA+vyQuh5fNeLG-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michael Wang <yun.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Cruz Zhao <cruzzhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Masahiro Yamada <masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nathan Chancellor <nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <ar>

On 2022/3/22 02:16, Tejun Heo wrote:
> Hello,
>=20
> On Thu, Mar 10, 2022 at 01:47:34PM +0800, Tianchen Ding wrote:
>> If we want to build group balancer in userspace, we need:
>>    1) gather load info from each rq periodically
>>    2) make decision to set cpuset.cpus of each cgroup
>>
>> However, there're some problems about this way.
>>
>> For 1), we need to consider how frequently collecting these info, which =
may
>> impact performance and accuracy. If the load changes hugely right after =
we
>> get it once, our data are expired and then the decision may be wrong. (I=
f we
>> are in kernel, faster action can be taken.)
>=20
> We now have a pretty well established way to transport data to userspace =
at
> really low overhead. If you piggy back on bpf interfaces, they can usually
> be pretty unintrusive and low effort as long as you have the right kind of
> data aggregated already, which shouldn't be that difficult here.
>=20

Yes, bpf is a good way to fetch these data.
In fact we may also consider impacting on some decisions of scheduler in=20
some scenes. But it seems to be a long term work...

>> We believe 2) is harder. The specific policy may be complex and alter
>> according to different scenes. There's not a general method.
>> e.g., with 16cpus and 4 cgroups, how to decide when we set one of them
>> 0-3(when busy)or 0-7(when some of other cgroups are idle)? If there are =
much
>> more threads in cgroupA than cgroupB/C/D , and we want to satisfy cgroup=
A as
>> far as possible(on the premise of fairness of B/C/D)=EF=BC=8C dynamically
>> enlarging(when B/C/D partly idle) and shrinking(when B/C/D busy) cpuset =
of
>> cgroupA requires complex policy. In this example, fairness and performan=
ce
>> can be provided by existing scheduler, but when it comes to grouping hot
>> cache or decreasing competion, both scheduler in kernel and action in
>> userspace are hard to solve.
>=20
> So, I get that it's not easy. In fact, we don't even yet know how to
> properly compare loads across groups of CPUs - simple sums that you're us=
ing
> break down when there are big gaps in weight numbers across tasks and can
> become meaningless in the presence of CPU affinities. They can still work

"simple sums" is fine because we only use this load when selecting=20
partitions, not migrating.

If I understand correctly, do you mean a scene that:
cgroupA has only one thread with full busy load (1024)
cgroup B/C/D have many threads with small load (maybe 100)
There're two CPU partitons:0-3 and 4-7

If A choose 0-3 (we suppose its thread sticking on cpu0), so the load of=20
partition 0-3 becomes 1024 because simple sums. So B/C/D will all choose=20
partition 4-7. This will be fine since our group balancer is a kind of=20
"soft" bind. If we are waking a thread from cgroupB and find there is no=20
free cpu in 4-7, we'll fallback to normal path and select other idle cpu=20
(i.e., 1-3) if possible.
Otherwise, if there is no idle cpu totally, meaning the whole system is=20
busy. The existing load balance mechanism will handle it, and our=20
patches only try to switch two tasks if their cache in their own cgroups=20
can be closer after migration.

> when the configuration is fairly homogeenous and controlled but the stand=
ard
> should be far higher for something we bake into the kernel and expose
> userland-visible interface for.
>=20

Our aim is to improve performance of apps, so will not limit cpu usage=20
strictly. This kind of soft bind also helps to avoid conflicts with=20
existing load balance mechanism. We may explain this in document.

>> What's more, in many cloud computing scenes, there may be hundreds or
>> thousands of containers, which are much larger than partition number. Th=
ese
>> containers may be dynamically created and destroyed at any time. Making
>> policy to manage them from userspace will not be practical.
>>
>> These problems become easy when going to kernelspace. We get info direct=
ly
>> from scheduler, and help revising its decision at some key points, or do
>> some support work(e.g., task migration if possible).
>=20
> I don't think they become necessarily easy. Sure, you can hack up somethi=
ng
> which works for some cases by poking into existing code; however, the bar
> for acceptance is also way higher for a kernel interface - it should be
> generic, consistent with other interfaces (I won't go into cgroup interfa=
ce
> issues here), and work orthogonally with other kernel features (ie. task /
> group weights should work in an explainable way). I don't think the propo=
sed
> patches are scoring high in those axes.
>=20

We set the interface into cpuset subsys because partition info should=20
follow effective_cpus. There may be a problem that we need to get load=20
info from cpu subsys, so "cpu" and "cpuset" should be both enabled in=20
the same cgroup. Fortunately, this is easy in cgroup-v2. Any other=20
conflict do you see?

About "work orthogonally with other kernel features", we've explained=20
above. Weights are only used in selecting partitions and we just tend to=20
trying pulling tasks to their selected partitions, not force.

> I'm not against the goal here. Given that cgroups express the logical
> structure of applications running on the system, it does make sense to
> factor that into scheduling decisions. However, what's proposed seems too
> premature and I have a hard time seeing why this level of functionality
> would be difficult to be implement from userspace with some additions in
> terms of visibility which is really easy to do these days.

Just as out explanation in the last mail, we believe building this in=20
userspace is not easy. Because interfaces provided by kernel now is=20
inflexible. From the view of cgroup, it is given a binded "cpuset.cpus",=20
and all cpus in this range are treated equally, while all cpus out of=20
this range are strictly forbidden. The existing cpuset mechanisms do=20
help resource limitation and isolation, but may be weak on improving=20
perforamce.

So, our idea is, doing this in userspace, which relies on existing=20
kernel interfaces, is hard. Only exposing more data to increase=20
visibility in userspace is not enough. We need a whole solution from=20
collecting data to impacting decisions of the scheduler. Maybe eBPF can=20
cover all these works in the future, but it takes long time to develop=20
and maybe too much to achieve just dynamic cpu bind.

Thanks.
