From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v6 1/7] psi: introduce state_mask to represent stalled psi states
Date: Tue, 19 Mar 2019 17:06:50 -0700
Message-ID: <CAJuCfpFEqv+x2GnSeU_JLQ3ahvfgNVPYyoRAxkDHcvVw-4r=jg@mail.gmail.com>
References: <20190319235619.260832-1-surenb@google.com> <20190319235619.260832-2-surenb@google.com>
 <20190320110249.652ec153@canb.auug.org.au>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eXp5qzoLPE5k4y/K+1OpvTbOH6oNQxSHAXnNXH0YvjQ=;
        b=Bur//thXopzVgwZJB7yIAIDhmYXnRCW6LthfE+610t5jV9d54r7SkeAhSSh8y7m5Zi
         /VYoJUghb4zWk2ojIaQffbFmDWXT5+bSZxdnlF7xlaiuqSmcuXM7hfN8cGLJdRvmIci9
         9clf/LGQ2TUf6AkWFIeRNei5APFL9r/bwC/QYUd3l50LdBZS9ZToLA6jD3+rtGvnqm4t
         Hvbd1dGMzUi904201WtqeTnm2oO2HTyGosAFtQKafrUe5JlbyCWgfcLxhCjEOItETDoJ
         fLwgwJu4UfNt1ZvkV5b94Nt2z/ESi1u4CI5ogvLA6g7WQlp0a6cLY4DS2b4oiX68xyV5
         nG+w==
In-Reply-To: <20190320110249.652ec153@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, axboe@kernel.dk, dennis@kernel.org, Dennis Zhou <dennisszhou@gmail.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@android.com>

On Tue, Mar 19, 2019 at 5:02 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi Suren,

Hi Stephen,

> On Tue, 19 Mar 2019 16:56:13 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > The psi monitoring patches will need to determine the same states as
> > record_times().  To avoid calculating them twice, maintain a state mask
> > that can be consulted cheaply.  Do this in a separate patch to keep the
> > churn in the main feature patch at a minimum.
> >
> > This adds 4-byte state_mask member into psi_group_cpu struct which results
> > in its first cacheline-aligned part becoming 52 bytes long.  Add explicit
> > values to enumeration element counters that affect psi_group_cpu struct
> > size.
> >
> > Link: http://lkml.kernel.org/r/20190124211518.244221-4-surenb@google.com
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Dennis Zhou <dennis@kernel.org>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Li Zefan <lizefan@huawei.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Tejun Heo <tj@kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>
> This last SOB line should not be here ... it is only there on the
> original patch because I import Andrew's quilt series into linux-next.

Sorry about that. This particular patch has not changed since then,
that's why I kept all the lines there. Please let me know if I should
remove it and re-post the patchset.
Thanks,
Suren.

> --
> Cheers,
> Stephen Rothwell
>
> --
> You received this message because you are subscribed to the Google Groups "kernel-team" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
