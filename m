From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] mm, slab: Extend slab/shrink to shrink all the memcg
 caches
Date: Tue, 23 Jul 2019 10:30:07 -0400
Message-ID: <f878a00c-5d84-534b-deac-5736534a61cd@redhat.com>
References: <20190702183730.14461-1-longman@redhat.com>
 <71ab6307-9484-fdd3-fe6d-d261acf7c4a5@sony.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <71ab6307-9484-fdd3-fe6d-d261acf7c4a5@sony.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: peter enderborg <peter.enderborg@sony.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Andrea Arcangeli <aarcange@redhat.com>

On 7/22/19 8:46 AM, peter enderborg wrote:
> On 7/2/19 8:37 PM, Waiman Long wrote:
>> Currently, a value of '1" is written to /sys/kernel/slab/<slab>/shrink
>> file to shrink the slab by flushing all the per-cpu slabs and free
>> slabs in partial lists. This applies only to the root caches, though.
>>
>> Extends this capability by shrinking all the child memcg caches and
>> the root cache when a value of '2' is written to the shrink sysfs file.
>>
>> On a 4-socket 112-core 224-thread x86-64 system after a parallel kernel
>> build, the the amount of memory occupied by slabs before shrinking
>> slabs were:
>>
>>  # grep task_struct /proc/slabinfo
>>  task_struct         7114   7296   7744    4    8 : tunables    0    0
>>  0 : slabdata   1824   1824      0
>>  # grep "^S[lRU]" /proc/meminfo
>>  Slab:            1310444 kB
>>  SReclaimable:     377604 kB
>>  SUnreclaim:       932840 kB
>>
>> After shrinking slabs:
>>
>>  # grep "^S[lRU]" /proc/meminfo
>>  Slab:             695652 kB
>>  SReclaimable:     322796 kB
>>  SUnreclaim:       372856 kB
>>  # grep task_struct /proc/slabinfo
>>  task_struct         2262   2572   7744    4    8 : tunables    0    0
>>  0 : slabdata    643    643      0
>
> What is the time between this measurement points? Should not the shrinked memory show up as reclaimable?

In this case, I echoed '2' to all the shrink sysfs files under
/sys/kernel/slab. The purpose of shrinking caches is to reclaim as much
unused memory slabs from all the caches, irrespective if they are
reclaimable or not. We do not reclaim any used objects. That is why we
see the numbers were reduced in both cases.

Cheers,
Longman
