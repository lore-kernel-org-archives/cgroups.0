From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 22/32] mm: Convert struct page to struct slab in
 functions used by other subsystems
Date: Wed, 5 Jan 2022 17:39:10 +0100
Message-ID: <d49a5ea1-3592-3db2-24d5-e274be880e35@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-23-vbabka@suse.cz>
 <YdT+qU4xgQeZc/jP@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641400750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=671oRtpp5WCs8Fk9Hz2g9PU50UrRMSTbK7reBDGjtCs=;
        b=NRsZKCZitYMeU3RMI4mLOr+6li06jujBRhQsffYRQUkFW9PzULWtrL9sf+TAZSnQfN/PFW
        vM6/MTfW8m/iSdJQlSZGTuf8ommuOTf4zyXfj2xodWa580XJFAlrfobKzZGZpOqhkgcw7b
        w7Rkd3lRVPo05v08Q4Ze6NDY68SHnmQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641400750;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=671oRtpp5WCs8Fk9Hz2g9PU50UrRMSTbK7reBDGjtCs=;
        b=A7c4TZBO+fD7rEud8NwULvyOqkWaT+XnEGjIj6AYNSs4vZ4Apwth/CZG0akr5xMhlAzuDJ
        JMYPGpTT1ZH7AUAw==
Content-Language: en-US
In-Reply-To: <YdT+qU4xgQeZc/jP-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Julia Lawall <julia.lawall-MZpvjPyXg2s@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 1/5/22 03:12, Roman Gushchin wrote:
> On Tue, Jan 04, 2022 at 01:10:36AM +0100, Vlastimil Babka wrote:
>> --- a/mm/kasan/report.c
>> +++ b/mm/kasan/report.c
>> @@ -249,7 +249,7 @@ static void print_address_description(void *addr, u8 tag)
>>  
>>  	if (page && PageSlab(page)) {
>>  		struct kmem_cache *cache = page->slab_cache;
>> -		void *object = nearest_obj(cache, page,	addr);
>> +		void *object = nearest_obj(cache, page_slab(page),	addr);
>                                                                   s/tab/space

Yeah it was pointed out earlier that the tab was already there but only this
change made it stand out. Fixing that up here would go against the automated
spatch conversion, so it's done in later manual patch that also touches this
line.

>> 2.34.1
>> 
> 
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> Thanks!

Thanks!
