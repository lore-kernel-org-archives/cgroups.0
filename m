From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 00/13 v4] block: always associate blkg and refcount
 cleanup
Date: Tue, 27 Nov 2018 16:10:01 -0500
Message-ID: <20181127210959.3c2yhp7citaxoqxm@macbook-pro-91.dhcp.thefacebook.com>
References: <20181126211946.77067-1-dennis@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ft4FysKjllP2Cb91bdlCvGAwT105IzF6SBB9loc5crw=;
        b=BoOePB6kLkSnZtNKIPcQr3rKUW3BdTkn4WKLPB/o7AZYEO3KwwF2Gka33pvZ7Od4Wv
         crT2YUcWp7Ta37OtfbynZy2QqmmHy9apo0rTB3gdb1hAIZHVpaWUXZnHoaRS/S6PmGjA
         f/oCzd9ROZKMq81SX7yi6OKif3j5Nbg9xmyAMdhm3mbkjr8dH7FWx6hMNgi28l/JknAD
         bHlbjK/c1hdlqy6feSpzPFsvqD/JI24mBOYkL7hxXi6xPGK+5k4psVkSSwmCqb2sYPL5
         QQn5jSk9cODOz3wwLcQ83t2Vvq1wPZj+2y3f6jVpO3pU7te0P1vfQJqFg2VdQYsy8EHg
         v7Hg==
Content-Disposition: inline
In-Reply-To: <20181126211946.77067-1-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 26, 2018 at 04:19:33PM -0500, Dennis Zhou wrote:
> Hi everyone,
> 
> This is respin of v3 [1] with fixes for the errors reported in [2] and
> [3]. v3 was reverted in [4].
> 
> The issue in [3] was that bio->bi_disk->queue and blkg->q were out
> of sync. So when I changed blk_get_rl() to use blkg->q, the wrong queue
> was returned and elevator from q->elevator->type threw a NPE. Note, with
> v4.21, the old block stack was removed and so this patch was dropped. I
> did backport this to v4.20 and verified this series does not encounter
> the error.
> 
> The biggest changes in v4 are when association occurs and clearly
> defining the cases where association should happen.
>   1. Association is now done when the device is set to keep blkg->q and
>      bio->bi_disk->queue in sync.
>   2. When a bio is submitted directly to the device, it will not be
>      associated with a blkg. This is because a blkg represents the
>      relationship between a blkcg and a request_queue. Going directly to
>      the device means the request_queue may not exist meaning no blkg
>      will exist.
> 
> The patch updating blk_get_rl() was dropped (v3 10/12). The patch to
> always associate a blkg from v3 (v3 04/12) was fixed and split into
> patches 0004 and 0005. 0011 is new removing bio_disassociate_task().
> 
> Summarizing the ideas of this series:
>   1. Gracefully handle blkg failure to create by walking up the blkg
>      tree rather than fall through to root.
>   2. Associate a bio with a blkg in core logic rather than per
>      controller logic.
>   3. Rather than have a css and blkg reference, hold just a blkg ref
>      as it also holds a css ref.
>   4. Switch to percpu ref counting for blkg.
> 

Hmm so reading through this series it's made me realize that iolatency is sort
of broken.  It relies on knowing if it needs to do something with the bio if
there is a blkg associated with it.  Before this patchset there wouldn't be a
blkg on the bio unless it was specifically associated.  I'm going to need to
figure out a different way to tag bio's to indicate that blk-iolatency should
care about it.  Probably add a bio flag or something.  Thanks,

Josef
