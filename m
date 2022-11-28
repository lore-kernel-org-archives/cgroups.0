From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH-block] blk-cgroup: Use css_tryget() in
 blkcg_destroy_blkgs()
Date: Mon, 28 Nov 2022 12:08:47 -0700
Message-ID: <0390c62d-11d9-5d89-ad88-db38526b74e6@kernel.dk>
References: <20221128033057.1279383-1-longman@redhat.com>
 <d08a0059-7c0b-d65f-d184-5b0cb75c08ed@acm.org>
 <f89e922c-16d5-0bcf-7e7e-096f42793a36@kernel.dk>
 <Y4UG9H9QsMnCvN+D@smile.fi.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vdiFLWGJlZNZEhU3chxdhx2hGdjjeSZKpnJnffDHCx4=;
        b=Q5XoN2CjIrbe+48L5bUfjZfu0U8JKd099j/FY7bwNTUH3aWmw9cAnqT8EgROl9fO4C
         qOJNJTIm54HvYo6ESRa+AGqTKFtczOfLgtde/tjYAQUNfe4U748t/psuR81Mo6eR6XDK
         sXlXiUBIXotQbcclPXQsaJq4Z9p3B5Dj4QF7c2XCk+w+z7/wrBnMz2rI26+IzJPJmuGO
         JKaYF8JhouN3XgWuhpIqqQ6dEd1oqnjkTbX4EWZ5r+qE4YJcamhZhJhQO252DrRpLJS/
         +shfuyh0O9KPr6c/aUrEpA6d1zQ2Pt/J0pfypcEynvs9EKZn9rve8Xm4ZoTR7+fcJ4XX
         7FTw==
Content-Language: en-US
In-Reply-To: <Y4UG9H9QsMnCvN+D@smile.fi.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Hillf Danton <hdanton@sina.com>, Yi Zhang <yi.zhang@redhat.com>

On 11/28/22 12:07 PM, Andy Shevchenko wrote:
> On Mon, Nov 28, 2022 at 12:00:55PM -0700, Jens Axboe wrote:
>> On 11/28/22 11:56 AM, Bart Van Assche wrote:
>>> On 11/27/22 19:30, Waiman Long wrote:
>>>> Fixes: 951d1e94801f ("blk-cgroup: Flush stats at blkgs destruction path")
>>>
>>> Has Jens' for-next branch perhaps been rebased? I see the following commit ID for that patch:
>>>
>>> dae590a6c96c ("blk-cgroup: Flush stats at blkgs destruction path")
>>
>> I don't know that sha is from, not from me. for-6.2/block has not been
>> rebased, for-next gets rebased whenever I need to do so as linux-next is
>> continually rebased anyway. But the sha for that commit would not change
>> as a result.
>>
>> I don't even have that sha in my tree, so...
> 
> $ git tag --contains dae590a6c96c
> next-20221117
> next-20221118
> next-20221121
> next-20221122
> next-20221123
> next-20221124
> next-20221125
> next-20221128

That is the right sha, I'm talking about the fixes line in the
patch you're replying to:

Fixes: 951d1e94801f ("blk-cgroup: Flush stats at blkgs destruction path")

which is certainly not from my tree.

-- 
Jens Axboe


