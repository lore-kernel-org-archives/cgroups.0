From: hanjinke <hanjinke.666@bytedance.com>
Subject: Re: [External] Re: [PATCH] blk-throttle: Fix io statistics for cgroup
 v1
Date: Fri, 31 Mar 2023 11:00:33 +0800
Message-ID: <6128380c-b148-cb7e-44d5-0bd7d05a2942@bytedance.com>
References: <20230328142309.73413-1-hanjinke.666@bytedance.com>
 <ZCSJaBO8i5jQFC10@slm.duckdns.org>
 <1a858cce-4d87-5e0a-9274-52cffde7dea6@bytedance.com>
 <ZCY7EoAUqfB0ac8S@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680231639;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AMrP2Zp/EKlqbziL+FgCOqPjH/auJOar/Bw7xvN0IJw=;
        b=gFLNd4ejWBxSDzU4aEgXUTu5XK7W5N8DYIf8y981jAiIl1PPhf0gQNwn/L7fY8o8Md
         GzCyVbfJEEy/JWxGYXiht+V4N/+fmTClBVFIuAb6szfd5tNfLkYBw1YNTx2czLm2sI/4
         LcWKYMZvb5xYSRjGmgeCQ85FAdWUc+Df9EGS63HjvDKh3crs1/lOjOR7uTf5jUjUrq5k
         cPnJx6PMlORh0s/D/pBuw61Y2/NN+GOsJ2tQ5p/TrXz7Y/mQIXZHi8xi5J/D+mhr1SvN
         iFKRECz2VC/NXpimQsG6Sf6YMmLfu9tL7zZkXzQAYPPhdz5i+P15KxHZ50QexXZjWeLk
         DgYQ==
In-Reply-To: <ZCY7EoAUqfB0ac8S@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org



在 2023/3/31 上午9:44, Tejun Heo 写道:
> Hello,
> 
> On Thu, Mar 30, 2023 at 11:44:04AM +0800, hanjinke wrote:
>> 在 2023/3/30 上午2:54, Tejun Heo 写道:
>>> On Tue, Mar 28, 2023 at 10:23:09PM +0800, Jinke Han wrote:
>>>> From: Jinke Han <hanjinke.666@bytedance.com>
>>>>
>>>> Now the io statistics of cgroup v1 are no longer accurate. Although
>>>> in the long run it's best that rstat is a good implementation of
>>>> cgroup v1 io statistics. But before that, we'd better fix this issue.
>>>
>>> Can you please expand on how the stats are wrong on v1 and how the patch
>>> fixes it?
>>>
>>> Thanks.
>>>
>> Now blkio.throttle.io_serviced and blkio.throttle.io_serviced become the
> 
> "now" might be a bit too vague. Can you point to the commit which made the
> change?
> 
>> only stable io stats interface of cgroup v1, and these statistics are done
>> in the blk-throttle code. But the current code only counts the bios that are
> 
> Ah, okay, so the stats are now updated by blk-throtl itself but
> 
>> actually throttled. When the user does not add the throttle limit, the io
>> stats for cgroup v1 has nothing. I fix it according to the statistical
>> method of v2, and made it count all ios accurately.
> 
> updated only when limits are configured which can be confusing. Makes sense
> to me. Can you please update the patch description accordingly?
> 
> Also, the following change:
> 
> @@ -2033,6 +2033,9 @@ void blk_cgroup_bio_start(struct bio *bio)
>          struct blkg_iostat_set *bis;
>          unsigned long flags;
> 
> +       if (!cgroup_subsys_on_dfl(io_cgrp_subsys))
> +               return;
> +
>          /* Root-level stats are sourced from system-wide IO stats */
>          if (!cgroup_parent(blkcg->css.cgroup))
>                  return;
> 
> seems incomplete as there's an additional
> cgroup_subsys_on_dfl(io_cgrp_subsys) test in the function. We probably wanna
> remove that?
> 
> Thanks.
> 

okay, according to your suggestion, I will send a v2.

Thanks
