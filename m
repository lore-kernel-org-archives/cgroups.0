From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] mm, slab: Extend slab/shrink to shrink all the memcg
 caches
Date: Wed, 3 Jul 2019 09:12:13 -0400
Message-ID: <9ade5859-b937-c1ac-9881-2289d734441d@redhat.com>
References: <20190702183730.14461-1-longman@redhat.com>
 <20190703065628.GK978@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190703065628.GK978@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Andrea Arcangeli <aarcange@redhat.com>

On 7/3/19 2:56 AM, Michal Hocko wrote:
> On Tue 02-07-19 14:37:30, Waiman Long wrote:
>> Currently, a value of '1" is written to /sys/kernel/slab/<slab>/shrink
>> file to shrink the slab by flushing all the per-cpu slabs and free
>> slabs in partial lists. This applies only to the root caches, though.
>>
>> Extends this capability by shrinking all the child memcg caches and
>> the root cache when a value of '2' is written to the shrink sysfs file.
> Why do we need a new value for this functionality? I would tend to think
> that skipping memcg caches is a bug/incomplete implementation. Or is it
> a deliberate decision to cover root caches only?

It is just that I don't want to change the existing behavior of the
current code. It will definitely take longer to shrink both the root
cache and the memcg caches. If we all agree that the only sensible
operation is to shrink root cache and the memcg caches together. I am
fine just adding memcg shrink without changing the sysfs interface
definition and be done with it.

Cheers,
Longman

