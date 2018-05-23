From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 6/7] psi: pressure stall information for CPU, memory, and
 IO
Date: Wed, 23 May 2018 09:17:47 -0400
Message-ID: <20180523131747.GA4086@cmpxchg.org>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
 <20180507210135.1823-7-hannes@cmpxchg.org>
 <87060553-2e09-2e2a-13a2-a91345d6df30@codeaurora.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bXtgLOdeHshlQpEJ7jqwOj/3dz2Qx0kbmqkNFXF9mCM=; b=GFMdoa1rH5o9/YzxQ8gP2VzjiT
        nKDK1+Ntr9KeM2afQ56UUum/sKvQdMM1rM/sPvoDgwDuXf2RcK/HrNFlZph1ZX51JWWRVxPL9c50z
        9CHOJRYYkAVmmqnuIuTQAy5FBX6JA1NZhvx+/Ta+rlsE56YwPLGfJutexzRaaW/kLmEA=;
Content-Disposition: inline
In-Reply-To: <87060553-2e09-2e2a-13a2-a91345d6df30@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vinayak Menon <vinmenon@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Wed, May 09, 2018 at 04:33:24PM +0530, Vinayak Menon wrote:
> On 5/8/2018 2:31 AM, Johannes Weiner wrote:
> > +	/* Kick the stats aggregation worker if it's gone to sleep */
> > +	if (!delayed_work_pending(&group->clock_work))
> 
> This causes a crash when the work is scheduled before system_wq is up. In my case when the first
> schedule was called from kthreadd. And I had to do this to make it work.
> if (keventd_up() && !delayed_work_pending(&group->clock_work))
>
> > +		schedule_delayed_work(&group->clock_work, MY_LOAD_FREQ);

I was trying to figure out how this is possible, and it didn't make
sense because we do initialize the system_wq way before kthreadd.

Did you by any chance backport this to a pre-4.10 kernel which does
not have 3347fa092821 ("workqueue: make workqueue available early
during boot") yet?

> > +void psi_task_change(struct task_struct *task, u64 now, int clear, int set)
> > +{
> > +	struct cgroup *cgroup, *parent;
> 
> unused variables

They're used in the next patch, I'll fix that up.

Thanks
