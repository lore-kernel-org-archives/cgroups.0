From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 05/10] memcg: Slab accounting.
Date: Tue, 28 Feb 2012 15:31:14 -0800
Message-ID: <CABCjUKCXuY3mKX-zj51=PZLmD9ojVyerqx7UjaMiJgYwAcE6HQ@mail.gmail.com>
References: <1330383533-20711-1-git-send-email-ssouhlal@FreeBSD.org>
	<1330383533-20711-6-git-send-email-ssouhlal@FreeBSD.org>
	<4F4CD573.20208@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=IlMtkl0Y4lEh6j1802lcVS5GkDO/yqLIjp2uDSF3CV8=;
        b=KaI0UAfiAFdHQ//Iyt/nF924z9CSlbpp2soNigMeuNq5ZHq6bzZHfe4/xNfr69PYTL
         VIlNUyrNP1SnlgtXtK5zT398xh6Yreg9vnCv0kpZbTkR74Mjr+XXaElWg7a1F+8mf7Vn
         fI8D9169PetBfqqPlITvKOrfaqDZLX6WWHgUaAAtqdhBTTLAuniHvUCJdksHhZckUJP3
         7kk3NeREnptkczCMt3MQRJvQhzbUL/zwEJn7UqSr3P+P36TZmttdSW+MBZxBpCBe2Hkc
         eiUwlmOM7LH0EddJQKdOOThMHzDkp2W87Qe4DBYavHdt53d+Y6Ip+R5Mnu2GKyvA6vP5
         W9MA==
In-Reply-To: <4F4CD573.20208-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Suleiman Souhlal <ssouhlal-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Tue, Feb 28, 2012 at 5:24 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> =
wrote:
> On 02/27/2012 07:58 PM, Suleiman Souhlal wrote:
>>
>> Introduce per-cgroup kmem_caches for memcg slab accounting, that
>> get created the first time we do an allocation of that type in the
>> cgroup.
>> If we are not permitted to sleep in that allocation, the cache
>> gets created asynchronously.
>
> And then we allocate from the root cgroup?

Yes, the allocation will go to the root cgroup (or not get accounted
at all if you don't have CONFIG_CGROUP_MEM_RES_CTLR_KMEM_ACCT_ROOT).
Once the workqueue runs and creates the memcg cache, all the
allocations of that type will start using it.

>> The cgroup cache gets used in subsequent allocations, and permits
>> accounting of slab on a per-page basis.
>>
>> The per-cgroup kmem_caches get looked up at slab allocation time,
>> in a MAX_KMEM_CACHE_TYPES-sized array in the memcg structure, based
>> on the original kmem_cache's id, which gets allocated when the origi=
nal
>> cache gets created.
>>
>> Allocations that cannot be attributed to a cgroup get charged to
>> the root cgroup.
>>
>> Each cgroup kmem_cache has a refcount that dictates the lifetime
>> of the cache: We destroy a cgroup cache when its cgroup has been
>> destroyed and there are no more active objects in the cache.
>
>
> Since we already track the number of pages in the slab, why do we nee=
d a
> refcnt?

I must be missing something, but I don't see a counter of the number
of active pages in the cache in the code. :-(

>> diff --git a/include/linux/slab.h b/include/linux/slab.h
>> index 573c809..fe21a91 100644
>> --- a/include/linux/slab.h
>> +++ b/include/linux/slab.h
>> @@ -21,6 +21,7 @@
>> =A0#define SLAB_POISON =A0 =A0 =A0 =A0 =A0 0x00000800UL =A0 =A0/* DE=
BUG: Poison objects */
>> =A0#define SLAB_HWCACHE_ALIGN =A0 =A00x00002000UL =A0 =A0/* Align ob=
js on cache
>> lines */
>> =A0#define SLAB_CACHE_DMA =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00x00004000U=
L =A0 =A0/* Use GFP_DMA
>> memory */
>> +#define SLAB_MEMCG =A0 =A0 =A0 =A0 =A0 =A0 0x00008000UL =A0 =A0/* m=
emcg kmem_cache */
>> =A0#define SLAB_STORE_USER =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x00010000UL =
=A0 =A0/* DEBUG: Store the
>> last owner for bug hunting */
>> =A0#define SLAB_PANIC =A0 =A0 =A0 =A0 =A0 =A00x00040000UL =A0 =A0/* =
Panic if
>> kmem_cache_create() fails */
>> =A0/*
>
>
> We'll get to this later, but I dislike adding this flag, since we can=
 just
> test for existence of a pointer that we need to track anyway in
> the slab structure.

I might be able to remove this flag. I'll try to get that done in v2.

>
> This may create some problems when we track it for root memcg, but th=
is is
> something your patchset does, and I believe we shouldn't.
>
>
>> diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
>> index fbd1117..449a0de 100644
>> --- a/include/linux/slab_def.h
>> +++ b/include/linux/slab_def.h
>> @@ -41,6 +41,10 @@ struct kmem_cache {
>> =A0 =A0 =A0 =A0/* force GFP flags, e.g. GFP_DMA */
>> =A0 =A0 =A0 =A0gfp_t gfpflags;
>>
>> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
>> + =A0 =A0 =A0 int id; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 /* id used for slab accounting */
>> +#endif
>> +
>
> What role does it play? Is it the same as the array index in my patch=
set?

Yes, this is the index into the memcg slab array.
The id gets allocated when someone does kmem_cache_create().


>> =A0 =A0 =A0 =A0size_t colour; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* =
cache colouring range */
>> =A0 =A0 =A0 =A0unsigned int colour_off; =A0 =A0 =A0 =A0/* colour off=
set */
>> =A0 =A0 =A0 =A0struct kmem_cache *slabp_cache;
>> @@ -51,7 +55,7 @@ struct kmem_cache {
>> =A0 =A0 =A0 =A0void (*ctor)(void *obj);
>>
>> =A0/* 4) cache creation/removal */
>> - =A0 =A0 =A0 const char *name;
>> + =A0 =A0 =A0 char *name;
>> =A0 =A0 =A0 =A0struct list_head next;
>>
>> =A0/* 5) statistics */
>> @@ -78,9 +82,26 @@ struct kmem_cache {
>> =A0 =A0 =A0 =A0 * variables contain the offset to the user object an=
d its size.
>> =A0 =A0 =A0 =A0 */
>> =A0 =A0 =A0 =A0int obj_offset;
>> - =A0 =A0 =A0 int obj_size;
>> =A0#endif /* CONFIG_DEBUG_SLAB */
>>
>> +#if defined(CONFIG_DEBUG_SLAB) ||
>> defined(CONFIG_CGROUP_MEM_RES_CTLR_KMEM)
>> + =A0 =A0 =A0 int obj_size;
>> +#endif
>> +
>> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
>> + =A0 =A0 =A0 /* Original cache parameters, used when creating a mem=
cg cache */
>> + =A0 =A0 =A0 size_t orig_align;
>> + =A0 =A0 =A0 unsigned long orig_flags;
>> +
>> + =A0 =A0 =A0 struct mem_cgroup *memcg;
>> +
>> + =A0 =A0 =A0 /* Who we copied from when creating cpuset cache */
>> + =A0 =A0 =A0 struct kmem_cache *orig_cache;
>> +
>> + =A0 =A0 =A0 atomic_t refcnt;
>> + =A0 =A0 =A0 struct list_head destroyed_list; /* Used when deleting=
 cpuset
>> cache */
>> +#endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
>
> I think you're adding way to many things here.
>
> I prefer the approach I took of having a memcg pointer, and then havi=
ng that
> stuff into memcg. It will be better for people not interested in this
> feature - like if you compile this in, but then does not mount memcg.

Given that there are only on the order of a hundred different
kmem_caches, when slab accounting is disabled, I'm not sure the 52
bytes (or 64?) that are being added here are a big concern.

If you really think this is important, I can move them to a different s=
tructure.

>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index c82ca1c..d1c0cd7 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -297,6 +297,11 @@ struct mem_cgroup {
>> =A0#ifdef CONFIG_INET
>> =A0 =A0 =A0 =A0struct tcp_memcontrol tcp_mem;
>> =A0#endif
>> +
>> +#if defined(CONFIG_CGROUP_MEM_RES_CTLR_KMEM)&& =A0defined(CONFIG_SL=
AB)
>>
>> + =A0 =A0 =A0 /* Slab accounting */
>> + =A0 =A0 =A0 struct kmem_cache *slabs[MAX_KMEM_CACHE_TYPES];
>> +#endif
>> =A0 =A0 =A0 =A0int independent_kmem_limit;
>> =A0};
>>
>> @@ -5633,6 +5638,312 @@ memcg_uncharge_kmem(struct mem_cgroup *memcg=
, long
>> long delta)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0res_counter_uncharge(&memcg->res, del=
ta);
>> =A0}
>>
>> +#ifdef CONFIG_SLAB
>
>
> Why CONFIG_SLAB? If this is in memcontrol.c, shouldn't have anything
> slab-specific here...

I'm not sure this code will compile with another slab allocator.
I'll look into what I need to do get rid of these #ifdefs.

Thanks,
-- Suleiman
