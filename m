From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v10 0/3] Charge loop device i/o to issuing cgroup
Date: Thu, 18 Mar 2021 08:53:32 -0700
Message-ID: <CALvZod6tvrZ_sj=BnM4baQepexwvOPREx3qe5ZJrmqftrqwBEA@mail.gmail.com>
References: <20210316153655.500806-1-schatzberg.dan@gmail.com> <7ca79335-026f-2511-2b58-0e9f32caa063@kernel.dk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pq/eBnxufGHS03GB6g8W63yjQMuRCa5QlbRp3PwKUEw=;
        b=bgdV4hZplv+94CUHWEbu9IHkjeAlUPO8LEb5m90TFIXf2m9HsOiO9yTkUsNDIdAL/2
         rBZTdVoEZ257H5o2v1HojtAp7qwdrf7q6Ii2ntKX7WkOrgSD01JG2StigU5YHcWoqSJZ
         bTXqHezszXCYygdvLZ/D4lwuJVAa88DpyGrABJ/xN9LlrHbBIre4dBG8nHgZCCo7PWaS
         YykPvxidGKJ7WFvtyyCMDgKpOdLSC7cUPueTA3LN63sNMlGVX/MIeRRWbisyCFlEdCpG
         VXqLfvbBzVRVVJY9HgvpGs9mCleH1KBcPG9F1+PKCOZB9CKurbXljzRWCaGovWH1biG9
         +hXA==
In-Reply-To: <7ca79335-026f-2511-2b58-0e9f32caa063@kernel.dk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alex.shi@linux.alibaba.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:MEMORY MANAGEMENT" <linux-mm@k>

On Wed, Mar 17, 2021 at 3:30 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/16/21 9:36 AM, Dan Schatzberg wrote:
> > No major changes, just rebasing and resubmitting
>
> Applied for 5.13, thanks.
>

I have requested a couple of changes in the patch series. Can this
applied series still be changed or new patches are required?
