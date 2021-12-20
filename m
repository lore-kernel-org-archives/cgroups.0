From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 23/33] mm/memcg: Convert slab objcgs from struct page
 to struct slab
Date: Tue, 21 Dec 2021 00:31:16 +0100
Message-ID: <9fb797dd-38ca-33f6-68ff-e425a9f5174c@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-24-vbabka@suse.cz> <Ybite9s1TS7cS67J@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640043077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8YhXpEhe+pCquDJVFSz7ORu16T7uTcxjpho57hipfy4=;
        b=uoS0ALg2Zu7gjQuqyqBfwI4dUP2tAwMoVSRfcOn4QUjCGwWTPwP4XnRWwp1F37H8cpf1Dk
        aVrEHjwPejR1KwlZRCJ7vLA/jIdfwyAsdW4ou28ps2Ohmkc+Oewz23wighFNonTN7JeNiW
        CaClj6/2f2GDTcNyeZZTziKpX/Uq3rA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640043077;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8YhXpEhe+pCquDJVFSz7ORu16T7uTcxjpho57hipfy4=;
        b=dIY5PvzwWBkvlldg+X0mTZyZ1m0WXluQUsW/Mw0xG+gMcweUWu5DBV4rLKk1UiYhoROtVd
        TiJTRYFCNSbgP7BA==
Content-Language: en-US
In-Reply-To: <Ybite9s1TS7cS67J-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 12/14/21 15:43, Johannes Weiner wrote:
> On Wed, Dec 01, 2021 at 07:15:00PM +0100, Vlastimil Babka wrote:
>> page->memcg_data is used with MEMCG_DATA_OBJCGS flag only for slab pages
>> so convert all the related infrastructure to struct slab.
>> 
>> To avoid include cycles, move the inline definitions of slab_objcgs() and
>> slab_objcgs_check() from memcontrol.h to mm/slab.h.
>> 
>> This is not just mechanistic changing of types and names. Now in
>> mem_cgroup_from_obj() we use PageSlab flag to decide if we interpret the page
>> as slab, instead of relying on MEMCG_DATA_OBJCGS bit checked in
>> page_objcgs_check() (now slab_objcgs_check()). Similarly in
>> memcg_slab_free_hook() where we can encounter kmalloc_large() pages (here the
>> PageSlab flag check is implied by virt_to_slab()).
> 
> Yup, this is great.
> 
>> @@ -2865,24 +2865,31 @@ int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
>>   */
>>  struct mem_cgroup *mem_cgroup_from_obj(void *p)
>>  {
>> -	struct page *page;
>> +	struct folio *folio;
>>  
>>  	if (mem_cgroup_disabled())
>>  		return NULL;
>>  
>> -	page = virt_to_head_page(p);
>> +	folio = virt_to_folio(p);
>>  
>>  	/*
>>  	 * Slab objects are accounted individually, not per-page.
>>  	 * Memcg membership data for each individual object is saved in
>>  	 * the page->obj_cgroups.
>>  	 */
>> -	if (page_objcgs_check(page)) {
>> +	if (folio_test_slab(folio)) {
>> +		struct obj_cgroup **objcgs;
>>  		struct obj_cgroup *objcg;
>> +		struct slab *slab;
>>  		unsigned int off;
>>  
>> -		off = obj_to_index(page->slab_cache, page_slab(page), p);
>> -		objcg = page_objcgs(page)[off];
>> +		slab = folio_slab(folio);
>> +		objcgs = slab_objcgs_check(slab);
> 
> AFAICS the change to the _check() variant was accidental.
> 
> folio_test_slab() makes sure it's a slab page, so the legit options
> for memcg_data are NULL or |MEMCG_DATA_OBJCGS; using slab_objcgs()
> here would include the proper asserts, like page_objcgs() used to.

Well spotted. On closer look, it's actually the same in
memcg_slab_free_hook() where I also added a folio_test_slab() as part of
virt_to_slab(). In fact it means page_objcgs_check() can be just deleted
instead of replaced by slab_objcgs_check(). Thanks!


