From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] memcg: Add kmem.slabinfo to v2 for debugging purpose
Date: Thu, 27 Jun 2019 09:47:40 -0400
Message-ID: <78c5ba55-b755-1997-edcc-9ee03a3f3300@redhat.com>
References: <20190626165614.18586-1-longman@redhat.com>
 <20190626152553.6f9178a0361e699a5d53e360@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190626152553.6f9178a0361e699a5d53e360@linux-foundation.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>

On 6/26/19 6:25 PM, Andrew Morton wrote:
> On Wed, 26 Jun 2019 12:56:14 -0400 Waiman Long <longman@redhat.com> wrote:
>
>> With memory cgroup v1, there is a kmem.slabinfo file that can be
>> used to view what slabs are allocated to the memory cgroup. There
>> is currently no such equivalent in memory cgroup v2. This file can
>> be useful for debugging purpose.
>>
>> This patch adds an equivalent kmem.slabinfo to v2 with the caveat that
>> this file will only show up as ".__DEBUG__.memory.kmem.slabinfo" when the
>> "cgroup_debug" parameter is specified in the kernel boot command line.
>> This is to avoid cluttering the cgroup v2 interface with files that
>> are seldom used by end users.
>>
>> ...
>>
>> mm/memcontrol.c | 16 ++++++++++++++++
>> 1 file changed, 16 insertions(+)
> A change to the kernel's user interface triggers a change to the
> kernel's user interface documentation.  This should be automatic by
> now :(
>
>
We don't usually document debugging only files as they are subject to
change with no stability guarantee. That is the point of marking it for
debugging instead of a regular file that we need to support forever.

Cheers,
Longman

