From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [External] Re: [PATCH] cgroup/cpuset: Add a new isolated
 mems.policy type.
Date: Tue, 6 Sep 2022 14:33:33 +0200
Message-ID: <Yxc+HZ6rjcR535oN@dhcp22.suse.cz>
References: <20220904040241.1708-1-hezhongkun.hzk@bytedance.com>
 <YxWbBYZKDTrkmlOe@dhcp22.suse.cz>
 <0e5f380b-9201-0f56-9144-ce8449491fc8@bytedance.com>
 <YxXUjvWmZoG9vVNV@dhcp22.suse.cz>
 <ca5e57fd-4699-2cec-b328-3d6bac43c8ef@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662467614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WJ2hDmw9JyVIDJ8sx54ryU/U8R/CYAaL47eDHzs+5iE=;
        b=al1qbdZOXhLv+Fvm/FIs/YRWj8fPc0Y4yzJiuX0pkO8cfK41Y6mVQR84DTVvOLCg+6cz8c
        bBab7jdlicHYdwUBzFcVIdsyPkNIWPrvTEkbJStX/wT9mVKDnGHI9o7TdbRnBk7eC+02LC
        ODvL7sSEOpXak0rE4eYSYaJKDTYTYH4=
Content-Disposition: inline
In-Reply-To: <ca5e57fd-4699-2cec-b328-3d6bac43c8ef-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhongkun He <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On Tue 06-09-22 18:37:40, Zhongkun He wrote:
> > On Mon 05-09-22 18:30:55, Zhongkun He wrote:
> > > Hi Michal, thanks for your reply.
> > > 
> > > The current 'mempolicy' is hierarchically independent. The default value of
> > > the child is to inherit from the parent. The modification of the child
> > > policy will not be restricted by the parent.
> > 
> > This breaks cgroup fundamental property of hierarchical enforcement of
> > each property. And as such it is a no go.
> > 
> > > Of course, there are other options, such as the child's policy mode must be
> > > the same as the parent's. node can be the subset of parent's, but the
> > > interleave type will be complicated, that's why hierarchy independence is
> > > used. It would be better if you have other suggestions?
> > 
> > Honestly, I am not really sure cgroup cpusets is a great fit for this
> > usecase. It would be probably better to elaborate some more what are the
> > existing shortcomings and what you would like to achieve. Just stating
> > the syscall is a hard to use interface is not quite clear on its own.
> > 
> > Btw. have you noticed this question?
> > 
> > > > What is the hierarchical behavior of the policy? Say parent has a
> > > > stronger requirement (say bind) than a child (prefer)?
> > > > > How to use the mempolicy interface:
> > > > > 	echo prefer:2 > /sys/fs/cgroup/zz/cpuset.mems.policy
> > > > > 	echo bind:1-3 > /sys/fs/cgroup/zz/cpuset.mems.policy
> > > > >           echo interleave:0,1,2,3 >/sys/fs/cgroup/zz/cpuset.mems.policy
> > > > 
> > > > Am I just confused or did you really mean to combine all these
> > > > together?
> > 
> 
> Hi Michal, thanks for your reply.
> 
> >>Say parent has a stronger requirement (say bind) than a child(prefer)?
> 
> Yes, combine all these together.

What is the semantic of the resulting policy?

> The parent's task will use 'bind', child's
> use 'prefer'.This is the current implementation, and we can discuss and
> modify it together if there are other suggestions.
>
> 1:Existing shortcomings
> 
> In our use case, the application and the control plane are two separate
> systems. When the application is created, it doesn't know how to use memory,
> and it doesn't care. The control plane will decide the memory usage policy
> based on different reasons (the attributes of the application itself, the
> priority, the remaining resources of the system). Currently, numactl is used
> to set it at program startup, and the child process will inherit the
> mempolicy.

Yes this is common practice I have seen so far.

> But we can't dynamically adjust the memory policy, except
> restart, the memory policy will not change.

Do you really need to change the policy itself or only the effective
nodemask? I mean what is your usecase to go from say mbind to preferred
policy?  Do you need any other policy than bind and preferred?
 
> 2:Our goals
> 
> For the above reasons, we want to create a mempolicy at the cgroup level.
> Usually processes under a cgroup have the same priority and attributes, and
> we can dynamically adjust the memory allocation strategy according to the
> remaining resources of the system. For example, a low-priority cgroup uses
> the 'bind:2-3' policy, and a high-priority cgroup uses bind:0-1. When
> resources are insufficient, it will be changed to bind:3, bind:0-2 by
> control plane, etc.Further more, more mempolicy can be extended, such as
> allocating memory according to node weight, etc.

Yes, I do understand that you want to change the node affinity and that
is already possible with cpuset cgroup. The existing constrain is that
the policy is hardcoded mbind IIRC. So you cannot really implement a dynamic
preferred policy which would make some sense to me. The question is how
to implement that with a sensible semantic. It is hard to partition the
system into several cgroups if subset allows to spill over to others.
Say something like the following
	root (nodes=0-3)
       /    \
A (0, 1)     B (2, 3)

if both are MBIND then this makes sense because they are kinda isolated
(at least for user allocations) but if B is PREFERRED and therefore
allowed to use nodes 0 and 1 then it can deplete the memory from A and
therefore isolation doesn't work at all.

I can imagine that the all cgroups would use PREFERRED policy and then
nobody can expect anything and the configuration is mostly best effort.
But it feels like this is an abuse of the cgroup interface and a proper
syscall interface is likely due. Would it make more sense to add
pidfd_set_mempolicy and allow sufficiently privileged process to
manipulate default memory policy of a remote process?
-- 
Michal Hocko
SUSE Labs
