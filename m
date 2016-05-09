From: Aleksa Sarai <asarai@suse.de>
Subject: Re: [PATCH v3 2/2] cgroup: allow management of subtrees by new cgroup
 namespaces
Date: Tue, 10 May 2016 00:04:05 +1000
Message-ID: <573098D5.3070109@suse.de>
References: <1462197681-6879-1-git-send-email-asarai@suse.de>
 <1462197681-6879-3-git-send-email-asarai@suse.de>
 <20160502160604.GR7822@mtj.duckdns.org> <57280456.1090106@suse.de>
 <20160503155511.GA7110@mtj.duckdns.org> <5729C7C2.8000205@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5729C7C2.8000205@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, dev@opencontainers.org, Aleksa Sarai <cyphar@cyphar.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

>>> However, I agree with James that this patchset isn't ideal (it was my
>>> first
>>> rough attempt). I think I'll get to work on properly virtualising
>>> /sys/fs/cgroup, which will allow for a new cgroup namespace to modify
>>> subtrees (but without allowing for cgroup escape) -- by pinning what pid
>>> namespace the cgroup was created under. We can use the same type of
>>> virtualization that /proc does (except instead of selectively showing
>>> the
>>> dentries, we selectively show different owners of the dentries).
>>>
>>> Would that be acceptable?
>>
>> I'm still not sold on the idea.  For better or worse, the permission
>> model is mostly based on vfs and I don't want to deviate too much as
>> that's likely to become confusing pretty quickly.  If a sub-hierarchy
>> is to be delegated, that's upto whomever is controlling cgroup
>> hierarchy in the sub-domain.  We can expand the perm checks to
>> consider user namespaces but I'd like to avoid going beyond that.
>
> As I mentioned in the other thread, I had another idea for a way to do
> this (that was more complicated to implement, so I went with this
> simpler patch first):
>
> On unshare(), we create a new cgroup that is a child of the calling
> process's current cgroup association (in all of the hierarchies,
> obviously). The new cgroup directory (and contained files) are owned by
> current_fs_{u,g}id(). The process is then moved into the cgroup, and the
> root of the cgroup namespace is changed to be that cgroup. This way,
> there would be no disparity between the VFS and cgroup permission model
> -- there'll be a global view of the cgroup hierarchy that everyone
> agrees on.
>
> I had three concerns with this patch:
>
> 1. It would cause issues with the no internal process constraint of
> cgroupv2. I spent some time trying to figure out how cgroupv2 would act
> in this case (do all of the processes automatically get moved into new
> subdirectories?), but couldn't figure it out. If it does move all of the
> processes into the subdirectory, we'd have to make a sink cgroup as well
> as the one for the namespace -- which then just becomes inefficient (you
> have a cgroup that has no purpose from an administration perspective).
>
> 2. We'd have to come up with a way to make the name of the new cgroup
> resistent to clashes (especially with cgroups already created by other
> processes), which smacks of a suboptimal solution to the problem.
>
> 3. We'd be creating cgroups and attaching processes to the cgroups
> without explicitly going through the VFS layer. This presumably means
> that other parts of userspace might not get alerted properly to the
> changes. I'm not really sure how we should deal with that, but it sounds
> like it could cause problems for someone.

Does anyone have any opinions on this idea?

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
