From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2] fs: fsnotify: account fsnotify metadata to kmemcg
Date: Wed, 27 Jun 2018 08:50:59 +0300
Message-ID: <CAOQ4uxhZ81xGucQtZv+koCKCHtJn9yDGSd9MwBaL2Ew+6t0suQ@mail.gmail.com>
References: <20180625230659.139822-1-shakeelb@google.com> <20180625230659.139822-2-shakeelb@google.com>
 <20180626190619.GB3958@cmpxchg.org> <CALvZod5VU0_==ggX82P19v=X7zpKj1xO5qPZ1mep4yRVhr7qaw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=3ps+gAwVXdy5arvYGiUVzRS5jQtBXjkjTtbqkRwO+pY=;
        b=ik1pqeN4HmLDtEM0WCXzJYAWEinZTCSPmfiLRPFWHRZ22upQKlUTmTyeDt0DFH8+ZR
         hv7KWMaGy+Eb6DKp4qAAdJBAK6JiMpumaqg6nPYLY0xYj2+Gf83UpxhqLg9yF8RVWx8E
         qgB1y53ye0VMbBBjtIyavMisdZJc3hAZF4BR/JibliY9uUZwqEHNXXxuNibix1c29Sy6
         aHnmK6lZGmmqvgdazswRDDt0mnqyT1iXXAzV/V10ybhafZlr/QbL6VRF+B+O++cEEmD7
         v7TqqAPBmaWekddA8li1ZyEJkdbtYsgc10tJBeWyx491jvMbrgDLGotKYvQpfigdhHL7
         eWAA==
In-Reply-To: <CALvZod5VU0_==ggX82P19v=X7zpKj1xO5qPZ1mep4yRVhr7qaw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, Roman Gushchin <guro@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Jan Kara <jack@suse.cz>

On Tue, Jun 26, 2018 at 11:05 PM, Shakeel Butt <shakeelb@google.com> wrote:
> On Tue, Jun 26, 2018 at 12:03 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>>
>> On Mon, Jun 25, 2018 at 04:06:58PM -0700, Shakeel Butt wrote:
>> > @@ -140,8 +141,9 @@ struct fanotify_event_info *fanotify_alloc_event(struct fsnotify_group *group,
>> >                                                struct inode *inode, u32 mask,
>> >                                                const struct path *path)
>> >  {
>> > -     struct fanotify_event_info *event;
>> > +     struct fanotify_event_info *event = NULL;
>> >       gfp_t gfp = GFP_KERNEL;
>> > +     struct mem_cgroup *old_memcg = NULL;
>> >
>> >       /*
>> >        * For queues with unlimited length lost events are not expected and
>> > @@ -151,19 +153,25 @@ struct fanotify_event_info *fanotify_alloc_event(struct fsnotify_group *group,
>> >       if (group->max_events == UINT_MAX)
>> >               gfp |= __GFP_NOFAIL;
>> >
>> > +     /* Whoever is interested in the event, pays for the allocation. */
>> > +     if (group->memcg) {
>> > +             gfp |= __GFP_ACCOUNT;
>> > +             old_memcg = memalloc_use_memcg(group->memcg);
>> > +     }
>>
>> group->memcg is only NULL when memcg is disabled or there is some
>> offlining race. Can you make memalloc_use_memcg(NULL) mean that it
>> should charge root_mem_cgroup instead of current->mm->memcg? That way
>> we can make this site unconditional while retaining the behavior:
>>
>>         gfp_t gfp = GFP_KERNEL | __GFP_ACCOUNT;
>>
>>         memalloc_use_memcg(group->memcg);
>>         kmem_cache_alloc(..., gfp);
>> out:
>>         memalloc_unuse_memcg();
>>
>> (dropping old_memcg and the unuse parameter as per the other mail)
>>
>
> group->memcg is only NULL when memcg is disabled (i.e.
> get_mem_cgroup_from_mm() returns root_mem_cgroup for offlined
> mm->memcg). Though group->memcg can point to an offlined memcg.
>
> If I understand you correctly this is what we want:
>
> 1. If group->memcg is NULL then __GFP_ACCOUNT is a noop i.e. memcg is disabled.
> 2. If group->memcg is root_mem_cgroup, then __GFP_ACCOUNT again is a
> kind of noop (charges to root_mem_cgroups are bypassed).
> 3. If group->memcg is offlined memcg, then make __GFP_ACCOUNT noop by
> returning root_mem_cgroup from get_mem_cgroup_from_current().
> 4. Else charge group->memcg.
>
> This seems reasonable. After your Ack and Amir's or Jan's answer to
> the nesting query, I will resend the next version of this patch
> series.
>
> In future if we find any use-cases of memalloc_use_memcg nesting then
> we can make it work for nesting.
>

For the fsnotify use case memalloc_use_memcg() certainly doesn't
need to nest, but I wonder, if that facility becomes popular among different
subsystems, how exactly do you intend to monitor that it doesn't grow
nested use cases? I would suggest that you at least leave a
WARN_ON_ONCE if memalloc_use_memcg() is called and
active_memcg is already set.

Thanks,
Amir.
