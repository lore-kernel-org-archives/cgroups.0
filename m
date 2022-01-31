From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 1/3] mm, memcg: Don't put offlined memcg into local stock
Date: Mon, 31 Jan 2022 12:09:09 -0500
Message-ID: <95ba1931-e9c9-45c3-b080-d28f2ad368a7@redhat.com>
References: <20211001190938.14050-1-longman@redhat.com>
 <20211001190938.14050-2-longman@redhat.com>
 <YVefHLo1+6lgw3aB@carbon.dhcp.thefacebook.com>
 <f7026256-4086-6632-569e-5b13594cb3fc@redhat.com>
 <YfgV2iiaVlR0hozD@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643648957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PpD0uApcfwaKszXDeNoEeoH+yx2tV+uOCx5g0+GZxx0=;
        b=cnUVnqyqY5mWvv3F7EZaxTeGGHkdsCFvAdYGk2eLeFfr2Boba7X9Bc285eldbzT0Fq00Vz
        XzNxju0vl8OMCuAcWHHmpijW7zS1BWXtvlbURm9CZzxpgYmp6EEm4AGgxTswVqr6TKdCUV
        v2qGUf3SgG733KdO4DWo26WtYtK+vVQ=
Content-Language: en-US
In-Reply-To: <YfgV2iiaVlR0hozD@carbon.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>

On 1/31/22 12:01, Roman Gushchin wrote:
> On Sun, Jan 30, 2022 at 10:55:56PM -0500, Waiman Long wrote:
>> On 10/1/21 19:51, Roman Gushchin wrote:
>>> On Fri, Oct 01, 2021 at 03:09:36PM -0400, Waiman Long wrote:
>>>> When freeing a page associated with an offlined memcg, refill_stock()
>>>> will put it into local stock delaying its demise until another memcg
>>>> comes in to take its place in the stock. To avoid that, we now check
>>>> for offlined memcg and go directly in this case to the slowpath for
>>>> the uncharge via the repurposed cancel_charge() function.
>>> Hi Waiman!
>>>
>>> I'm afraid it can make a cleanup of a dying cgroup slower: for every
>>> released page we'll potentially traverse the whole cgroup tree and
>>> decrease atomic page counters.
>>>
>>> I'm not sure I understand the benefits we get from this change which
>>> do justify the slowdown on the cleanup path.
>>>
>>> Thanks!
>> I was notified of a lockdep splat that this patch may help to prevent.
> Would you mind to test this patch:
> https://www.spinics.net/lists/cgroups/msg31244.html ?
>
> It should address this dependency.

Thanks for the pointer. I believe that your patch should be able to 
address this circular locking dependency.

Feel free to add my

Reviewed-by: Waiman Long <longman@redhat.com>

Cheers,
Longman

