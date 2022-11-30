From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] mm: memcontrol: protect the memory in cgroup from being
 oom killed
Date: Wed, 30 Nov 2022 15:29:11 -0800
Message-ID: <Y4fnRyIp17NXpti9@P9FQF9L96D.corp.robot.car>
References: <20221130070158.44221-1-chengkaitao@didiglobal.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669850971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tLdcW8YLuJNMoWtBITi5oNMUbS4UvnO6BlVvWMG2nYE=;
        b=oJT/fRlbxbmZrYuoQmUv92rI06HoeclkYkBmi6RfeHrRbgReK+CHE10c6xJ8goJ+2VOyWN
        h9wjleatctaHsOOBKTxLa1OitIsI7BCUNk3DDcto0/tSYqLUVefiRap60qItuf/b1XmpE8
        dJVgc1TkD0UwkYXK7a1IHJWdtcREVCk=
Content-Disposition: inline
In-Reply-To: <20221130070158.44221-1-chengkaitao@didiglobal.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: chengkaitao <pilgrimtao@gmail.com>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, mhocko@kernel.org, shakeelb@google.com, akpm@linux-foundation.org, songmuchun@bytedance.com, cgel.zte@gmail.com, ran.xiaokai@zte.com.cn, viro@zeniv.linux.org.uk, zhengqi.arch@bytedance.com, ebiederm@xmission.com, Liam.Howlett@Oracle.com, chengzhihao1@huawei.com, haolee.swjtu@gmail.com, yuzhao@google.com, willy@infradead.org, vasily.averin@linux.dev, vbabka@suse.cz, surenb@google.com, sfr@canb.auug.org.au, mcgrof@kernel.org, sujiaxun@uniontech.com, feng.tang@intel.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, Nov 30, 2022 at 03:01:58PM +0800, chengkaitao wrote:
> From: chengkaitao <pilgrimtao@gmail.com>
> 
> We created a new interface <memory.oom.protect> for memory, If there is
> the OOM killer under parent memory cgroup, and the memory usage of a
> child cgroup is within its effective oom.protect boundary, the cgroup's
> tasks won't be OOM killed unless there is no unprotected tasks in other
> children cgroups. It draws on the logic of <memory.min/low> in the
> inheritance relationship.
> 
> It has the following advantages,
> 1. We have the ability to protect more important processes, when there
> is a memcg's OOM killer. The oom.protect only takes effect local memcg,
> and does not affect the OOM killer of the host.
> 2. Historically, we can often use oom_score_adj to control a group of
> processes, It requires that all processes in the cgroup must have a
> common parent processes, we have to set the common parent process's
> oom_score_adj, before it forks all children processes. So that it is
> very difficult to apply it in other situations. Now oom.protect has no
> such restrictions, we can protect a cgroup of processes more easily. The
> cgroup can keep some memory, even if the OOM killer has to be called.

It reminds me our attempts to provide a more sophisticated cgroup-aware oom
killer. The problem is that the decision which process(es) to kill or preserve
is individual to a specific workload (and can be even time-dependent
for a given workload). So it's really hard to come up with an in-kernel
mechanism which is at the same time flexible enough to work for the majority
of users and reliable enough to serve as the last oom resort measure (which
is the basic goal of the kernel oom killer).

Previously the consensus was to keep the in-kernel oom killer dumb and reliable
and implement complex policies in userspace (e.g. systemd-oomd etc).

Is there a reason why such approach can't work in your case?

Thanks!
