From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blk-cgroup: Use cond_resched() when destroy blkgs
Date: Wed, 27 Jan 2021 09:37:46 -0500
Message-ID: <YBF6uiFcU8k4u0Da@slm.duckdns.org>
References: <8f4fb91ced02e58ef425189c83214086f1154a0c.1611664710.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=RAjQSGWWGLdiLLcdLbe3VngHBT6cZLdVl1RZlBUtV9Y=;
        b=A8ZmzDYNExX2+4/EkVTAG8V8v88i62t0xqSgY8RGP7xW9jzlCLRiAsbhy+UB8xkDxG
         RFBWXxlM0ad/OuCDSiCN7/3R0d/aqQTgBnrPVdIZEAGV8HpcuZm7Th0hURZT+VfcgVYM
         2g/vr/vYsBdRDq7QfZFkkwjTFZ7omKsM2f6kICs4Iy+VNa37xaXA8k7Ie8pC3bP3YQIb
         gJ0nEGZc1iH4WZLsOBnv8OB1FbjUYkQUtUCRz+Ts2R4+m9Gq+WwDpK0fh7yuMAeIuEB8
         wRRCA3+iT1E3DMhNRCrPggdWwV+1QRNo2KcZJoU23h/8yiK1+8YMfMCP4FOu55YCbuut
         PECQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <8f4fb91ced02e58ef425189c83214086f1154a0c.1611664710.git.baolin.wang@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: axboe@kernel.dk, joseph.qi@linux.alibaba.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello, Baolin.

On Tue, Jan 26, 2021 at 09:33:25PM +0800, Baolin Wang wrote:
> On !PREEMPT kernel, we can get below softlockup when doing stress
> testing with creating and destroying block cgroup repeatly. The
> reason is it may take a long time to acquire the queue's lock in
> the loop of blkcg_destroy_blkgs(), thus we can use cond_resched()
> instead of cpu_relax() to avoid this issue, since the
> blkcg_destroy_blkgs() is not called from atomic contexts.
>=20
> [ 4757.010308] watchdog: BUG: soft lockup - CPU#11 stuck for 94s!
> [ 4757.010698] Call trace:
> [ 4757.010700] =A0blkcg_destroy_blkgs+0x68/0x150
> [ 4757.010701] =A0cgwb_release_workfn+0x104/0x158
> [ 4757.010702] =A0process_one_work+0x1bc/0x3f0
> [ 4757.010704] =A0worker_thread+0x164/0x468
> [ 4757.010705] =A0kthread+0x108/0x138
>=20
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

* Can you please add might_sleep() at the top of the function?

* Given that the system can accumulate a huge number of blkgs in
  pathological cases, I wonder whether a better way to go about it is
  explicitly testing need_resched() on each loop and release locks and do
  cond_resched() if true?

Thanks.

--=20
tejun
