From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC PATCH 21/32] mm: Convert struct page to struct slab in
 functions used by other subsystems
Date: Tue, 16 Nov 2021 17:32:58 +0100
Message-ID: <6866ad09-f765-0e8b-4821-8dbdc6d0f24e@suse.cz>
References: <20211116001628.24216-1-vbabka@suse.cz>
 <20211116001628.24216-22-vbabka@suse.cz>
 <CA+fCnZd_39cEvP+ktfxSrYAj6xdM02X6C0CxA5rLauaMhs2mxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1637080378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IdNHsSJ0TUD00V1kkWXYSG/GlAFO0QPXtO8TfYkofSY=;
        b=MijUyi88lZ9DiijG3jxYOvHLk3fRiZzkR+fpqvw/u1z0LEueLN/0KUr7R3BvYU1M4z6aBE
        zhnvy154JcLZ4I5wXS7KnTyl7U7XczcEzaEGt54cc8nMDHqImnQ2IfYFGx830RQdTAkIlY
        4ss7d7Tu0HfV1mYRx3tt0igHxDXiZps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1637080378;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IdNHsSJ0TUD00V1kkWXYSG/GlAFO0QPXtO8TfYkofSY=;
        b=JKrI4zxYmDk0OoP0A4AGw4Uj1AYkJhYXTHuBPrGvh+prinKuWrhEVkFyZhC891suL7lvHV
        vhCNK4l3K5a0L5BQ==
Content-Language: en-US
In-Reply-To: <CA+fCnZd_39cEvP+ktfxSrYAj6xdM02X6C0CxA5rLauaMhs2mxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Julia Lawall <julia.lawall-MZpvjPyXg2s@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kasan-dev <kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 11/16/21 15:02, Andrey Konovalov wrote:
>> --- a/mm/kasan/report.c
>> +++ b/mm/kasan/report.c
>> @@ -249,7 +249,7 @@ static void print_address_description(void *addr, u8 tag)
>>
>>         if (page && PageSlab(page)) {
>>                 struct kmem_cache *cache = page->slab_cache;
>> -               void *object = nearest_obj(cache, page, addr);
>> +               void *object = nearest_obj(cache, page_slab(page),      addr);
> 
> The tab before addr should be a space. checkpatch should probably report this.

Good catch, thanks. Note the tab is there already before this patch, it just
happened to appear identical to a single space before.
