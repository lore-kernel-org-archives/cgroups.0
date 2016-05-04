From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: allow management of subtrees by new cgroup
 namespaces
Date: Wed, 4 May 2016 19:49:45 +1000
Message-ID: <5729C5B9.5040201@suse.de>
References: <1462110065-4904-1-git-send-email-asarai@suse.de>
 <1462110065-4904-2-git-send-email-asarai@suse.de>
 <1462226406.3036.17.camel@HansenPartnership.com> <572805FD.9080202@suse.de>
 <1462242375.3093.12.camel@HansenPartnership.com> <572849C7.2020303@suse.de>
 <1462285590.11378.19.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462285590.11378.19.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

>>>>> Perhaps what you should to be arguing then that the default
>>>>> permissions of the cgroup directories need to be all rwx for
>>>>> everyone and then your patch becomes unnecessary?
>>>>
>>>> I don't think that would be the nicest way of dealing with this
>>>> (then a process can make very large numbers of cgroups all over
>>>> the tree, which might not cause huge issues but would still be a
>>>> pain for administrators and systemds alike).
>>>
>>> Beware of what you cite as a problem.  Any user can enter a user
>>> namespace and then unshare a cgroup namespace.  This means that
>>> what you seem to want is equivalent to any user at all being able
>>> to create a cgroup hierarchy.
>>
>> They should only be allowed to make subtrees of the cgroup *they
>> currently reside in* IMO.
>
> For the usual case that is the top level cgroup because most processes
> don't get initially confined.  If there is initial confinement by
> something, then whatever it is could alter the permissions as well.
>
> So if the default case is equivalent to making all the initial top
> level cgroups rwx, we should understand the implications of that and
> the best way to concentrate minds is to ask what happens if it were the
> default.

A patchset I worked on (and then trashed) before writing this one would 
create a cgroup under your current cgroup, then would make you the owner 
of the new cgroup (and move you to it, making it the root of the 
namespace). This would alleviate this particular issue, but brings up 
many others (such as making sure there's no name clashes, and the fact 
that processes will start moving around in cgroups and whether or not 
userspace will be sufficiently alerted to the changes). In addition, the 
code was quite bad.

My ideal solution would be something like the above, because it means 
that we don't have to have disagreement about who "owns" a particular 
node in the cgroup hierarchy. Then we don't even have to virtualise 
/sys/fs/cgroups because there can be a global agreement on who owns what.

The only issue I could think of was the name clashes, and the fact that 
processes will now be moving around cgroups without explicitly writing 
to cgroup.procs.

>> If we decide to implement both, we have to agree on the restrictions
>> *immediately* because the cgroup namespace was merged in 4.6-rc1 so
>> changing the restrictions on it in 4.7 would probably be frowned
>> upon.
>
> No, that horse has left the stable: the cgroup namespace applies to
> both v1 and v2.

I was referring to the "what restrictions should apply to cgroup.procs 
in a cgroup namespace" question, because if we don't agree on this 
before 4.7 we would break back-compat.

>> My thinking was that rename(2) would make this a simple decision, but
>> I just realised that rename(2) doesn't let you change the hierarchy.
>> But it should be noted that cgroupv2 has a fix for this: you can't
>> move a task to another cgroup unless you have attach rights
>> (cgroup.procs) to the common ancestor of the current cgroup and the
>> target cgroup.
>
> Currently the decision is made in cgroup_procs_write_permission() and
> actually is blind to the user namespace, so this needs updating anyway.

Yeah, but we can't apply it (the common ancestor restriction) to 
cgroupv1 (back-compat). Maybe we could combine both updates as one 
"correcting the semantics" patch?

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
