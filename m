From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 5/5] psi: introduce psi monitor
Date: Tue, 29 Jan 2019 10:05:07 -0800
Message-ID: <CAJuCfpH3k0rrZZw_HhrjXYuFX31p283qg_5vQEnyd_wAMaxbqA@mail.gmail.com>
References: <20190124211518.244221-1-surenb@google.com> <20190124211518.244221-6-surenb@google.com>
 <20190129104431.GJ28467@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y+ap6Bq9i9Bosxjv/aC11VsPIK0N0Zh2bt/qMaK7RFo=;
        b=pTMYdsjVGlPjGB46EzZOJP2ZzDqCQrAqtMKteb4meGoxCxhdPbKwQR1sea+cC+6KTW
         G+seq4FJVEvK5CRhVUtH84btkAFM7Xc4jxG+SDLF8sUlDknTuC2WFvELFSNqQRh3hYCG
         CvcEgmI2ubiEKT3037EZFz8oCFJ9h2vrXZeY/DN5KatkMVTeIUt85CojWalyztZWPCu9
         5UNFCramOZsutLuabzLGoYyV22vjYFlPJrv+sIbEz+foWtJ/T43QYM6ELa5elREGVVhI
         DNszJWv4OwXbAtfHWrgmqegPvT7xs193W6REmvUd1rwEKb5NxMrkXxmOSbFn7DV+Sf2Z
         wrqg==
In-Reply-To: <20190129104431.GJ28467@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, axboe@kernel.dk, dennis@kernel.org, Dennis Zhou <dennisszhou@gmail.com>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@android.com

Thanks for review Peter!

On Tue, Jan 29, 2019 at 2:44 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Jan 24, 2019 at 01:15:18PM -0800, Suren Baghdasaryan wrote:
> >  static void psi_update_work(struct work_struct *work)
> >  {
> >       struct delayed_work *dwork;
> >       struct psi_group *group;
> > +     bool first_pass = true;
> > +     u64 next_update;
> > +     u32 change_mask;
> > +     int polling;
> >       bool nonidle;
> > +     u64 now;
> >
> >       dwork = to_delayed_work(work);
> >       group = container_of(dwork, struct psi_group, clock_work);
> >
> > +     now = sched_clock();
> > +
> > +     mutex_lock(&group->update_lock);
>
> actually acquiring a mutex can take a fairly long while; would it not
> make more sense to take the @now timestanp _after_ it, instead of
> before?

Yes, that makes sense. As long as *now* is set before the *retry*
label, otherwise the retry mechanism would get even more complicated
to understand with floating *now* timestamp. Will move the assignment
right after the mutex_lock()

> --
> You received this message because you are subscribed to the Google Groups "kernel-team" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
