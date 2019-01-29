From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 5/5] psi: introduce psi monitor
Date: Tue, 29 Jan 2019 10:31:40 -0800
Message-ID: <CAJuCfpHdtY7cRBfVP-+e9hQrTigStj2XK_qpk8z91HSKW+Y5WA@mail.gmail.com>
References: <20190124211518.244221-1-surenb@google.com> <20190124211518.244221-6-surenb@google.com>
 <20190129123843.GK28467@hirez.programming.kicks-ass.net> <CAJuCfpGxtGHsow002nd8Ao8mo9MaZQqZau_NLTMrZ8=aypTkig@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0m3skRRv8gGXarJnQx7v/9n5i4k4SmQKxcZwANz4wvY=;
        b=J+vXHO/cVQyn/1ZJqpK6skQGqPQVpUQSFTHNxOQ/z+6XxcF12Z91kemu2Nn9BKNMUz
         VP2EBsuvQUqdG6OJx/S2GiAKnWo+P7aQJs+XX8IYSA27JNRhIyd5zPGOuA4KgMsq7Kee
         QiadlZ0vaoAxeOniQYEFw+UqJTxEOOafgjs+b2yXFkK417Qtr48IV6RG7VIffB2j+Njb
         c7cVImBJqH3RrxBu4gbUXHt5GgzGTblW6m3mg+uCtQfvUNk0vGUqQKmZ3QJ8lvIbM0cH
         QoErGjgId+U39N2tUYBt2csNLu2AJeqjLyj3WU/Qlx6fW9iBFyqFB9iWtV5dL84G55L8
         HcUw==
In-Reply-To: <CAJuCfpGxtGHsow002nd8Ao8mo9MaZQqZau_NLTMrZ8=aypTkig@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, axboe@kernel.dk, dennis@kernel.org, Dennis Zhou <dennisszhou@gmail.com>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@android.com

On Tue, Jan 29, 2019 at 10:18 AM Suren Baghdasaryan <surenb@google.com> wrote:
>
> On Tue, Jan 29, 2019 at 4:38 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Thu, Jan 24, 2019 at 01:15:18PM -0800, Suren Baghdasaryan wrote:
> > > +                     atomic_set(&group->polling, polling);
> > > +                     /*
> > > +                      * Memory barrier is needed to order group->polling
> > > +                      * write before times[] read in collect_percpu_times()
> > > +                      */
> > > +                     smp_mb__after_atomic();
> >
> > That's broken, smp_mb__{before,after}_atomic() can only be used on
> > atomic RmW operations, something atomic_set() is _not_.
>
> Oh, I didn't realize that. After reading the following example from
> atomic_ops.txt I was under impression that smp_mb__after_atomic()
> would make changes done by atomic_set() visible:
>
> /* All memory operations before this call will
> * be globally visible before the clear_bit().
> */
> smp_mb__before_atomic();
> clear_bit( ... );
> /* The clear_bit() will be visible before all
> * subsequent memory operations.
> */
> smp_mb__after_atomic();
>
> but I'm probably missing something. Is there a more detailed
> description of these rules anywhere else?

I was referred to memory-barriers.txt that explains this clearly
stating that "These functions do not imply memory barriers.". Thanks
for noticing! Will change to smp_mb().

> Meanwhile I'll change smp_mb__after_atomic() into smp_mb(). Would that
> fix the ordering?
>
> > --
> > You received this message because you are subscribed to the Google Groups "kernel-team" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> >
