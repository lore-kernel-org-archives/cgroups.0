From: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] blk-throttle: enable io throttle for root in
 cgroup v2
Date: Wed, 9 Feb 2022 11:14:23 +0800
Message-ID: <YgMxjyVjMjmkMQU5@T590>
References: <20220114093000.3323470-1-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644376491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X9DHk6APJIsHE1UI+ceCyZijDLQACCuReEtHVHktgAg=;
        b=Ge3pakHxnVL3TJoU87q8CVo0aNFlRKRKvaLFTKgJjrLI2zbnRJFO0wSYnfuMitO5mW88nT
        xyT9v401LnSmcKKk7tE+DcryGq67O3DAg8pnup8DZwT4nZeCtxzVcxVtr6MuDzJMFNud7w
        2y2n+zv5ec+xA5EPsIw/zymFFP+19gE=
Content-Disposition: inline
In-Reply-To: <20220114093000.3323470-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hello Yu Kuai,

On Fri, Jan 14, 2022 at 05:30:00PM +0800, Yu Kuai wrote:
> RFC patch: https://lkml.org/lkml/2021/9/9/1432
> 
> There is a proformance problem in our environment:
> 
> A host can provide a remote device to difierent client. If one client is
> under high io pressure, other clients might be affected.

Can you use the linux kernel storage term to describe the issue?
Such as, I guess here host means target server(iscsi, nvme target?),
client should be scsi initiator, or nvme host. If not, can you provide
one actual example for your storage use case?

With common term used, it becomes pretty easy for people to understand &
solve the issue, and avoid any misunderstanding.

> 
> Limit the overall iops/bps(io.max) from the client can fix the problem,

Just be curious how each client can figure out perfect iops/bps limit?
Given one client doesn't know how many clients are connected to the
target server.

It sounds like the throttle shouldn't be done in client side cgroup,
given the throttle is nothing to do with tasks. 

Maybe it should be done in server side, since server has enough
information to provide fair iops/bps allocation for each clients.


Thanks, 
Ming

