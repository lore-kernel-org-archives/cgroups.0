From: hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [RFC PATCH] blk-throtl: Introduce sync queue for
 write ios
Date: Tue, 13 Dec 2022 11:55:16 +0800
Message-ID: <f42d81c1-47c8-e283-1259-8c554bf46c46@bytedance.com>
References: <20221206163826.10700-1-hanjinke.666@bytedance.com>
 <Y5et48VryiKgL/eD@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fYjaVxJ8zzYY/wcJIpDE24JVFr7zT7qIcwbkFsHmVvs=;
        b=QWEx+gZ2PhKWDG0bgn2LpnDM2ERwR0BtZxJCkzyxSMzyqp91gjIp9nztK75ZbkIZGj
         fH+BckFZpqbGaNDMTQvYT0GjUCFDXpaT9Q68Pqcq8dg87e9Ubp7zgxs06kgGcFtsyM6v
         X+wXRVQqk0dEG5RCr0OeSEf6bWScfcfyi88jC3lI9JU6yW0Z8Or3q7+HwHvcgd1s0nNK
         wTC98sUh2PBmkmNZy9lWh+6vpPmvAMXTOmE+8Y4uVxaELC/6Rbstvc0upqU86ZS0yVxa
         Bqdux28uMNN0+pHpHGZyd4FihPpyg7GALCAh4lAEqE2oXwGEZTmtq4DJPSqfab7wzTqI
         lRKA==
In-Reply-To: <Y5et48VryiKgL/eD-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



在 2022/12/13 上午6:40, Tejun Heo 写道:
> On Wed, Dec 07, 2022 at 12:38:26AM +0800, Jinke Han wrote:
>> From: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>>
>> Now we don't distinguish sync write ios from normal buffer write ios
>> in blk-throtl. A bio with REQ_SYNC tagged always mean it will be wait
>> until write completion soon after it submit. So it's reasonable for sync
>> io to complete as soon as possible.
>>
>> In our test, fio writes a 100g file in sequential 4k blocksize in
>> a container with low bps limit configured (wbps=10M). More than 1200
>> ios were throttled in blk-throtl queue and the avarage throtle time
>> of each io is 140s. At the same time, the operation of saving a small
>> file by vim will be blocked amolst 140s. As a fsync will be send by vim,
>> the sync ios of fsync will be blocked by a huge amount of buffer write
>> ios ahead. This is also a priority inversion problem within one cgroup.
>> In the database scene, things got really bad with blk-throtle enabled
>> as fsync is called very often.
>>
>> This patch introduces a independent sync queue for write ios and gives
>> a huge priority to sync write ios. I think it's a nice respond to the
>> semantics of REQ_SYNC. Bios with REQ_META and REQ_PRIO gains the same
>> priority as they are important to fs. This may avoid some potential
>> priority inversion problems.
> 
> I think the idea makes sense but wonder whether the implementation would be
> cleaner / simpler if the sq->queued[] are indexed by SYNC, ASYNC and the
> sync writes are queued in the sync queue together with reads.
> 
> Thanks.
> 

If something is said wrong, please correct me.

If sq->queue[] were only classfied SYNC and ASYNC, some things may 
become a little difficult to handle。As we put sync write and read 
together into SYNC queue, the two may influence each other.
Whit wbps=1M and rbps=100M configured, sync io likely be throtled while 
read ios after it may can be dispatched within the limit. In that case,
maybe we should scan the whole SYNC queue to check read io.

Thanks.
Jinke

