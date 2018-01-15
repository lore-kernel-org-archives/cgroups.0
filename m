From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: Re: [PATCH v4] mm/memcg: try harder to decrease
 [memory,memsw].limit_in_bytes
Date: Mon, 15 Jan 2018 15:30:59 +0300
Message-ID: <7d1b5bfb-f602-8cf4-2de6-dd186484e55c@virtuozzo.com>
References: <20180109152622.31ca558acb0cc25a1b14f38c@linux-foundation.org>
 <20180110124317.28887-1-aryabinin@virtuozzo.com>
 <20180111104239.GZ1732@dhcp22.suse.cz>
 <4a8f667d-c2ae-e3df-00fd-edc01afe19e1@virtuozzo.com>
 <20180111124629.GA1732@dhcp22.suse.cz>
 <ce885a69-67af-5f4c-1116-9f6803fb45ee@virtuozzo.com>
 <20180111162947.GG1732@dhcp22.suse.cz>
 <560a77b5-02d7-cbae-35f3-0b20a1c384c2@virtuozzo.com>
 <20180112122405.GK1732@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=oblxiovEdl6j21U+S1apdsciE7vYM21+Z/J8x3IQj1w=;
 b=WmEYu2Z1jBI6uCqUHzUtZ0zYtLFe2X7e3KlmshTPAqTFG5uYmjrI8tfPctWZoeCNLwaJpSyx0ZhGscxWwwPT9MQ32SkLtEpdxdoqhmwuH9LWlfG1DYS+9PwGrUDe8pVlCnK0dHl0HOQPUNYOS6uNLs5ApGV1eYSw3/vu0Ht3foo=
In-Reply-To: <20180112122405.GK1732@dhcp22.suse.cz>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>



On 01/12/2018 03:24 PM, Michal Hocko wrote:
> On Fri 12-01-18 00:59:38, Andrey Ryabinin wrote:
>> On 01/11/2018 07:29 PM, Michal Hocko wrote:
> [...]
>>> I do not think so. Consider that this reclaim races with other
>>> reclaimers. Now you are reclaiming a large chunk so you might end up
>>> reclaiming more than necessary. SWAP_CLUSTER_MAX would reduce the over
>>> reclaim to be negligible.
>>>
>>
>> I did consider this. And I think, I already explained that sort of race in previous email.
>> Whether "Task B" is really a task in cgroup or it's actually a bunch of reclaimers,
>> doesn't matter. That doesn't change anything.
> 
> I would _really_ prefer two patches here. The first one removing the
> hard coded reclaim count. That thing is just dubious at best. If you
> _really_ think that the higher reclaim target is meaningfull then make
> it a separate patch. I am not conviced but I will not nack it it either.
> But it will make our life much easier if my over reclaim concern is
> right and we will need to revert it. Conceptually those two changes are
> independent anywa.
> 

Ok, fair point. But what about livelock than? Don't you think that we should
go back to something like in V1 patch to prevent it?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
