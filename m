From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v10 0/3] Charge loop device i/o to issuing cgroup
Date: Thu, 18 Mar 2021 10:00:17 -0600
Message-ID: <8c32421c-4bd8-ec46-f1d0-25996956f4da@kernel.dk>
References: <20210316153655.500806-1-schatzberg.dan@gmail.com>
 <7ca79335-026f-2511-2b58-0e9f32caa063@kernel.dk>
 <CALvZod6tvrZ_sj=BnM4baQepexwvOPREx3qe5ZJrmqftrqwBEA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wUijfwg+uIfKfZvAaaXdkGTXi/eEZcihpR4YJOsQcao=;
        b=x4gGUgw/3leBjfQHr9OOg+OpXui02/U/2GUZyNPrOGO0bY2mPIcrTwKHXxWy9qZ4EM
         7tvKJoaDcaSG9p354Dma+Y4AEo8dHqedWnCovZGA9AcGBEzqN1WJImRhBoawGR0IWW7w
         uHHXneMsob/NSsiZjL1y4DtteY0j8oseFc2oEsyAuvIEdazYmMNQyS+DEX6e5v6xED9l
         qW63lH5JdKzrpPTBfitQt28mJ+iazG3qO+Qrqn4n86reF2TRsB5gSf3r8QoJEZYF5etR
         TjWV3pyO9o+TCsXcMIGXdrMgtnxKLFg17mpOFDiOwR2qzDnqT235xki7H3U4Mj9MZnB7
         DR7Q==
In-Reply-To: <CALvZod6tvrZ_sj=BnM4baQepexwvOPREx3qe5ZJrmqftrqwBEA@mail.gmail.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb@google.com>
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alex.shi@linux.alibaba.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:MEMORY MANAGEMENT" <linux-mm@k>

On 3/18/21 9:53 AM, Shakeel Butt wrote:
> On Wed, Mar 17, 2021 at 3:30 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/16/21 9:36 AM, Dan Schatzberg wrote:
>>> No major changes, just rebasing and resubmitting
>>
>> Applied for 5.13, thanks.
>>
> 
> I have requested a couple of changes in the patch series. Can this
> applied series still be changed or new patches are required?

I have nothing sitting on top of it for now, so as far as I'm concerned
we can apply a new series instead. Then we can also fold in that fix
from Colin that he posted this morning...

-- 
Jens Axboe

