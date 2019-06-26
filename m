From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: Add kmem.slabinfo to v2 for debugging purpose
Date: Wed, 26 Jun 2019 15:25:53 -0700
Message-ID: <20190626152553.6f9178a0361e699a5d53e360@linux-foundation.org>
References: <20190626165614.18586-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561587954;
        bh=dWrZzF/XhnDsjGoEGdLBbSVqFhzeMu0M8np8rL3DeVs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mssNCvDXM3lIy9mHu47Fi5QIRccIP4NEIrmBc+mQHupnTW7+YYbhguOoXDqtvERvH
         REfZC+aT9ppRRnmbB7/H8Yp47SEvjMSnzviL8SITVJOqWUzWaWRjUa5YprDOQSdFxO
         pQ6Rdu5QWpA8GqFoZXwWmNRKk1ID+8M77YZ7zkKo=
In-Reply-To: <20190626165614.18586-1-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>

On Wed, 26 Jun 2019 12:56:14 -0400 Waiman Long <longman@redhat.com> wrote:

> With memory cgroup v1, there is a kmem.slabinfo file that can be
> used to view what slabs are allocated to the memory cgroup. There
> is currently no such equivalent in memory cgroup v2. This file can
> be useful for debugging purpose.
> 
> This patch adds an equivalent kmem.slabinfo to v2 with the caveat that
> this file will only show up as ".__DEBUG__.memory.kmem.slabinfo" when the
> "cgroup_debug" parameter is specified in the kernel boot command line.
> This is to avoid cluttering the cgroup v2 interface with files that
> are seldom used by end users.
>
> ...
>
> mm/memcontrol.c | 16 ++++++++++++++++
> 1 file changed, 16 insertions(+)

A change to the kernel's user interface triggers a change to the
kernel's user interface documentation.  This should be automatic by
now :(


