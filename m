From: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Tue, 12 Nov 2013 20:33:24 +0100
Message-ID: <CA+SBX_MWM1iU7kyT5Ct3OJ7S3oMgbz_EWbFH1dGae+r_UnDxOA@mail.gmail.com>
References: <20131031192732.2dbb14b3@gandalf.local.home>
	<CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
	<5277932C.40400@huawei.com>
	<CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
	<5278B3F1.9040502@huawei.com>
	<20131107235301.GB1092@cmpxchg.org>
	<20131108001437.GC1092@cmpxchg.org>
	<CA+SBX_P6wzmb0k0qM1m06C_1024ZTfYZOs0axLBBJm46X+osqA@mail.gmail.com>
	<20131111153943.GA22384@dhcp22.suse.cz>
	<CA+SBX_PiRoL7HU-C_wXHjHYduYrbTjO3i6_OoHOJ_Mq+sMZStg@mail.gmail.com>
	<20131112135844.GA6049@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=O1NRpDLbHm5s+dl3uzqqb/F+/lpG+NWSRbLaPZ+nK8s=;
        b=WjZUmC9JNJCfa0ov0TOCTOxXDfScu4l4a4xwkmdrDngOVRw+nEqoRqv0g7Wf3ddZWr
         5DZbOvBapAV4yQTrrM8fWl5uM9MiWnWJX+LeJqIpPzmOOWVZNoVseHfF1vESgznhHTTV
         uvXM31YeNnC/5yE1lzK11kaYGgyVmXlN2Jq2Yi+3x4C7t4pc5jUGdQ1IteFb6ELx9o7x
         pzooHLZ153w8OMUqNlgVnqhGHcRI8nCHDbOGQQJDy5zrIjKdno9zvwUMDKzA8FWZSf/X
         metyFRZhN/C4jNSnPfwRACoi/OyY2X86wE7YNmLzfIZrGJ2rtqB0v7z4M6nKBCYAwExT
         t5ew==
In-Reply-To: <20131112135844.GA6049-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> No swap means that no charges are done by a group non-member. So the
> race Johannes was describing shouldn't be the problem in your case.
>
> Out of curiosity, do you set any limit for kmem?
>

I did a quick search through the code, but I see nothing related to
kernel memory:
https://github.com/SchedMD/slurm/blob/master/src/plugins/task/cgroup/task_cgroup_memory.c


>> memory.use_hierarchy support is enabled and memory is limited from the
>> job directory. I have mounted the cgroup to /var/slurm/cgroup/memory
>> in addition to the normal directory at /sys/fs/cgroup/memory.
>
> How exactly have you mounted it there?

Slurm has an automount option, which takes care of this. I don't
actually know, why I made this kind of setup. So I will probably
revert back to /sys/fs/cgroup tomorrow.

>
> Btw. how reproducible is this? Do you think you could try to bisect
> it down? Reducing bisection to mm/ and kernel/ diretories should be
> sufficient I guess.

The bug is quite reproducible here .. within a few minutes at most.
Since we have diskless clients with nfsroot and aufs, bisectioning
proved to be a bit difficult (means the kernel compiled and booted but
aufs failed on /etc). But then I have tried bisectioning the whole
kernel sources. Tomorrow, I will first try to test without
CONFIG_MEMCG_SWAP_ENABLED and CONFIG_MEMCG_KMEM, and then give
bisectioning only the two directories another try. Btw. I never saw
this bug before 3.11, but it may well be, that because of some trivial
code change, it became much more likely to trigger.
