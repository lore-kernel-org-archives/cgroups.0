From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] cpuset: Allow setscheduler regardless of manipulated
 task
Date: Thu, 23 Jun 2022 14:44:33 -0400
Message-ID: <ab4bcd51-83c5-ae21-ddf6-607a31a7d6ac@redhat.com>
References: <20220623124944.2753-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656009876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=636D/XRoEUnQhXwCEpL4spRdQ6LF5SX4zYskRSw7REM=;
        b=hAzvUZIYHyGmd07z5d08FoOvxSt8zGGMAd1kR38kJOsKDXMRNH+8dWBvel4IZ9VD6/ifmB
        ydazkQQ2n/DK7X5B/PtXm6nLNaYXbubTsydCF5MIK7Q8gXOEzC1S9pnmyuiQbXdjLB/4Qx
        xmn7eCupplV+ukHF+Ua++N78TGB6AgY=
Content-Language: en-US
In-Reply-To: <20220623124944.2753-1-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 6/23/22 08:49, Michal Koutn=C3=BD wrote:
> When we migrate a task between two cgroups, one of the checks is a
> verification that we can modify task's scheduler settings
> (cap_task_setscheduler()).
>
> An implicit migration occurs also when enabling a controller on the
> unified hierarchy (think of parent to child migration). The
> aforementioned check may be problematic if the caller of the migration
> (enabling a controller) has no permissions over migrated tasks.
> For instance, user's cgroup that ends up running a process of a
> different user. Although cgroup permissions are configured favorably,
> the enablement fails due to the foreign process [1].
>
> Change the behavior by relaxing the permissions check on the unified
> hierarchy (or in v2 mode). This is in accordance with unified hierarchy
> attachment behavior when permissions of the source to target cgroups are
> decisive whereas the migrated task is opaque (for contrast, see more
> restrictive check in __cgroup1_procs_write()).
>
> [1] https://github.com/systemd/systemd/issues/18293#issuecomment-831205649
>
> Reasons for RFC:
>
> 1) The unified hierarchy attachment behavior -- is that the
>     right/consented model that migrated objects don't matter?
>
> 2) If 1) is true, have I missed any danger in allowing cpuset'ing a
>     possibly privileged processes?
That could be an issue.

> 2.2) cpuset may be in v2 mode even on v1 hierarchy with different
>     migration control rules (but checking migratee's creds in v1
>     eliminates effect of this patch).
>
> 3) Alternative approach would be to allow cpuset migrations only when
>     nothing effectively changes (which is the case for parent->child
>     migration upon controller enablement).
What do you mean by nothing effectively changes?
>
> 4) This is just idea draft, not tested in the real case.

Since the check is done on a taskset level, if only one of the tasks in=20
the taskset fails, the whole taskset fails. Maybe we should consider an=20
option for task based migration. So all the tasks that can be migrated=20
will be migrated and the rests will be left behind in the original=20
cpuset. Just a thought.

Cheers,
Longman

