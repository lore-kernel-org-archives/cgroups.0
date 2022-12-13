From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3] mm: Add nodes= arg to memory.reclaim
Date: Tue, 13 Dec 2022 09:51:27 +0100
Message-ID: <Y5g9D12uEr7HpP5K@dhcp22.suse.cz>
References: <20221202223533.1785418-1-almasrymina@google.com>
 <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz>
 <CAHS8izM-XdLgFrQ1k13X-4YrK=JGayRXV_G3c3Qh4NLKP7cH_g@mail.gmail.com>
 <87k02volwe.fsf@yhuang6-desk2.ccr.corp.intel.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670921488; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cJqVpp0rgt2DpLfJteOt1+knopZ57BAnBRXhD56Saew=;
        b=MfMJRehQtolYF5vDu/F2qedFOWN5WjmU9c57R+GI1JCJbJYbMgJO0bjjf4S1YVNy0qGtIo
        u672Fjtmqv/Ii8avOlmNsNaT+W4ZkjnojFEgAYgg+bY/BIy2tr2FefoWzPGm0l/yfl6CEJ
        bn5zrj+XgsAI5VrL7PTa5ET5Aefo6Ok=
Content-Disposition: inline
In-Reply-To: <87k02volwe.fsf@yhuang6-desk2.ccr.corp.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Mina Almasry <almasrymina@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Yang Shi <yang.shi@linux.alibaba.com>, Yosry Ahmed <yosryahmed@google.com>, weixugc@google.com, fvdl@google.com, bagasdotme@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Tue 13-12-22 14:30:57, Huang, Ying wrote:
> Mina Almasry <almasrymina@google.com> writes:
[...]
> After these discussion, I think the solution maybe use different
> interfaces for "proactive demote" and "proactive reclaim".  That is,
> reconsider "memory.demote".  In this way, we will always uncharge the
> cgroup for "memory.reclaim".  This avoid the possible confusion there.
> And, because demotion is considered aging, we don't need to disable
> demotion for "memory.reclaim", just don't count it.

As already pointed out in my previous email, we should really think more
about future requirements. Do we add memory.promote interface when there
is a request to implement numa balancing into the userspace? Maybe yes
but maybe the node balancing should be more generic than bound to memory
tiering and apply to a more fine grained nodemask control.

Fundamentally we already have APIs to age (MADV_COLD, MADV_FREE),
reclaim (MADV_PAGEOUT, MADV_DONTNEED) and MADV_WILLNEED to prioritize
(swap in, or read ahead) which are per mm/file. Their primary usability
issue is that they are process centric and that requires a very deep
understanding of the process mm layout so it is not really usable for a
larger scale orchestration.
The important part of those interfaces is that they do not talk about
demotion because that is an implementation detail. I think we want to
follow that model at least. From a higher level POV I believe we really
need an interface to age&reclaim and balance memory among nodes. Are
there more higher level usecases?
-- 
Michal Hocko
SUSE Labs
