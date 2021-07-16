From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/6] cgroup/cpuset: Clarify the use of invalid
 partition root
Date: Fri, 16 Jul 2021 14:44:27 -0400
Message-ID: <c6ae2d9b-ad6e-9bbd-b25c-f52b0ff6fb9b@redhat.com>
References: <20210621184924.27493-1-longman@redhat.com>
 <20210621184924.27493-3-longman@redhat.com>
 <YNcHOe3o//pIiByh@mtj.duckdns.org>
 <6ea1ac38-73e1-3f78-a5d2-a4c23bcd8dd1@redhat.com>
 <YONGk3iw/zrNzwLK@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626461071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7RoDupO6M1bVRrm6W8ZOvDrptNGSB7yFCE/hhZqmCP0=;
        b=RwDNRDvOsdUGbZ6Zfo4pFN7JYKQ6czviRweCPE2uYNRxkfI5K6AqHm8W35+yFcfpsNviIt
        7TQSeSDxHobZC3LFq63k9mx20gMpQo6Z0PhzPYC1bt0/cw4GvF/aJ4PbKCXx1727mOw77V
        MkHYfjVInL2WGvZyhwzKVksD5pIZ2IU=
In-Reply-To: <YONGk3iw/zrNzwLK-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 7/5/21 1:51 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Mon, Jun 28, 2021 at 09:06:50AM -0400, Waiman Long wrote:
>> The main reason for doing this is because normal cpuset control file act=
ions
>> are under the direct control of the cpuset code. So it is up to us to de=
cide
>> whether to grant it or deny it. Hotplug, on the other hand, is not under=
 the
>> control of cpuset code. It can't deny a hotplug operation. This is the m=
ain
>> reason why the partition root error state was added in the first place.
> I have a difficult time convincing myself that this difference justifies =
the
> behavior difference and it keeps bothering me that there is a state which
> can be reached through one path but rejected by the other. I'll continue
> below.
>
>> Normally, users can set cpuset.cpus to whatever value they want even tho=
ugh
>> they are not actually granted. However, turning on partition root is und=
er
>> more strict control. You can't turn on partition root if the CPUs reques=
ted
>> cannot actually be granted. The problem with setting the state to just
>> partition error is that users may not be aware that the partition creati=
on
>> operation fails.=C2=A0 We can't assume all users will do the proper error
>> checking. I would rather let them know the operation fails rather than
>> relying on them doing the proper check afterward.
>>
>> Yes, I agree that it is a different philosophy than the original cpuset
>> code, but I thought one reason of doing cgroup v2 is to simplify the
>> interface and make it a bit more erorr-proof. Since partition root creat=
ion
>> is a relatively rare operation, we can afford to make it more strict than
>> the other operations.
> So, IMO, one of the reasons why cgroup1 interface was such a mess was
> because each piece of interaction was designed ad-hoc without regard to t=
he
> overall consistency. One person feels a particular way of interacting with
> the interface is "correct" and does it that way and another person does
> another part in a different way. In the end, we ended up with a messy
> patchwork.
>
> One problematic aspect of cpuset in cgroup1 was the handling of failure
> modes, which was caused by the same exact approach - we wanted the interf=
ace
> to reject invalid configurations outright even though we didn't have the
> ability to prevent those configurations from occurring through other path=
s,
> which makes the failure mode more subtle by further obscuring them.
>
> I think a better approach would be having a clear signal and mechanism to
> watch the state and explicitly requiring users to verify and monitor the
> state transitions.

Sorry for the late reply as I was busy with other works.

I agree with you on principle. However, the reason why there are more=20
restrictions on enabling partition is because I want to avoid forcing=20
the users to always read back cpuset.partition.type to see if the=20
operation succeeds instead of just getting an error from the operation.=20
The former approach is more error prone. If you don't want changes in=20
existing behavior, I can relax the checking and allow them to become an=20
invalid partition if an illegal operation happens.

Also there is now another cpuset patch to extend cpu isolation to cgroup=20
v1 [1]. I think it is better suit to the cgroup v2 partition scheme, but=20
cgroup v1 is still quite heavily out there.

Please let me know what you want me to do and I will send out a v3 version.

Thanks a lot!
Longman

