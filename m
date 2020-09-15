From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH 0/5] Some improvements for blk-throttle
Date: Tue, 15 Sep 2020 12:17:57 -0600
Message-ID: <c36a1c1b-ca46-13c8-42eb-94e63ff845d1@kernel.dk>
References: <cover.1599458244.git.baolin.wang@linux.alibaba.com>
 <822998a7-4cc7-88ee-8b3f-e8e7660a5b0a@kernel.dk>
 <20200915085926.GA122937@VM20190228-100.tbsite.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bTTRD0/irNQCd03woygzg2YIc3JV44oMGNS2xdYHnuY=;
        b=oMdFH0qeR7ktNNSHnOFu0cnxSyqibVe5Xfhe2tBaiWKuUcg1GDfeVU/qMzK149v5K+
         iK0oQoF39aDYeONrDyDjZS59ruDFyIryDGNrD04kboLa7s9/T2DfrPvNZ5mWtnsUkKVL
         wGRPpofseOHZAXio+PZGs0lAxHmN2RrQUMM55FmC4GuBfqFk6vs/rdl67En8WyxSWjxW
         3H3o+eCZ/0wMTcov8J54w+bE6IFxngx5LeFTF0V4ivTjpkp8ZfjwQtktOH8V2XBotEpH
         qQPHM+S0mkUvPlV3hkhPxbpIp5SEt/s2xbVoAaBbZYT9AHlf2HEqGHcTeYP3nfBbEY13
         w2SQ==
In-Reply-To: <20200915085926.GA122937-PSVAw9Ne/48PSk46DbOZ3sID7SEwvUJKXqFh9Ls21Oc@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, baolin.wang7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 9/15/20 2:59 AM, Baolin Wang wrote:
> Hi Jens,
> 
> On Mon, Sep 14, 2020 at 07:37:53PM -0600, Jens Axboe wrote:
>> On 9/7/20 2:10 AM, Baolin Wang wrote:
>>> Hi All,
>>>
>>> This patch set did some clean-ups, as well as removing some unnecessary
>>> bps/iops limitation calculation when checking if can dispatch a bio or
>>> not for a tg. Please help to review. Thanks.
>>>
>>> Baolin Wang (5):
>>>   blk-throttle: Fix some comments' typos
>>>   blk-throttle: Use readable READ/WRITE macros
>>>   blk-throttle: Define readable macros instead of static variables
>>>   blk-throttle: Avoid calculating bps/iops limitation repeatedly
>>>   blk-throttle: Avoid checking bps/iops limitation if bps or iops is    
>>>     unlimited
>>>
>>>  block/blk-throttle.c | 59 ++++++++++++++++++++++++++++++++--------------------
>>>  1 file changed, 36 insertions(+), 23 deletions(-)
>>
>> Looks reasonable to me, I've applied it.
> 
> Thanks.
> 
>>
>> Out of curiosity, are you using blk-throttle in production, or are these
>> just fixes/cleanups that you came across?
> 
> Yes, we're using it in some old products, and I am trying to do some
> cleanups and optimizaiton when testing it.

Gotcha. Reason I ask is I've been considering deprecating it, but when
fixes come in for something, that always makes me think that some folks
are actually using it.

-- 
Jens Axboe

