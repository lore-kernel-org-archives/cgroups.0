From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [External] Re: [PATCH v4] mm: memcontrol: Add the missing
 numa_stat interface for cgroup v2
Date: Tue, 15 Sep 2020 09:19:49 -0700
Message-ID: <f2ec1c19-b86b-887e-186a-3a8c3014857d@infradead.org>
References: <20200915055825.5279-1-songmuchun@bytedance.com>
 <a3e2a7bf-ae5a-9ca8-74f9-57af795f0380@infradead.org>
 <CAMZfGtVQtsFmU_5DVSZ1mFCnqZrPHrJFKT81Zg8TXDM7c74TDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=gtbrt8dJvKGHqvO+xWVhJDadXOXm7TXL2RE8ocfRdrU=; b=YqV8EnuDoph6ku6oHt9bx4qUwH
        KCZuDIAfFZknOwjfV+X/HK/ns4hKfz+uJoTC0Dg/MiUtHBr/U3QjAmuqYuF0IriwVx9ktkYnJtyWe
        q0U+yndgpPFNawlhOeefRJi7NmEX3tz1to/MpP8mBy6agxzAxzN5gpuwMEolreI1xu3kZICFJZ03M
        Rsz9WpOpYypQrogf3aEzzzzp4SvhUCMYp4g2YkdJn5w6Cj8mj6HjVdDZTzoVuC0AeyBFktr5xDn6v
        t/0m1BM8miYt+1+xl5yDYv5nAsskVRWIpiWdx00+BuANy7G7O6bQtgsIfTg+sXt9mpH/B/f1PEKHc
        EaY3jqbA==;
In-Reply-To: <CAMZfGtVQtsFmU_5DVSZ1mFCnqZrPHrJFKT81Zg8TXDM7c74TDQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On 9/15/20 9:01 AM, Muchun Song wrote:
> On Tue, Sep 15, 2020 at 11:45 PM Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>>

>>> +static int __init numa_stats_init(void)
>>> +{
>>> +     int i;
>>> +
>>> +     for (i = 0; i < ARRAY_SIZE(numa_stats); i++) {
>>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>> +             if (numa_stats[i].idx == NR_ANON_THPS)
>>> +                     numa_stats[i].ratio = HPAGE_PMD_SIZE;
>>> +#endif
>>> +     }
>>
>> Although the loop may be needed sometime in the future due to
>> other changes.. why couldn't it be like this for now?
> 
> The compiler is so smart, so there is nothing difference between
> them. I disassemble the numa_stats_init when
> !CONFIG_TRANSPARENT_HUGEPAGE.
> 
> Dump of assembler code for function numa_stats_init:
>    0xffffffff8273b061 <+0>: callq  0xffffffff81057490 <__fentry__>
>    0xffffffff8273b066 <+5>: xor    %eax,%eax
>    0xffffffff8273b068 <+7>: retq
> 

Of course!  Thanks.

>>
>>
>>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>> +     for (i = 0; i < ARRAY_SIZE(numa_stats); i++) {
>>> +             if (numa_stats[i].idx == NR_ANON_THPS)
>>> +                     numa_stats[i].ratio = HPAGE_PMD_SIZE;
>>> +     }
>>> +#endif
>>
>>
>>> +
>>> +     return 0;
>>> +}
>>> +pure_initcall(numa_stats_init);


-- 
~Randy

