From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 5/5] psi: introduce psi monitor
Date: Tue, 29 Jan 2019 10:18:20 -0800
Message-ID: <CAJuCfpGxtGHsow002nd8Ao8mo9MaZQqZau_NLTMrZ8=aypTkig@mail.gmail.com>
References: <20190124211518.244221-1-surenb@google.com> <20190124211518.244221-6-surenb@google.com>
 <20190129123843.GK28467@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+GxBm8s8C6x84ozFyjXoCsKwNqijbNBimqTvowaT6HA=;
        b=wU/63d3BqpbaETl1R60YuKHDVlM6oWOlycD365weCHPw8D4pDzyh2VmzYqavACHnQy
         2E0vBCvdlWBdD0etwek0HhdNqKvPtKLOAlQFgRzID0mB2cjaCZJAIigmbf1v4lWqUmwF
         JYp4Lm4pJN4DP1NeOojB4yAKbERZnHYyTY/xV0SnPKvVMxwa0YihtVntVY4dx1P0s7Xv
         4qCpYp2b+meS9qpg6uaMXpF6iwtg2kmE0QFWzaul4ag1gf7tCHOCDFeIDiSALdVR1tN1
         YAYiKWKxmIsV+dTX2MeLcYGkNN7xNy2V9BjAvc+Yg3lghhd8r0GW1PvEMaDY7CwEZJHL
         Tr5A==
In-Reply-To: <20190129123843.GK28467@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, axboe@kernel.dk, dennis@kernel.org, Dennis Zhou <dennisszhou@gmail.com>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@android.com

On Tue, Jan 29, 2019 at 4:38 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Jan 24, 2019 at 01:15:18PM -0800, Suren Baghdasaryan wrote:
> > +                     atomic_set(&group->polling, polling);
> > +                     /*
> > +                      * Memory barrier is needed to order group->polling
> > +                      * write before times[] read in collect_percpu_times()
> > +                      */
> > +                     smp_mb__after_atomic();
>
> That's broken, smp_mb__{before,after}_atomic() can only be used on
> atomic RmW operations, something atomic_set() is _not_.

Oh, I didn't realize that. After reading the following example from
atomic_ops.txt I was under impression that smp_mb__after_atomic()
would make changes done by atomic_set() visible:

/* All memory operations before this call will
* be globally visible before the clear_bit().
*/
smp_mb__before_atomic();
clear_bit( ... );
/* The clear_bit() will be visible before all
* subsequent memory operations.
*/
smp_mb__after_atomic();

but I'm probably missing something. Is there a more detailed
description of these rules anywhere else?

Meanwhile I'll change smp_mb__after_atomic() into smp_mb(). Would that
fix the ordering?

> --
> You received this message because you are subscribed to the Google Groups "kernel-team" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
