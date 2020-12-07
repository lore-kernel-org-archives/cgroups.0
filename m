From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [External] Re: [RESEND PATCH v2 00/12] Convert all vmstat
 counters to pages or bytes
Date: Mon, 7 Dec 2020 10:51:32 -0800
Message-ID: <30ebae81-86e8-80db-feb6-d7c47dbaccb2@infradead.org>
References: <20201206101451.14706-1-songmuchun@bytedance.com>
 <20201207130018.GJ25569@dhcp22.suse.cz>
 <CAMZfGtWSEKWqR4f+23xt+jVF-NLSTVQ0L0V3xfZsQzV7aeebhw@mail.gmail.com>
 <20201207150254.GL25569@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=Fhg9E9vu9bcihpp9kbZUi5L6cmFWBOpMdcZ1HS+gTsU=; b=MP9sgYRH78V0t379UCgKgnAYn7
        m2l2H/HIv5YeNZj/6Dq0pEKPpYFvsbbuKTcdZ81mV+SSXodUygEQ9E6fdMMwyt7xJOQB/aHzyv80W
        pymtSuLdV3Crs3vJM2bsRXvcivvA0z6+0fGiNoEELOMs25pRdiy4Yy3t/IZiu+SzqE1dbtNp4ld8e
        mr36rhF6azEE4B19+UFohrjcLDCiGsFBgCk8G9mTV+VLRLZ6RIWI3aHQgjRkv4ynAAUbAN3X48iwL
        LZL2QnJMM9nN/+tzBAQ34S+TUxeKFTY/IPLty1lTr80G9nEr++Jv9ua/CPzlOebMwPaSyegE++5Nk
        MJdQ8wlg==;
In-Reply-To: <20201207150254.GL25569@dhcp22.suse.cz>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.com>, Muchun Song <songmuchun@bytedance.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, rafael@kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>, Roman Gushchin <guro@fb.com>, Mike Rapoport <rppt@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, esyr@redhat.com, peterx@redhat.com, krisman@collabora.com, Suren Baghdasaryan <surenb@google.com>, avagin@openvz.org, Marco Elver <elver@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>

On 12/7/20 7:02 AM, Michal Hocko wrote:
> On Mon 07-12-20 22:52:30, Muchun Song wrote:
>> On Mon, Dec 7, 2020 at 9:00 PM Michal Hocko <mhocko@suse.com> wrote:
>>>
>>> On Sun 06-12-20 18:14:39, Muchun Song wrote:
>>>> Hi,
>>>>
>>>> This patch series is aimed to convert all THP vmstat counters to pages
>>>> and some KiB vmstat counters to bytes.
>>>>
>>>> The unit of some vmstat counters are pages, some are bytes, some are
>>>> HPAGE_PMD_NR, and some are KiB. When we want to expose these vmstat
>>>> counters to the userspace, we have to know the unit of the vmstat counters
>>>> is which one. It makes the code complex. Because there are too many choices,
>>>> the probability of making a mistake will be greater.
>>>>
>>>> For example, the below is some bug fix:
>>>>   - 7de2e9f195b9 ("mm: memcontrol: correct the NR_ANON_THPS counter of hierarchical memcg")
>>>>   - not committed(it is the first commit in this series) ("mm: memcontrol: fix NR_ANON_THPS account")
>>>>
>>>> This patch series can make the code simple (161 insertions(+), 187 deletions(-)).
>>>> And make the unit of the vmstat counters are either pages or bytes. Fewer choices
>>>> means lower probability of making mistakes :).
>>>>
>>>> This was inspired by Johannes and Roman. Thanks to them.
>>>
>>> It would be really great if you could summarize the current and after
>>> the patch state so that exceptions are clear and easier to review. The
>>
>> Agree. Will do in the next version. Thanks.
>>
>>
>>> existing situation is rather convoluted but we have at least units part
>>> of the name so it is not too hard to notice that. Reducing exeptions
>>> sounds nice but I am not really sure it is such an improvement it is
>>> worth a lot of code churn. Especially when it comes to KB vs B. Counting
>>
>> There are two vmstat counters (NR_KERNEL_STACK_KB and
>> NR_KERNEL_SCS_KB) whose units are KB. If we do this, all
>> vmstat counter units are either pages or bytes in the end. When
>> we expose those counters to userspace, it can be easy. You can
>> reference to:
>>
>>     [RESEND PATCH v2 11/12] mm: memcontrol: make the slab calculation consistent
>>
>> From this point of view, I think that it is worth doing this. Right?
> 
> Well, unless I am missing something, we have two counters in bytes, two
> in kB, both clearly distinguishable by the B/KB suffix. Changing KB to B
> will certainly reduce the different classes of units, no question about
> that, but I am not really sure this is worth all the code churn. Maybe
> others will think otherwise.
> 
> As I've said the THP accounting change makes more sense to me because it
> allows future changes which are already undergoing so there is more
> merit in those.
> 

Hi,

Are there any documentation changes that go with these patches?
Or are none needed?

If the patches change the output in /proc/* or /sys/* then I expect
there would need to be some doc changes.

And is there any chance of confusing userspace s/w (binary or scripts)
with these changes?

thanks.
-- 
~Randy

