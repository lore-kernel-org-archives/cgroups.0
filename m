From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH v2 2/6] cgroup/cpuset: Clarify the use of invalid
 partition root
Date: Mon, 28 Jun 2021 09:06:50 -0400
Message-ID: <6ea1ac38-73e1-3f78-a5d2-a4c23bcd8dd1@redhat.com>
References: <20210621184924.27493-1-longman@redhat.com>
 <20210621184924.27493-3-longman@redhat.com>
 <YNcHOe3o//pIiByh@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624885616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Wsog/UA6NQRm36wrbUHXM3ftcSt/9+OFEW6vcsabAY=;
        b=RiR40TU4jrtl9rNUACuQNyx3biuO0jOUfjOJYa6ZdFJNcIR0kwK6zXRf2i3JB2TrDYifVN
        0FV9Ko9m9P8GhPRbog+ijE+UScWmqlp/0xhj/bYB6w8PgRoJMkNhtEGDh0NoqEpJHxOz9G
        7oYHPVAH1UquSbN7FuPBdlf2OObnwZ4=
In-Reply-To: <YNcHOe3o//pIiByh@mtj.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>

On 6/26/21 6:53 AM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Mon, Jun 21, 2021 at 02:49:20PM -0400, Waiman Long wrote:
>>   1) A partition root can't be changed to member if it has child partiti=
on
>>      roots.
>>   2) Removing CPUs from cpuset.cpus that causes it to become invalid is
>>      not allowed.
> I'm not a fan of this approach. No matter what we have to be able to hand=
le
> CPU removals which are user-iniated operations anyway, so I don't see why
> we're adding a different way of handling a different set of operations. J=
ust
> handle them the same?

The main reason for doing this is because normal cpuset control file=20
actions are under the direct control of the cpuset code. So it is up to=20
us to decide whether to grant it or deny it. Hotplug, on the other hand,=20
is not under the control of cpuset code. It can't deny a hotplug=20
operation. This is the main reason why the partition root error state=20
was added in the first place.

Normally, users can set cpuset.cpus to whatever value they want even=20
though they are not actually granted. However, turning on partition root=20
is under more strict control. You can't turn on partition root if the=20
CPUs requested cannot actually be granted. The problem with setting the=20
state to just partition error is that users may not be aware that the=20
partition creation operation fails.=C2=A0 We can't assume all users will do=
=20
the proper error checking. I would rather let them know the operation=20
fails rather than relying on them doing the proper check afterward.

Yes, I agree that it is a different philosophy than the original cpuset=20
code, but I thought one reason of doing cgroup v2 is to simplify the=20
interface and make it a bit more erorr-proof. Since partition root=20
creation is a relatively rare operation, we can afford to make it more=20
strict than the other operations.

Cheers,
Longman

