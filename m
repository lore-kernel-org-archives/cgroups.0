From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [v10 3/6] mm, oom: cgroup-aware OOM killer
Date: Fri, 6 Oct 2017 07:43:25 +0200
Message-ID: <20171006054325.uefqqiox4jzsjhjl@dhcp22.suse.cz>
References: <20171004154638.710-1-guro@fb.com>
 <20171004154638.710-4-guro@fb.com>
 <alpine.DEB.2.10.1710041322160.67374@chino.kir.corp.google.com>
 <20171004204153.GA2696@cmpxchg.org>
 <alpine.DEB.2.10.1710050123180.20389@chino.kir.corp.google.com>
 <20171005104429.GB12982@castle.dhcp.TheFacebook.com>
 <alpine.DEB.2.10.1710051453590.87457@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1710051453590.87457@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu 05-10-17 15:02:18, David Rientjes wrote:
[...]
> I would need to add patches to add the "evaluate as a whole but do not 
> kill all" knob and a knob for "oom priority" so that userspace has the 
> same influence over a cgroup based comparison that it does with a process 
> based comparison to meet business goals.

I do not think 2 knobs would be really necessary for your usecase. If we
allow priorities on non-leaf memcgs then a non 0 priority on such a
memcg would mean that we have to check the cumulative consumption. You
can safely use kill all knob on top of that if you need.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
