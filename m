From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] memcg: Add kmem.slabinfo to v2 for debugging purpose
Date: Thu, 27 Jun 2019 16:59:24 -0400
Message-ID: <afc95bfa-d913-b834-c4b7-39839e7a902d@redhat.com>
References: <20190626165614.18586-1-longman@redhat.com>
 <20190627142024.GW657710@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190627142024.GW657710@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>

On 6/27/19 10:20 AM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Wed, Jun 26, 2019 at 12:56:14PM -0400, Waiman Long wrote:
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
> Can you please take a look at drgn?
>
>   https://github.com/osandov/drgn
>
> Baking in debug interface files always is limited and nasty and drgn
> can get you way more flexible debugging / monitoring tool w/o having
> to bake in anything into the kernel.  For an example, please take a
> look at
>
>   https://lore.kernel.org/bpf/20190614015620.1587672-10-tj@kernel.org/
>
> Thanks.
>
Thanks for the information. Will take a serious look at that.

Cheers,
Longman

