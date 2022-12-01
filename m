From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH] mm: memcontrol: protect the memory in cgroup from being
 oom killed
Date: Thu, 1 Dec 2022 14:08:26 +0100
Message-ID: <Y4inSsNpmomzRt8J@dhcp22.suse.cz>
References: <Y4hqlzNeZ6Osu0pI@dhcp22.suse.cz>
 <C2CC36C1-29AE-4B65-A18A-19A745652182@didiglobal.com>
 <Y4ihyRqQzyFFLqh6@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1669900106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K/3E4rKV56hZO1ZYVzKhSOwwyXDyBi7M71us9jjagdo=;
        b=ZC25gQgYpHLJv3sUQUpw833y1NbAm84Kj96hRcqLaxWPqonFdDKoAEQwY8o+h5Urr4f/94
        sYhbrouqe8Sz2mT73RyW2KuWQ0ZQZVfQyN3N+lHgNLROGt3f2Q2frfuTwFrG8knt0CulCG
        XireW5USxtH4hjxIvL59nH4fLlaqq3M=
Content-Disposition: inline
In-Reply-To: <Y4ihyRqQzyFFLqh6@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?56iL5Z6y5rab?= Chengkaitao Cheng <chengkaitao@didiglobal.com>
Cc: Tao pilgrim <pilgrimtao@gmail.com>, "tj@kernel.org" <tj@kernel.org>, "lizefan.x@bytedance.com" <lizefan.x@bytedance.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "corbet@lwn.net" <corbet@lwn.net>, "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>, "shakeelb@google.com" <shakeelb@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "songmuchun@bytedance.com" <songmuchun@bytedance.com>, "cgel.zte@gmail.com" <cgel.zte@gmail.com>, "ran.xiaokai@zte.com.cn" <ran.xiaokai@zte.com.cn>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>

On Thu 01-12-22 13:44:58, Michal Hocko wrote:
> On Thu 01-12-22 10:52:35, 程垲涛 Chengkaitao Cheng wrote:
> > At 2022-12-01 16:49:27, "Michal Hocko" <mhocko@suse.com> wrote:
[...]
> > >Why cannot you simply discount the protection from all processes
> > >equally? I do not follow why the task_usage has to play any role in
> > >that.
> > 
> > If all processes are protected equally, the oom protection of cgroup is 
> > meaningless. For example, if there are more processes in the cgroup, 
> > the cgroup can protect more mems, it is unfair to cgroups with fewer 
> > processes. So we need to keep the total amount of memory that all 
> > processes in the cgroup need to protect consistent with the value of 
> > eoom.protect.
> 
> You are mixing two different concepts together I am afraid. The per
> memcg protection should protect the cgroup (i.e. all processes in that
> cgroup) while you want it to be also process aware. This results in a
> very unclear runtime behavior when a process from a more protected memcg
> is selected based on its individual memory usage.

Let me be more specific here. Although it is primarily processes which
are the primary source of memcg charges the memory accounted for the oom
badness purposes is not really comparable to the overal memcg charged
memory. Kernel memory, non-mapped memory all that can generate rather
interesting cornercases.
-- 
Michal Hocko
SUSE Labs
