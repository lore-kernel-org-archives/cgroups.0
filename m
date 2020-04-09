From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/5] block: add request->io_data_len
Date: Thu, 9 Apr 2020 08:08:59 +0300
Message-ID: <c2b362f5-36f6-116d-ddb5-2445d13d2bac@gmail.com>
References: <20200408201450.3959560-1-tj@kernel.org>
 <20200408201450.3959560-3-tj@kernel.org>
 <20200409014406.GA370295@localhost.localdomain>
 <20200409021119.GJ162390@mtj.duckdns.org>
 <20200409023857.GB370295@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p/HH0I63YdWRi6zlDYRvwzJ5V+QRFikbr1SYHN1Nt0w=;
        b=bxYr4H02EMVAhN2rr3PIeVwESTDIrZeTP52yl2v5asGqpo5KqQ277wQNnIA+SxyNtd
         MQEejIbkAofiSfIxf5nJg8rMNodVMULxPXtSiUdIx9t1H1v4PH6NOF2BZdINeNfhifrs
         rXXSfHkyBMu+OszMxJvBCNuLhRTB4NubYOd5lBIvQOgx8hHChIo4J+OCeLiVVDJ9qRwt
         8aWOYITlmaP6rRJHHo2bCJ7llA2vLaMCMyfodK/Qi+xKzPCRQSmlYsTlT1mT6MyNrrx4
         7HH3uqpmF9vOv1ibeM49KxFYH6aAoZZUJ5GuZ4yLlmWh1vwvi5wg15bVZXFoC0VF1qM3
         nbgQ==
In-Reply-To: <20200409023857.GB370295-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, newella-b10kYP2dOMg@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org

On 09/04/2020 05:38, Ming Lei wrote:
> On Wed, Apr 08, 2020 at 10:11:19PM -0400, Tejun Heo wrote:
>> On Thu, Apr 09, 2020 at 09:44:06AM +0800, Ming Lei wrote:
>>> Almost all __blk_mq_end_request() follow blk_update_request(), so the
>>> completed bytes can be passed to __blk_mq_end_request(), then we can
>>> avoid to introduce this field.
>>
>> But on some drivers blk_update_request() may be called multiple times before
>> __blk_mq_end_request() is called and what's needed here is the total number of
>> bytes in the whole request, not just in the final completion.
> 
> OK.
> 
> Another choice might be to record request bytes in rq's payload
> when calling .queue_rq() only for these drivers.
> 
>>
>>> Also there is just 20 callers of __blk_mq_end_request(), looks this kind
>>> of change shouldn't be too big.
>>
>> This would work iff we get rid of partial completions and if we get rid of
>> partial completions, we might as well stop exposing blk_update_request() and
>> __blk_mq_end_request().
> 
> Indeed, we can store the completed bytes in request payload, so looks killing
> partial completion shouldn't be too hard.

struct request already has such field (see @stats_sectors) because of the same
root-cause. I'd prefer killing it as well by following Ming's way, but otherwise
it could be easily adopted.

-- 
Pavel Begunkov
