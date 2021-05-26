From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH-next] mm/memcontrol.c: Fix potential uninitialized
 variable warning
Date: Wed, 26 May 2021 18:29:02 -0400
Message-ID: <9fb60ba4-258d-2bb5-57af-c174df9b1a31@redhat.com>
References: <20210526193602.8742-1-longman@redhat.com>
 <20210526134321.42bbd4a9dcbcf53e855c5b1b@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622068146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KJRZ7Xr9eE1StDnH/ATVl1uLoI8ZB4qRKeY2WD/qOD0=;
        b=RYS3otLmKgkK9XXdcQQynoE1AomxeYvgoT7dz5ecDcd1J9yb2f9o/wfXzKvUpL3XWA5UBI
        oHeZZk+WbFtfGvMYZ+46CUTjz+IAoTn9nLBOWsPuNpPh2fbDQhtqQ9FuowCHEcuXRz6UpJ
        ouNnhdfxi9tF3zn/PSMcn0+PDl51fv0=
In-Reply-To: <20210526134321.42bbd4a9dcbcf53e855c5b1b-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On 5/26/21 4:43 PM, Andrew Morton wrote:
> On Wed, 26 May 2021 15:36:02 -0400 Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> If the -Wno-maybe-uninitialized gcc option is not specified, compilation
>> of memcontrol.c may generate the following warnings:
>>
>> mm/memcontrol.c: In function ‘refill_obj_stock’:
>> ./arch/x86/include/asm/irqflags.h:127:17: warning: ‘flags’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>>    return !(flags & X86_EFLAGS_IF);
>>            ~~~~~~~^~~~~~~~~~~~~~~~
>> mm/memcontrol.c:3216:16: note: ‘flags’ was declared here
>>    unsigned long flags;
>>                  ^~~~~
>> In file included from mm/memcontrol.c:29:
>> mm/memcontrol.c: In function ‘uncharge_page’:
>> ./include/linux/memcontrol.h:797:2: warning: ‘objcg’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>>    percpu_ref_put(&objcg->refcnt);
>>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> Fix that by properly initializing *pflags in get_obj_stock() and
>> introducing a use_objcg bool variable in uncharge_page() to avoid
>> potentially accessing the struct page data twice.
>>
> Thanks.  I'll queue this as a fix against your "mm/memcg: optimize user
> context object stock access".
>
Thanks for that.

Cheers,
Longman

