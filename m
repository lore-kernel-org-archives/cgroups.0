From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v2 0/4] Change the return value for page isolation
 functions
Date: Wed, 15 Feb 2023 09:21:33 +0800
Message-ID: <208eb79f-d064-36be-fece-a91007802379@linux.alibaba.com>
References: <cover.1676382188.git.baolin.wang@linux.alibaba.com>
 <5064ee08-792f-14f2-6f2d-26e81af8a239@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5064ee08-792f-14f2-6f2d-26e81af8a239-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, naoya.horiguchi-YMj9X0ASwKA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, osalvador-l3A5Bk7waGM@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, damon-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2/15/2023 1:52 AM, David Hildenbrand wrote:
> On 14.02.23 14:59, Baolin Wang wrote:
>> Now the page isolation functions did not return a boolean to indicate
>> success or not, instead it will return a negative error when failed
>> to isolate a page. So below code used in most places seem a boolean
>> success/failure thing, which can confuse people whether the isolation
>> is successful.
>>
>> if (folio_isolate_lru(folio))
>>          continue;
>>
>> Moreover the page isolation functions only return 0 or -EBUSY, and
>> most users did not care about the negative error except for few users,
>> thus we can convert all page isolation functions to return a boolean
>> value, which can remove the confusion to make code more clear.
>>
>> No functional changes intended in this patch series.
>>
>> Changes from v1:
>>   - Convert all isolation functions to return bool.
> 
> Acked-by: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks.

> 
> Although it's controversial if
> 
> if (!ret)
>      ret = -EBUSY;
> else
>      ret = 0;
> 
> is really appealing to the readers eye :)
> 
> ret = ret ? 0 : -EBUSY;
> 
> It's still confusing.
> 
> would be better as
> 
> ret = isolated ? 0 : -EBUSY;
> 
> IOW, not reusing the "int ret" variable.

Yes, pretty clear. Will do in next version.
