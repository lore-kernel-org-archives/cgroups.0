From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH 9/9] sched/psi: add PSI_IRQ to track IRQ/SOFTIRQ pressure
Date: Wed, 27 Jul 2022 23:09:53 +0800
Message-ID: <0a1f7ce7-2869-c189-3703-89bff2198874@bytedance.com>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-10-zhouchengming@bytedance.com>
 <Yt7gOhbqYzIKyhfv@cmpxchg.org>
 <5f91e194-439a-12c0-4987-5dea0e68a60a@bytedance.com>
 <YuE26+jMjnE4GZZ2@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DejOeyc5Bty+6/iRLEMvFvVGs80thD2zi1F/z5KtilQ=;
        b=S4xk6iuqrK2V6O+FNHAsu2C7x4XJs+23oGUi5oHWTWQnBlli+yAG+HZmiWeLLlbpbM
         RtHNKyzYNQ98X6FHE7uMEGImP/fIXqGsdoSBUoLrmG1K2yz3+KjnFpBbq2yvEkc/tlWn
         zUTEw1Sl3/zTmYldqoh6SVe8Zabq4bwGO6R++U5wbsWMatVsJ3lWm7r72s1N0W31yKiC
         gz2M30fO7at6a+e80cvKZaQ9wByQaqZgUHjfyGOJUxVy6NoZKYyJAP3nEHZkbYXOjMJu
         qmDLVLKFFge0qg9+DNv4gYYiAzMT2+1fUuDMBSqcFglBV4wbKrWaxKIK6ZdRgTO08ldB
         Pb9g==
Content-Language: en-US
In-Reply-To: <YuE26+jMjnE4GZZ2@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: surenb@google.com, mingo@redhat.com, peterz@infradead.org, tj@kernel.org, corbet@lwn.net, akpm@linux-foundation.org, rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, cgroups@vger.kernel.org

On 2022/7/27 21:00, Johannes Weiner wrote:
> On Wed, Jul 27, 2022 at 07:28:37PM +0800, Chengming Zhou wrote:
>> On 2022/7/26 02:26, Johannes Weiner wrote:
>>> I think we can remove the NR_CPU task count, which frees up one
>>> u32. Something like the below diff should work (untested!)
>>
>> Hi, I tested ok, would you mind if I put this patch in this series?
>>
>> Subject: [PATCH] sched/psi: remove NR_ONCPU task accounting
>>
>> We put all fields updated by the scheduler in the first cacheline of
>> struct psi_group_cpu for performance.
>>
>> Since we want add another PSI_IRQ_FULL to track IRQ/SOFTIRQ pressure,
>> we need to reclaim space first. This patch remove NR_ONCPU task accounting
>> in struct psi_group_cpu, use TSK_ONCPU in state_mask to track instead.
> 
> Thanks for testing it, that sounds good.
> 
>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>> Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
>> Tested-by: Chengming Zhou <zhouchengming@bytedance.com>
> 
> Since you're handling the patch, you need to add your own
> Signed-off-by: as well. And keep From: Johannes (git commit --author).

Got it. Thanks!

