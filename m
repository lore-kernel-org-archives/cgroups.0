From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH] mm: memcontrol: protect the memory in cgroup from being
 oom killed
Date: Thu, 1 Dec 2022 13:44:57 +0100
Message-ID: <Y4ihyRqQzyFFLqh6@dhcp22.suse.cz>
References: <Y4hqlzNeZ6Osu0pI@dhcp22.suse.cz>
 <C2CC36C1-29AE-4B65-A18A-19A745652182@didiglobal.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1669898698; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2usVyVHvq6UpCYGTeYatlo+CIODmj9sJULa7nXifL7I=;
        b=hVlPQZhQULbKSaUOF1Ptr93R7UHM2CFgYMqevAQOi+JuvHhxUFBIvxcFSM2Vh7Djf7zhEL
        dlFAaCNFppiO/tq30A6MzlbBRIYJXya8GMZ+SOvkebJl/TRVMO1i2Tyy8KA1wVap+1o63F
        rrwgJlk321vFBTdqNpCzEqeY/yXhzEU=
Content-Disposition: inline
In-Reply-To: <C2CC36C1-29AE-4B65-A18A-19A745652182@didiglobal.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?56iL5Z6y5rab?= Chengkaitao Cheng <chengkaitao@didiglobal.com>
Cc: Tao pilgrim <pilgrimtao@gmail.com>, "tj@kernel.org" <tj@kernel.org>, "lizefan.x@bytedance.com" <lizefan.x@bytedance.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "corbet@lwn.net" <corbet@lwn.net>, "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>, "shakeelb@google.com" <shakeelb@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "songmuchun@bytedance.com" <songmuchun@bytedance.com>, "cgel.zte@gmail.com" <cgel.zte@gmail.com>, "ran.xiaokai@zte.com.cn" <ran.xiaokai@zte.com.cn>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>

On Thu 01-12-22 10:52:35, 程垲涛 Chengkaitao Cheng wrote:
> At 2022-12-01 16:49:27, "Michal Hocko" <mhocko@suse.com> wrote:
> >On Thu 01-12-22 04:52:27, 程垲涛 Chengkaitao Cheng wrote:
> >> At 2022-12-01 00:27:54, "Michal Hocko" <mhocko@suse.com> wrote:
> >> >On Wed 30-11-22 15:46:19, 程垲涛 Chengkaitao Cheng wrote:
> >> >> On 2022-11-30 21:15:06, "Michal Hocko" <mhocko@suse.com> wrote:
> >> >> > On Wed 30-11-22 15:01:58, chengkaitao wrote:
> >> >> > > From: chengkaitao <pilgrimtao@gmail.com>
> >> >> > >
> >> >> > > We created a new interface <memory.oom.protect> for memory, If there is
> >> >> > > the OOM killer under parent memory cgroup, and the memory usage of a
> >> >> > > child cgroup is within its effective oom.protect boundary, the cgroup's
> >> >> > > tasks won't be OOM killed unless there is no unprotected tasks in other
> >> >> > > children cgroups. It draws on the logic of <memory.min/low> in the
> >> >> > > inheritance relationship.
> >> >> >
> >> >> > Could you be more specific about usecases?
> >> >
> >> >This is a very important question to answer.
> >> 
> >> usecases 1: users say that they want to protect an important process 
> >> with high memory consumption from being killed by the oom in case 
> >> of docker container failure, so as to retain more critical on-site 
> >> information or a self recovery mechanism. At this time, they suggest 
> >> setting the score_adj of this process to -1000, but I don't agree with 
> >> it, because the docker container is not important to other docker 
> >> containers of the same physical machine. If score_adj of the process 
> >> is set to -1000, the probability of oom in other container processes will 
> >> increase.
> >> 
> >> usecases 2: There are many business processes and agent processes 
> >> mixed together on a physical machine, and they need to be classified 
> >> and protected. However, some agents are the parents of business 
> >> processes, and some business processes are the parents of agent 
> >> processes, It will be troublesome to set different score_adj for them. 
> >> Business processes and agents cannot determine which level their 
> >> score_adj should be at, If we create another agent to set all processes's 
> >> score_adj, we have to cycle through all the processes on the physical 
> >> machine regularly, which looks stupid.
> >
> >I do agree that oom_score_adj is far from ideal tool for these usecases.
> >But I also agree with Roman that these could be addressed by an oom
> >killer implementation in the userspace which can have much better
> >tailored policies. OOM protection limits would require tuning and also
> >regular revisions (e.g. memory consumption by any workload might change
> >with different kernel versions) to provide what you are looking for.
> 
> There is a misunderstanding, oom.protect does not replace the user's 
> tailed policies, Its purpose is to make it easier and more efficient for 
> users to customize policies, or try to avoid users completely abandoning 
> the oom score to formulate new policies.

Then you should focus on explaining on how this makes those policies and
easier and moe efficient. I do not see it.

[...]

> >Why cannot you simply discount the protection from all processes
> >equally? I do not follow why the task_usage has to play any role in
> >that.
> 
> If all processes are protected equally, the oom protection of cgroup is 
> meaningless. For example, if there are more processes in the cgroup, 
> the cgroup can protect more mems, it is unfair to cgroups with fewer 
> processes. So we need to keep the total amount of memory that all 
> processes in the cgroup need to protect consistent with the value of 
> eoom.protect.

You are mixing two different concepts together I am afraid. The per
memcg protection should protect the cgroup (i.e. all processes in that
cgroup) while you want it to be also process aware. This results in a
very unclear runtime behavior when a process from a more protected memcg
is selected based on its individual memory usage.
-- 
Michal Hocko
SUSE Labs
