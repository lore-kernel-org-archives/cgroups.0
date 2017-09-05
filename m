From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [v7 5/5] mm, oom: cgroup v2 mount option to disable cgroup-aware
 OOM killer
Date: Tue, 5 Sep 2017 17:53:44 -0400
Message-ID: <20170905215344.GA27427@cmpxchg.org>
References: <20170904142108.7165-1-guro@fb.com>
 <20170904142108.7165-6-guro@fb.com>
 <20170905134412.qdvqcfhvbdzmarna@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=c0aYZ8nfI9j8QNFGVAZATJp2XAYeqc0f7L9wq8e4hvg=; b=c9FdtLfin6KRzhhAlPHXrsYLzk
	4mw0wGY+TPV4KvrwyEqGOrkV+0w5oYh9OoSGgDBL8wItiqVqpn+6jYn5hBhXps/1dT+Dh7CivewEo
	nOorljUsk8i6ZJJ6FfmUW/jlLZkLHWm5ZOaaoX1CJ5Zt3SG5AGYdE9HgyZGUz44n6lLg=;
Content-Disposition: inline
In-Reply-To: <20170905134412.qdvqcfhvbdzmarna@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Sep 05, 2017 at 03:44:12PM +0200, Michal Hocko wrote:
> Why is this an opt out rather than opt-in? IMHO the original oom logic
> should be preserved by default and specific workloads should opt in for
> the cgroup aware logic. Changing the global behavior depending on
> whether cgroup v2 interface is in use is more than unexpected and IMHO
> wrong approach to take. I think we should instead go with 
> oom_strategy=[alloc_task,biggest_task,cgroup]
> 
> we currently have alloc_task (via sysctl_oom_kill_allocating_task) and
> biggest_task which is the default. You are adding cgroup and the more I
> think about the more I agree that it doesn't really make sense to try to
> fit thew new semantic into the existing one (compare tasks to kill-all
> memcgs). Just introduce a new strategy and define a new semantic from
> scratch. Memcg priority and kill-all are a natural extension of this new
> strategy. This will make the life easier and easier to understand by
> users.

oom_kill_allocating_task is actually a really good example of why
cgroup-awareness *should* be the new default.

Before we had the oom killer victim selection, we simply killed the
faulting/allocating task. While a valid answer to the problem, it's
not very fair or representative of what the user wants or intends.

Then we added code to kill the biggest offender instead, which should
have been the case from the start and was hence made the new default.
The oom_kill_allocating_task was added on the off-chance that there
might be setups who, for historical reasons, rely on the old behavior.
But our default was chosen based on what behavior is fair, expected,
and most reflective of the user's intentions.

The cgroup-awareness in the OOM killer is exactly the same thing. It
should have been the default from the beginning, because the user
configures a group of tasks to be an interdependent, terminal unit of
memory consumption, and it's undesirable for the OOM killer to ignore
this intention and compare members across these boundaries.

We should go the same way here as with kill_alloc_task: the default
should be what's sane and expected by the vast majority of our users,
with a knob (I would prefer a sysctl here, actually) to switch back in
case somebody - unexpectedly - actually relies on the old behavior.

I don't see why couldn't change user-visible behavior here if we don't
expect anyone (quirky setups aside) to rely on it AND we provide a
knob to revert in the field for the exceptions.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
