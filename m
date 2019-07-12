From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] MAINTAINERS: add entry for block io cgroup
Date: Fri, 12 Jul 2019 09:15:28 -0600
Message-ID: <82bc7337-c48f-7559-bd9b-6a21ccbfceb0@kernel.dk>
References: <156284038698.3851.6531328622774377848.stgit@buzz>
 <20190712142502.GA680549@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2opEnBuVBF2b4E5QanZT3B1PxQTl1jpFqVeaeD4Jvac=;
        b=BMS+LBZ1HOJ+oPmT+jj9cCB2CMuhLD9hOgL1EGxhXgjcCFU+uRhdlTEHJctcvcAfAC
         93xCyhVww0XoYzbRJRJbpZBsYO3Bm1q/MlPGVvrNSmWS6qfkXQz8BXXUjRJsSG2wkg1B
         oUhykgoEyU+U5WMY8pngtLd8pQv2pIfwtfSV3MVO+kJRkbbD+jxi3cwlmNKFU6maqscI
         iIz0r5umTAoC5x9daY2n1PVhdWCYjSYP5JjtzczVfPEaIuMScEe303uYSFPRxEjPxbTY
         wo2uvzLdn+ynMMpp8KKHkC8MInm7bHAk0Gz2dmFjF6xGUKzzWIe57apPN0x9lMRWIqqQ
         wFDw==
In-Reply-To: <20190712142502.GA680549@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On 7/12/19 8:25 AM, Tejun Heo wrote:
> Hello, Konstantin.
> 
> On Thu, Jul 11, 2019 at 01:19:47PM +0300, Konstantin Khlebnikov wrote:
>> +CONTROL GROUP - BLOCK IO CONTROLLER (BLKIO)
>> +L:	cgroups@vger.kernel.org
>> +F:	Documentation/cgroup-v1/blkio-controller.rst
>> +F:	block/blk-cgroup.c
>> +F:	include/linux/blk-cgroup.h
>> +F:	block/blk-throttle.c
>> +F:	block/blk-iolatency.c
>> +F:	block/bfq-cgroup.c
> 
> Given that blkcg changes are often entangled with generic block
> changes and best routed through block tree, I think it'd be useful to
> add the followings.
> 
> M:      Tejun Heo <tj@kernel.org>
> M:      Jens Axboe <axboe@kernel.dk>
> L:      linux-block@vger.kernel.org
> T:      git git://git.kernel.dk/linux-block

I applied the patch with these additions.

-- 
Jens Axboe

