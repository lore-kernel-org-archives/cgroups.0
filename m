From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: Remove unnecessary rcu_read_lock/unlock()
Date: Wed, 18 May 2022 16:31:53 -0600
Message-ID: <de6b0f81-67e1-b167-a618-193c2303f149@kernel.dk>
References: <20220516173930.159535-1-bh1scw@gmail.com>
 <CGME20220518192850eucas1p1458c00d4917c5ed39f2c37c9eb30cd46@eucas1p1.samsung.com>
 <46253c48-81cb-0787-20ad-9133afdd9e21@samsung.com>
 <1dad86bb-ae31-5bf8-5810-9e81c68be8ff@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=thG3qSgnZW+qUMLaaxOPkQALuH6P7RbZ23MHltmMGlE=;
        b=AQkqPj3D0tdfs64sN8mLJd9diiGRGQDbqzoTBkPKxEszGHSW23pLd3DZLq1t7J1BaH
         N9Dc9tw3fZhqvdD7K5lreOPHKrd45AK941vaNu1U6kmB0u/LHeGMLIh4oh/lBCmsuM/R
         nT++BAX42jIVpVd2Cbc0IDNOSqTH4QxG9Nid9TMDGCoIPhTqZxONNkMk58Jq/wMtOPZn
         FR121zdv/+aGTq1DPhIOuVGzvj3hKtit/Buc/d9k5941ePSeMzytuGUKs98ffe6KJ8yI
         O4tYIxZQsAbIvPWbv/KXPvXLRccYsR4v+/q7YR/qrq7ooDJjsiO24fAzsrF642GuT1FQ
         Z4rg==
Content-Language: en-US
In-Reply-To: <1dad86bb-ae31-5bf8-5810-9e81c68be8ff-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, bh1scw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On 5/18/22 4:29 PM, Jens Axboe wrote:
> On 5/18/22 1:28 PM, Marek Szyprowski wrote:
>> On 16.05.2022 19:39, bh1scw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>>> From: Fanjun Kong <bh1scw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>
>>> spin_lock_irq/spin_unlock_irq contains preempt_disable/enable().
>>> Which can serve as RCU read-side critical region, so remove
>>> rcu_read_lock/unlock().
>>>
>>> Signed-off-by: Fanjun Kong <bh1scw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> This patch landed in today's linux next-20220518 as commit 77c570a1ea85 
>> ("blk-cgroup: Remove unnecessary rcu_read_lock/unlock()").
>>
>> Unfortunately it triggers the following warning on ARM64 based Raspberry 
>> Pi 4B board:>
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 1 at block/blk-cgroup.c:301 blkg_create+0x398/0x4e0
> 
> Should this use rcu_read_lock_any_held() rather than
> rcu_read_lock_held()?

I think the better alternative is just to delete the WARN_ON(), we have
a:

lockdep_assert_held(&q->queue_lock);

right after it. Since the queue_lock is IRQ disabling, having two checks
serves no purpose. I'll kill the line.

-- 
Jens Axboe

