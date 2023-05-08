From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 0/2] memcontrol: support cgroup level OOM protection
Date: Mon, 8 May 2023 16:18:18 +0200
Message-ID: <ZFkEqhAs7FELUO3a@dhcp22.suse.cz>
References: <ZFd5bpfYc3nPEVie@dhcp22.suse.cz>
 <66F9BB37-3BE1-4B0F-8DE1-97085AF4BED2@didiglobal.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1683555501; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T5lxbwwkgegSAFfxW6WBB5ZioSoqo06SKF1oFOPKNV8=;
        b=QhPg/7/l3dn9YKEJHp+3Q9S5X4xDGjO+PMTw/QsUjMM5aiqIPpw1tOTBO51QZq0HVoSdEw
        XRMjUh4ZbrAfZwJtYwbR+BdrEwzZ3mP3mFuiRXIL+Xh2XJOl7qHAwIHPva/nveawIJQKvO
        D197PO+w12kXlGQIT7W+lD0s4MeOXkY=
Content-Disposition: inline
In-Reply-To: <66F9BB37-3BE1-4B0F-8DE1-97085AF4BED2@didiglobal.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?56iL5Z6y5rab?= Chengkaitao Cheng <chengkaitao@didiglobal.com>
Cc: "tj@kernel.org" <tj@kernel.org>, "lizefan.x@bytedance.com" <lizefan.x@bytedance.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "corbet@lwn.net" <corbet@lwn.net>, "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>, "shakeelb@google.com" <shakeelb@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "brauner@kernel.org" <brauner@kernel.org>, "muchun.song@linux.dev" <muchun.song@linux.dev>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>, "pilgrimtao@gmail.com" <pilgrimtao@gmail.com>, "haolee.swjtu@gmail.com" <haolee.swjtu@gmail.com>

On Mon 08-05-23 09:08:25, 程垲涛 Chengkaitao Cheng wrote:
> At 2023-05-07 18:11:58, "Michal Hocko" <mhocko@suse.com> wrote:
> >On Sat 06-05-23 19:49:46, chengkaitao wrote:
> >> Establish a new OOM score algorithm, supports the cgroup level OOM
> >> protection mechanism. When an global/memcg oom event occurs, we treat
> >> all processes in the cgroup as a whole, and OOM killers need to select
> >> the process to kill based on the protection quota of the cgroup
> >
> >Although your patch 1 briefly touches on some advantages of this
> >interface there is a lack of actual usecase. Arguing that oom_score_adj
> >is hard because it needs a parent process is rather weak to be honest.
> >It is just trivial to create a thin wrapper, use systemd to launch
> >important services or simply update the value after the fact. Now
> >oom_score_adj has its own downsides of course (most notably a
> >granularity and a lack of group protection.
> >
> >That being said, make sure you describe your usecase more thoroughly.
> >Please also make sure you describe the intended heuristic of the knob.
> >It is not really clear from the description how this fits hierarchical
> >behavior of cgroups. I would be especially interested in the semantics
> >of non-leaf memcgs protection as they do not have any actual processes
> >to protect.
> >
> >Also there have been concerns mentioned in v2 discussion and it would be
> >really appreciated to summarize how you have dealt with them.
> >
> >Please also note that many people are going to be slow in responding
> >this week because of LSFMM conference
> >(https://events.linuxfoundation.org/lsfmm/)
> 
> Here is a more detailed comparison and introduction of the old oom_score_adj
> mechanism and the new oom_protect mechanism,
> 1. The regulating granularity of oom_protect is smaller than that of oom_score_adj.
> On a 512G physical machine, the minimum granularity adjusted by oom_score_adj
> is 512M, and the minimum granularity adjusted by oom_protect is one page (4K).
> 2. It may be simple to create a lightweight parent process and uniformly set the 
> oom_score_adj of some important processes, but it is not a simple matter to make 
> multi-level settings for tens of thousands of processes on the physical machine 
> through the lightweight parent processes. We may need a huge table to record the 
> value of oom_score_adj maintained by all lightweight parent processes, and the 
> user process limited by the parent process has no ability to change its own 
> oom_score_adj, because it does not know the details of the huge table. The new 
> patch adopts the cgroup mechanism. It does not need any parent process to manage 
> oom_score_adj. the settings between each memcg are independent of each other, 
> making it easier to plan the OOM order of all processes. Due to the unique nature 
> of memory resources, current Service cloud vendors are not oversold in memory 
> planning. I would like to use the new patch to try to achieve the possibility of 
> oversold memory resources.

OK, this is more specific about the usecase. Thanks! So essentially what
it boils down to is that you are handling many containers (memcgs from
our POV) and they have different priorities. You want to overcommit the
memory to the extend that global ooms are not an unexpected event. Once
that happens the total memory consumption of a specific memcg is less
important than its "priority". You define that priority by the excess of
the memory usage above a user defined threshold. Correct?

Your cover letter mentions that then "all processes in the cgroup as a
whole". That to me reads as oom.group oom killer policy. But a brief
look into the patch suggests you are still looking at specific tasks and
this has been a concern in the previous version of the patch because
memcg accounting and per-process accounting are detached.

> 3. I conducted a test and deployed an excessive number of containers on a physical 
> machine, By setting the oom_score_adj value of all processes in the container to 
> a positive number through dockerinit, even processes that occupy very little memory 
> in the container are easily killed, resulting in a large number of invalid kill behaviors. 
> If dockerinit is also killed unfortunately, it will trigger container self-healing, and the 
> container will rebuild, resulting in more severe memory oscillations. The new patch 
> abandons the behavior of adding an equal amount of oom_score_adj to each process 
> in the container and adopts a shared oom_protect quota for all processes in the container. 
> If a process in the container is killed, the remaining other processes will receive more 
> oom_protect quota, making it more difficult for the remaining processes to be killed.
> In my test case, the new patch reduced the number of invalid kill behaviors by 70%.
> 4. oom_score_adj is a global configuration that cannot achieve a kill order that only 
> affects a certain memcg-oom-killer. However, the oom_protect mechanism inherits 
> downwards, and user can only change the kill order of its own memcg oom, but the 
> kill order of their parent memcg-oom-killer or global-oom-killer will not be affected

Yes oom_score_adj has shortcomings.

> In the final discussion of patch v2, we discussed that although the adjustment range 
> of oom_score_adj is [-1000,1000], but essentially it only allows two usecases
> (OOM_SCORE_ADJ_MIN, OOM_SCORE_ADJ_MAX) reliably. Everything in between is 
> clumsy at best. In order to solve this problem in the new patch, I introduced a new 
> indicator oom_kill_inherit, which counts the number of times the local and child 
> cgroups have been selected by the OOM killer of the ancestor cgroup. By observing 
> the proportion of oom_kill_inherit in the parent cgroup, I can effectively adjust the 
> value of oom_protect to achieve the best.

What does the best mean in this context?

> about the semantics of non-leaf memcgs protection,
> If a non-leaf memcg's oom_protect quota is set, its leaf memcg will proportionally 
> calculate the new effective oom_protect quota based on non-leaf memcg's quota.

So the non-leaf memcg is never used as a target? What if the workload is
distributed over several sub-groups? Our current oom.group
implementation traverses the tree to find a common ancestor in the oom
domain with the oom.group.

All that being said and with the usecase described more specifically. I
can see that memcg based oom victim selection makes some sense. That
menas that it is always a memcg selected and all tasks withing killed.
Memcg based protection can be used to evaluate which memcg to choose and
the overall scheme should be still manageable. It would indeed resemble
memory protection for the regular reclaim.

One thing that is still not really clear to me is to how group vs.
non-group ooms could be handled gracefully. Right now we can handle that
because the oom selection is still process based but with the protection
this will become more problematic as explained previously. Essentially
we would need to enforce the oom selection to be memcg based for all
memcgs. Maybe a mount knob? What do you think?
-- 
Michal Hocko
SUSE Labs
