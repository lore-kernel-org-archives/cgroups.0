From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v3 2/2] cgroup: allow management of subtrees by new cgroup
 namespaces
Date: Wed, 4 May 2016 19:58:26 +1000
Message-ID: <5729C7C2.8000205@suse.de>
References: <1462197681-6879-1-git-send-email-asarai@suse.de>
 <1462197681-6879-3-git-send-email-asarai@suse.de>
 <20160502160604.GR7822@mtj.duckdns.org> <57280456.1090106@suse.de>
 <20160503155511.GA7110@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160503155511.GA7110-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

>> However, I agree with James that this patchset isn't ideal (it was my first
>> rough attempt). I think I'll get to work on properly virtualising
>> /sys/fs/cgroup, which will allow for a new cgroup namespace to modify
>> subtrees (but without allowing for cgroup escape) -- by pinning what pid
>> namespace the cgroup was created under. We can use the same type of
>> virtualization that /proc does (except instead of selectively showing the
>> dentries, we selectively show different owners of the dentries).
>>
>> Would that be acceptable?
>
> I'm still not sold on the idea.  For better or worse, the permission
> model is mostly based on vfs and I don't want to deviate too much as
> that's likely to become confusing pretty quickly.  If a sub-hierarchy
> is to be delegated, that's upto whomever is controlling cgroup
> hierarchy in the sub-domain.  We can expand the perm checks to
> consider user namespaces but I'd like to avoid going beyond that.

As I mentioned in the other thread, I had another idea for a way to do 
this (that was more complicated to implement, so I went with this 
simpler patch first):

On unshare(), we create a new cgroup that is a child of the calling 
process's current cgroup association (in all of the hierarchies, 
obviously). The new cgroup directory (and contained files) are owned by 
current_fs_{u,g}id(). The process is then moved into the cgroup, and the 
root of the cgroup namespace is changed to be that cgroup. This way, 
there would be no disparity between the VFS and cgroup permission model 
-- there'll be a global view of the cgroup hierarchy that everyone 
agrees on.

I had three concerns with this patch:

1. It would cause issues with the no internal process constraint of 
cgroupv2. I spent some time trying to figure out how cgroupv2 would act 
in this case (do all of the processes automatically get moved into new 
subdirectories?), but couldn't figure it out. If it does move all of the 
processes into the subdirectory, we'd have to make a sink cgroup as well 
as the one for the namespace -- which then just becomes inefficient (you 
have a cgroup that has no purpose from an administration perspective).

2. We'd have to come up with a way to make the name of the new cgroup 
resistent to clashes (especially with cgroups already created by other 
processes), which smacks of a suboptimal solution to the problem.

3. We'd be creating cgroups and attaching processes to the cgroups 
without explicitly going through the VFS layer. This presumably means 
that other parts of userspace might not get alerted properly to the 
changes. I'm not really sure how we should deal with that, but it sounds 
like it could cause problems for someone.

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
