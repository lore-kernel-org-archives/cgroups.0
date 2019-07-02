From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 2/2] mm, slab: Extend vm/drop_caches to shrink kmem slabs
Date: Tue, 2 Jul 2019 14:41:43 -0400
Message-ID: <eeca4ef9-1b62-dada-3d31-c247cb0b137f@redhat.com>
References: <20190624174219.25513-1-longman@redhat.com>
 <20190624174219.25513-3-longman@redhat.com>
 <20190627151506.GE5303@dhcp22.suse.cz>
 <5cb05d2c-39a7-f138-b0b9-4b03d6008999@redhat.com>
 <20190628073128.GC2751@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190628073128.GC2751@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Andrea Arcangeli <aarcange@redhat.com>

On 6/28/19 3:31 AM, Michal Hocko wrote:
> On Thu 27-06-19 17:16:04, Waiman Long wrote:
>> On 6/27/19 11:15 AM, Michal Hocko wrote:
>>> On Mon 24-06-19 13:42:19, Waiman Long wrote:
>>>> With the slub memory allocator, the numbers of active slab objects
>>>> reported in /proc/slabinfo are not real because they include objects
>>>> that are held by the per-cpu slab structures whether they are actually
>>>> used or not.  The problem gets worse the more CPUs a system have. For
>>>> instance, looking at the reported number of active task_struct objects,
>>>> one will wonder where all the missing tasks gone.
>>>>
>>>> I know it is hard and costly to get a real count of active objects.
>>> What exactly is expensive? Why cannot slabinfo reduce the number of
>>> active objects by per-cpu cached objects?
>>>
>> The number of cachelines that needs to be accessed in order to get an
>> accurate count will be much higher if we need to iterate through all the
>> per-cpu structures. In addition, accessing the per-cpu partial list will
>> be racy.
> Why is all that a problem for a root only interface that should be used
> quite rarely (it is not something that you should be reading hundreds
> time per second, right)?

That can be true. Anyway, I have posted a new patch to use the existing
<slab>/shrink sysfs file to perform memcg cache shrinking as well. So I
am not going to pursue this patch.

Thanks,
Longman

