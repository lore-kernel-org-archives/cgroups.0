From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v3 1/2] mm: memcg: remote memcg charging for kmem allocations
Date: Tue, 13 Mar 2018 10:55:18 -0700
Message-ID: <CALvZod5XFKLfQiHN1g3KWJ-DEJPt8gX6QJD=x22x_eyDN88RYg@mail.gmail.com>
References: <20180221223757.127213-1-shakeelb@google.com> <20180221223757.127213-2-shakeelb@google.com>
 <20180313134902.GW12772@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=BSFYoH1xxNB+T1iUsOY+R5RBpDE2anP6VHOewGs6Hm4=;
        b=hh7yFz7o+Wr6f8G9PGfs/sHvH7hDu0PJ+8R6GVxPF2Uq3eVeCiuf4XicuYGC2adjnU
         Q2qqoa5uVxIoaBm5GRJohaDjYr/7hrCaELRqi4zdhIR0ZZ6QtN6pJvxi9Ezgi+Aa9Gi9
         P2YTdcO9Jod6g6pOS65rTYQHJIbrOiEtsSJviJrqtfF5VGfea6TwIzPEE/UNaTPzb3x7
         7I6mSWv6AGKWrtf0MRZcA/DQk1Uc1q7PrOkR7ehxXsTpnBSYzmaRqYAe+MgEQeAPtyPZ
         uIQtubC4eNBu+jcKAzW1g+BCzzJLnuUFsSh8vWUaNqHC0nO8GLYTVQaI17CHSdZr/teI
         mXLQ==
In-Reply-To: <20180313134902.GW12772@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Tue, Mar 13, 2018 at 6:49 AM, Michal Hocko <mhocko@kernel.org> wrote:
> On Wed 21-02-18 14:37:56, Shakeel Butt wrote:
> [...]
>> +#ifdef CONFIG_MEMCG
>> +static inline struct mem_cgroup *memalloc_memcg_save(struct mem_cgroup *memcg)
>> +{
>> +     struct mem_cgroup *old_memcg = current->target_memcg;
>> +     current->target_memcg = memcg;
>> +     return old_memcg;
>> +}
>
> So you are relying that the caller will handle the reference counting
> properly? I do not think this is a good idea.

For the fsnotify use-case, this assumption makes sense as fsnotify has
an abstraction of fsnotify_group which is created by the
person/process interested in the events and thus can be used to hold
the reference to the person/process's memcg. Another use-case I have
in mind is the filesystem mount. Basically attaching a mount with a
memcg and thus all user pages and kmem allocations (inodes, dentries)
for that mount will be charged to the attached memcg. In this use-case
the super_block is the perfect structure to hold the reference to the
memcg.

If in future we find a use-case where this assumption does not make
sense we can evolve the API and since this is kernel internal API, it
should not be hard to evolve.

> Also do we need some kind
> of debugging facility to detect unbalanced save/restore scopes?
>

I am not sure, I didn't find other similar patterns (like PF_MEMALLOC)
having debugging facility. Maybe we can add such debugging facility
when we find more users other than kmalloc & kmem_cache_alloc. Vmalloc
may be one but I could not think of a use-case for vmalloc for remote
charging, so, no need to add more code at this time.

> [...]
>> @@ -2260,7 +2269,10 @@ struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep)
>>       if (current->memcg_kmem_skip_account)
>>               return cachep;
>>
>> -     memcg = get_mem_cgroup_from_mm(current->mm);
>> +     if (current->target_memcg)
>> +             memcg = get_mem_cgroup(current->target_memcg);
>> +     if (!memcg)
>> +             memcg = get_mem_cgroup_from_mm(current->mm);
>>       kmemcg_id = READ_ONCE(memcg->kmemcg_id);
>>       if (kmemcg_id < 0)
>>               goto out;
>
> You are also adding one branch for _each_ charge path even though the
> usecase is rather limited.
>

I understand the concern but the charging path, IMO, is much complex
than just one or couple of additional branches. I can run a simple
microbenchmark to see if there is anything noticeable here.

> I will have to think about this approach more. It is clearly less code
> than your previous attempt but I cannot say I would be really impressed.
>

Thanks for your time.
