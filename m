From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 0/9] memcg accounting from OpenVZ
Date: Thu, 11 Mar 2021 10:00:17 +0300
Message-ID: <24a416f7-9def-65c9-599e-d56f7c328d33@virtuozzo.com>
References: <5affff71-e503-9fb9-50cb-f6d48286dd52@virtuozzo.com>
 <CALvZod5YOtqXcSqn2Zj2Nb_SKgDRKOMW4o5i-u_yj7CanQVtGQ@mail.gmail.com>
 <ad68d004-fa84-3d21-60b7-d4a342ad4007@virtuozzo.com>
 <YEiiQ2TGnJcEtL3d@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6XPR4e7Qekz+ZPzIgfhEI9MBflHrYmy/+tDff+zpX30=;
 b=A+6eWPlIyvvZRRYeZxrKxIlyg3t95fJoF6pdp1ZWgVwLwwgSL6OpY7ciQupLfgVr+oNYMzuIq+bDpb1FfyHZ9jRtn/GviVI634k+KKnc9hGsDJh2OhAQ34MrD8ryvQozONgLZAgOk9EZFjd7n0b4KX2M2bciDnkwDWiTOq4SRcA=
In-Reply-To: <YEiiQ2TGnJcEtL3d-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 3/10/21 1:41 PM, Michal Hocko wrote:
> On Wed 10-03-21 13:17:19, Vasily Averin wrote:
>> On 3/10/21 12:12 AM, Shakeel Butt wrote:
>>> On Tue, Mar 9, 2021 at 12:04 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>>>>
>>>> OpenVZ many years accounted memory of few kernel objects,
>>>> this helps us to prevent host memory abuse from inside memcg-limited container.
>>>
>>> The text is cryptic but I am assuming you wanted to say that OpenVZ
>>> has remained on a kernel which was still on opt-out kmem accounting
>>> i.e. <4.5. Now OpenVZ wants to move to a newer kernel and thus these
>>> patches are needed, right?
>>
>> Something like this.
>> Frankly speaking I badly understand which arguments should I provide to upstream
>> to enable accounting for some new king of objects.
>>
>> OpenVZ used own accounting subsystem since 2001 (i.e. since v2.2.x linux kernels) 
>> and we have accounted all required kernel objects by using our own patches.
>> When memcg was added to upstream Vladimir Davydov added accounting of some objects
>> to upstream but did not skipped another ones.
>> Now OpenVZ uses RHEL7-based kernels with cgroup v1 in production, and we still account
>> "skipped" objects by our own patches just because we accounted such objects before.
>> We're working on rebase to new kernels and we prefer to push our old patches to upstream. 
> 
> That is certainly an interesting information. But for a changelog it
> would be more appropriate to provide information about how much memory
> user can induce and whether there is any way to limit that memory by
> other means. How practical those other means are and which usecases will
> benefit from the containment.

Right now I would like to understand how should I argument my requests about
accounting of new kind of objects.

Which description it enough to enable object accounting?
Could you please specify some edge rules?
Should I push such patches trough this list? 
Is it probably better to send them to mailing lists of according subsystems?
Should I notify them somehow at least?

"untrusted netadmin inside memcg-limited container can create unlimited number of routing entries, trigger OOM on host that will be unable to find the reason of memory  shortage and  kill huge"

"each mount inside memcg-limited container creates non-accounted mount object,
 but new mount namespace creation consumes huge piece of non-accounted memory for cloned mounts"

"unprivileged user inside memcg-limited container can create non-accounted multi-page per-thread kernel objects for LDT"

"non-accounted multi-page tty objects can be created from inside memcg-limited container"

"unprivileged user inside memcg-limited container can trigger creation of huge number of non-accounted fasync_struct objects"

Thank you,
	Vasily Averin
