From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v10 0/3] Charge loop device i/o to issuing cgroup
Date: Wed, 17 Mar 2021 16:30:48 -0600
Message-ID: <7ca79335-026f-2511-2b58-0e9f32caa063@kernel.dk>
References: <20210316153655.500806-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B1Pn4DbFEch76dQ9ia9lLBjd1nNH8Pqwys+so0gPrt0=;
        b=lNbRHp6l0oM2+Xq1AOXCruM08fOp6OY0+sGgqz70SCTkv4se0odGZQPG+2axOFqFHe
         gBMmrJfpnSZ6ewa5+etGicUlX6aWCCHLXvxkhAfui38IGfPcdWIVG/2vuIThlZe1/5j7
         pxqp0mj3hZDp5XwfNY+dK2+YK1nlugwQMLaDmYvF0ZlXPcqkq9/8UKBHyjRs4OUxnMUI
         Her8syokr+HbPWZDRXobrQg0l9k0AOkKvi+yPIpnFzY8HPLuQKqeeoHWzZV9WGuL/PAE
         cCqR255GknGuZO8aVj4J8LBWYTifQKdU526zmqrvtB1GyY5NPrRMNB45NBZi3r1tu57l
         8nZw==
In-Reply-To: <20210316153655.500806-1-schatzberg.dan@gmail.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alex.shi@linux.alibaba.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:MEMORY MANAGEMENT" <>

On 3/16/21 9:36 AM, Dan Schatzberg wrote:
> No major changes, just rebasing and resubmitting

Applied for 5.13, thanks.

-- 
Jens Axboe

