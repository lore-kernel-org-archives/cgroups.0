From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 0/2] memcontrol: support cgroup level OOM protection
Date: Sun, 7 May 2023 12:11:58 +0200
Message-ID: <ZFd5bpfYc3nPEVie@dhcp22.suse.cz>
References: <20230506114948.6862-1-chengkaitao@didiglobal.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1683454319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E2IBRhSYCp7770K3WZ9qLNwH/ZcVfrY9C1tieDZlpdg=;
        b=FIbi3vnJWeyisZKQAKPVxxKWxGo2cNOIKsLNgCwvtQ9PD+03S4WGFNTrTeJVW8AyA0ho3C
        4qhOKE4ROa0kpIcILETDzKxA6afhoxlER3gNbyxMQyTTYalxOeW0dQ8rZBj0mnF5I5ObNd
        ZJsiFec8xeevqFYY1Vrw1++ytRBXVaw=
Content-Disposition: inline
In-Reply-To: <20230506114948.6862-1-chengkaitao@didiglobal.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: chengkaitao <chengkaitao@didiglobal.com>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, roman.gushchin@linux.dev, shakeelb@google.com, akpm@linux-foundation.org, brauner@kernel.org, muchun.song@linux.dev, viro@zeniv.linux.org.uk, zhengqi.arch@bytedance.com, ebiederm@xmission.com, Liam.Howlett@oracle.com, chengzhihao1@huawei.com, pilgrimtao@gmail.com, haolee.swjtu@gmail.com, yuzhao@google.com, willy@infradead.org, vasily.averin@linux.dev, vbabka@suse.cz, surenb@google.com, sfr@canb.auug.org.au, mcgrof@kernel.org, sujiaxun@uniontech.com, feng.tang@intel.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Sat 06-05-23 19:49:46, chengkaitao wrote:
> Establish a new OOM score algorithm, supports the cgroup level OOM
> protection mechanism. When an global/memcg oom event occurs, we treat
> all processes in the cgroup as a whole, and OOM killers need to select
> the process to kill based on the protection quota of the cgroup

Although your patch 1 briefly touches on some advantages of this
interface there is a lack of actual usecase. Arguing that oom_score_adj
is hard because it needs a parent process is rather weak to be honest.
It is just trivial to create a thin wrapper, use systemd to launch
important services or simply update the value after the fact. Now
oom_score_adj has its own downsides of course (most notably a
granularity and a lack of group protection.

That being said, make sure you describe your usecase more thoroughly.
Please also make sure you describe the intended heuristic of the knob.
It is not really clear from the description how this fits hierarchical
behavior of cgroups. I would be especially interested in the semantics
of non-leaf memcgs protection as they do not have any actual processes
to protect.

Also there have been concerns mentioned in v2 discussion and it would be
really appreciated to summarize how you have dealt with them.

Please also note that many people are going to be slow in responding
this week because of LSFMM conference
(https://events.linuxfoundation.org/lsfmm/)
-- 
Michal Hocko
SUSE Labs
