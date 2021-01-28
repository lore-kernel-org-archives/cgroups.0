From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] blk-cgroup: Use cond_resched() when destroy blkgs
Date: Wed, 27 Jan 2021 22:31:05 -0500
Message-ID: <YBIv+fG6jleTxOTh@slm.duckdns.org>
References: <8e8a0c4644d5eb01b7f79ec9b67c2b240f4a6434.1611798287.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=VOw4mJ4y43ELleH9R6vau/EgvTWH40V/X9BffSOccpQ=;
        b=JRELr5pJ/BHYdN461dpHR9FbEXmyaPZ8n28FutnjSzyXAQ9PhSgQP/kt8xKM8gi7qP
         3MOY8cwEC0iCFfb7aCC1GbD1AjF16oMDTFJdt0ii8dJgmTugQn3g/D/8mUY7vZep5chy
         NQsA7BNIhfvs4TuB7gwJCLYJflgU43lFBxvVCbWGXk8ROXBkOfw3cXHw/wpdq0qPy0I4
         uIq8EUOHgwagyl1w8wl+zkUehJblW+qiGs3+BYGaOARMQvyhn+Jusx+FQ6h0zR9KKuHU
         CsiZVj5j+gjPPCMRdmaGkmNdk9hv1BFIKPZZBF54QIBlTfvB4naW6nkA6eelg9jN1Hc1
         jWmQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <8e8a0c4644d5eb01b7f79ec9b67c2b240f4a6434.1611798287.git.baolin.wang@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-9"
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: axboe@kernel.dk, joseph.qi@linux.alibaba.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jan 28, 2021 at 11:22:00AM +0800, Baolin Wang wrote:
> On !PREEMPT kernel, we can get below softlockup when doing stress
> testing with creating and destroying block cgroup repeatly. The
> reason is it may take a long time to acquire the queue's lock in
> the loop of blkcg_destroy_blkgs(), or the system can accumulate a
> huge number of blkgs in pathological cases. We can add a need_resched()
> check on each loop and release locks and do cond_resched() if true
> to avoid this issue, since the blkcg_destroy_blkgs() is not called
> from atomic contexts.
>=20
> [ 4757.010308] watchdog: BUG: soft lockup - CPU#11 stuck for 94s!
> [ 4757.010698] Call trace:
> [ 4757.010700] =A0blkcg_destroy_blkgs+0x68/0x150
> [ 4757.010701] =A0cgwb_release_workfn+0x104/0x158
> [ 4757.010702] =A0process_one_work+0x1bc/0x3f0
> [ 4757.010704] =A0worker_thread+0x164/0x468
> [ 4757.010705] =A0kthread+0x108/0x138
>=20
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--=20
tejun
