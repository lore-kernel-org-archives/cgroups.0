From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blkcg: put back rcu lock in blkcg_bio_issue_check()
Date: Thu, 6 Dec 2018 10:51:30 -0700
Message-ID: <d179c449-9593-8630-2a01-8a625f2b7e67@kernel.dk>
References: <20181206174938.2326-1-dennis@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p+Rx8CLlS6c401nqoIEnCpIsNrBL9fyp9Oc6jt1Tq/4=;
        b=VIqjwJKw3smg1cWJh/wIPcBRMymm2SYM9WBebm5zk+ed2CV931tKYME84zMiLRDKnw
         2bch/XEgYWaAwrnUvIJ4ACQu78vbStAl5PQeTiMGqHsrrW+3Icq/XqrX+ifLa9z/1Dry
         dmebjcev4p0DY/xiKbvHYg3iEGLtvdztXo5TxJLxQOHD1gCdOJOKi2dcoJshkkWZvUPj
         Ry3FmLaAEv4UepKn8AcBCPHb0NpriDDy9+mW1puyYI+a6HFpyEtwXgTL7sDuLcmiHthf
         RDGwxEbKdn5My2vwCNdH/v7xnYPrV7W0na49tHoYwZgcFgy1fvM3F+E4OJB1vzG9jHFn
         /Z2A==
In-Reply-To: <20181206174938.2326-1-dennis@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/6/18 10:49 AM, Dennis Zhou wrote:
> I was a little overzealous in removing the rcu_read_lock() call from
> blkcg_bio_issue_check() and it broke blk-throttle. Put it back.

Applied, thanks Dennis.

-- 
Jens Axboe

