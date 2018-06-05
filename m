From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v13 0/7] cgroup-aware OOM killer
Date: Tue, 5 Jun 2018 14:13:48 +0200
Message-ID: <20180605121348.GD19202@dhcp22.suse.cz>
References: <20171130152824.1591-1-guro@fb.com>
 <20180605114729.GB19202@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180605114729.GB19202@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Tue 05-06-18 13:47:29, Michal Hocko wrote:
> It seems that this is still in limbo mostly because of David's concerns.
> So let me reiterate them and provide my POV once more (and the last
> time) just to help Andrew make a decision:

Sorry, I forgot to add reference to the email with the full David's
reasoning. Here it is http://lkml.kernel.org/r/alpine.DEB.2.10.1801091556490.173445@chino.kir.corp.google.com
 
> 1) comparision root with tail memcgs during the OOM killer is not fair
> because we are comparing tasks with memcgs.
> 
> This is true, but I do not think this matters much for workloads which
> are going to use the feature. Why? Because the main consumers of the new
> feature seem to be containers which really need some fairness when
> comparing _workloads_ rather than processes. Those are unlikely to
> contain any significant memory consumers in the root memcg. That would
> be mostly common infrastructure.
> 
> Is this is fixable? Yes, we would need to account in the root memcgs.
> Why are we not doing that now? Because it has some negligible
> performance overhead. Are there other ways? Yes we can approximate root
> memcg memory consumption but I would rather wait for somebody seeing
> that as a real problem rather than add hacks now without a strong
> reason.
> 
> 
> 2) Evading the oom killer by attaching processes to child cgroups which
> basically means that a task can split up the workload into smaller
> memcgs to hide their real memory consumption.
> 
> Again true but not really anything new. Processes can already fork and
> split up the memory consumption. Moreover it doesn't even require any
> special privileges to do so unlike creating a sub memcg. Is this
> fixable? Yes, untrusted workloads can setup group oom evaluation at the
> delegation layer so all subgroups would be considered together.
> 
> 3) Userspace has zero control over oom kill selection in leaf mem
> cgroups.
> 
> Again true but this is something that needs a good evaluation to not end
> up in the fiasko we have seen with oom_score*. Current users demanding
> this feature can live without any prioritization so blocking the whole
> feature seems unreasonable.
> 
> 4) Future extensibility to be backward compatible.
> 
> David is wrong here IMHO. Any prioritization or oom selection policy
> controls added in future are orthogonal to the oom_group concept added
> by this patchset. Allowing memcg to be an oom entity is something that
> we really want longterm. Global CGRP_GROUP_OOM is the most restrictive
> semantic and softening it will be possible by a adding a new knob to
> tell whether a memcg/hierarchy is a workload or a set of tasks.
> -- 
> Michal Hocko
> SUSE Labs

-- 
Michal Hocko
SUSE Labs
