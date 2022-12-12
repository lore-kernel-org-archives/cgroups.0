From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] blk-throtl: Introduce sync queue for write ios
Date: Mon, 12 Dec 2022 12:40:35 -1000
Message-ID: <Y5et48VryiKgL/eD@slm.duckdns.org>
References: <20221206163826.10700-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NPDIXZNKcYo1HDMoRq9WdF0H3wxdPBhSwXt2rQdX8Hk=;
        b=T2+mjUOnvMC6+SflvTfeyWtuCJGJy3r5riUOCGBFfGCcjwxEGIy88D1g3qOknp/kpu
         r44QvUgQpK7IfygXGopoHH1Aqbi/nw2i4MQqJwBE0lCXzalcJcAW1XuiZk/FGFJxgiZw
         TyeR/sUnOZE0e7jeZhBYzXFCMMScwKqXqgJ8pfVbW72SncqkteKT1wIGEAox7BOx78pH
         63kxkkSdWKIK4rJV+FaikdslcCef/vtpSxfob2P3xVWgugrM/WmIIqY360cPU55tMyRB
         cARaPspT5prnBLkezhBY9EE2WTXRTBgFrQZGgtY/jicSHR3pu+WJA3shdhCsQAysAnrt
         sDXg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221206163826.10700-1-hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Dec 07, 2022 at 12:38:26AM +0800, Jinke Han wrote:
> From: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> Now we don't distinguish sync write ios from normal buffer write ios
> in blk-throtl. A bio with REQ_SYNC tagged always mean it will be wait
> until write completion soon after it submit. So it's reasonable for sync
> io to complete as soon as possible.
> 
> In our test, fio writes a 100g file in sequential 4k blocksize in
> a container with low bps limit configured (wbps=10M). More than 1200
> ios were throttled in blk-throtl queue and the avarage throtle time
> of each io is 140s. At the same time, the operation of saving a small
> file by vim will be blocked amolst 140s. As a fsync will be send by vim,
> the sync ios of fsync will be blocked by a huge amount of buffer write
> ios ahead. This is also a priority inversion problem within one cgroup.
> In the database scene, things got really bad with blk-throtle enabled
> as fsync is called very often.
> 
> This patch introduces a independent sync queue for write ios and gives
> a huge priority to sync write ios. I think it's a nice respond to the
> semantics of REQ_SYNC. Bios with REQ_META and REQ_PRIO gains the same
> priority as they are important to fs. This may avoid some potential
> priority inversion problems.

I think the idea makes sense but wonder whether the implementation would be
cleaner / simpler if the sq->queued[] are indexed by SYNC, ASYNC and the
sync writes are queued in the sync queue together with reads.

Thanks.

-- 
tejun
