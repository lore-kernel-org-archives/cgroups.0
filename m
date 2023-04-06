From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH 1/4] block, bfq: remove BFQ_WEIGHT_LEGACY_DFL
Date: Thu, 6 Apr 2023 22:34:09 +0800
Message-ID: <4cb0dfbc-d546-ed1e-b951-e37104a3f691@bytedance.com>
References: <20230328145701.33699-1-zhouchengming@bytedance.com>
 <ZCSKirFH8f1JdQS2@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680791657;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u6B8WILcVPZkFHn7fuQhYBzfHKFx9fU8cwkns1fF9d0=;
        b=AIbzpnMbfgEcISAfvM0ZqDPjxCflIy7Bjr+w8Hoa9c4tyfutVUcOuhVy1uPqDCLN8o
         l2hXaWvIar5w34wTkmMTh916W5QufMl6gYWrBx84ksfKr5V0t1J46nv8NyAAgiMxooYH
         WWKwUSngOqDNX7gSnTmn1D3C9FpkFUV2eC6w69VAeEVKFX9YvDNYhB5ORZs+gPdAkeKR
         NA7oG+YnIn0VJIgaxex2cbj/BzhIlpmNbjOwjJL8NdWMD5QzdXUPiBJePwezcKHZbwgu
         BIZaG0rdrX3djh3P4C2XAfMXCQsU3jWticdWb0wXVg4WbhYgQGwpdeEfeYze+HJb4qNR
         uEPw==
Content-Language: en-US
In-Reply-To: <ZCSKirFH8f1JdQS2@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: paolo.valente@linaro.org, axboe@kernel.dk, josef@toxicpanda.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 2023/3/30 02:59, Tejun Heo wrote:
> On Tue, Mar 28, 2023 at 10:56:58PM +0800, Chengming Zhou wrote:
>> BFQ_WEIGHT_LEGACY_DFL is the same as CGROUP_WEIGHT_DFL, which means
>> we don't need cpd_bind_fn() callback to update default weight when
>> attached to a hierarchy.
>>
>> This patch remove BFQ_WEIGHT_LEGACY_DFL and cpd_bind_fn().
>>
>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> 
> For 1-3,
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Thanks.
> 

Thanks, I will drop the last patch and send v2 with the tag.

