From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v9 3/3] blk-cgroup: Flush stats at blkgs destruction path
Date: Fri, 4 Nov 2022 16:21:50 -0400
Message-ID: <17047545-2993-f59b-2dbe-ccc997599ea1@redhat.com>
References: <20221104182050.342908-1-longman@redhat.com>
 <20221104182050.342908-4-longman@redhat.com>
 <Y2VvboMSxgF0pYpX@slm.duckdns.org>
 <84fd6656-d133-b9df-c39e-fbb3a1f4a873@redhat.com>
 <Y2VyWDvtwOsMBcKB@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667593317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IQUjE5P5kUgI2AUaH5ZmnOzKErlp1CyVjP3BJnMtrps=;
        b=V+fpzqxBAXLlrc3Iag7AP1GnsRg+Yjvor+0IDaF4hG4WqzuHN0pbQPcftwHYvF/8a2Th0M
        OVzWpCih7r+RrM5fEa327s3Hx6zLmO6uhP4E3Ek43gitNzJ4mTLFrlyc+G8TIeFeKe44UU
        UXY+Y7ONc0jnEbIuyTk2wHNTzrS5gYQ=
Content-Language: en-US
In-Reply-To: <Y2VyWDvtwOsMBcKB@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Hillf Danton <hdanton@sina.com>


On 11/4/22 16:13, Tejun Heo wrote:
> On Fri, Nov 04, 2022 at 04:12:05PM -0400, Waiman Long wrote:
>> I should have named the function cgroup_rstat_css_cpu_flush() to indicate
>> that the cpu is a needed parameter. We can have a cgroup_rstat_css_flush()
>> in the future if the need arises.
>>
>> It is an optimization to call this function only if the corresponding cpu
>> has a pending lockless list. I could do cpu iteration here and call the
>> flushing function for all the CPUs. It is less optimized this way. Since it
>> is a slow path, I guess performance is not that critical. So I can go either
>> way. Please let me know your preference.
> Yeah, cpu_flush is fine. Let's leave it that way.
>
Will do.

Cheers,
Longman

