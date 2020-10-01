From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] mm: fix some comments in page_alloc.c and mempolicy.c
Date: Thu, 01 Oct 2020 09:17:29 -0700
Message-ID: <11c9c699aaa873847b4d14dfa5e2435b94c08569.camel@perches.com>
References: <20200925160650.GA42847@rlk>
         <10c1b339-b352-7643-7adf-d82c941c7d2c@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <10c1b339-b352-7643-7adf-d82c941c7d2c@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Hildenbrand <david@redhat.com>, Hui Su <sh_def@163.com>, lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Thu, 2020-10-01 at 14:27 +0200, David Hildenbrand wrote:
> On 25.09.20 18:06, Hui Su wrote:
> > 1. the cpuset.c has been moved from kernel/cpuset.c to
> > kernel/cgroup/cpuset.c long time ago, but the comment is stale,
> > so we update it.
[]
> > diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
[]
> > @@ -1,5 +1,5 @@
> >  /*
> > - *  kernel/cpuset.c
> > + *  kernel/cgroup/cpuset.c

It's probably better to remove this altogether instead.


