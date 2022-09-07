From: Zhongkun He <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] cgroup/cpuset: Add a new isolated
 mems.policy type.
Date: Wed, 7 Sep 2022 21:50:24 +0800
Message-ID: <93d76370-6c43-5560-9a5f-f76a8cc979e0@bytedance.com>
References: <20220904040241.1708-1-hezhongkun.hzk@bytedance.com>
 <YxWbBYZKDTrkmlOe@dhcp22.suse.cz>
 <0e5f380b-9201-0f56-9144-ce8449491fc8@bytedance.com>
 <YxXUjvWmZoG9vVNV@dhcp22.suse.cz>
 <ca5e57fd-4699-2cec-b328-3d6bac43c8ef@bytedance.com>
 <Yxc+HZ6rjcR535oN@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=MgiF2QhoVH7izaAC6v9HdSeip3/dnqOw2S5EnYEL7zk=;
        b=tyBysNtakVLwLosd6NM/vK1CqUudzQqZPlC72cw1rfa2hg2wgZvjK0mTMetrBlukH7
         tZb+67+N/zPM5Tmb+bOM1Sykm7wQgEVgj8BUBD8vCGwxoSYiRU/hUjveit3Ud+/2bmBC
         ZR7Ssg78La9RTA7wxRojAleaPa7l0715zdhc2pbBLmjwJTFUPto3Fv10Vvy6GhelSdFG
         A+8ZMtgwXszLUMihVXzN7kstNCgHJEzSn/Aw+XPw44wzu6MDLjAWgNOu8Ej6gsuX4eOm
         RTYQun6Tw78tSBtvWIMsySt1k72KvjHw8OpB3O1h7WMhOXb/pDiZ/L+kDny2Jt3KubrT
         H/GQ==
In-Reply-To: <Yxc+HZ6rjcR535oN-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

>> Hi Michal, thanks for your reply.
>>
>>>> Say parent has a stronger requirement (say bind) than a child(prefer)?
>>
>> Yes, combine all these together.
> 
> What is the semantic of the resulting policy?
> 
>> The parent's task will use 'bind', child's
>> use 'prefer'.This is the current implementation, and we can discuss and
>> modify it together if there are other suggestions.
>>
>> 1:Existing shortcomings
>>
>> In our use case, the application and the control plane are two separate
>> systems. When the application is created, it doesn't know how to use memory,
>> and it doesn't care. The control plane will decide the memory usage policy
>> based on different reasons (the attributes of the application itself, the
>> priority, the remaining resources of the system). Currently, numactl is used
>> to set it at program startup, and the child process will inherit the
>> mempolicy.
> 
> Yes this is common practice I have seen so far.
> 
>> But we can't dynamically adjust the memory policy, except
>> restart, the memory policy will not change.
> 
> Do you really need to change the policy itself or only the effective
> nodemask? I mean what is your usecase to go from say mbind to preferred
> policy?  Do you need any other policy than bind and preferred?
>   
>> 2:Our goals
>>
>> For the above reasons, we want to create a mempolicy at the cgroup level.
>> Usually processes under a cgroup have the same priority and attributes, and
>> we can dynamically adjust the memory allocation strategy according to the
>> remaining resources of the system. For example, a low-priority cgroup uses
>> the 'bind:2-3' policy, and a high-priority cgroup uses bind:0-1. When
>> resources are insufficient, it will be changed to bind:3, bind:0-2 by
>> control plane, etc.Further more, more mempolicy can be extended, such as
>> allocating memory according to node weight, etc.
> 
> Yes, I do understand that you want to change the node affinity and that
> is already possible with cpuset cgroup. The existing constrain is that
> the policy is hardcoded mbind IIRC. So you cannot really implement a dynamic
> preferred policy which would make some sense to me. The question is how
> to implement that with a sensible semantic. It is hard to partition the
> system into several cgroups if subset allows to spill over to others.
> Say something like the following
> 	root (nodes=0-3)
>         /    \
> A (0, 1)     B (2, 3)
> 
> if both are MBIND then this makes sense because they are kinda isolated
> (at least for user allocations) but if B is PREFERRED and therefore
> allowed to use nodes 0 and 1 then it can deplete the memory from A and
> therefore isolation doesn't work at all.
> 
> I can imagine that the all cgroups would use PREFERRED policy and then
> nobody can expect anything and the configuration is mostly best effort.
> But it feels like this is an abuse of the cgroup interface and a proper
> syscall interface is likely due. Would it make more sense to add
> pidfd_set_mempolicy and allow sufficiently privileged process to
> manipulate default memory policy of a remote process?

Hi Michal, thanks for your reply.

 > Do you really need to change the policy itself or only the effective
 > nodemask? Do you need any other policy than bind and preferred?

Yes, we need to change the policy, not only his nodemask. we really want 
policy is interleave, and extend it to weight-interleave.
Say something like the following
			node       weight
     interleave:		 0-3       1:1:1:1  default one by one
     weight-interleave:   0-3       1:2:4:6  alloc pages by weight
					    (User set weight.)
In the actual usecase, the remaining resources of each node are 
different, and the use of interleave cannot maximize the use of resources.

Back to the previous question.
 >The question is how to implement that with a sensible semantic.

Thanks for your analysis and suggestions.It is really difficult to add 
policy directly to cgroup for the hierarchical enforcement. It would be 
a good idea to add pidfd_set_mempolicy.

Also, there is a new idea.
We can try to separate the elements of mempolicy and use them independently.
Mempolicy has two meanings:
     nodes:which nodes to use(nodes,0-3), we can use cpuset's 
effective_mems directly.
     mode:how to use them(bind,prefer,etc). change the mode to a 
cpuset->flags,such as CS_INTERLEAVE。
task_struct->mems_allowed is equal to cpuset->effective_mems,which is 
hierarchical enforcement。CS_INTERLEAVE can also be updated into tasks， 
just like other flags(CS_SPREAD_PAGE).
When a process needs to allocate memory, it can find the appropriate 
node to allocate pages according to the flag and mems_allowed.

thanks.



