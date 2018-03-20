From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 2/2] cpuset: Add cpuset.flags control knob to v2
Date: Tue, 20 Mar 2018 13:22:47 -0700
Message-ID: <20180320202247.GQ519464@devbig577.frc2.facebook.com>
References: <1521148842-15486-1-git-send-email-longman@redhat.com>
 <1521148842-15486-3-git-send-email-longman@redhat.com>
 <20180319162654.GR2943022@devbig577.frc2.facebook.com>
 <8e553b7e-cab6-1b5d-9110-cc5770ae16c4@redhat.com>
 <cbe9b852-80b6-8341-b51c-4d754d00ce53@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JJRebm91yWfZcmM+LpkiXWSVfAREfKscDI10Eld2EVM=;
        b=c/pXSUJwRvMN3CyXjSBteGtzRqOSWiUValZNeMyqJLGoymt66vJd/DaR5KQQeyj2zI
         M7C6B38pQiUXy+vPJVsV91uQyxmIiBSImgMCYnTtPPTabwfrkL0ESlJTzhul26OywPb/
         DQ+4Xfc43kJNMPrRi3sMJTwKwSkmBlOPLxjY6BkIkpR3diKGxJP4k1i34Kc5tlb//86n
         O15QYc5X2I8CFfJHQ7Gv5VJ8jowmzuTzS1poTi0E2yxzla0TdYNd4SDZ0PJwJFLgiTEQ
         r2SafBAmbD5auKmcPtkarUujO32iRzGw0gXMyGWhAIRB3n5r12INMzGG92k7ZrR0CuUS
         bPEA==
Content-Disposition: inline
In-Reply-To: <cbe9b852-80b6-8341-b51c-4d754d00ce53@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

Hello, Waiman.

On Tue, Mar 20, 2018 at 04:12:25PM -0400, Waiman Long wrote:
> After some thought, I am planning to impose the following additional
> constraints on how sched_load_balance works in v2.
> 
> 1) sched_load_balance will be made hierarchical, the child will inherit
> the flag from its parent.
> 2) cpu_exclusive will be implicitly associated with sched_load_balance.
> IOW, sched_load_balance => !cpu_exclusive, and !sched_load_balance =>
> cpu_exclusive.
> 3) sched_load_balance cannot be 1 on a child if it is 0 on the parent.
> 
> With these changes, sched_load_balance will have to be set by the parent
> and so will not be delegatable. Please let me know your thought on that.

So, for configurations, we usually don't let them interact across
hierarchy because that can lead to configurations surprise-changing
and delegated children locking the parent into the current config.

This case could be different and as long as we always guarantee that
an ancestor isn't limited by its descendants in what it can configure,
it should be okay (e.g. an ancestor should always be able to turn on
sched_load_balance regardless of how the descendants are configured).

Hmmm... can you explain why sched_load_balance needs to behave this
way?

Thanks.

-- 
tejun
