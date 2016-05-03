From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: allow management of subtrees by new cgroup
 namespaces
Date: Tue, 3 May 2016 16:48:39 +1000
Message-ID: <572849C7.2020303@suse.de>
References: <1462110065-4904-1-git-send-email-asarai@suse.de>
 <1462110065-4904-2-git-send-email-asarai@suse.de>
 <1462226406.3036.17.camel@HansenPartnership.com> <572805FD.9080202@suse.de>
 <1462242375.3093.12.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462242375.3093.12.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

>>> Perhaps what you should to be arguing then that the default
>>> permissions of the cgroup directories need to be all rwx for
>>> everyone and then your patch becomes unnecessary?
>>
>> I don't think that would be the nicest way of dealing with this (then
>> a process can make very large numbers of cgroups all over the tree,
>> which might not cause huge issues but would still be a pain for
>> administrators and systemds alike).
>
> Beware of what you cite as a problem.  Any user can enter a user
> namespace and then unshare a cgroup namespace.  This means that what
> you seem to want is equivalent to any user at all being able to create
> a cgroup hierarchy.

They should only be allowed to make subtrees of the cgroup *they 
currently reside in* IMO. Making the hierarchies chmod(0777) would allow 
any process in any hierarchy to create cgroups anywhere in the tree. It 
would just make management within cgroupv2 much harder (especially with 
the no internal process semantics of cgroupv2). This wouldn't happen 
with the cgroup namespace.

It should be noted that cgroupv1 doesn't have the same protection I 
outline below, so this would actually cause cgroup escapes in that case 
(which we should obviously avoid).

> [...] This means that either it is a problem, and the
> cgroup namespace will have to be restricted in some way over how it can
> create subordinate cgroups or it's not a problem and we might as well
> just see what happens if any old user can do it.

See above. The only restriction I think is necessary is that the process 
can only create subtrees of the current cgroup it is in.

>>> Alternatively, if the desire is fully to virtualize /sys/fs/cgroups
>>> , then I think we have to decide how that would happen.  I think
>>> the default requirements would be that a pid namespace be
>>> established (so only the tasks in that pid namespace would be able
>>> to be controlled by the cgroup namespace.  That, I think requires
>>> that any given cgroup namespace "own" a pid namespace (being the
>>> one present when it was created) but that it only gets a new
>>> virtual set of directories owned by the userns owner if there's a
>>> pid namespace established for the cgroup and cgroup->user_ns ==
>>> pid_ns->user_ns (meaning we established a user ns then a pid one
>>> then a cgroup one, so it's now safe to treat root in the user_ns as
>>> owning the virtualized cgroup directories).
>>
>> I know this is probably a stupid question, but why couldn't we just
>> compare the user_ns with the tcred->user_ns?
>
> If any old user namespace can unshare a cgroup namespace and manipulate
> the tree, then that condition is just fine.  If we're going to require
> they have to create a pid namespace as well, then you need a more
> elaborate condition.

Well, I guess my question was more like "if we don't require the pid 
namespace pinning, what bad things will happen?". You've described the 
corner case, and I'm not sure it's a problem for cgroupv2. It is a 
problem for cgroupv1 (unfortunately), due to backwards compatibility 
reasons. So, we have to decide whether we are going to add a restriction 
for cgroup namespaces, so that this functionality can be implemented for 
both versions -- or should we only implement the minimal version (which 
would only work on cgroupv2).

If we decide to implement both, we have to agree on the restrictions 
*immediately* because the cgroup namespace was merged in 4.6-rc1 so 
changing the restrictions on it in 4.7 would probably be frowned upon.

>>   Or are you worried about a process in a cgroup namespace moving
>> processes to a subtree that isn't in the same pid namespace (even
>> though they're in the same user namespace)?
>
> The corner case I'm worrying about is what happens to a process owned
> by the user that gets moved by the administrator to a more confining
> cgroup after the establishment of the cgroup namespace?  If we allow
> too much capability to the user_ns->owner, then they could just take it
> out again.  The semantics of who can do what after the namespace is
> established seem to need better definition.  One answer might be that
> after the cgroup namespace is established, the real admin can't safely
> move the processes, which is why they should be better confined (say
> within a pid namespace) so it's not *all* processes owned by this user
> that can escape control, merely ones that the user has declared a
> desire to control the cgroups for).

My thinking was that rename(2) would make this a simple decision, but I 
just realised that rename(2) doesn't let you change the hierarchy. But 
it should be noted that cgroupv2 has a fix for this: you can't move a 
task to another cgroup unless you have attach rights (cgroup.procs) to 
the common ancestor of the current cgroup and the target cgroup.

What this means is that you can only "fight the administrator" in the 
case that the admin has decided to move you inside the subtree of the 
cgroup namespace you are in. Itherwise, you can't move back to your old 
cgroup. Of course, it means that the cgroup namespace is now broken -- 
but that's what the admin wanted to do. I don't think that should be a 
problem.

Since this isn't available in cgroupv1, there's a question about whether 
this functionality should be allowed for cgroupv1. Since cgroupv2 still 
doesn't support all of the controllers needed for many container 
runtimes to work, I don't think we should not implement this for 
cgroupv1. But that's just my opinion.

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
