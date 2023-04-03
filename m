From: hanjinke <hanjinke.666@bytedance.com>
Subject: Re: [External] Re: [PATCH v2] blk-throttle: Fix io statistics for
 cgroup v1
Date: Tue, 4 Apr 2023 01:56:51 +0800
Message-ID: <cb69bf15-6288-e5d9-08c9-cf64187ddd03@bytedance.com>
References: <20230401094708.77631-1-hanjinke.666@bytedance.com>
 <20230403153021.z4smxxnxbgdcgcey@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680544617;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zvbXO2zEiAAtifGVfeUKcNOUgXd8fePbZNqY6UemQus=;
        b=NeE9Wk2utSK19PXZCOaD49MN9bJsYQQCqJkMm5dFlVhQ4vvtd39tS83Ayte5UqNH/E
         hQkOpBGdzyonrza8zrN6BS+EBfh4tDDmQtDTvheNR37l0XGyERQg2SZKou3blg+q+vcY
         tIadtzWN0DsbYZ8vj716opgE5Ajw9eL2oXL5tJJCei7uAhysaZE4CZl/Nsrw3ykGoQya
         9EsCld/FHm1EPhsBWCFAjQRGc0NuV3z7k97Jj1l/TipicMXFBzU72JXBXv5uGzIm7GB5
         Fkr5tmml+hyc8WL47nSRDq4+7FNjAiiTAqenK0YtEagBNuL2pcirKdcqTqU4XSxq417Y
         lOnQ==
In-Reply-To: <20230403153021.z4smxxnxbgdcgcey@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org



在 2023/4/3 下午11:30, Michal Koutný 写道:
> On Sat, Apr 01, 2023 at 05:47:08PM +0800, Jinke Han <hanjinke.666@bytedance.com> wrote:
>> From: Jinke Han <hanjinke.666@bytedance.com>
>>
>> After commit f382fb0bcef4 ("block: remove legacy IO schedulers"),
>> blkio.throttle.io_serviced and blkio.throttle.io_service_bytes become
>> the only stable io stats interface of cgroup v1,
> 
> There is also blkio.bfq.{io_serviced,io_service_bytes} couple, so it's
> not the only. Or do you mean stable in terms of used IO scheduler?
> 

Oh, the stable here means that it always exists, and when the bfq 
scheduler is not used, the bfq interface may not exist.

>> and these statistics are done in the blk-throttle code. But the
>> current code only counts the bios that are actually throttled. When
>> the user does not add the throttle limit,
> 
> ... "or the limit doesn't kick in"
> 

Agree.

>> the io stats for cgroup v1 has nothing.
> 
> 
>> I fix it according to the statistical method of v2, and made it count
>> all ios accurately.
> 
> s/all ios/all bios and split ios/
> 
> (IIUC you fix two things)
> 
>> Fixes: a7b36ee6ba29 ("block: move blk-throtl fast path inline")
> 
> Good catch.
> 
> Does it also undo the performance gain from that commit? (Or rather,
> have you observed effect of your patch on v2-only performance?)
> 

Under v1, this statistical overhead is unavoidable. Under v2, the static 
key is friendly to judging branches, so I think the performance 
difference before and after the patch is negligible.

>> Signed-off-by: Jinke Han <hanjinke.666@bytedance.com>
>> ---
>>   block/blk-cgroup.c   | 6 ++++--
>>   block/blk-throttle.c | 6 ------
>>   block/blk-throttle.h | 9 +++++++++
>>   3 files changed, 13 insertions(+), 8 deletions(-)
> 
> The code looks correct.
> 
> Thanks,
> Michal

Thanks.

