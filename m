From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH] blk-throttle: verify format of bandwidth limit and detect
 overflows
Date: Tue, 5 Mar 2019 20:27:38 +0300
Message-ID: <8854733a-8724-d4d1-da37-48717b05a42a@yandex-team.ru>
References: <155125474480.292717.11530762471075713387.stgit@buzz>
 <20190305155631.GC50184@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1551806858; bh=SHMSe0BDUm7rTH2OZfSxE/ZaTpJiliYBzSWNaqaUXTY=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=tDJLPYS1loEp0aC1r9BJoM6xeYPqeLJOrgmqsG8vRcRtgBk1E0k/nDjfoMJUlgLOq
         +0LV8oZVsopSRE51WPExwANwgaLbQKLsWD3ThUy8Z8xC/a6kXL3+QQztJXshP7T0L5
         gVKtaISq7uPC0Dk05k3RUthG1UckTGlmEaPA6ccw=
In-Reply-To: <20190305155631.GC50184@devbig004.ftw2.facebook.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

On 05.03.2019 18:56, Tejun Heo wrote:
> Hello, Konstantin.
> 
> On Wed, Feb 27, 2019 at 11:05:44AM +0300, Konstantin Khlebnikov wrote:
>> Unlike to memory cgroup blkio throttler does not support value suffixes.
>>
>> It silently ignores everything after last digit. For example this command
>> will set rate limit 1 byte per second rather than 1 megabyte per second:
>>
>> # echo "7:0 1M" > blkio.throttle.read_bps_device
>> # cat blkio.throttle.read_bps_device
>> 7:0 1
>>
>> Cgroup2 interface has the same flaw:
>>
>> # echo "7:0 rbps=1M" > io.max
>> # cat io.max
>> 7:0 rbps=1 wbps=max riops=max wiops=max
>>
>> Also sscanf does not care much about overflows.
>>
>> This patch uses modern function kstrtou64 for parsing.
>> It rejects trailing garbage and detects integer overflows.
>>
>> Also this patch handles iops limit overflows for cgroup-v1 in the same as
>> cgroup-v2: limits >= UINT_MAX becomes unlimited.
>>
>> Fixes: 2ee867dcfa2e ("blkcg: implement interface for the unified hierarchy")
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> 
> So, I'd much rather keep the parsing implementations simple.  Unless
> there's a correctness problem (you mentioned overflowing, how would
> that happen?), the simpler the better.  I don't think the kernel needs
> to be in the business of strict input verification here.

This is inconsistency between controllers. IO controller should either
accept size suffixes or reject them. Ignoring garbage is not an option.
To be honest, I've successfully shot in the foot by bps limit "1M".

Integer overflows are happens when userspace software uses floats for data
representation and calculations. This way values bigger than 2^32-1 or
2^64-1 could appear easily in text representation.

Almost all integer knobs in sysctl and sysfs use modern kstrtoXX functions
with strict validation of format and overflows.

> 
> Thanks.
> 
