From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 1/2] mm/memcg: try harder to decrease [memory,memsw].limit_in_bytes
Date: Wed, 20 Dec 2017 10:15:57 -0800
Message-ID: <CALvZod7ED3qaqekGTd-2PHmbTjY+D_NcFP1bE5_AgP8OF=jXJw@mail.gmail.com>
References: <20171220102429.31601-1-aryabinin@virtuozzo.com>
 <20171220103337.GL4831@dhcp22.suse.cz> <6e9ee949-c203-621d-890f-25a432bd4bb3@virtuozzo.com>
 <20171220113404.GN4831@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=aTpH/aoFVkbsZOCTRI5WT8t/Sb8BC9y2i2kaQ7qHUbA=;
        b=J1dgDy9sg/TO4hCGben6fMS/8xMPcaka+meJqWEbmvrj2bEFEkziytfrn+Wak2v5ny
         dxWaFIo+IJthFdqIh6EhJYlPgzM7y0NqjQqK/HopVKXK4Pivy263y/MctoZjI0dWkD7H
         MhAJEpeRYaI2z8YhOTuhpFGBKiZ0EOdH9l1ejPOsLUqqOJt+0tZ2d5/vWvfmadLpYe/3
         6Rlg88sLnYWc/bOzEKbeKD/CTpm8ut9LdwJ9O7P4NbtijxC+/iyFO2dmXBCxq2X+rtn3
         WcdEV+NcJvlQmPrDLY6aFzhzXENQzA7ImB0ZAjXH46yCXm4N6fzD8KNJ1SXFUi5Pok75
         FSYg==
In-Reply-To: <20171220113404.GN4831@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Wed, Dec 20, 2017 at 3:34 AM, Michal Hocko <mhocko@kernel.org> wrote:
> On Wed 20-12-17 14:32:19, Andrey Ryabinin wrote:
>> On 12/20/2017 01:33 PM, Michal Hocko wrote:
>> > On Wed 20-12-17 13:24:28, Andrey Ryabinin wrote:
>> >> mem_cgroup_resize_[memsw]_limit() tries to free only 32 (SWAP_CLUSTER_MAX)
>> >> pages on each iteration. This makes practically impossible to decrease
>> >> limit of memory cgroup. Tasks could easily allocate back 32 pages,
>> >> so we can't reduce memory usage, and once retry_count reaches zero we return
>> >> -EBUSY.
>> >>
>> >> It's easy to reproduce the problem by running the following commands:
>> >>
>> >>   mkdir /sys/fs/cgroup/memory/test
>> >>   echo $$ >> /sys/fs/cgroup/memory/test/tasks
>> >>   cat big_file > /dev/null &
>> >>   sleep 1 && echo $((100*1024*1024)) > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
>> >>   -bash: echo: write error: Device or resource busy
>> >>
>> >> Instead of trying to free small amount of pages, it's much more
>> >> reasonable to free 'usage - limit' pages.
>> >
>> > But that only makes the issue less probable. It doesn't fix it because
>> >             if (curusage >= oldusage)
>> >                     retry_count--;
>> > can still be true because allocator might be faster than the reclaimer.
>> > Wouldn't it be more reasonable to simply remove the retry count and keep
>> > trying until interrupted or we manage to update the limit.
>>
>> But does it makes sense to continue reclaiming even if reclaimer can't
>> make any progress? I'd say no. "Allocator is faster than reclaimer"
>> may be not the only reason for failed reclaim. E.g. we could try to
>> set limit lower than amount of mlock()ed memory in cgroup, retrying
>> reclaim would be just a waste of machine's resources.  Or we simply
>> don't have any swap, and anon > new_limit. Should be burn the cpu in
>> that case?
>
> We can check the number of reclaimed pages and go EBUSY if it is 0.
>
>> > Another option would be to commit the new limit and allow temporal overcommit
>> > of the hard limit. New allocations and the limit update paths would
>> > reclaim to the hard limit.
>> >
>>
>> It sounds a bit fragile and tricky to me. I wouldn't go that way
>> without unless we have a very good reason for this.
>
> I haven't explored this, to be honest, so there may be dragons that way.
> I've just mentioned that option for completness.
>

We already do this for cgroup-v2's memory.max. So, I don't think it is
fragile or tricky.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
