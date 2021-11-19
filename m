From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: fix missing put device in error path from blkg_conf_pref()
Date: Fri, 19 Nov 2021 06:27:01 -0700
Message-ID: <163732842185.43918.10012034831708951012.b4-ty@kernel.dk>
References: <20211102020705.2321858-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=tTFVd1nWcx3/XcFWQghei7zJBEBnxYkZz8vTHO1fGeE=;
        b=AUEqQdV3wtCQoHQw3uXtTZQMCIea9TPMKqSH9B1cD/8co4jzDGxflGe06I87v4A9qZ
         jc5tKvG64fJDptVFDLqT/yBxbv9cKwLkJOodF0z3YLG+EqKKJaXV8iU3GqeisaoIL0Mw
         TBanQ1f2qFDNkSwU2cn14jYVXl5OlB64IXXKchqXlVGlLk7sLzh1Jar1N9guEthfUUwT
         yXlX078M0Xbx0RnCnFAkRDhxr4wxRw+wU3RjbSgt58pAwmsRDnxk+ZCQP9yQm0MCS4SN
         Biu6Cr5RGg7EiSSW28CI+jbgqzijwh5imiGNmDkypWlXexx752rNPvboyYI+NIW+FqBM
         rIMQ==
In-Reply-To: <20211102020705.2321858-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Tue, 2 Nov 2021 10:07:05 +0800, Yu Kuai wrote:
> If blk_queue_enter() failed due to queue is dying, the
> blkdev_put_no_open() is needed because blkcg_conf_open_bdev() succeeded.
> 
> 

Applied, thanks!

[1/1] blk-cgroup: fix missing put device in error path from blkg_conf_pref()
      commit: 15c30104965101b8e76b24d27035569d6613a7d6

Best regards,
-- 
Jens Axboe


