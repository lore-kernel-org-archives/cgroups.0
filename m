From: hanjinke <hanjinke.666@bytedance.com>
Subject: Re: [External] Re: [PATCH] blk-throttle: Fix io statistics for cgroup
 v1
Date: Thu, 30 Mar 2023 11:44:04 +0800
Message-ID: <1a858cce-4d87-5e0a-9274-52cffde7dea6@bytedance.com>
References: <20230328142309.73413-1-hanjinke.666@bytedance.com>
 <ZCSJaBO8i5jQFC10@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680147850;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VQ0aOCOIHslwWeAUgUUQoRMNFdlJZ0p6oA7JcNsWsx0=;
        b=L+8iXJz7z6DpLY76k9YnkTN+Ng1+Vo9mPB+jC9SB7IjpmO3LMz4Hr/y+fOU2kxrSt+
         FUo2gaKnDsMwgrl42/7xi6Yh+80sOsLnGQJlkHW+UPYCjEkmPHWYkKn8ogJI9VoOckZJ
         yrZpbVrjX6iGVQySm59jzoash/p2C9KrcCptCZc0zcHSuynZrzsdJC3UkneRyzFsHpvK
         u1IyUNlALDXTxlvVbFCXDRHn4hJ9weygOneNpN82Hl3Ctb2woSJG/q263FQVbML4agrV
         +xxlKgb39kkYVwtYjxa+462WbzaSUeTkMecADWk1CVDYOUOHJms1FgGXJ0vQBnFwn6nH
         fU7w==
In-Reply-To: <ZCSJaBO8i5jQFC10@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org



在 2023/3/30 上午2:54, Tejun Heo 写道:
> On Tue, Mar 28, 2023 at 10:23:09PM +0800, Jinke Han wrote:
>> From: Jinke Han <hanjinke.666@bytedance.com>
>>
>> Now the io statistics of cgroup v1 are no longer accurate. Although
>> in the long run it's best that rstat is a good implementation of
>> cgroup v1 io statistics. But before that, we'd better fix this issue.
> 
> Can you please expand on how the stats are wrong on v1 and how the patch
> fixes it?
> 
> Thanks.
> 
Now blkio.throttle.io_serviced and blkio.throttle.io_serviced become the 
only stable io stats interface of cgroup v1, and these statistics are 
done in the blk-throttle code. But the current code only counts the bios 
that are actually throttled. When the user does not add the throttle 
limit, the io stats for cgroup v1 has nothing. I fix it according to the 
statistical method of v2, and made it count all ios accurately.

Thanks.
