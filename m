From: Roman Gushchin <guro@fb.com>
Subject: Re: [RFC PATCH] mm/memcontrol: Increase threshold for draining
 per-cpu stocked bytes.
Date: Tue, 5 Jan 2021 10:23:52 -0800
Message-ID: <20210105182352.GE371241@carbon.dhcp.thefacebook.com>
References: <1609862862-3573-1-git-send-email-imran.f.khan@oracle.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=WtT29LA629qXQBw7Zvb7T9hSmf0vZGxqOAOGaSrQNjI=;
 b=mGYaZLqlcRhJu26/VIovO2ZJmzC5oGVVGS1EH+e/hGfSHvDZHpaRAc7f7G5NO66ce+b6
 6P0pXT6DNoWS/s1DH/OAMNK0pTxyQzzxzq3HuQw0Z3ZCDpwEgMlzKR0G+JPoyt5Lmwyg
 ELEG6SdwtauuCvBo5HJy67rwKmqkVnK6qZk= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WtT29LA629qXQBw7Zvb7T9hSmf0vZGxqOAOGaSrQNjI=;
 b=YUdIeEhjHFGtoEXNQKc3o47d+XKPYm8dZDs6Ed1XhOk521+sJ7SdtBdbv1ABWP+upfagLKjPcfkT2baiTTe1zBO6s43R8849xVonoHG3Y6bGMEfYG/n1WZrKfFYzqsste2ymc0qTi9J3AXKLd+sO3ITGaPXaTAIW1pqIJEXE4bA=
Content-Disposition: inline
In-Reply-To: <1609862862-3573-1-git-send-email-imran.f.khan@oracle.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Imran Khan <imran.f.khan@oracle.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue, Jan 05, 2021 at 04:07:42PM +0000, Imran Khan wrote:
> While allocating objects whose size is multiple of PAGE_SIZE,
> say kmalloc-4K, we charge one page for extra bytes corresponding
> to the obj_cgroup membership pointer and remainder of the charged
> page gets added to per-cpu stocked bytes. If this allocation is
> followed by another allocation of the same size, the stocked bytes
> will not suffice and thus we endup charging an extra page
> again for membership pointer and remainder of this page gets added
> to per-cpu stocked bytes. This second addition will cause amount of
> stocked bytes to go beyond PAGE_SIZE and hence will result in
> invocation of drain_obj_stock.
> 
> So if we are in a scenario where we are consecutively allocating,
> several PAGE_SIZE multiple sized objects, the stocked bytes will
> never be enough to suffice a request and every second request will
> trigger draining of stocked bytes.
> 
> For example invoking __alloc_skb multiple times with
> 2K < packet size < 4K will give a call graph like:
> 
> __alloc_skb
>     |
>     |__kmalloc_reserve.isra.61
>     |    |
>     |    |__kmalloc_node_track_caller
>     |    |    |
>     |    |    |slab_pre_alloc_hook.constprop.88
>     |    |     obj_cgroup_charge
>     |    |    |    |
>     |    |    |    |__memcg_kmem_charge
>     |    |    |    |    |
>     |    |    |    |    |page_counter_try_charge
>     |    |    |    |
>     |    |    |    |refill_obj_stock
>     |    |    |    |    |
>     |    |    |    |    |drain_obj_stock.isra.68
>     |    |    |    |    |    |
>     |    |    |    |    |    |__memcg_kmem_uncharge
>     |    |    |    |    |    |    |
>     |    |    |    |    |    |    |page_counter_uncharge
>     |    |    |    |    |    |    |    |
>     |    |    |    |    |    |    |    |page_counter_cancel
>     |    |    |
>     |    |    |
>     |    |    |__slab_alloc
>     |    |    |    |
>     |    |    |    |___slab_alloc
>     |    |    |    |
>     |    |    |slab_post_alloc_hook
> 
> This frequent draining of stock bytes and resultant charging of pages
> increases the CPU load and hence deteriorates the scheduler latency.
> 
> The above mentioned scenario and it's impact can be seen by running
> hackbench with large packet size on v5.8 and subsequent kernels. The
> deterioration in hackbench number starts appearing from v5.9 kernel,
> 'commit f2fe7b09a52b ("mm: memcg/slab: charge individual slab objects
> instead of pages")'.
> 
> Increasing the draining limit to twice of KMALLOC_MAX_CACHE_SIZE
> (a safe upper limit for size of slab cache objects), will avoid draining
> of stock, every second allocation request, for the above mentioned
> scenario and hence will reduce the CPU load for such cases. For
> allocation of smaller objects or other allocation patterns the behaviour
> will be same as before.
> 
> This change increases the draining threshold for per-cpu stocked bytes
> from PAGE_SIZE to KMALLOC_MAX_CACHE_SIZE * 2.

Hello, Imran!

Yes, it makes total sense to me.

Btw, in earlier versions of the new slab controller there was a separate stock
for byte-sized charging and it was 32 pages large. Later Johannes suggested
the current layered design and he thought that because of the layering a single
page is enough for the upper layer.

> 
> Below are the hackbench numbers with and without this change on
> v5.10.0-rc7.
> 
> Without this change:
>     # hackbench process 10 1000 -s 100000
>     Running in process mode with 10 groups using 40 file descriptors
>     each (== 400 tasks)
>     Each sender will pass 100 messages of 100000 bytes
>     Time: 4.401
> 
>     # hackbench process 10 1000 -s 100000
>     Running in process mode with 10 groups using 40 file descriptors
>     each (== 400 tasks)
>     Each sender will pass 100 messages of 100000 bytes
>     Time: 4.470
> 
> With this change:
>     # hackbench process 10 1000 -s 100000
>     Running in process mode with 10 groups using 40 file descriptors
>     each (== 400 tasks)
>     Each sender will pass 100 messages of 100000 bytes
>     Time: 3.782
> 
>     # hackbench process 10 1000 -s 100000
>     Running in process mode with 10 groups using 40 file descriptors
>     each (== 400 tasks)
>     Each sender will pass 100 messages of 100000 bytes
>     Time: 3.827
> 
> As can be seen the change gives an improvement of about 15% in hackbench
> numbers.
> Also numbers obtained with the change are inline with those obtained
> from v5.8 kernel.

The difference is quite impressive!

I wonder if you tried smaller values than KMALLOC_MAX_CACHE_SIZE * 2?
Let's say 16 and 32?

KMALLOC_MAX_CACHE_SIZE * 2 makes sense to me, but then the whole construction
with two layer caching is very questionable. Anyway, it's not a reason to not
merge your patch, just something I wanna look at later.

> 
> Signed-off-by: Imran Khan <imran.f.khan@oracle.com>

Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!
