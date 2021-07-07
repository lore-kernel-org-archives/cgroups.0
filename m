From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V2] blk-cgroup: prevent rcu_sched detected stalls warnings
 while iterating blkgs
Date: Wed, 7 Jul 2021 09:38:54 -0600
Message-ID: <dc715155-f936-16ef-bcc4-3063988402ba@kernel.dk>
References: <20210707015649.1929797-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H/u+AYAwK9mJcG4oUWcnUGsuenx4nlYeOD13u9gKYw4=;
        b=hBe29YUOrYgfT6USN8t15IXPOdsaxaWTgbrLieT0ub7LIuxZQLgx28SKSKI2NneYaX
         3TfqswY3vdTXnPYj/gn7E2GPnw3fzQoZ4/2cKo2U8yYmk5UOaMGBZQV4FkLxJmLZXtVU
         WvhFUSJeZJD0jCIgSkOooNBIcaNQ9PF6I4tHzvnb41Q+vpQ2njGA69DOrhrmQUVwdRRi
         Sh9D/0WnPlX9q+V7H0eoW9RNCAufgJnb+iMaMGxTsP5RGsfxe2RomDZSsmI9qPJ6eHFr
         413hVjj1elDDIYi4tiXFVKvlOELXOGD7sQNBIzlhRADjBFfQJmRxGkGU8TIJv3VJCVld
         rESw==
In-Reply-To: <20210707015649.1929797-1-yukuai3@huawei.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai3@huawei.com>, tj@kernel.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On 7/6/21 7:56 PM, Yu Kuai wrote:
> We run a test that create millions of cgroups and blkgs, and then trigger
> blkg_destroy_all(). blkg_destroy_all() will hold spin lock for a long
> time in such situation. Thus release the lock when a batch of blkgs are
> destroyed.
> 
> blkcg_activate_policy() and blkcg_deactivate_policy() might have the
> same problem, however, as they are basically only called from module
> init/exit paths, let's leave them alone for now.

Applied, thanks.

-- 
Jens Axboe

