From: David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v2 0/4] Change the return value for page isolation
 functions
Date: Tue, 14 Feb 2023 18:52:49 +0100
Message-ID: <5064ee08-792f-14f2-6f2d-26e81af8a239@redhat.com>
References: <cover.1676382188.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676397174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3wcl/mIBo22eXMS7cK2NpuJ4cYApHgRaBD0p8jlitp0=;
        b=af4G+Z83bFhYKqytrCIrlYfFnY1GWw4b11XqNPVmAqCiZIAYtESX9NjwAbMUDtyxhEN6Hg
        pYpHT9wUS+V0EK0YVceN5PSo2LxA5RiZOIReZsYm7sDg3PVfVOV56gjpnOFGql4dWytKHX
        F8HqPjYNpfpRS8ig3BnRSE4SfJyxqMU=
Content-Language: en-US
In-Reply-To: <cover.1676382188.git.baolin.wang@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, sj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, naoya.horiguchi@nec.com, linmiaohe@huawei.com, osalvador@suse.de, mike.kravetz@oracle.com, willy@infradead.org, damon@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On 14.02.23 14:59, Baolin Wang wrote:
> Now the page isolation functions did not return a boolean to indicate
> success or not, instead it will return a negative error when failed
> to isolate a page. So below code used in most places seem a boolean
> success/failure thing, which can confuse people whether the isolation
> is successful.
> 
> if (folio_isolate_lru(folio))
>          continue;
> 
> Moreover the page isolation functions only return 0 or -EBUSY, and
> most users did not care about the negative error except for few users,
> thus we can convert all page isolation functions to return a boolean
> value, which can remove the confusion to make code more clear.
> 
> No functional changes intended in this patch series.
> 
> Changes from v1:
>   - Convert all isolation functions to return bool.

Acked-by: David Hildenbrand <david@redhat.com>

Although it's controversial if

if (!ret)
	ret = -EBUSY;
else
	ret = 0;

is really appealing to the readers eye :)

ret = ret ? 0 : -EBUSY;

It's still confusing.

would be better as

ret = isolated ? 0 : -EBUSY;

IOW, not reusing the "int ret" variable.

-- 
Thanks,

David / dhildenb

