From: Roman Gushchin <guro@fb.com>
Subject: Re: [v7 5/5] mm, oom: cgroup v2 mount option to disable cgroup-aware
 OOM killer
Date: Tue, 5 Sep 2017 15:30:21 +0100
Message-ID: <20170905143021.GA28599@castle.dhcp.TheFacebook.com>
References: <20170904142108.7165-1-guro@fb.com>
 <20170904142108.7165-6-guro@fb.com>
 <20170905134412.qdvqcfhvbdzmarna@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=okzz/GdoLjEsL6Wgjj3kQ3FEJWqR5bqIpjzXwVwlyVk=;
 b=CN0YzcdYLjga3M8jhtfm9oJs0yFwFb5c2mHUvhJ0ePoX9QbEzSwpvDj192ZQMnw38yp3
 xGu4IPa/ZuaT0jNP0jz2C5YDTRibSpPxd2en3Nu5Z/S54iHcZ7osUnlHNa645eD/mbD8
 kdtx+G8IAKg4S/pWuBbf7FxboMgRqso7tNQ= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=okzz/GdoLjEsL6Wgjj3kQ3FEJWqR5bqIpjzXwVwlyVk=;
 b=iG+qTRA2LCHxDuU9QmItnnKRGsK3lgDQJ8gaYDbNkdfyx9bCiIq0eLnXbblco5UZcgBVGwIR0Rc4MMktcnzNSVAVM32rg93akq4It0mkiSg48mbZusKxGw3Qbktas49n+acQabfcjpVbrvQUaenH+GJHnd3OTfEObFtRcYGVcoM=
Content-Disposition: inline
In-Reply-To: <20170905134412.qdvqcfhvbdzmarna@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Sep 05, 2017 at 03:44:12PM +0200, Michal Hocko wrote:
> I will go and check patch 2 more deeply but this is something that I
> wanted to sort out first.
> 
> On Mon 04-09-17 15:21:08, Roman Gushchin wrote:
> > Introducing of cgroup-aware OOM killer changes the victim selection
> > algorithm used by default: instead of picking the largest process,
> > it will pick the largest memcg and then the largest process inside.
> > 
> > This affects only cgroup v2 users.
> > 
> > To provide a way to use cgroups v2 if the old OOM victim selection
> > algorithm is preferred for some reason, the nogroupoom mount option
> > is added.
> > 
> > If set, the OOM selection is performed in a "traditional" per-process
> > way. Both oom_priority and oom_group memcg knobs are ignored.
> 
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
> 
> Does that make sense to you?

Absolutely.

The only thing: I'm not sure that we have to preserve the existing logic
as default option. For most users (except few very specific usecases),
it should be at least as good, as the existing one.

Making it opt-in means that corresponding code will be executed only
by few users, who cares. Then we should probably hide corresponding
cgroup interface (oom_group and oom_priority knobs) by default,
and it feels as unnecessary complication and is overall against
cgroup v2 interface design.

> I think we should instead go with
> oom_strategy=[alloc_task,biggest_task,cgroup]

It would be a really nice interface; although I've no idea how to implement it:
"alloc_task" is an existing sysctl, which we have to preserve;
while "cgroup" depends on cgroup v2.

Thanks!
