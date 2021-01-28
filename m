From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v3] blk-cgroup: Use cond_resched() when destroy blkgs
Date: Thu, 28 Jan 2021 07:32:03 -0700
Message-ID: <9087d02b-ef9b-46c4-6933-82bb3e520597@kernel.dk>
References: <0be1a0a03367f7230497a2e7a5ed47d2a2d5ae1a.1611809091.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R9tH9YjKdu4SV5abNwwJi97SLfnNUb/O813edamRM6Q=;
        b=JDmPw59tJk29B48kwIPKMz8KmvxLlJaaL1BgF4PLqrTIPWOsd2twVS3BZHj3LqHf/U
         tVkocwsz1ijDsPRE8Lh0rHKqIaPBxD68EvPZuRDRxeyFh0/RydPe00W8XBvxCIezyQDE
         U7o4h7sq3V+jfnHYdfXa1zced+kebVZ5WwWH0AuZbpl8NrmTChkCa4zu6Pfij7OwB+Pe
         xnLp++aHRlDNuc2B9fwl5dGTmL4I8ekGdMANiQefjJt9CwRK07Xt++q6WH8YZHf1kuOQ
         CheoPG0P6G5bqkQugw+92XkrSKpZ+Q5qoio15YLoW05cd0ey4B9mSoo+ptj0jxQZyujf
         cigQ==
In-Reply-To: <0be1a0a03367f7230497a2e7a5ed47d2a2d5ae1a.1611809091.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 1/27/21 10:58 PM, Baolin Wang wrote:
> On !PREEMPT kernel, we can get below softlockup when doing stress
> testing with creating and destroying block cgroup repeatly. The
> reason is it may take a long time to acquire the queue's lock in
> the loop of blkcg_destroy_blkgs(), or the system can accumulate a
> huge number of blkgs in pathological cases. We can add a need_resched()
> check on each loop and release locks and do cond_resched() if true
> to avoid this issue, since the blkcg_destroy_blkgs() is not called
> from atomic contexts.
> 
> [ 4757.010308] watchdog: BUG: soft lockup - CPU#11 stuck for 94s!
> [ 4757.010698] Call trace:
> [ 4757.010700]  blkcg_destroy_blkgs+0x68/0x150
> [ 4757.010701]  cgwb_release_workfn+0x104/0x158
> [ 4757.010702]  process_one_work+0x1bc/0x3f0
> [ 4757.010704]  worker_thread+0x164/0x468
> [ 4757.010705]  kthread+0x108/0x138

Thanks, applied.

-- 
Jens Axboe

