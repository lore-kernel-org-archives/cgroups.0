From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 5/5] psi: introduce psi monitor
Date: Tue, 29 Jan 2019 10:25:58 -0800
Message-ID: <CAJuCfpHyuY89Aw3YpQpaor2hKvdqJOH5sMoXNZ-yNAnAb+tY6A@mail.gmail.com>
References: <20190124211518.244221-1-surenb@google.com> <20190124211518.244221-6-surenb@google.com>
 <20190129123843.GK28467@hirez.programming.kicks-ass.net> <20190129151649.GA2997@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ADwM0lszvaqhduF5I3DNeFvWPeUQTXjMtjOQKUDAPJ8=;
        b=BXh7n98B5xjbeB+aql7MNs/6BjRNZglzr66LB5d1zE4A4IXStoeq7g7volggkOR0jm
         Zw4Ew6E/Mn8x9yOekTa6e3ZeVuRcso8aX3m5+bpoW/SbRmwVAh7PW5CHhPa3QjTpqSWI
         uLYmSvffhC1lccnslt+fRVgCkeoPzinyOXdqCHzx03/tGID0YwW0bRIT+fsW57P472hY
         dIksMeGK073m5vEA30nAIeiNKStj7FtgFsaObHsW4CFEy8wMXyPrYI4K27+VKVl2sh9y
         MmAVuYcOhROvZCyChKdV3QsAE741Ix5ZmCqCkX3aa2Jdi2RMb+Cwe5vou1Ftliov/taq
         +Hdg==
In-Reply-To: <20190129151649.GA2997@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, axboe@kernel.dk, dennis@kernel.org, Dennis Zhou <dennisszhou@gmail.com>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@android.com

On Tue, Jan 29, 2019 at 7:16 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Jan 29, 2019 at 01:38:43PM +0100, Peter Zijlstra wrote:
> > On Thu, Jan 24, 2019 at 01:15:18PM -0800, Suren Baghdasaryan wrote:
> > > +                   atomic_set(&group->polling, polling);
> > > +                   /*
> > > +                    * Memory barrier is needed to order group->polling
> > > +                    * write before times[] read in collect_percpu_times()
> > > +                    */
> > > +                   smp_mb__after_atomic();
> >
> > That's broken, smp_mb__{before,after}_atomic() can only be used on
> > atomic RmW operations, something atomic_set() is _not_.
>
> Also; the comment should explain _why_ not only what.

Got it. Will change the comment to something like:

Order group->polling=0 before reading times[] in
collect_percpu_times() to detect possible race with hotpath that
modifies times[] before it sets group->polling=1 (see Race #1 in the
comments at the top).

> --
> You received this message because you are subscribed to the Google Groups "kernel-team" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
