From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Mon, 5 Jun 2023 16:00:39 -0400
Message-ID: <be64a569-4388-9dd9-3e06-36d716a54f6c@redhat.com>
References: <46d26abf-a725-b924-47fa-4419b20bbc02@redhat.com>
 <jqkf7jkuyxqiupmxmdbmpnbpojub2pjsz3oogwncmwqdghlsgk@phsqzirmmlyl>
 <f2bd7b1e-190e-1d08-f085-b4cae36fb5be@redhat.com>
 <ZFGOTHQj3k5rzmyR@blackbook>
 <deb7b684-3d7c-b3ae-7b36-5b7ba2dd8001@redhat.com>
 <ZFUo5IYAIwTEKR4_@slm.duckdns.org>
 <759603dd-7538-54ad-e63d-bb827b618ae3@redhat.com>
 <405b2805-538c-790b-5bf8-e90d3660f116@redhat.com>
 <ZGvHUjOCjwat91Gq@slm.duckdns.org>
 <18793f4a-fd39-2e71-0b77-856afb01547b@redhat.com>
 <ZH4jfmypOXGJPu0D@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685995245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0I6F66ZIa/tgx7QAKJtZG0czi9R4RbNmqFbBvhdUYFM=;
        b=GrG4zP4HD1BikLUtvI9bFwlcwjDE5BVhdCZdpd+bKT07mGc1ewzlpl7j2r+r6irN5yIrSF
        2j0N5SeEfuNevUqVuK+eI3dl8U+PNfK9bZYqpCboTcXprNJHhIhf0lSr1iS50O1gPzD3KG
        E76DtMXNUG0ewg2V49SEJqTNT+KZW24=
Content-Language: en-US
In-Reply-To: <ZH4jfmypOXGJPu0D-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mrunal Patel <mpatel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryan Phillips <rphillips-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brent Rowsell <browsell-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Hunt <pehunt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 6/5/23 14:03, Tejun Heo wrote:
> Hello, Waiman.
>
> On Sun, May 28, 2023 at 05:18:50PM -0400, Waiman Long wrote:
>> On 5/22/23 15:49, Tejun Heo wrote:
>> Sorry for the late reply as I had been off for almost 2 weeks due to PTO.
> And me too. Just moved.
>
>>> Why is the syntax different from .cpus? Wouldn't it be better to keep them
>>> the same?
>> Unlike cpuset.cpus, cpuset.cpus.reserve is supposed to contains CPUs that
>> are used in multiple partitions. Also automatic reservation of adjacent
>> partitions can happen in parallel. That is why I think it will be safer if
> Ah, I see, this is because cpu.reserve is only in the root cgroup, so you
> can't say that the knob is owned by the parent cgroup and thus access is
> controlled that way.
>
> ...
>>>>       There are two types of partitions - adjacent and remote.  The
>>>>       parent of an adjacent partition must be a valid partition root.
>>>>       Partition roots of adjacent partitions are all clustered around
>>>>       the root cgroup.  Creation of adjacent partition is done by
>>>>       writing the desired partition type into "cpuset.cpus.partition".
>>>>
>>>>       A remote partition does not require a partition root parent.
>>>>       So a remote partition can be formed far from the root cgroup.
>>>>       However, its creation is a 2-step process.  The CPUs needed
>>>>       by a remote partition ("cpuset.cpus" of the partition root)
>>>>       has to be written into "cpuset.cpus.reserve" of the root
>>>>       cgroup first.  After that, "isolated" can be written into
>>>>       "cpuset.cpus.partition" of the partition root to form a remote
>>>>       isolated partition which is the only supported remote partition
>>>>       type for now.
>>>>
>>>>       All remote partitions are terminal as adjacent partition cannot
>>>>       be created underneath it.
>>> Can you elaborate this extra restriction a bit further?
>> Are you referring to the fact that only remote isolated partitions are
>> supported? I do not preclude the support of load balancing remote
>> partitions. I keep it to isolated partitions for now for ease of
>> implementation and I am not currently aware of a use case where such a
>> remote partition type is needed.
>>
>> If you are talking about remote partition being terminal. It is mainly
>> because it can be more tricky to support hierarchical adjacent partitions
>> underneath it especially if it is not isolated. We can certainly support it
>> if a use case arises. I just don't want to implement code that nobody is
>> really going to use.
>>
>> BTW, with the current way the remote partition is created, it is not
>> possible to have another remote partition underneath it.
> The fact that the control is spread across a root-only file and per-cgroup
> file seems hacky to me. e.g. How would it interact with namespacing? Are
> there reasons why this can't be properly hierarchical other than the amount
> of work needed? For example:
>
>    cpuset.cpus.exclusive is a per-cgroup file and represents the mask of CPUs
>    that the cgroup holds exclusively. The mask is always a subset of
>    cpuset.cpus. The parent loses access to a CPU when the CPU is given to a
>    child by setting the CPU in the child's cpus.exclusive and the CPU can't
>    be given to more than one child. IOW, exclusive CPUs are available only to
>    the leaf cgroups that have them set in their .exclusive file.
>
>    When a cgroup is turned into a partition, its cpuset.cpus and
>    cpuset.cpus.exclusive should be the same. For backward compatibility, if
>    the cgroup's parent is already a partition, cpuset will automatically
>    attempt to add all cpus in cpuset.cpus into cpuset.cpus.exclusive.
>
> I could well be missing something important but I'd really like to see
> something like the above where the reservation feature blends in with the
> rest of cpuset.

It can certainly be made hierarchical as you suggest. It does increase 
complexity from both user and kernel point of view.

 From the user point of view, there is one more knob to manage 
hierarchically which is not used that often.

 From the kernel point of view, we may need to have one more cpumask per 
cpuset as the current subparts_cpus is used to track automatic 
reservation. We need another cpumask to contain extra exclusive CPUs not 
allocated through automatic reservation. The fact that you mention this 
new control file as a list of exclusively owned CPUs for this cgroup. 
Creating a partition is in fact allocating exclusive CPUs to a cgroup. 
So it kind of overlaps with the cpuset.cpus.partititon file. Can we fail 
a write to cpuset.cpus.exclusive if those exclusive CPUs cannot be 
granted or will this exclusive list is only valid if a valid partition 
can be formed. So we need to properly manage the dependency between 
these 2 control files.

Alternatively, I have no problem exposing cpuset.cpus.exclusive as a 
read-only file. It is a bit problematic if we need to make it writable.

As for namespacing, you do raise a good point. I was thinking mostly 
from a whole system point of view as the use case that I am aware of 
does not needs that. To allow delegation of exclusive CPUs to a child 
cgroup, that cgroup has to be a partition root itself. One compromise 
that I can think of is to only allow automatic reservation only in such 
a scenario. In that case, I need to support a remote load balanced 
partition as well and hierarchical sub-partitions underneath it. That 
can be done with some extra code to the existing v2 patchset without 
introducing too much complexity.

IOW, the use of remote partition is only allowed on the whole system 
level where one has access to the cgroup root. Exclusive CPUs 
distribution within a container can only be done via the use of adjacent 
partitions with automatic reservation. Will that be a good enough 
compromise from your point of view?

Cheers,
Longman

