From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] mm, slab: Extend slab/shrink to shrink all the memcg
 caches
Date: Wed, 3 Jul 2019 12:16:09 -0400
Message-ID: <ca6147ca-25be-cba6-a7b9-fcac6d21345d@redhat.com>
References: <20190702183730.14461-1-longman@redhat.com>
 <20190702130318.39d187dc27dbdd9267788165@linux-foundation.org>
 <78879b79-1b8f-cdfd-d4fa-610afe5e5d48@redhat.com>
 <20190702143340.715f771192721f60de1699d7@linux-foundation.org>
 <c29ff725-95ba-db4d-944f-d33f5f766cd3@redhat.com>
 <20190703155314.GT978@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190703155314.GT978@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Andrea Arcangeli <aarcange@redhat.com>

On 7/3/19 11:53 AM, Michal Hocko wrote:
> On Wed 03-07-19 11:21:16, Waiman Long wrote:
>> On 7/2/19 5:33 PM, Andrew Morton wrote:
>>> On Tue, 2 Jul 2019 16:44:24 -0400 Waiman Long <longman@redhat.com> wrot=
e:
>>>
>>>> On 7/2/19 4:03 PM, Andrew Morton wrote:
>>>>> On Tue,  2 Jul 2019 14:37:30 -0400 Waiman Long <longman@redhat.com> w=
rote:
>>>>>
>>>>>> Currently, a value of '1" is written to /sys/kernel/slab/<slab>/shri=
nk
>>>>>> file to shrink the slab by flushing all the per-cpu slabs and free
>>>>>> slabs in partial lists. This applies only to the root caches, though.
>>>>>>
>>>>>> Extends this capability by shrinking all the child memcg caches and
>>>>>> the root cache when a value of '2' is written to the shrink sysfs fi=
le.
>>>>> Why?
>>>>>
>>>>> Please fully describe the value of the proposed feature to or users. =

>>>>> Always.
>>>> Sure. Essentially, the sysfs shrink interface is not complete. It allo=
ws
>>>> the root cache to be shrunk, but not any of the memcg caches.=C2=A0
>>> But that doesn't describe anything of value.  Who wants to use this,
>>> and why?  How will it be used?  What are the use-cases?
>>>
>> For me, the primary motivation of posting this patch is to have a way to
>> make the number of active objects reported in /proc/slabinfo more
>> accurately reflect the number of objects that are actually being used by
>> the kernel.
> I believe we have been through that. If the number is inexact due to
> caching then lets fix slabinfo rather than trick around it and teach
> people to do a magic write to some file that will "solve" a problem.
> This is exactly what drop_caches turned out to be in fact. People just
> got used to drop caches because they were told so by $random web page.
> So really, think about the underlying problem and try to fix it.
>
> It is true that you could argue that this patch is actually fixing the
> existing interface because it doesn't really do what it is documented to
> do and on those grounds I would agree with the change.

I do think that we should correct the shrink file to do what it is
designed to do to include the memcg caches as well.


>  But do not teach
> people that they have to write to some file to get proper numbers.
> Because that is just a bad idea and it will kick back the same way
> drop_caches.

The /proc/slabinfo file is a well-known file that is probably used
relatively extensively. Making it to scan through all the per-cpu
structures will probably cause performance issues as the slab_mutex has
to be taken during the whole duration of the scan. That could have
undesirable side effect.

Instead, I am thinking about extending the slab/objects sysfs file to
also show the number of objects hold up by the per-cpu structures and
thus we can get an accurate count by subtracting it from the reported
active objects. That will have a more limited performance impact as it
is just one kmem cache instead of all the kmem caches in the system.
Also the sysfs files are not as commonly used as slabinfo. That will be
another patch in the near future.

Cheers,
Longman

