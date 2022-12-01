From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH] mm: memcontrol: protect the memory in cgroup from being
 oom killed
Date: Thu, 1 Dec 2022 16:17:49 +0100
Message-ID: <Y4jFnY7kMdB8ReSW@dhcp22.suse.cz>
References: <Y4inSsNpmomzRt8J@dhcp22.suse.cz>
 <C9FFF5A4-B883-4C0D-A802-D94080D6C3A4@didiglobal.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1669907870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nXlkWC2x3jCBLbFSc4SzlcbQGp8MHx6uDp5av6z1mNo=;
        b=k30ixjE6LqemmfsFV0Zse9FQiuesSQnFgGvweadjcr1aagroTOCG5WHwVwJFGEfGusCFCf
        KW2BoWfpyl09bC/FfJrhxJiI1euhcu0Y3ghwo3YfXLLX4Fou04MqnJwgyeq+bFLrnwfWaS
        682upUE6Tr9AOU9BINm3McZE+5sMDig=
Content-Disposition: inline
In-Reply-To: <C9FFF5A4-B883-4C0D-A802-D94080D6C3A4@didiglobal.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?56iL5Z6y5rab?= Chengkaitao Cheng <chengkaitao@didiglobal.com>
Cc: Tao pilgrim <pilgrimtao@gmail.com>, "tj@kernel.org" <tj@kernel.org>, "lizefan.x@bytedance.com" <lizefan.x@bytedance.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "corbet@lwn.net" <corbet@lwn.net>, "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>, "shakeelb@google.com" <shakeelb@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "songmuchun@bytedance.com" <songmuchun@bytedance.com>, "cgel.zte@gmail.com" <cgel.zte@gmail.com>, "ran.xiaokai@zte.com.cn" <ran.xiaokai@zte.com.cn>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>

On Thu 01-12-22 14:30:11, 程垲涛 Chengkaitao Cheng wrote:
> At 2022-12-01 21:08:26, "Michal Hocko" <mhocko@suse.com> wrote:
> >On Thu 01-12-22 13:44:58, Michal Hocko wrote:
> >> On Thu 01-12-22 10:52:35, 程垲涛 Chengkaitao Cheng wrote:
> >> > At 2022-12-01 16:49:27, "Michal Hocko" <mhocko@suse.com> wrote:
> >[...]
> >> There is a misunderstanding, oom.protect does not replace the user's 
> >> tailed policies, Its purpose is to make it easier and more efficient for 
> >> users to customize policies, or try to avoid users completely abandoning 
> >> the oom score to formulate new policies.
> >
> > Then you should focus on explaining on how this makes those policies and
> > easier and moe efficient. I do not see it.
> 
> In fact, there are some relevant contents in the previous chat records. 
> If oom.protect is applied, it will have the following benefits
> 1. Users only need to focus on the management of the local cgroup, not the 
> impact on other users' cgroups.

Protection based balancing cannot really work in an isolation.

> 2. Users and system do not need to spend extra time on complicated and 
> repeated scanning and configuration. They just need to configure the 
> oom.protect of specific cgroups, which is a one-time task

This will not work same way as the memory reclaim protection cannot work
in an isolation on the memcg level.

> >> > >Why cannot you simply discount the protection from all processes
> >> > >equally? I do not follow why the task_usage has to play any role in
> >> > >that.
> >> > 
> >> > If all processes are protected equally, the oom protection of cgroup is 
> >> > meaningless. For example, if there are more processes in the cgroup, 
> >> > the cgroup can protect more mems, it is unfair to cgroups with fewer 
> >> > processes. So we need to keep the total amount of memory that all 
> >> > processes in the cgroup need to protect consistent with the value of 
> >> > eoom.protect.
> >> 
> >> You are mixing two different concepts together I am afraid. The per
> >> memcg protection should protect the cgroup (i.e. all processes in that
> >> cgroup) while you want it to be also process aware. This results in a
> >> very unclear runtime behavior when a process from a more protected memcg
> >> is selected based on its individual memory usage.
> >
> The correct statement here should be that each memcg protection should 
> protect the number of mems specified by the oom.protect. For example, 
> a cgroup's usage is 6G, and it's oom.protect is 2G, when an oom killer occurs, 
> In the worst case, we will only reduce the memory used by this cgroup to 2G 
> through the om killer.

I do not see how that could be guaranteed. Please keep in mind that a
non-trivial amount of memory resources could be completely independent
on any process life time (just consider tmpfs as a trivial example).

> >Let me be more specific here. Although it is primarily processes which
> >are the primary source of memcg charges the memory accounted for the oom
> >badness purposes is not really comparable to the overal memcg charged
> >memory. Kernel memory, non-mapped memory all that can generate rather
> >interesting cornercases.
> 
> Sorry, I'm thoughtless enough about some special memory statistics. I will fix 
> it in the next version

Let me just emphasise that we are talking about fundamental disconnect.
Rss based accounting has been used for the OOM killer selection because
the memory gets unmapped and _potentially_ freed when the process goes
away. Memcg changes are bound to the object life time and as said in
many cases there is no direct relation with any process life time.

Hope that clarifies.
-- 
Michal Hocko
SUSE Labs
