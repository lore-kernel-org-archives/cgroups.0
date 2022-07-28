From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup/cpuset: Keep current cpus list if cpus
 affinity was explicitly set
Date: Thu, 28 Jul 2022 10:59:01 -0400
Message-ID: <a58852b4-313a-9271-f31d-f79a91ec188b@redhat.com>
References: <20220728005815.1715522-1-longman@redhat.com>
 <20220728144420.GA27407@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659020349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z/5IAGid/MkaGLoGKjcup59KN/CNT4vmw2F2KlJ1qxE=;
        b=iy/CWFy2ERcNaDYBIusjuZmZzM2djzl3Ob9ZYUFU4SLuxVobavzg6W/LkgiITBlML+6mv+
        lYQVD+GvcQh4JBl9nlexWzpa32MZbfi4xwN31DbQ2r/zMojD3Ey56MVOOgI1OMG1SjJkEX
        wznnx+XRolb1+lDBHPrr1fEMNhnA0YA=
Content-Language: en-US
In-Reply-To: <20220728144420.GA27407-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 7/28/22 10:44, Michal Koutn=C3=BD wrote:
> Hello.
>
> On Wed, Jul 27, 2022 at 08:58:14PM -0400, Waiman Long <longman-H+wXaHxf7a=
LQT0dZR+AlfA@public.gmane.org> wrote:
>> It was found that any change to the current cpuset hierarchy may reset
>> the cpus_allowed list of the tasks in the affected cpusets to the
>> default cpuset value even if those tasks have cpus affinity explicitly
>> set by the users before.
> I'm surprised this went so long unnoticed / unreported.
>
> Could it be users relied on that implicit affinity reset?

As said, it is more easily triggered in a cgroup v2 environment.=20
Systemd, on a cgroup v2 environment, will write "+cpuset" to the root=20
cgroup's subtree_control file when a new container is instantiated. I=20
don't know why it is doing that, but that cause problem as it resets all=20
the cpus_allowed list assignment. Cgroup v1 doesn't have this problem.


>> That is especially easy to trigger under a cgroup v2 environment where
>> writing "+cpuset" to the root cgroup's cgroup.subtree_control file
>> will reset the cpus affinity of all the processes in the system.
> This should apply only to tasks that were extracted out of the root
> cgroup, no? (OK, those are all processes practically.)
The reset is done on all cgroups in a particular subtree. In the case of=20
cgroup root, it is all the processes in the system.
>
> (Even without your second patch, the scope should be limited because of
> src_cset=3D=3Ddst_cset check in cgroup_migrate_prepare_dst().)
>
>> That is especially problematic in a nohz_full environment where the
>> tasks running in the nohz_full CPUs usually have their cpus affinity
>> explicitly set and will behave incorrectly if cpus affinity changes.
> One could also argue that for such processes, cgroup hierarchy should be
> first configured and only then they start and set own affinity.
>
>> Fix this problem by adding a flag in the task structure to indicate that
>> a task has their cpus affinity explicitly set before and make cpuset
>> code not to change their cpus_allowed list unless the user chosen cpu
>> list is no longer a subset of the cpus_allowed list of the cpuset itself.
> I'm uneasy with the occasional revert of this flag, i.e. the task who
> set their affinity would sometimes have it overwritten and sometimes
> not (which might have been relied on, especially with writes into
> cpuset.cpus).
> (But I have no better answer than the counter-argument above since
> there's no easier way to detect the implicit migrations.)
I also thought about that. Another possible alternative is to use the=20
intersection of cpuset's cpu list and task's own cpu list as long as it=20
is not empty. Reducing the number of cpus assigned to a task may produce=20
some unexpected behavior too.
>
> Also, is there similar effect with memory binding?

I think so, but memory binding is less frequently used and its effect is=20
less noticeable.

Cheers,
Longman

>
> Thanks,
> Michal
>

