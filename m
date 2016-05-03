From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: allow management of subtrees by new cgroup
 namespaces
Date: Tue, 3 May 2016 11:59:25 +1000
Message-ID: <572805FD.9080202@suse.de>
References: <1462110065-4904-1-git-send-email-asarai@suse.de>
 <1462110065-4904-2-git-send-email-asarai@suse.de>
 <1462226406.3036.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462226406.3036.17.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

>> Change the mode of the cgroup directory for each cgroup association,
>> allowing the process to create subtrees and modify the limits of the
>> subtrees *without* allowing the process to modify its own limits. Due
>> to the cgroup core restrictions and unix permission model, this
>> allows for processes to create new subtrees without breaking the
>> cgroup limits for the process.
>
> Actually, that's not really what this patch does.  If you unshare
> without having created any cgroups, it sets the other permission of the
> entire top level hierarchy to o+rwx:

While that is odd, it makes sense (because that's the "current cgroup" 
you are in). But I agree with your point that this patch is less than ideal.

> ironically, this now makes the root group a permission denier (at least
> for my distribution), because if I were in the root group (and not
> root), the r-x on the group would rule the rwx on other ... I really
> don't think that sounds correct.

You're right, that's odd. I'm confused why your root cgroups have u-w 
though.

>
> Perhaps what you should to be arguing then that the default permissions
> of the cgroup directories need to be all rwx for everyone and then your
> patch becomes unnecessary?

I don't think that would be the nicest way of dealing with this (then a 
process can make very large numbers of cgroups all over the tree, which 
might not cause huge issues but would still be a pain for administrators 
and systemds alike).

> Alternatively, if the desire is fully to virtualize /sys/fs/cgroups,
> then I think we have to decide how that would happen.  I think the
> default requirements would be that a pid namespace be established (so
> only the tasks in that pid namespace would be able to be controlled by
> the cgroup namespace.  That, I think requires that any given cgroup
> namespace "own" a pid namespace (being the one present when it was
> created) but that it only gets a new virtual set of directories owned
> by the userns owner if there's a pid namespace established for the
> cgroup and cgroup->user_ns == pid_ns->user_ns (meaning we established a
> user ns then a pid one then a cgroup one, so it's now safe to treat
> root in the user_ns as owning the virtualized cgroup directories).

I know this is probably a stupid question, but why couldn't we just 
compare the user_ns with the tcred->user_ns? Or are you worried about a 
process in a cgroup namespace moving processes to a subtree that isn't 
in the same pid namespace (even though they're in the same user 
namespace)? I don't mind implementing that this way (although we'd have 
to change a bunch of the checks with pid_ns to use the 
cgroup_ns->pid_ns), I'm just wondering if it's necessary.

> We could do this in the same way that proc gets virtualized after
> remounting (in a new mount namespace) on fork into a pid namespace.

I actually really like this idea. I'll get to work on it.

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
