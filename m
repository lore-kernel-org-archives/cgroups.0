From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH-next v5 3/4] mm/memcg: Improve refill_obj_stock()
 performance
Date: Fri, 23 Apr 2021 16:06:25 -0400
Message-ID: <49715eb2-9ac4-8208-2c63-e432092c3ab2@redhat.com>
References: <20210420192907.30880-1-longman@redhat.com>
 <20210420192907.30880-4-longman@redhat.com>
 <YIC7dh0+nQDFmU+T@carbon.dhcp.thefacebook.com>
 <d17f1c19-fc1b-df92-8361-fa6b88170861@redhat.com> <YIIwsAk4RaJw5WCL@carbon>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619208390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4QiJOyaRBjpj+Qp4w+e7694mCmNFhGls/eL4ztohU9Y=;
        b=KgF5KQpWtQ/LCHQk6CqWB1RD/xvN4tDzE2C499dTMecYMM/XXp1yq1dow3HPTAMoLKWwqO
        A6ganN8cKc525c8t+6rv7F5BWTJiEeFv1lofxVqNe3Pl/mYdo2fYaZAsWN9GEHdFc9/JpK
        uH7L98dlX9mElc7DmcFsprs8WCkdp2A=
In-Reply-To: <YIIwsAk4RaJw5WCL@carbon>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On 4/22/21 10:28 PM, Roman Gushchin wrote:
> On Thu, Apr 22, 2021 at 01:26:08PM -0400, Waiman Long wrote:
>> On 4/21/21 7:55 PM, Roman Gushchin wrote:
>>> On Tue, Apr 20, 2021 at 03:29:06PM -0400, Waiman Long wrote:
>>>> There are two issues with the current refill_obj_stock() code. First of
>>>> all, when nr_bytes reaches over PAGE_SIZE, it calls drain_obj_stock() to
>>>> atomically flush out remaining bytes to obj_cgroup, clear cached_objcg
>>>> and do a obj_cgroup_put(). It is likely that the same obj_cgroup will
>>>> be used again which leads to another call to drain_obj_stock() and
>>>> obj_cgroup_get() as well as atomically retrieve the available byte from
>>>> obj_cgroup. That is costly. Instead, we should just uncharge the excess
>>>> pages, reduce the stock bytes and be done with it. The drain_obj_stock()
>>>> function should only be called when obj_cgroup changes.
>>> I really like this idea! Thanks!
>>>
>>> However, I wonder if it can implemented simpler by splitting drain_obj_stock()
>>> into two functions:
>>>        empty_obj_stock() will flush cached bytes, but not reset the objcg
>>>        drain_obj_stock() will call empty_obj_stock() and then reset objcg
>>>
>>> Then we simple can replace the second drain_obj_stock() in
>>> refill_obj_stock() with empty_obj_stock(). What do you think?
>> Actually the problem is the flushing cached bytes to objcg->nr_charged_bytes
>> that can become a performance bottleneck in a multithreaded testing
>> scenario. See my description in the latter half of my cover-letter.
>>
>> For cgroup v2, update the page charge will mostly update the per-cpu page
>> charge stock. Flushing the remaining byte charge, however, will cause the
>> obgcg to became the single contended cacheline for all the cpus that need to
>> flush the byte charge. That is why I only update the page charge and left
>> the remaining byte charge stayed put in the object stock.
>>
>>>> Secondly, when charging an object of size not less than a page in
>>>> obj_cgroup_charge(), it is possible that the remaining bytes to be
>>>> refilled to the stock will overflow a page and cause refill_obj_stock()
>>>> to uncharge 1 page. To avoid the additional uncharge in this case,
>>>> a new overfill flag is added to refill_obj_stock() which will be set
>>>> when called from obj_cgroup_charge().
>>>>
>>>> A multithreaded kmalloc+kfree microbenchmark on a 2-socket 48-core
>>>> 96-thread x86-64 system with 96 testing threads were run.  Before this
>>>> patch, the total number of kilo kmalloc+kfree operations done for a 4k
>>>> large object by all the testing threads per second were 4,304 kops/s
>>>> (cgroup v1) and 8,478 kops/s (cgroup v2). After applying this patch, the
>>>> number were 4,731 (cgroup v1) and 418,142 (cgroup v2) respectively. This
>>>> represents a performance improvement of 1.10X (cgroup v1) and 49.3X
>>>> (cgroup v2).
>>> This part looks more controversial. Basically if there are N consequent
>>> allocations of size (PAGE_SIZE + x), the stock will end up with (N * x)
>>> cached bytes, right? It's not the end of the world, but do we really
>>> need it given that uncharging a page is also cached?
>> Actually the maximum charge that can be accumulated in (2*PAGE_SIZE + x - 1)
>> since a following consume_obj_stock() will use those bytes once the byte
>> charge is not less than (PAGE_SIZE + x).
> Got it, thank you for the explanation!
>
> Can you, please, add a comment explaining what the "overfill" parameter does
> and why it has different values on charge and uncharge paths?
> Personally, I'd revert it's meaning and rename it to something like "trim"
> or just plain "bool charge".
> I think the simple explanation is that during the charge we can't refill more
> than a PAGE_SIZE - 1 and the following allocation will likely use it or
> the following deallocation will trim it if necessarily.
> And on the uncharge path there are no bounds and the following deallocation
> can only increase the cached value.

Yes, that is the intention. I will make suggested change and put in a 
comment about it.

Thanks,
Longman

