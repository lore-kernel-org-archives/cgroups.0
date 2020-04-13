From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHSET v2 block/for-5.8] iocost: improve use_delay and latency
 target handling
Date: Mon, 13 Apr 2020 21:49:12 +0300
Message-ID: <5d2e4017-563b-4a2e-58d7-7af6e3183569@gmail.com>
References: <20200413162758.97252-1-tj@kernel.org>
 <dd55f890-740c-16b5-77bd-4c6fdb710b3d@gmail.com>
 <6f69d35c-c593-f140-c351-c7fd2c13069e@gmail.com>
 <20200413170833.GD60335@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ypxii2YE5TJTFobtoZ3bxlwCYM5c9IgWRJHcbubUIFk=;
        b=stGWxXpq1iqGKETDz+BqkKspCAA8HAaoSsEoFBqNgOSwYmGZYnCOQ48O/wxD8RI/eG
         L/lwKPwRpo6mgoDpzKKR7nqgyt3Jzh+NNTW6mBGX0QjsDmNzBqhGKu5JADbHNVEbr85e
         wR6/09CEZpUKuNeMqwClEXulk5fCbTmNPT2fCxZ5oWOJENPwZNn22/TD/pjtwolQ0IZV
         JEkVQYSu5uifIrCsBUL89UU+qeBwSXTNEeDNIp64SaIJhi+OwEsJjiBgagZwla1Sfu9j
         B6GkxpaiS9dtPWgr8rmSOT1t7HIKq1cV5539hC491XOJGGlHTi+YIY4LLJ+nioXfvGQP
         iw4g==
In-Reply-To: <20200413170833.GD60335-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, newella-b10kYP2dOMg@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org

On 13/04/2020 20:08, Tejun Heo wrote:
> On Mon, Apr 13, 2020 at 08:00:29PM +0300, Pavel Begunkov wrote:
>> On 13/04/2020 19:56, Pavel Begunkov wrote:
>>> On 13/04/2020 19:27, Tejun Heo wrote:
>>>> Changes from v1[1]
>>>>
>>>> * Dropped 0002-block-add-request-io_data_len.patch and updated to use
>>>>   rq->stats_sectors instead as suggested by Pavel Begunkov.
>>>
>>> rq->stats_sectors is set only when there is QUEUE_FLAG_STATS, see
>>> blk_mq_start_request(). I don't see blk-iocost requiring it. Did I miss something?
>>
>> And there is no reason to not initialise it unconditionally.
> 
> The updated patch turns on accounting when iocost is enabled on a queue.

Great. FWIW, if you don't really need accounting, it'd be IMHO more robust and
with less overhead just to do this ->stats_sectors assignment unconditionally.

> 
>   @@ -2267,6 +2295,7 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
>    	spin_lock_irq(&ioc->lock);
>  
>    	if (enable) {
>   +		blk_stat_enable_accounting(ioc->rqos.q);
>    		blk_queue_flag_set(QUEUE_FLAG_RQ_ALLOC_TIME, ioc->rqos.q);
>    		ioc->enabled = true;
>    	} else {
> 
> Thanks.
> 

-- 
Pavel Begunkov
