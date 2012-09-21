From: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v3 09/16] sl[au]b: always get the cache from its page in kfree
Date: Fri, 21 Sep 2012 12:33:23 +0300
Message-ID: <CAOJsxLFgwOqUcLHEwYNERwn1Uvp4-8CmvRKTfBFAHD6p_-6c7g@mail.gmail.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
	<1347977530-29755-10-git-send-email-glommer@parallels.com>
	<00000139d9fe8595-8905906d-18ed-4d41-afdb-f4c632c2d50a-000000@email.amazonses.com>
	<5059777E.8060906@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=7kBHJ2p8qQYFSdCP8KPih/RhWFTvI80ON82GqexLNRE=;
        b=ZD+3ul4D0+Z+7Ot5/JhYOFdiOQ0wbl9+KHPI/6t/TT8rcJTqN2B0f9sLVX7B0lSbVm
         NjuhUxzg/ERHc1FO/B/8A4Gf1kOvE174RQVNnGkBV5ca82jas2tosbbgDnJCS5lKZRmF
         rtOc1ZXTxbTNYl4OjTtrLLAqWBHlaq613KbKt9EzgwMsaeyPfs7rNLUQHkU+QzFzNd3x
         riEgrnEnc0n2Dk9MpshVg3Ziofw1LKEA2B0FPqxH0hh71Zqal+zgPODEbPA+y3qKy04P
         VFu3oftwMHJOq1qOk9z8eyuXpJqhZNvlYtp5SlWtJwkmANJcmIFe3170iKtlssyoeg4U
         V+kw==
In-Reply-To: <5059777E.8060906@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>

On Wed, Sep 19, 2012 at 10:42 AM, Glauber Costa <glommer@parallels.com> wrote:
>>> index f2d760c..18de3f6 100644
>>> --- a/mm/slab.c
>>> +++ b/mm/slab.c
>>> @@ -3938,9 +3938,12 @@ EXPORT_SYMBOL(__kmalloc);
>>>   * Free an object which was previously allocated from this
>>>   * cache.
>>>   */
>>> -void kmem_cache_free(struct kmem_cache *cachep, void *objp)
>>> +void kmem_cache_free(struct kmem_cache *s, void *objp)
>>>  {
>>>      unsigned long flags;
>>> +    struct kmem_cache *cachep = virt_to_cache(objp);
>>> +
>>> +    VM_BUG_ON(!slab_equal_or_parent(cachep, s));
>>
>> This is an extremely hot path of the kernel and you are adding significant
>> processing. Check how the benchmarks are influenced by this change.
>> virt_to_cache can be a bit expensive.
>
> Would it be enough for you to have a separate code path for
> !CONFIG_MEMCG_KMEM?
>
> I don't really see another way to do it, aside from deriving the cache
> from the object in our case. I am open to suggestions if you do.

We should assume that most distributions enable CONFIG_MEMCG_KMEM,
right? Therfore, any performance impact should be dependent on whether
or not kmem memcg is *enabled* at runtime or not.

Can we use the "static key" thingy introduced by tracing folks for this?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
