From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v3] mm: fix race between kmem_cache destroy, create and deactivate
Date: Thu, 31 May 2018 17:48:31 -0700
Message-ID: <CALvZod69UOuEzsDZ1V-f5Nc5Ou=7qSvmxsyucBioZc1MunRHUw@mail.gmail.com>
References: <20180530001204.183758-1-shakeelb@google.com> <20180531171834.e16fc59550d24437a12c612b@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=clRbq+UF0DlIBgPmj4jPJVfMDVl21+9YWWUWZkDdQRg=;
        b=gno8Sjn1gVqotNoi3N+jgHI0NGG3/Dg3QFeDlU5olpEhnxbB2VL5X9uMUEO5TlNdw0
         bno/XJxZcy65lvT+1Anurwz2yYZSRVi20WskB0Lx527n+APPJOvQQFReCaElBMpzuUJj
         PXsNgZDNYmI5iWoRugaIbHe4P8mfwI3Xf9rG06DQLT1B4z7D6H8pFqgsa0SgHQPhQbQX
         NuxsKC6qxIERRY2BYVyg5/uIqdKhH7/jYDgftYkSUfZA3BTTs+Uh+jVT/whGOwdpaBvl
         MjhKU22GUWlHdMZYbm2JTMfv8w3XFC7iGGrdxp3C+Su4geM1qei+XEI+4RyhUzZFNhWP
         UOUQ==
In-Reply-To: <20180531171834.e16fc59550d24437a12c612b@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Thu, May 31, 2018 at 5:18 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 29 May 2018 17:12:04 -0700 Shakeel Butt <shakeelb@google.com> wrote:
>
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
>> To fix this race, on root kmem cache destruction, mark the cache as
>> dying and flush the workqueue used for memcg kmem cache creation and
>> deactivation.
>>
>> Signed-off-by: Shakeel Butt <shakeelb@google.com>
>> ---
>> Changelog since v2:
>> - Instead of refcount, flush the workqueue
>
> This one-liner doesn't appear to fully describe the difference between
> v2 and v3, which is rather large:
>

Sorry about that, I should have explained more. The reason the diff
between v2 and v3 is large is because v3 is the complete rewrite. So,
the diff is the revert of v2 and then v3 patch. If you drop all the
previous versions and just keep v3, it will be smaller.

thanks,
Shakeel
