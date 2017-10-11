From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [v11 3/6] mm, oom: cgroup-aware OOM killer
Date: Wed, 11 Oct 2017 15:08:15 +0200
Message-ID: <20171011130815.qjw7jfnnqz3gpn4s@dhcp22.suse.cz>
References: <20171005130454.5590-1-guro@fb.com>
 <20171005130454.5590-4-guro@fb.com>
 <alpine.DEB.2.10.1710091414260.59643@chino.kir.corp.google.com>
 <20171010122306.GA11653@castle.DHCP.thefacebook.com>
 <alpine.DEB.2.10.1710101345370.28262@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1710101345370.28262@chino.kir.corp.google.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue 10-10-17 14:13:00, David Rientjes wrote:
[...]
> For these reasons: unfair comparison of root mem cgroup usage to bias 
> against that mem cgroup from oom kill in system oom conditions, the 
> ability of users to completely evade the oom killer by attaching all 
> processes to child cgroups either purposefully or unpurposefully, and the 
> inability of userspace to effectively control oom victim selection:
> 
> Nacked-by: David Rientjes <rientjes@google.com>

I consider this NACK rather dubious. Evading the heuristic as you
describe requires root privileges in default configuration because
normal users are not allowed to create subtrees. If you
really want to delegate subtree to an untrusted entity then you do not
have to opt-in for this oom strategy. We can work on an additional means
which would allow to cover those as well (e.g. priority based one which
is requested for other usecases).

A similar argument applies to the root memcg evaluation. While the
proposed behavior is not optimal it would work for general usecase
described here where the root memcg doesn't really run any large number
of tasks. If somebody who explicitly opts-in for the new strategy and it
doesn't work well for that usecase we can enhance the behavior. That
alone is not a reason to nack the whole thing.

I find it really disturbing that you keep nacking this approach just
because it doesn't suite your specific usecase while it doesn't break
it. Moreover it has been stated several times already that future
improvements are possible and cover what you have described already.
-- 
Michal Hocko
SUSE Labs
