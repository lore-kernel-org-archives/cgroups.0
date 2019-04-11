From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: Re: [RFC PATCH 0/2] mm/memcontrol: Finer-grained memory control
Date: Thu, 11 Apr 2019 18:35:00 +0300
Message-ID: <d8fc644e-0e83-7925-e728-34f6fc016f98@virtuozzo.com>
References: <20190410191321.9527-1-longman@redhat.com>
 <1b6ee304-6176-15a0-c3fa-0b59cdd60085@virtuozzo.com>
 <cea941ed-f401-7380-6e48-622115a02533@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cea941ed-f401-7380-6e48-622115a02533@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, aryabinin@virtuozzo.com

On 11.04.2019 17:55, Waiman Long wrote:
> On 04/11/2019 10:37 AM, Kirill Tkhai wrote:
>> On 10.04.2019 22:13, Waiman Long wrote:
>>> The current control mechanism for memory cgroup v2 lumps all the memory
>>> together irrespective of the type of memory objects. However, there
>>> are cases where users may have more concern about one type of memory
>>> usage than the others.
>>>
>>> We have customer request to limit memory consumption on anonymous memory
>>> only as they said the feature was available in other OSes like Solaris.
>>>
>>> To allow finer-grained control of memory, this patchset 2 new control
>>> knobs for memory controller:
>>>  - memory.subset.list for specifying the type of memory to be under control.
>>>  - memory.subset.high for the high limit of memory consumption of that
>>>    memory type.
>>>
>>> For simplicity, the limit is not hierarchical and applies to only tasks
>>> in the local memory cgroup.
>>>
>>> Waiman Long (2):
>>>   mm/memcontrol: Finer-grained control for subset of allocated memory
>>>   mm/memcontrol: Add a new MEMCG_SUBSET_HIGH event
>>>
>>>  Documentation/admin-guide/cgroup-v2.rst |  35 +++++++++
>>>  include/linux/memcontrol.h              |   8 ++
>>>  mm/memcontrol.c                         | 100 +++++++++++++++++++++++-
>>>  3 files changed, 142 insertions(+), 1 deletion(-)
>> CC Andrey.
>>
>> In Virtuozzo kernel we have similar functionality for limitation of page cache in a cgroup:
>>
>> https://github.com/OpenVZ/vzkernel/commit/8ceef5e0c07c7621fcb0e04ccc48a679dfeec4a4
> 
> It will be helpful to know the use case where you want to limit page
> cache usage. I have anonymous memory in mind when I compose this patch,
> but I make the mechanism more generic so that it can apply to other use
> cases as well.

We have distributed storage, and there are its daemons on every host.
There are replication factor 1:N, so the same block may be duplicated
on different hosts. They produce a lot of pagecache, but it is reused
not often (because of the above 1:N).

So, we want to limit pagecache, but do not limit anon memory. This
prevents global reclaim, and we found this improves our performance tests.

Kirill
