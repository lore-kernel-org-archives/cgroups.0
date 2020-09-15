From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/5] Some improvements for blk-throttle
Date: Mon, 14 Sep 2020 19:37:53 -0600
Message-ID: <822998a7-4cc7-88ee-8b3f-e8e7660a5b0a@kernel.dk>
References: <cover.1599458244.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=veTRf67heiIFBb4KPb8qCnP0OdQI7n5gixhte0BRym0=;
        b=nuIk1sCKUYraP3k57rU4ShNSYsyPO6TSIfbhfJGQr6XoUbfSbodkxRYwXNVW/EEBnx
         S4g4Plpz8OrOv+wOakdj/YTlGdE7xpbSoZTCgFA6cKkcQ999EbkYaI90Y/2dWERkkNZ/
         z3uPvic5mPlvmNiDl4C1QEcmUXvaJdlRCS9gFz+05Q3KennGshV4VpIpviIZsmb/AVOc
         zVzlJ+dFJ+ZST8txLF+bWxw/p4eKBSvfLb5JsmcPncRwA1w43w2seg2dbik9+EhH5cCR
         TQA/WLjUvkqQRATpdsgf4rCmTr8tRoXZEu/XvpfvhuSclBmVwXpwe2nDqKzztpaj2/1u
         Blxg==
In-Reply-To: <cover.1599458244.git.baolin.wang@linux.alibaba.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Baolin Wang <baolin.wang@linux.alibaba.com>, tj@kernel.org
Cc: baolin.wang7@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 9/7/20 2:10 AM, Baolin Wang wrote:
> Hi All,
> 
> This patch set did some clean-ups, as well as removing some unnecessary
> bps/iops limitation calculation when checking if can dispatch a bio or
> not for a tg. Please help to review. Thanks.
> 
> Baolin Wang (5):
>   blk-throttle: Fix some comments' typos
>   blk-throttle: Use readable READ/WRITE macros
>   blk-throttle: Define readable macros instead of static variables
>   blk-throttle: Avoid calculating bps/iops limitation repeatedly
>   blk-throttle: Avoid checking bps/iops limitation if bps or iops is    
>     unlimited
> 
>  block/blk-throttle.c | 59 ++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 36 insertions(+), 23 deletions(-)

Looks reasonable to me, I've applied it.

Out of curiosity, are you using blk-throttle in production, or are these
just fixes/cleanups that you came across?


-- 
Jens Axboe

