From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] cgroup/cpuset: Make cpuset_fork() handle
 CLONE_INTO_CGROUP properly
Date: Tue, 4 Apr 2023 09:52:37 -0400
Message-ID: <a01585bc-03f8-e32c-ac46-99ac484a5e5d@redhat.com>
References: <20230331145045.2251683-1-longman@redhat.com>
 <20230331145045.2251683-2-longman@redhat.com>
 <20230403165523.aphsec2epqi72k27@blackpad>
 <d9f0005c-6825-b2a0-eac3-fcbad6e32b2f@redhat.com>
 <20230404091953.tcu3zg7npstk3ztc@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680616361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2t022cV29B7Zbre5ZWJdAks4cSokwANFRg/jjQH6iKk=;
        b=G7VgNnALgbtc0CFUe4mF4BKXu9j0ctywryY0kk37/GM6KUpS27tIXZEdDdGAhqLhIQI6iN
        dReeTAbsTyYalZMlYdXOmvOobtFl96pBrZH/vGCFHrS+q3/ZbXZumN9EDeASKHGXI8q0dk
        RRSxcXwT9iTj3slavdCIodRxJXpnKrU=
Content-Language: en-US
In-Reply-To: <20230404091953.tcu3zg7npstk3ztc@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org


On 4/4/23 05:19, Michal Koutn=C3=BD wrote:
> On Mon, Apr 03, 2023 at 01:18:42PM -0400, Waiman Long <longman-H+wXaHxf7a=
LQT0dZR+AlfA@public.gmane.org> wrote:
>> 1) PF_NO_SETAFFINITY flag - which won't be set in the case of fork() as =
it
>> is for kthread only.
>> 2) DL bandwidth - Juri has a cpuset outstanding to modify the way this c=
heck
>> is being done. I want to wait until it is settled before tackling this, =
if
>> necessary.
> BTW what about CLONE_INTO_CGROUP where the target cpuset has empty
> effective cpuset?
Good point. That will require a can_fork() method then. I will look into=20
that.
>
>> 3) security_task_setscheduler() - the CLONE_INTO_CGROUP code has already
>> checked that, we don't need to duplicate the check.
> Not sure what this refers to.
It is just checking of the task the has privilege of running into that=20
cgroup.
>
>> So we don't need a can_fork() check for now.
> Anyway, good breakdown. Could you please add it to the commit message
> too?

Yes, I can put that into the commit log.

Cheers,
Longman

> Regards,
> Michal

