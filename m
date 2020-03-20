From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC] memcg: fix default behaviour of non-overridden
 memcg.swappiness
Date: Fri, 20 Mar 2020 14:44:28 +0100
Message-ID: <20200320134428.GG24409@dhcp22.suse.cz>
References: <BL0PR02MB560170CD4D4245D4B89BC22EE9F40@BL0PR02MB5601.namprd02.prod.outlook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BL0PR02MB560170CD4D4245D4B89BC22EE9F40@BL0PR02MB5601.namprd02.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ivan Teterevkov <ivan.teterevkov@nutanix.com>
Cc: "rientjes@google.com" <rientjes@google.com>, "willy@infradead.org" <willy@infradead.org>, "vbabka@suse.cz" <vbabka@suse.cz>, "tj@kernel.org" <tj@kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "corbet@lwn.net" <corbet@lwn.net>, "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "guro@fb.com" <guro@fb.com>, "shakeelb@google.com" <shakeelb@google.com>, "chris@chrisdown.name" <chris@chrisdown.name>, "yang.shi@linux.alibaba.com" <yang.shi@linux.alibaba.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "minchan@kernel.org" <minchan@kernel.org>, "ying.huang@intel.com" <ying.huang@intel.com>, "ziqian.lzq@antfin.com" <ziqian.lzq@antfin.com>, cgroups@vger.kerne

On Thu 19-03-20 17:38:30, Ivan Teterevkov wrote:
> This patch tries to resolve uncertainty around the memcg.swappiness when
> it's not overridden by the user: shall there be the latest vm_swappiness
> or the value captured at the moment when the cgroup was created?
> 
> I'm sitting on the fence with regards to this patch because cgroup v1 is
> considered legacy nowadays and the semantics of "swappiness" is already
> overwhelmed. However, the patch might be considered as a "fix" because
> looking at the documentation [1] one might have the impression that it's
> the latest /proc/sys/vm/swappiness value that should be found in the
> memcg.swappiness unless it's overridden or inherited from a cgroup where
> it was overridden when the given cgroup was created.

Could you be more specific what makes you think this? Let me quote the
whole thing here
: 5.3 swappiness
: --------------
: 
: Overrides /proc/sys/vm/swappiness for the particular group. The tunable
: in the root cgroup corresponds to the global swappiness setting.
: 
: Please note that unlike during the global reclaim, limit reclaim
: enforces that 0 swappiness really prevents from any swapping even if
: there is a swap storage available. This might lead to memcg OOM killer
: if there are no file pages to reclaim.

I do not want to pick on words here but to me it sounds this tunable is
clearly documented as the explicit override for the global value. The
root memcg corresponds to the global limit because root tends to be
special in many other aspects. But in general, the semantic of knobs is
that they do not unexpectedly change their values without an explicit
user/admin intervention.
> 
> Also, shall this magic -1 be exposed to the user? I think it's a "no",
> but what if the user wants to un-override the memcg.swappiness...

If we are to use such a semantic then it absolutely has to be an opt-in
behavior and expressed in some way to the user space (e.g. a symbolic
name referring to the global setting).
> 
> What do you reckon?

I am not convinced we need it. There would have to be a real life
usecase that cannot really work with the current semantic. I remember
that this has been brought up when discussing early swappiness
initialization [1]. But it seems there is a much better solution for
that problem [2].

[1] http://lkml.kernel.org/r/BL0PR02MB560167492CA4094C91589930E9FC0@BL0PR02MB5601.namprd02.prod.outlook.com
[2] http://lkml.kernel.org/r/20200317132105.24555-1-vbabka@suse.cz
-- 
Michal Hocko
SUSE Labs
