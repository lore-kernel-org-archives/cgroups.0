From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH block-5.13] blk-iocost: fix weight updates of inner active
 iocgs
Date: Tue, 11 May 2021 20:50:58 -0600
Message-ID: <204404df-1ef8-d31b-8d4b-21f77810b774@kernel.dk>
References: <YJsxnLZV1MnBcqjj@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wH9LtqZdrV82uryQNvQG57KCdHT182AjVpniYypTn5s=;
        b=ekZ2yF344cjQ1w+P7pdP5YE3qyPqszU1gfMoVhIghgGvBlVDotZUUdZKBm8p4LzN4K
         DQlYqB1DgsZqKX63DfWUjYaLmQQJOpKX8nTveCQaT23trBzrWevAXubvtKACRfXjPssx
         nPXp7rHUuGWKOBP86wHyAX7aMvHeyOu40NzEyQ2J5ctHygJK7Q/iXox3481w8aGd+fgi
         z4gw9VRikxgwoorJ2KscX857v09yyo/MUK+CC55zXB411rsMRtWI7Vs/xsK39UJRDB65
         kUGzyTt1Wp1mzE9S49sKC8irtXNB7PB5s/pDnvU7GevOkmx3bilmWkWsQa65/FcC0/qp
         yxQQ==
In-Reply-To: <YJsxnLZV1MnBcqjj-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Dan Schatzberg <dschatzberg-b10kYP2dOMg@public.gmane.org>

On 5/11/21 7:38 PM, Tejun Heo wrote:
> When the weight of an active iocg is updated, weight_updated() is called
> which in turn calls __propagate_weights() to update the active and inuse
> weights so that the effective hierarchical weights are update accordingly.
> 
> The current implementation is incorrect for inner active nodes. For an
> active leaf iocg, inuse can be any value between 1 and active and the
> difference represents how much the iocg is donating. When weight is updated,
> as long as inuse is clamped between 1 and the new weight, we're alright and
> this is what __propagate_weights() currently implements.
> 
> However, that's not how an active inner node's inuse is set. An inner node's
> inuse is solely determined by the ratio between the sums of inuse's and
> active's of its children - ie. they're results of propagating the leaves'
> active and inuse weights upwards. __propagate_weights() incorrectly applies
> the same clamping as for a leaf when an active inner node's weight is
> updated. Consider a hierarchy which looks like the following with saturating
> workloads in AA and BB.
> 
>      R
>    /   \
>   A     B
>   |     |
>  AA     BB
> 
> 1. For both A and B, active=100, inuse=100, hwa=0.5, hwi=0.5.
> 
> 2. echo 200 > A/io.weight
> 
> 3. __propagate_weights() update A's active to 200 and leave inuse at 100 as
>    it's already between 1 and the new active, making A:active=200,
>    A:inuse=100. As R's active_sum is updated along with A's active,
>    A:hwa=2/3, B:hwa=1/3. However, because the inuses didn't change, the
>    hwi's remain unchanged at 0.5.
> 
> 4. The weight of A is now twice that of B but AA and BB still have the same
>    hwi of 0.5 and thus are doing the same amount of IOs.
> 
> Fix it by making __propgate_weights() always calculate the inuse of an
> active inner iocg based on the ratio of child_inuse_sum to child_active_sum.

Applied, thanks.

-- 
Jens Axboe

