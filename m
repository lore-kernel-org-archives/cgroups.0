From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [RFC PATCH] blk-throttle: enable io throttle for root in cgroup
 v2
Date: Fri, 17 Sep 2021 19:41:03 +0200
Message-ID: <20210917174103.GC13346@blackbody.suse.cz>
References: <20210909140815.2600858-1-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631900464; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yGdnRQChmmfug9TJwp/GqG9nQH+or3zg5tguY5oo+D4=;
        b=cMHI6XJFM9M0KRsFulwCJSBaxKY+SGgZU1ShmWu4BBWJgJXWUslymcRIbNBgnGVyfc2xZF
        I+qnQnhzLxFMwiYPjH9sGL51bd1pzspozV/uMy7gb8qemsd7KaVa5X8ON5xYzK50nwQLcg
        jTtHsbjzv3skwLtVW2LjumGvwEwlHcY=
Content-Disposition: inline
In-Reply-To: <20210909140815.2600858-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

Hello Yu.

On Thu, Sep 09, 2021 at 10:08:15PM +0800, Yu Kuai <yukuai3@huawei.com> wrote:
> I'm not sure why this feature is disabled in the first place, is
> there any problem or design constraint?

The idea for v2 is that in the root cgroup remain only kernel threads that
provide "global" services and any user workload that should be
constrained is put into non-root cgroups. Additionally, if kernel
threads carry out work associated with a cgroup they can charge it to
the respective cgroup.

[snip]
> We want to limit the overall iops/bps of the device in cgroup v2,

Cui bono? (I mean what is the reason for throttling on the global level
when there's no other entity utiliting the residual?
<joke>Your drives are too fast?</joke>)

Michal
