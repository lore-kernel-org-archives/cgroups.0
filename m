From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: Re: [PATCH v10 0/3] Charge loop device i/o to issuing cgroup
Date: Fri, 19 Mar 2021 11:51:22 -0400
Message-ID: <YFTIepcb+qm/+/9d@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
References: <20210316153655.500806-1-schatzberg.dan@gmail.com>
 <7ca79335-026f-2511-2b58-0e9f32caa063@kernel.dk>
 <CALvZod6tvrZ_sj=BnM4baQepexwvOPREx3qe5ZJrmqftrqwBEA@mail.gmail.com>
 <8c32421c-4bd8-ec46-f1d0-25996956f4da@kernel.dk>
 <20210318164625.1018062b042e540bd83bb08e@linux-foundation.org>
 <CALvZod6FMQQC17Zsu9xoKs=dFWaJdMC2Qk3YiDPUUQHx8teLYg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yQLsk2Tp9wfXFgh3gpmNEHc/1LVc0qNRoZDzdBhuURQ=;
        b=bCWupG2mTUy75B9SdmzjE60Wm4fflLRjowQwVn0gS6PS4fBpwtA4DG4NH5Ooo3tjeb
         Crja/7T/8mXD/ardmLAx9Cgj9xa8d+7v4SAYzzWKKlTF9zMvmgsqI7cDS2DVMNvfaNqm
         LOnBD/IscqHTTRHxI0+clnR7I7MtJsFKSnRmftmwUX9WDsHYGy3JCbi8ZzuASOeNKxvN
         3zwlzI1Lsg8ODU9JsRK0o+Mrj105/EzdsFRDCKYRigFK6nXnRLSH6W+8swv8w6IIZ21t
         yIoQbHXSuiQUxqfhpVfSgAxe4zd87/cXTnjfUxvlzRsMa6bcG9GblChEkIpSopFEyxX3
         n5BA==
Content-Disposition: inline
In-Reply-To: <CALvZod6FMQQC17Zsu9xoKs=dFWaJdMC2Qk3YiDPUUQHx8teLYg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alex.shi@linux.alibaba.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>

On Thu, Mar 18, 2021 at 05:56:28PM -0700, Shakeel Butt wrote:
> 
> We need something similar for mem_cgroup_swapin_charge_page() as well.
> 
> It is better to take this series in mm tree and Jens is ok with that [1].
> 
> [1] https://lore.kernel.org/linux-next/4fea89a5-0e18-0791-18a8-4c5907b0d2c4@kernel.dk/

It sounds like there are no concerns about the loop-related work in
the patch series. I'll rebase on the mm tree and resubmit.
