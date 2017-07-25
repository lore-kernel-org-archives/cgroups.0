From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: remove unnecessary empty check when enabling
 threaded mode
Date: Tue, 25 Jul 2017 13:16:08 -0400
Message-ID: <20170725171607.GC3216015@devbig577.frc2.facebook.com>
References: <1500669293-21792-1-git-send-email-longman@redhat.com>
 <1500669293-21792-2-git-send-email-longman@redhat.com>
 <20170722134358.GB3329631@devbig577.frc2.facebook.com>
 <20170723121826.GC1498614@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GLcvlO5wznzbi0/hG0wyvp4ALHe55VOGADFSzGU/uwI=;
        b=FgWslLnKoIx2TPNA1Z2ceabi+EQV8nnlAIXO5RaSl8y7q5FROUYZbbZLnyCiJjBPzr
         P2rlbL7BMXKOxaqAic1gGFILEW5ljK9tqipqvjqG6e/fNpxm7rzxnzmGu3cu+vqaFDel
         P5J9MW7Pw7Izg5eBfB9upcTY35C3/u4gepdX+tuXDGtKM+0fq34uKa7tbpxx1JtlPVyj
         FbkAJT0Xk6g91Vkq6t/Tcww6IUPrsxfdiLdzpbxWCgm2gVtACl+OvAvbflXp18P+8pxY
         RKdXdEi3hmDB4EpKeGxr2mgjotAKd37Xjw9o+kYixSNrglTu2F2Lgl8y0oF6eJ2+orTa
         VtRQ==
Content-Disposition: inline
In-Reply-To: <20170723121826.GC1498614@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On Sun, Jul 23, 2017 at 08:18:26AM -0400, Tejun Heo wrote:
> cgroup_enable_threaded() checks that the cgroup doesn't have any tasks
> or children and fails the operation if so.  This test is unnecessary
> because the first part is already checked by
> cgroup_can_be_thread_root() and the latter is unnecessary.  The latter
> actually cause a behavioral oddity.  Please consider the following
> hierarchy.  All cgroups are domains.
> 
>     A
>    / \
>   B   C
>        \
>         D
> 
> If B is made threaded, C and D becomes invalid domains.  Due to the no
> children restriction, threaded mode can't be enabled on C.  For C and
> D, the only thing the user can do is removal.
> 
> There is no reason for this restriction.  Remove it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Waiman Long <longman@redhat.com>

Applied to cgroup/for-4.14 with Waiman's ack.

Thanks.

-- 
tejun
