From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2] mm: fix race between kmem_cache destroy, create and deactivate
Date: Sat, 26 May 2018 15:43:34 -0700
Message-ID: <CALvZod6kwrrsm7n1LJ51Eakv8sPauOLHjU_E958HueVx8J3H9Q@mail.gmail.com>
References: <20180522201336.196994-1-shakeelb@google.com> <20180526185837.k5ztrillokpi65qj@esperanza>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=M1sn3tTe/hzAPCQmGTmPe8jG0FvJ5Q1o4X82msO1Jek=;
        b=SGyjlwbr5aHIOmlVtnAYrHvBn8Hg2MscqUy8RAvyp9CLFyv7cNDISRoJda0t1ajC9f
         uG15R+owHkPJoSanoXcHFegenppWi7hAzN+o7MaWDLnJrXb3XUfacJwl+mwNb3U88/n8
         JugGhXU6vekvmHIU1rKmSmKUOBptak5MOEunpksEUqlM2569QpqsjhhL+OcX2YqicC7z
         YreXUs40OKaKDfifRZmeNEKR4tpXWnnvrBGgUUqvxs+EZU34UUWWl491JEyXrn9AFgVW
         gx02y5IsOavKWr98ZzimHS3koUUWfKmu3p6IJuozzi8Sp0YVj2koDtZWw7QWbRsYWwif
         SsjA==
In-Reply-To: <20180526185837.k5ztrillokpi65qj@esperanza>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Sat, May 26, 2018 at 11:58 AM, Vladimir Davydov
<vdavydov.dev@gmail.com> wrote:
> On Tue, May 22, 2018 at 01:13:36PM -0700, Shakeel Butt wrote:
>> The memcg kmem cache creation and deactivation (SLUB only) is
>> asynchronous. If a root kmem cache is destroyed whose memcg cache is in
>> the process of creation or deactivation, the kernel may crash.
>>
>> Example of one such crash:
>>       general protection fault: 0000 [#1] SMP PTI
>>       CPU: 1 PID: 1721 Comm: kworker/14:1 Not tainted 4.17.0-smp
>>       ...
>>       Workqueue: memcg_kmem_cache kmemcg_deactivate_workfn
>>       RIP: 0010:has_cpu_slab
>>       ...
>>       Call Trace:
>>       ? on_each_cpu_cond
>>       __kmem_cache_shrink
>>       kmemcg_cache_deact_after_rcu
>>       kmemcg_deactivate_workfn
>>       process_one_work
>>       worker_thread
>>       kthread
>>       ret_from_fork+0x35/0x40
>>
>> This issue is due to the lack of real reference counting for the root
>> kmem_caches. Currently kmem_cache does have a field named refcount which
>> has been used for multiple purposes i.e. shared count, reference count
>> and noshare flag. Due to its conflated nature, it can not be used for
>> reference counting by other subsystems.
>>
>> This patch decoupled the reference counting from shared count and
>> noshare flag. The new field 'shared_count' represents the shared count
>> and noshare flag while 'refcount' is converted into a real reference
>> counter.
>>
>> The reference counting is only implemented for root kmem_caches for
>> simplicity. The reference of a root kmem_cache is elevated on sharing or
>> while its memcg kmem_cache creation or deactivation request is in the
>> fly and thus it is made sure that the root kmem_cache is not destroyed
>> in the middle. As the reference of kmem_cache is elevated on sharing,
>> the 'shared_count' does not need any locking protection as at worst it
>> can be out-dated for a small window which is tolerable.
>
> I wonder if we could fix this problem without introducing reference
> counting for kmem caches (which seems a bit of an overkill to me TBO),
> e.g. by flushing memcg_kmem_cache_wq before root cache destruction?

Thanks I will look into workqueue flushing.
