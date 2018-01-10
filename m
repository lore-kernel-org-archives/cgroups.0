From: xuejiufei <xuejiufei@gmail.com>
Subject: Re: [RFC PATCH] blk-throttle: dispatch more sync writes in block
 throttle layer
Date: Wed, 10 Jan 2018 09:44:43 +0800
Message-ID: <37158a6a-ff0d-10e7-c39b-9d588b5f50d2@gmail.com>
References: <f6f59e3c-456a-8275-8af0-32e4f2e5cdd6@gmail.com>
 <20180108120742.GJ3668920@devbig577.frc2.facebook.com>
 <5ff01c31-5277-909f-4c35-9b9be513d8e1@gmail.com>
 <20180109145659.GG3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lYymnx7swErdUoSm09GtchnzsEyrFwmUkGfnWPoVWDc=;
        b=bxNYZ/ZfZhLUPrQpLIA0XAH/UE8Qw53nJsGcxxQbkDCBNWHUb/rCeDOnL9xp7kmfnk
         Vd9P38VmZ7WvFY+i7YvOJXh2FI2wujVn9cO1y8+EHF11BnY4DGVy0YlRLjQlSe8TrcUm
         PNco3wSi/FNtlMH9ScKs4DjSdCwl4tEUuGOkj1ssp5My1VdpQFJZnSVRxa8CtexWsYLL
         CwZa8G9PFDXELvZfySRG6JZXV288H7HnA4XQGuNnMVnfpKdQKGP38PlM3gJ4Gjo6K0e7
         WiwUa7dIqXiQHjsOO4jkj24SoFDch3ErYMb8K/YdVMpg71rQhdH6S8tj26EfYeGy9KZk
         /BFQ==
In-Reply-To: <20180109145659.GG3668920@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@fb.com>, Shaohua Li <shli@kernel.org>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, jinli.zjl@alibaba-inc.com, qijiang.qj@alibaba-inc.com

Hi Tejun,

On 2018/1/9 下午10:56, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jan 09, 2018 at 12:45:13PM +0800, xuejiufei wrote:
>> 1. A bio is charged according to the direction, if we put the reads
>> and sync writes together, we need to search the queue to pick a
>> certain number of read and write IOs when the limit is not reached.
> 
> Ah, you're right.
> 
>> 2. I found that the multi-queue scheduler kyber also has three queues:
>> one for read, one for sync write and one for others. This patch
>> introduces another queue for async writes and others just like kyber.
> 
> Yeah, it'd make sense to make that a separate queue then.
> 
Could you please review this patch and give some advice?

Thanks.
Jiufei Xue

> Thanks.
> 
