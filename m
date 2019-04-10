From: Chris Down <chris@chrisdown.name>
Subject: Re: [RFC PATCH 0/2] mm/memcontrol: Finer-grained memory control
Date: Wed, 10 Apr 2019 22:38:24 +0100
Message-ID: <20190410213824.GA13638@chrisdown.name>
References: <20190410191321.9527-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LOxvXqKFPj3MVMl61HzHsAJfIq2rKeT4Ruwa8q/szlk=;
        b=IuGLqpYW78+nQWkej9wKStxCq8RIIrHjSMDS6OyqdFFNNxekxJhF89osk20TuKhrEO
         MElGo2FWORrNdRRerXLqjoT6MJkaWwt2JRoVTuFYipzOQEPGknG5meN37wEVLWBVLpAF
         x5IlPyQE3C1AOSQ8B1VRa/tpNetbiGbUNZFEI=
Content-Disposition: inline
In-Reply-To: <20190410191321.9527-1-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, Aaron Lu <aaron.lu@intel.com>

Hi Waiman,

Waiman Long writes:
>The current control mechanism for memory cgroup v2 lumps all the memory
>together irrespective of the type of memory objects. However, there
>are cases where users may have more concern about one type of memory
>usage than the others.

I have concerns about this implementation, and the overall idea in general. We 
had per-class memory limiting in the cgroup v1 API, and it ended up really 
poorly, and resulted in a situation where it's really hard to compose a usable 
system out of it any more.

A major part of the restructure in cgroup v2 has been to simplify things so 
that it's more easy to understand for service owners and sysadmins. This was 
intentional, because otherwise the system overall is hard to make into 
something that does what users *really* want, and users end up with a lot of 
confusion, misconfiguration, and generally an inability to produce a coherent 
system, because we've made things too hard to piece together.

In general, for purposes of resource control, I'm not convinced that it makes 
sense to limit only one kind of memory based on prior experience with v1. Can 
you give a production use case where this would be a clear benefit, traded off 
against the increase in complexity to the API?

>For simplicity, the limit is not hierarchical and applies to only tasks
>in the local memory cgroup.

We've made an explicit effort to make all things hierarchical -- this confuses 
things further. Even if we did have something like this, it would have to 
respect the hierarchy, we really don't want to return to the use_hierarchy 
days where users, sysadmins, and even ourselves are confused by the resource 
control semantics that are supposed to be achieved.

>We have customer request to limit memory consumption on anonymous memory
>only as they said the feature was available in other OSes like Solaris.

What's the production use case where this is demonstrably providing clear 
benefits in terms of resource control? How can it compose as part of an easy to 
understand, resource controlling system? I'd like to see a lot more information 
on why this is needed, and the usability and technical tradeoffs considered.

Thanks,

Chris
