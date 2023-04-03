From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup/cpuset: Allow only one active attach operation
 per cpuset
Date: Mon, 3 Apr 2023 13:41:33 -0400
Message-ID: <24b67530-62ce-4f9c-7b74-d41d2ccc710e@redhat.com>
References: <20230331145045.2251683-1-longman@redhat.com>
 <20230331145045.2251683-4-longman@redhat.com>
 <20230403164736.lpjdpzxxnjlpxrqv@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680543700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=du5ube66GFFv6eiC7GgKY4F8MRZGEnQkABRtMIiA1tM=;
        b=J6cASXk5i9MHrtpZDY8dEZvmUQKNuPizeI6WliI719tDfaYDiQEb6IJyq3fn1lH3ATkSzJ
        P3lNcBzS5+aERcfFSpAisMZ2HjCQ16slHA4jaRYYu4l2E1TOcaw1hCQ0iu2zMRy3zGOHXB
        taKagSrR63RGIUIJAGRbr70nEqz9w2c=
Content-Language: en-US
In-Reply-To: <20230403164736.lpjdpzxxnjlpxrqv@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org


On 4/3/23 12:47, Michal Koutn=C3=BD wrote:
> On Fri, Mar 31, 2023 at 10:50:45AM -0400, Waiman Long <longman-H+wXaHxf7a=
LQT0dZR+AlfA@public.gmane.org> wrote:
>> The current cpuset code uses the global cpuset_attach_old_cs variable
>> to store the old cpuset value between consecutive cpuset_can_attach()
>> and cpuset_attach() calls. Since a caller of cpuset_can_attach() may
>> not need to hold the global cgroup_threadgroup_rwsem, parallel cpuset
>> attach operations are possible.
> Do I understand correctly this consequence of the cpuset_attach_task()
> on the clone path?
> In that particular case (with CLONE_INTO_CGROUP) cgroup_mutex is taken,
> so the access the the old_cs variable should still be synchronized with
> regular migrations that are also under cgroup_mutex.

This patch is actually not related to the CLONE_INTO_GROUP problem in=20
patch 1. It is a generic problem when multiple users are moving threads=20
into cgroup.threads of the same or different cpusets simultaneously.


>> When there are concurrent cpuset attach operations in progress,
>> cpuset_attach() may fetch the wrong value from cpuset_attach_old_cs
>> causing incorrect result.  To avoid this problem while still allowing
>> certain level of parallelism, drop cpuset_attach_old_cs and use a
>> per-cpuset attach_old_cs value. Also restrict to at most one active
>> attach operation per cpuset to avoid corrupting the value of the
>> per-cpuset attach_old_cs value.
> Secondly, semantically wouldn't a `void *ss_priv[CGROUP_SUBSYS_COUNT]`
> in struct cgroup_taskset make it simpler wrt the exclusivity guarantees?

I guess we can put the old_cs value into cgroup_taskset. Since the=20
related attach_in_progress value is in cpuset, so I put the old_cs there=20
too.


> Thirdly, if my initial assumptino is right -- I'd suggest ordering this
> before the patch `cgroup/cpuset: Make cpuset_fork() handle
> CLONE_INTO_CGROUP properly` to spare backporters possible troubles if
> this is would be a fixup to that.

I don't believe this patch has a dependency on patch 1.

I had thought about adding a fixes tag so it will be backported to=20
stable. However, this problem should be rare. Let's see what others=20
think about it.

Cheers,
Longman

