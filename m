From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: Fix typo in comment
Date: Mon, 21 Nov 2022 10:01:52 +0800
Message-ID: <191a3853-70c5-b89e-0911-e046207876e5@shopee.com>
References: <20221120155134.57193-1-haifeng.xu@shopee.com>
 <819bdb10-2569-b7b1-b75b-168b77d1959f@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=McRhEbkJO4TzXUeiVWCG8MYZdpyYAh/UI0V02O72ffA=;
        b=EbJG7unhNaF/gUyUj4qAfK00TtL1GN9HurLGl/zwYmLVMkrGvboKfJiZhuUDzo8HVA
         y4g5YvzbCuOaXTRNGk0BXLhhqcvvO+EXOQMryhqNuZnrnyRWRY/Qg7jXG9uT+IBH/Fh9
         vgZyZxOVyJemEIdVp/5DmbICQ+iLM5CJjdh14olEhf789Z7895MyRp1MAzL9VEqbhwFf
         uL7X9B42yy0Fv4klFvrJReT74Vj4RVU5LiJpyWeN6yde0KuWYScOFjBMj9V/hNAHtrWT
         cZ5roky2c4+Nave/IzprJPWNOiBJeduXVBBmBCY7qzwBnBbyZDlPAkcMbJQFmfWwTW5U
         Wk9Q==
In-Reply-To: <819bdb10-2569-b7b1-b75b-168b77d1959f-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2022/11/21 00:38, Kamalesh Babulal wrote:
> 
> 
> On 11/20/22 21:21, haifeng.xu wrote:
>> Replace iff with if.
>>
>> Signed-off-by: haifeng.xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
>> ---
>>  kernel/cgroup/cgroup.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>> index f2743a476190..93c5e50b1392 100644
>> --- a/kernel/cgroup/cgroup.c
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -814,7 +814,7 @@ static bool css_set_populated(struct css_set *cset)
>>   * One of the css_sets associated with @cgrp is either getting its first
>>   * task or losing the last.  Update @cgrp->nr_populated_* accordingly.  The
>>   * count is propagated towards root so that a given cgroup's
>> - * nr_populated_children is zero iff none of its descendants contain any
>> + * nr_populated_children is zero if none of its descendants contain any
>>   * tasks.
>>   *
>>   * @cgrp's interface file "cgroup.populated" is zero if both
> 
> iff abbreviates to if and only if and it's a valid usage.
> 

Ok, thanks.
