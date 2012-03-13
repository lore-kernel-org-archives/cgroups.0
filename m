From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 06/13] slab: Add kmem_cache_gfp_flags() helper function.
Date: Tue, 13 Mar 2012 16:21:03 -0700
Message-ID: <CABCjUKCioWO-F7k=hVs_18B3uyL4zG3-krPFDh++YAnmejKKdg@mail.gmail.com>
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org>
	<1331325556-16447-7-git-send-email-ssouhlal@FreeBSD.org>
	<4F5C8414.5090800@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=Z6XaCii8VWzXWyIaFm6CW4CHbO1RZbgaBdWJR/Syz58=;
        b=PViQlN3z7t8uD8JfclHFD8ELfIcq8hhxb4NQLiIm0KIjCCDfseyw7b/j6mCJ40B6B8
         6JJQ1sVV4Audp57eA4oBqOOO7tTeadGqRRzE2RRQ+dTGxERNFUTEhe+1hRuCw8ncfwIa
         e3OFJMANYViPE8xLEzjUjzhFHsiMn5SrwAkQEW/z6E+pzS3Tp/nnmyk1kmCGn/Xh9ODj
         vyQM4mPDJK62My+VADQEjqTD7qWbvG5e0C+uS2MwPoGMkxSe6P2C2OxlHQNcecljHNN4
         kCvCMAMbz7XIu0sAXQkPmawXK4zUwgtgpusHV6npwHgfrxaWD+THiHCRFlUER1ixcXD3
         z3MA==
In-Reply-To: <4F5C8414.5090800-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Suleiman Souhlal <ssouhlal-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dan.magenheimer-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Mar 11, 2012 at 3:53 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> =
wrote:
> On 03/10/2012 12:39 AM, Suleiman Souhlal wrote:
>>
>> This function returns the gfp flags that are always applied to
>> allocations of a kmem_cache.
>>
>> Signed-off-by: Suleiman Souhlal<suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> ---
>> =A0include/linux/slab_def.h | =A0 =A06 ++++++
>> =A0include/linux/slob_def.h | =A0 =A06 ++++++
>> =A0include/linux/slub_def.h | =A0 =A06 ++++++
>> =A03 files changed, 18 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
>> index fbd1117..25f9a6a 100644
>> --- a/include/linux/slab_def.h
>> +++ b/include/linux/slab_def.h
>> @@ -159,6 +159,12 @@ found:
>> =A0 =A0 =A0 =A0return __kmalloc(size, flags);
>> =A0}
>>
>> +static inline gfp_t
>> +kmem_cache_gfp_flags(struct kmem_cache *cachep)
>> +{
>> + =A0 =A0 =A0 return cachep->gfpflags;
>> +}
>> +
>> =A0#ifdef CONFIG_NUMA
>> =A0extern void *__kmalloc_node(size_t size, gfp_t flags, int node);
>> =A0extern void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t fla=
gs, int
>> node);
>> diff --git a/include/linux/slob_def.h b/include/linux/slob_def.h
>> index 0ec00b3..3fa527d 100644
>> --- a/include/linux/slob_def.h
>> +++ b/include/linux/slob_def.h
>> @@ -34,4 +34,10 @@ static __always_inline void *__kmalloc(size_t siz=
e,
>> gfp_t flags)
>> =A0 =A0 =A0 =A0return kmalloc(size, flags);
>> =A0}
>>
>> +static inline gfp_t
>> +kmem_cache_gfp_flags(struct kmem_cache *cachep)
>> +{
>> + =A0 =A0 =A0 return 0;
>> +}
>> +
>> =A0#endif /* __LINUX_SLOB_DEF_H */
>> diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
>> index a32bcfd..5911d81 100644
>> --- a/include/linux/slub_def.h
>> +++ b/include/linux/slub_def.h
>> @@ -313,4 +313,10 @@ static __always_inline void *kmalloc_node(size_=
t
>> size, gfp_t flags, int node)
>> =A0}
>> =A0#endif
>>
>> +static inline gfp_t
>> +kmem_cache_gfp_flags(struct kmem_cache *cachep)
>> +{
>> + =A0 =A0 =A0 return cachep->allocflags;
>> +}
>> +
>
>
> Why is this needed? Can't the caller just call
> mem_cgroup_get_kmem_cache(cachep, flags | cachep->allocflags) ?

Because slub calls this cachep->allocflags, while slab calls it
cachep->gfpflags.

I'll look into renaming one of them to match the other.

-- Suleiman
