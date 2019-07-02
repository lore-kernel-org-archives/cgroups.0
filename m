From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] mm, slab: Extend slab/shrink to shrink all the memcg
 caches
Date: Tue, 2 Jul 2019 16:44:24 -0400
Message-ID: <78879b79-1b8f-cdfd-d4fa-610afe5e5d48@redhat.com>
References: <20190702183730.14461-1-longman@redhat.com>
 <20190702130318.39d187dc27dbdd9267788165@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190702130318.39d187dc27dbdd9267788165@linux-foundation.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Andrea Arcangeli <aarcange@redhat.com>

On 7/2/19 4:03 PM, Andrew Morton wrote:
> On Tue,  2 Jul 2019 14:37:30 -0400 Waiman Long <longman@redhat.com> wrote:
>
>> Currently, a value of '1" is written to /sys/kernel/slab/<slab>/shrink
>> file to shrink the slab by flushing all the per-cpu slabs and free
>> slabs in partial lists. This applies only to the root caches, though.
>>
>> Extends this capability by shrinking all the child memcg caches and
>> the root cache when a value of '2' is written to the shrink sysfs file.
> Why?
>
> Please fully describe the value of the proposed feature to or users.=20
> Always.

Sure. Essentially, the sysfs shrink interface is not complete. It allows
the root cache to be shrunk, but not any of the memcg caches.=C2=A0

The same can also be said for others slab sysfs files which show current
cache status. I don't think sysfs files are created for the memcg
caches, but I may be wrong. In many cases, information can be available
elsewhere like the slabinfo file. The shrink operation, however, has no
other alternative available.

>> ...
>>
>> --- a/Documentation/ABI/testing/sysfs-kernel-slab
>> +++ b/Documentation/ABI/testing/sysfs-kernel-slab
>> @@ -429,10 +429,12 @@ KernelVersion:	2.6.22
>>  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
>>  		Christoph Lameter <cl@linux-foundation.org>
>>  Description:
>> -		The shrink file is written when memory should be reclaimed from
>> -		a cache.  Empty partial slabs are freed and the partial list is
>> -		sorted so the slabs with the fewest available objects are used
>> -		first.
>> +		A value of '1' is written to the shrink file when memory should
>> +		be reclaimed from a cache.  Empty partial slabs are freed and
>> +		the partial list is sorted so the slabs with the fewest
>> +		available objects are used first.  When a value of '2' is
>> +		written, all the corresponding child memory cgroup caches
>> +		should be shrunk as well.  All other values are invalid.
> One would expect this to be a bitfield, like /proc/sys/vm/drop_caches.=20
> So writing 3 does both forms of shrinking.
>
> Yes, it happens to be the case that 2 is a superset of 1, but what
> about if we add "4"?
>
Yes, I can make it into a bit fields of 2 bits, just like
/proc/sys/vm/drop_caches.

Cheers,
Longman

