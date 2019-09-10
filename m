From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCHSET block/for-next] blk-iocost: Implement absolute debt
 handling
Date: Tue, 10 Sep 2019 12:32:02 -0600
Message-ID: <1d8b7394-09bc-63ef-5bb7-de0f2ff2c75a@kernel.dk>
References: <20190904194556.2984857-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gmihbRTTguhKuF5poqPrKOZtRuKZ2B/FVhu85kYPomo=;
        b=eFEJ0DHdQ+gOjr08che3M4Ms36pQZ/j0IezL7oi03HQnX2YjfG1S+nNKpcLRqLGWtQ
         PPxCQw+rHkJOyVpzA+WrbkIWHKwEQwYWJoThRT+YJ+Z3FLxkwzRk/gUSR4mBaYxPs/A3
         ZHHHb/+KW51o1rmGeub/erimGc9yzYv0SnByD5rdzoyIJ7PwZNxKm4n1vCbrVDwpCWvS
         sAbC06jkTUKjyfwSL8GcQMX4lTVlRzbXbCyowRdrk/eNaJMSv2bHcL8+UjIkLfgVeR0a
         eK1lxBcNMUCi4/G5rr+vfxQG/ioz4oWUm9RgMCHhKh1G9K44i828u1woNK4lOf65DSik
         a8Bg==
In-Reply-To: <20190904194556.2984857-1-tj@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@vger.kernel.org, cgroups@vger.kernel.org, newella@fb.com

On 9/4/19 1:45 PM, Tejun Heo wrote:
> Currently, when a given cgroup doesn't have enough budget, a forced or
> merged bio will advance the cgroup's vtime by the cost calculated
> according to the hierarchical weight at the time of issue.  Once vtime
> is advanced, how the cgroup's weight changes doesn't matter.  It has
> to wait until global vtime catches up with the cgroup's.
> 
> This means that the cost is calculated based on the hweight at the
> time of issuing but may later be paid at the wrong hweight.  This, for
> example, can lead to a scenario like the following.
> 
> 1. A cgroup with a very low hweight runs out of budget.
> 
> 2. A storm of swap-out happens on it.  All of them are scaled
>     according to the current low hweight and charged to vtime pushing
>     it to a far future.
> 
> 3. All other cgroups go idle and now the above cgroup has access to
>     the whole device.  However, because vtime is already wound using
>     the past low hweight, what its current hweight is doesn't matter
>     until global vtime catches up to the local vtime.
> 
> 4. As a result, either vrate gets ramped up extremely or the IOs stall
>     while the underlying device is idle.
> 
> This patchset fixes the behavior by accounting the cost of forced or
> merged bios in absolute vtime rather than cgroup-relative.  This
> allows the cgroup to pay back the debt with whatever actual budget it
> has each period removing the hweight discrepancy.
> 
> Note that !forced bios' costs are already accounted in absolute vtime.
> This patchset puts forced charges on the same ground.
> 
> This patchset contains the following five patches and is on top of the
> current linux-block.git for-next 35e7ae82f62b ("Merge branch
> 'for-5.4/block' into for-next").
> 
>   0001-blk-iocost-Account-force-charged-overage-in-absolute.patch
>   0002-blk-iocost-Don-t-let-merges-push-vtime-into-the-futu.patch
>   0003-iocost_monitor-Always-use-strings-for-json-values.patch
>   0004-iocost_monitor-Report-more-info-with-higher-accuracy.patch
>   0005-iocost_monitor-Report-debt.patch
> 
> 0001-0002 implement absolute debt handling.  0003-0005 improve the
> monitoring script and add debt reporting.

Applied, thanks.

-- 
Jens Axboe

