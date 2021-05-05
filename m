From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/2] mm: memcg/slab: Create a new set of kmalloc-cg-<n>
 caches
Date: Wed, 5 May 2021 14:54:00 -0400
Message-ID: <5d1683d2-1023-1d1c-91e7-b68549debe1d@redhat.com>
References: <20210505154613.17214-1-longman@redhat.com>
 <20210505154613.17214-3-longman@redhat.com>
 <YJLWN6bNBYyKRPEN@carbon.DHCP.thefacebook.com>
 <f14a263b-10ea-ef2b-eefa-066591a4b637@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620240844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xzcUJiTSMQjqP53U/sK3VcFgjGCdL+Yqx50eNS1EYWE=;
        b=DoI2R8UovkmriXKAHZApMNuFjaaQLCsVAY5Do/ue4nasJdIYhDig01oKYmQUk9Ztm3l+Fr
        VV1HVOQW1Z0oW97CaMSGNtDAL9sr73vgA7TUi5fqCS4OL2KCMKqlEl8d0uMbZ3OrC7OWMY
        zhZKxU8IrwyzpoJ8Jh++c58pACYrTNY=
In-Reply-To: <f14a263b-10ea-ef2b-eefa-066591a4b637-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 5/5/21 2:11 PM, Waiman Long wrote:
> On 5/5/21 1:30 PM, Roman Gushchin wrote:
>
>>
>> Btw, I wonder if we also need a change in the slab caches merging 
>> procedure?
>> KMALLOC_NORMAL caches should not be merged with caches which can 
>> potentially
>> include accounted objects.
>
> Thank for catching this omission.
>
> I will take a look and modify the merging procedure in a new patch. 
> Accounting is usually specified at kmem_cache_create() time. Though, I 
> did find one instance of setting ACCOUNT flag in kmem_cache_alloc(), I 
> will ignore this case and merge accounted, but unreclaimable caches to 
> KMALLOC_CGROUP. 

In mm/slab_common.c:

#define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
                          SLAB_CACHE_DMA32 | SLAB_ACCOUNT)

struct kmem_cache *find_mergeable(unsigned int size, unsigned int align,
   :
                 if ((flags & SLAB_MERGE_SAME) != (s->flags & 
SLAB_MERGE_SAME))
                         continue;

By making sure kmalloc-cg-* has SLAB_ACCOUNT bit set, a kmemcache 
created with with SLAB_ACCOUNT may merge with kmalloc-cg-* whereas one 
without SLAB_ACCOUNT may merge with kmalloc-* for now. So the current 
code should work fine for most cases. Though, if the ACCOUNT flag is set 
at kmem_cache_alloc() and the cache happens to be merged into kmalloc-*, 
we will have the rare case that an objcg pointer array may have to be 
added to a kmalloc-* cache. However, this is not a common practice, and 
the three cases (not one, sorry) that I found so far is in

arch/x86/kvm/x86.c:     ctxt = kmem_cache_zalloc(x86_emulator_cache, 
GFP_KERNEL_ACCOUNT);
fs/hostfs/hostfs_kern.c:        hi = 
kmem_cache_alloc(hostfs_inode_cache, GFP_KERNEL_ACCOUNT);
virt/kvm/kvm_main.c:    vcpu = kmem_cache_zalloc(kvm_vcpu_cache, 
GFP_KERNEL_ACCOUNT);

We will have to advise against doing that.

Cheers,
Longman


