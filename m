From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [External] Re: [PATCH] cgroup/cpuset: Add a new isolated
 mems.policy type.
Date: Thu, 8 Sep 2022 09:19:20 +0200
Message-ID: <YxmXeC7te2HAi4dX@dhcp22.suse.cz>
References: <20220904040241.1708-1-hezhongkun.hzk@bytedance.com>
 <YxWbBYZKDTrkmlOe@dhcp22.suse.cz>
 <0e5f380b-9201-0f56-9144-ce8449491fc8@bytedance.com>
 <YxXUjvWmZoG9vVNV@dhcp22.suse.cz>
 <ca5e57fd-4699-2cec-b328-3d6bac43c8ef@bytedance.com>
 <Yxc+HZ6rjcR535oN@dhcp22.suse.cz>
 <93d76370-6c43-5560-9a5f-f76a8cc979e0@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662621560; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yklmv2ux9aHaYIhutjyFigStqNyf61xsI5qM8T+Pp2M=;
        b=XsPHwzskZaYb147v91HjRFvXSb84ItKrVKY4TdypktvPUCZ2ermxWVd6wuWWBL62hWeknq
        6NcmpS4lfkIA6SlBKqpvEw22impF8ik4Ke/ZnscUqU7zWcM3fgHpS+TuB6ok1QrNv/Ppp5
        kt5N85b5OZvoxs/3u369Z0s2CX7Fv+g=
Content-Disposition: inline
In-Reply-To: <93d76370-6c43-5560-9a5f-f76a8cc979e0-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Zhongkun He <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On Wed 07-09-22 21:50:24, Zhongkun He wrote:
[...]
> > Do you really need to change the policy itself or only the effective
> > nodemask? Do you need any other policy than bind and preferred?
> 
> Yes, we need to change the policy, not only his nodemask. we really want
> policy is interleave, and extend it to weight-interleave.
> Say something like the following
> 			node       weight
>     interleave:		 0-3       1:1:1:1  default one by one
>     weight-interleave:   0-3       1:2:4:6  alloc pages by weight
> 					    (User set weight.)
> In the actual usecase, the remaining resources of each node are different,
> and the use of interleave cannot maximize the use of resources.

OK, this seems a separate topic. It would be good to start by proposing
that new policy in isolation with the semantic description.

> Back to the previous question.
> >The question is how to implement that with a sensible semantic.
> 
> Thanks for your analysis and suggestions.It is really difficult to add
> policy directly to cgroup for the hierarchical enforcement. It would be a
> good idea to add pidfd_set_mempolicy.

Are you going to pursue that path?
 
> Also, there is a new idea.
> We can try to separate the elements of mempolicy and use them independently.
> Mempolicy has two meanings:
>     nodes:which nodes to use(nodes,0-3), we can use cpuset's effective_mems
> directly.
>     mode:how to use them(bind,prefer,etc). change the mode to a
> cpuset->flags,such as CS_INTERLEAVE。
> task_struct->mems_allowed is equal to cpuset->effective_mems,which is
> hierarchical enforcement。CS_INTERLEAVE can also be updated into tasks，
> just like other flags(CS_SPREAD_PAGE).
> When a process needs to allocate memory, it can find the appropriate node to
> allocate pages according to the flag and mems_allowed.

I am not sure I see the advantage as the mode and nodes are always
closely coupled. You cannot really have one wihtout the other.

-- 
Michal Hocko
SUSE Labs
