From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 2/2] mm, slab: Extend vm/drop_caches to shrink kmem slabs
Date: Thu, 27 Jun 2019 17:31:58 -0400
Message-ID: <73f18141-7e74-9630-06ff-ac8cf9688e6e@redhat.com>
References: <20190624174219.25513-1-longman@redhat.com>
 <20190624174219.25513-3-longman@redhat.com>
 <20190626201900.GC24698@tower.DHCP.thefacebook.com>
 <063752b2-4f1a-d198-36e7-3e642d4fcf19@redhat.com>
 <20190627212419.GA25233@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190627212419.GA25233@tower.DHCP.thefacebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Shakeel Butt <shakeelb@goog>

On 6/27/19 5:24 PM, Roman Gushchin wrote:
>>> 2) what's your long-term vision here? do you think that we need to shrink
>>>    kmem_caches periodically, depending on memory pressure? how a user
>>>    will use this new sysctl?
>> Shrinking the kmem caches under extreme memory pressure can be one way
>> to free up extra pages, but the effect will probably be temporary.
>>> What's the problem you're trying to solve in general?
>> At least for the slub allocator, shrinking the caches allow the number
>> of active objects reported in slabinfo to be more accurate. In addition,
>> this allow to know the real slab memory consumption. I have been working
>> on a BZ about continuous memory leaks with a container based workloads.
>> The ability to shrink caches allow us to get a more accurate memory
>> consumption picture. Another alternative is to turn on slub_debug which
>> will then disables all the per-cpu slabs.
> I see... I agree with Michal here, that extending drop_caches sysctl isn't
> the best idea. Isn't it possible to achieve the same effect using slub sysfs?

Yes, using the slub sysfs interface can be a possible alternative.

Cheers,
Longman

