From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH -next v4 0/5] multiple cleanup patches for bfqd
Date: Tue, 01 Nov 2022 20:11:28 -0600
Message-ID: <166735508849.16539.13483811523178998202.b4-ty@kernel.dk>
References: <20221102022542.3621219-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xMwht8Kpuf4LTPdcGCutOruwBCb0mDtYIKt07DMBo4E=;
        b=3tM2CRKuvgSzDtO4YVhoaV1qCBEevMeRGgXGrmtKFAev/snlKP5Xk6nNeRdBCAP6B0
         VZZ1RkVha8lmm8QlrzbOLgbzk/oEJLb6KXV5DIspagBlE7prEN7VNxRg66/Xx9/6EEr5
         qDo+fMediXpg2y4tK0/cGWFw7vX7DgQismTRejAH5dC/j20lcsejEnhAg8YsM7fe84Db
         OwKwWnOMj2a95PzEx2MY6SckIx55uRbT++lNNE5UXKMXot23Yl3VzsMrASwHoZsXP7SY
         O4Ki5GqPakLrQqljsMvzRR5lUGVmtboW0JSadNNszzhifG9lhJz/ViHZImbU9sijLq+3
         W8XQ==
In-Reply-To: <20221102022542.3621219-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, 2 Nov 2022 10:25:37 +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Changes in v4:
>  - move first two patches from v3 into another thread.
>  - add patch 1
> 
> Changes in v3:
>  - resend v2 with new mail address
> 
> [...]

Applied, thanks!

[1/5] block, bfq: remove set but not used variable in __bfq_entity_update_weight_prio
      commit: 060d9217d356a28e1bcfd2df0c8bf59aa24a12ce
[2/5] block, bfq: factor out code to update 'active_entities'
      commit: e5c63eb4b59f9fb9b28e29d605a4dabbeff7772e
[3/5] block, bfq: cleanup bfq_activate_requeue_entity()
      commit: f6fd119b1ae2c4f794dffc87421cf4ce2414401e
[4/5] block, bfq: remove dead code for updating 'rq_in_driver'
      commit: 918fdea3884ca8de93bd0e8ad02545eb8e3695d6
[5/5] block, bfq: don't declare 'bfqd' as type 'void *' in bfq_group
      commit: aa625117d6f67e33fab280358855fdd332bb20ab

Best regards,
-- 
Jens Axboe


