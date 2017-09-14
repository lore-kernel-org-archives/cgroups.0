From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Thu, 14 Sep 2017 15:40:14 +0200
Message-ID: <20170914134014.wqemev2kgychv7m5@dhcp22.suse.cz>
References: <20170911131742.16482-1-guro@fb.com>
 <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com>
 <20170913122914.5gdksbmkolum7ita@dhcp22.suse.cz>
 <20170913215607.GA19259@castle>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170913215607.GA19259@castle>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed 13-09-17 14:56:07, Roman Gushchin wrote:
> On Wed, Sep 13, 2017 at 02:29:14PM +0200, Michal Hocko wrote:
[...]
> > I strongly believe that comparing only leaf memcgs
> > is more straightforward and it doesn't lead to unexpected results as
> > mentioned before (kill a small memcg which is a part of the larger
> > sub-hierarchy).
> 
> One of two main goals of this patchset is to introduce cgroup-level
> fairness: bigger cgroups should be affected more than smaller,
> despite the size of tasks inside. I believe the same principle
> should be used for cgroups.

Yes bigger cgroups should be preferred but I fail to see why bigger
hierarchies should be considered as well if they are not kill-all. And
whether non-leaf memcgs should allow kill-all is not entirely clear to
me. What would be the usecase?
Consider that it might be not your choice (as a user) how deep is your
leaf memcg. I can already see how people complain that their memcg has
been killed just because it was one level deeper in the hierarchy...

I would really start simple and only allow kill-all on leaf memcgs and
only compare leaf memcgs & root. If we ever need to kill whole
hierarchies then allow kill-all on intermediate memcgs as well and then
consider cumulative consumptions only on those that have kill-all
enabled.

Or do I miss any reasonable usecase that would suffer from such a
semantic?
-- 
Michal Hocko
SUSE Labs
