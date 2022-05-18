From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-cgroup: Remove unnecessary rcu_read_lock/unlock()
Date: Wed, 18 May 2022 16:29:35 -0600
Message-ID: <1dad86bb-ae31-5bf8-5810-9e81c68be8ff@kernel.dk>
References: <20220516173930.159535-1-bh1scw@gmail.com>
 <CGME20220518192850eucas1p1458c00d4917c5ed39f2c37c9eb30cd46@eucas1p1.samsung.com>
 <46253c48-81cb-0787-20ad-9133afdd9e21@samsung.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GHsUE9N7qwGKPhSfb7FLSZbI7huX80ouMGDrIjhw1Uk=;
        b=tok1tK7PAPs2jl/A5+MZDuzJGG74i7qajPVXyIwM3P53jmWgJKGEW7xAVxKnCBpMuW
         BnKA1MeavVlAHM+qmVYN405lR1GJKzR3fFBXM+n9IgkNThCrONTNOshTDllOgV0aSm2S
         bpSoI4pRydA/Nn0a0wlg8oLEhiZYRUn3g4325mDVoqBkb0dNlvbTWfaHzn7ZNlNUotWk
         lNm6knKRwz6jFbdE+onYhm26Cb5FxhurSbjVKHHpKViUX4kmpXEpRm4R4Hv64WsaZg+D
         s5CpNv4rgXS9RqIgdp3zMSXg1UwgClwDlEWUmWfSEUD++9eq0DBNYmbksnJwUu9qNd6E
         qINQ==
Content-Language: en-US
In-Reply-To: <46253c48-81cb-0787-20ad-9133afdd9e21@samsung.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Marek Szyprowski <m.szyprowski@samsung.com>, bh1scw@gmail.com, tj@kernel.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com

On 5/18/22 1:28 PM, Marek Szyprowski wrote:
> On 16.05.2022 19:39, bh1scw@gmail.com wrote:
>> From: Fanjun Kong <bh1scw@gmail.com>
>>
>> spin_lock_irq/spin_unlock_irq contains preempt_disable/enable().
>> Which can serve as RCU read-side critical region, so remove
>> rcu_read_lock/unlock().
>>
>> Signed-off-by: Fanjun Kong <bh1scw@gmail.com>
> 
> This patch landed in today's linux next-20220518 as commit 77c570a1ea85 
> ("blk-cgroup: Remove unnecessary rcu_read_lock/unlock()").
> 
> Unfortunately it triggers the following warning on ARM64 based Raspberry 
> Pi 4B board:>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at block/blk-cgroup.c:301 blkg_create+0x398/0x4e0

Should this use rcu_read_lock_any_held() rather than rcu_read_lock_held()?

-- 
Jens Axboe

