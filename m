From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add entry for block io cgroup
Date: Fri, 12 Jul 2019 07:25:19 -0700
Message-ID: <20190712142502.GA680549@devbig004.ftw2.facebook.com>
References: <156284038698.3851.6531328622774377848.stgit@buzz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9L3733if1HuRLL5zZv5eZHlWQiU13iqExsAt1AQHDmY=;
        b=VSgPlNfdufMwqcv8BXKRQn84MCxQSn/4zstrvTf+cNggal8AgvbiU+yvfRo6INmcRC
         0bCXNaw4N6SMdHF45IWdRLf2OIkJrk8RNNtk+wLEZMb8rhQmo4nuJF7bbI5cwO0aaBjS
         L5F5cY0jXiBtmkuyQrZh9eOx53RNk8G4xdjpUHA+LzOmuFQbxd2zvRZ7VkicqO8ACvhF
         S4F4YqPkbSb1EPWdmUCJn8dczDJf7yNw/VTAQKPtOp1LUXx4pv+4yDXQJX46WJ0CLGgg
         iX81GXvv0/fMQDBuonE9xsfz2wNDYPx0P3Ao7I4qaFWrN6EQXMafnl6G+B0l0BSF2iOU
         GN8A==
Content-Disposition: inline
In-Reply-To: <156284038698.3851.6531328622774377848.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello, Konstantin.

On Thu, Jul 11, 2019 at 01:19:47PM +0300, Konstantin Khlebnikov wrote:
> +CONTROL GROUP - BLOCK IO CONTROLLER (BLKIO)
> +L:	cgroups@vger.kernel.org
> +F:	Documentation/cgroup-v1/blkio-controller.rst
> +F:	block/blk-cgroup.c
> +F:	include/linux/blk-cgroup.h
> +F:	block/blk-throttle.c
> +F:	block/blk-iolatency.c
> +F:	block/bfq-cgroup.c

Given that blkcg changes are often entangled with generic block
changes and best routed through block tree, I think it'd be useful to
add the followings.

M:      Tejun Heo <tj@kernel.org>
M:      Jens Axboe <axboe@kernel.dk>
L:      linux-block@vger.kernel.org
T:      git git://git.kernel.dk/linux-block

Thanks.

-- 
tejun
