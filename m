From: hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [RFC PATCH] blk-throtl: Introduce sync queue for
 write ios
Date: Wed, 14 Dec 2022 12:02:53 +0800
Message-ID: <1e53592f-b1f1-df85-3edb-eba4c5a5f989@bytedance.com>
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
        bh=/fCrMB9cQt2MX8YzEWi0sGLkBMAE2dTTyW94AFZn9pA=;
        b=fgjO1qQIwaV1ipZKA8klXdP4Ve8zlCH05WM04DBeAuVhT2gV0/NDQjwzHWxvy6vjoo
         Z8Wpdy4M8ga+fRK0sYnPreKKUxfL63DTSNOd+GnpDA5wFIEeY2UZ6ZizffNy5TSem3fD
         OASi7zyrHG3s4Cefq1ZVxzjAlDEwOJdGHqEyh+ePjyV/tbXz8S0ksLLjPOSMBw+VUGLc
         h6l+EOVvIc7rBKKXCwQ0L0ko7MdR1a95ECuIGMulh2iJaSWH0s7Fjmc9D+aOWAorlGYa
         11LUxOEneebX67UHldEWM+Vgc3beULPdhg7ncK0q2+MFuQACLqTCu2dc15pdEWPK5h2K
         FgzQ==
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
Should we keep the main category of io based READ and WRITE, and within 
READ / WRITE the subcategory were SYNC and ASYNC ? This may give less 
intrusion into existing frameworks.

Thanks.
