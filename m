From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH-block] blk-cgroup: Use css_tryget() in
 blkcg_destroy_blkgs()
Date: Mon, 28 Nov 2022 08:42:51 -0700
Message-ID: <786aacda-b25d-67f6-bad3-0030b0e2637e@kernel.dk>
References: <20221128033057.1279383-1-longman@redhat.com>
 <427068db-6695-a1e2-4aa2-033220680eb9@kernel.dk>
 <b9018641-d39f-ff74-8cfb-ba597f5ee0c2@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ikwtuVAChvrOqHqA+XhFG3V1RBdB0rFmyOatV701UIQ=;
        b=Fwu3Ja3YaAsN1OEWkHKqkrg51PQ/MJYssqHid6c8J9kVpUsh/EPYMERU9XC+dWZVAI
         ks0ZTd8F7YD+QSiUkNIBTBXm6mUVz0xZ7ujFZUwBEvWiCJLHZYHttV2R3YtRwQu1fTIt
         FKtOo2nTXLcr1pMLGN2f6GTbBwbi8dkQz2tBJR2pNIxnwwKkg1RVnp0namd7dn/AGi71
         VBNyq+X7/RujQC4vRW946mpIw4ISIOUor89aiBelXseDzT9pXv8ZIA9+vw3PHyXUqLHs
         5lu0fXvF24H8xOd39b4l3YMxtatKl98TuPL7LTELlGg5CXB08V/YousK8YV4jnIy2//3
         rL0A==
Content-Language: en-US
In-Reply-To: <b9018641-d39f-ff74-8cfb-ba597f5ee0c2@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Hillf Danton <hdanton@sina.com>, Yi Zhang <yi.zhang@redhat.com>

On 11/28/22 8:38?AM, Waiman Long wrote:
> On 11/28/22 09:14, Jens Axboe wrote:
>> On 11/27/22 8:30?PM, Waiman Long wrote:
>>> Commit 951d1e94801f ("blk-cgroup: Flush stats at blkgs destruction
>>> path") incorrectly assumes that css_get() will always succeed. That may
>>> not be true if there is no blkg associated with the blkcg. If css_get()
>>> fails, the subsequent css_put() call may lead to data corruption as
>>> was illustrated in a test system that it crashed on bootup when that
>>> commit was included. Also blkcg may be freed at any time leading to
>>> use-after-free. Fix it by using css_tryget() instead and bail out if
>>> the tryget fails.
>>>
>>> Fixes: 951d1e94801f ("blk-cgroup: Flush stats at blkgs destruction path")
>>> Reported-by: Yi Zhang <yi.zhang@redhat.com>
>>> Signed-off-by: Waiman Long <longman@redhat.com>
>>> ---
>>> ? block/blk-cgroup.c | 7 ++++++-
>>> ? 1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>>> index 57941d2a8ba3..74fefc8cbcdf 100644
>>> --- a/block/blk-cgroup.c
>>> +++ b/block/blk-cgroup.c
>>> @@ -1088,7 +1088,12 @@ static void blkcg_destroy_blkgs(struct blkcg *blkcg)
>>> ? ????? might_sleep();
>>> ? -??? css_get(&blkcg->css);
>>> +??? /*
>>> +???? * If css_tryget() fails, there is no blkg to destroy.
>>> +???? */
>>> +??? if (!css_tryget(&blkcg->css))
>>> +??????? return;
>>> +
>>> ????? spin_lock_irq(&blkcg->lock);
>>> ????? while (!hlist_empty(&blkcg->blkg_list)) {
>>> ????????? struct blkcg_gq *blkg = hlist_entry(blkcg->blkg_list.first,
>> This doesn't seem safe to me, but maybe I'm missing something. A tryget
>> operation can be fine if we're under RCU lock and the entity is freed
>> appropriately, but what makes it safe here? Could blkcg already be gone
>> at this point?
> 
> The actual freeing of the blkcg structure is under RCU protection. So
> the structure won't be freed immediately even if css_tryget() fails. I
> suspect what Michal found may be the root cause of this problem. If
> so, this is an existing bug which gets exposed by my patch.

But what prevents it from going away here since you're not under RCU
lock for the tryget? Doesn't help that the freeing side is done in an
RCU safe manner, if the ref attempt is not.

-- 
Jens Axboe
