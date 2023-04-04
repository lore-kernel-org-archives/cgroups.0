From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 1/3] cgroup/cpuset: Make cpuset_fork() handle
 CLONE_INTO_CGROUP properly
Date: Tue, 4 Apr 2023 13:26:10 -0400
Message-ID: <1100a740-3da4-a5bd-6a98-49b49c97b11b@redhat.com>
References: <20230331145045.2251683-1-longman@redhat.com>
 <20230331145045.2251683-2-longman@redhat.com>
 <20230403165523.aphsec2epqi72k27@blackpad>
 <d9f0005c-6825-b2a0-eac3-fcbad6e32b2f@redhat.com>
 <20230404091953.tcu3zg7npstk3ztc@blackpad>
 <a01585bc-03f8-e32c-ac46-99ac484a5e5d@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680629188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+zbXb6Euw4EpIZ9qJHPVIzO46HN/te+bwrGro+cOrx4=;
        b=Ni0ImnvZKr9fY4auCi41mqPoOWU9ZwpZ3AmJvLnRLXEe9WNjUKHhUxsEjnvPykj5GeMHwR
        XlmH5BXnhtbhGkMWZh5vXYHMdxtMgpFf91VX3WxXWARvG5KNH0bl7zddlMiwG7oAWCSEcM
        quvHE132Llz8lWg8wjv2gGU3p7hkD7E=
Content-Language: en-US
In-Reply-To: <a01585bc-03f8-e32c-ac46-99ac484a5e5d@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Christian Brauner <brauner@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, gscrivan@redhat.com

On 4/4/23 09:52, Waiman Long wrote:
>
> On 4/4/23 05:19, Michal Koutn=C3=BD wrote:
>> On Mon, Apr 03, 2023 at 01:18:42PM -0400, Waiman Long=20
>> <longman@redhat.com> wrote:
>>> 1) PF_NO_SETAFFINITY flag - which won't be set in the case of fork()=20
>>> as it
>>> is for kthread only.
>>> 2) DL bandwidth - Juri has a cpuset outstanding to modify the way=20
>>> this check
>>> is being done. I want to wait until it is settled before tackling=20
>>> this, if
>>> necessary.
>> BTW what about CLONE_INTO_CGROUP where the target cpuset has empty
>> effective cpuset?
> Good point. That will require a can_fork() method then. I will look=20
> into that.
>>
>>> 3) security_task_setscheduler() - the CLONE_INTO_CGROUP code has=20
>>> already
>>> checked that, we don't need to duplicate the check.
>> Not sure what this refers to.
> It is just checking of the task the has privilege of running into that=20
> cgroup.
>>
>>> So we don't need a can_fork() check for now.
>> Anyway, good breakdown. Could you please add it to the commit message
>> too?
>
> Yes, I can put that into the commit log.

I decide to add the can_fork method to do a pre-check. So I don't think=20
I need to update the commit log of this patch.

Cheers,
Longman

