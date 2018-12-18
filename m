From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 6/6] psi: introduce psi monitor
Date: Mon, 17 Dec 2018 17:21:05 -0800
Message-ID: <CAJuCfpHGsDnE-eAHY1QnX949stA3cvNA=078q1swqVnz95aJfg@mail.gmail.com>
References: <20181214171508.7791-1-surenb@google.com> <20181214171508.7791-7-surenb@google.com>
 <20181217162223.GD2218@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mbu7X9AToTNe0+9pY+V/zik+z11jPPNgr5XbogPquck=;
        b=coXf01atRsTDqmB60HaGrMfJ9f0HsjrT+OHvDJEcfrJamR18DOV+C7fFynNk2ez9SJ
         BKSH1/oXnxflTvNhg+cGiL7yWVnj2Zg4e3QNNWlkYdCVMXHb43eZnhdyZOKXEi66v+RI
         HbljguhNMbi9EKkecWaukYVNcgrqph1g9k+fFNtG/EGhk9GizfS+fGgSN2p+Q+2PkFry
         kY20M9dCRj/bSHJZrgrAMFb/pnNcUyHC5iIWkM57w4hvflFBtOxRZhIvwdHzRUQ/kfLF
         JEPAfSUjM3ZhQK3CmnONs/7pVi7e5yHMB7jY8US8eK6M6y8iqmLkPsYLXVj7fTi8/b70
         BDEQ==
In-Reply-To: <20181217162223.GD2218@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, axboe@kernel.dk, dennis@kernel.org, Dennis Zhou <dennisszhou@gmail.com>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@android.com

On Mon, Dec 17, 2018 at 8:22 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, Dec 14, 2018 at 09:15:08AM -0800, Suren Baghdasaryan wrote:
> > +ssize_t psi_trigger_parse(char *buf, size_t nbytes, enum psi_res res,
> > +     enum psi_states *state, u32 *threshold_us, u32 *win_sz_us)
> > +{
> > +     bool some;
> > +     bool threshold_pct;
> > +     u32 threshold;
> > +     u32 win_sz;
> > +     char *p;
> > +
> > +     p = strsep(&buf, " ");
> > +     if (p == NULL)
> > +             return -EINVAL;
> > +
> > +     /* parse type */
> > +     if (!strcmp(p, "some"))
> > +             some = true;
> > +     else if (!strcmp(p, "full"))
> > +             some = false;
> > +     else
> > +             return -EINVAL;
> > +
> > +     switch (res) {
> > +     case (PSI_IO):
> > +             *state = some ? PSI_IO_SOME : PSI_IO_FULL;
> > +             break;
> > +     case (PSI_MEM):
> > +             *state = some ? PSI_MEM_SOME : PSI_MEM_FULL;
> > +             break;
> > +     case (PSI_CPU):
> > +             if (!some)
> > +                     return -EINVAL;
> > +             *state = PSI_CPU_SOME;
> > +             break;
> > +     default:
> > +             return -EINVAL;
> > +     }
> > +
> > +     while (isspace(*buf))
> > +             buf++;
> > +
> > +     p = strsep(&buf, "%");
> > +     if (p == NULL)
> > +             return -EINVAL;
> > +
> > +     if (buf == NULL) {
> > +             /* % sign was not found, threshold is specified in us */
> > +             buf = p;
> > +             p = strsep(&buf, " ");
> > +             if (p == NULL)
> > +                     return -EINVAL;
> > +
> > +             threshold_pct = false;
> > +     } else
> > +             threshold_pct = true;
> > +
> > +     /* parse threshold */
> > +     if (kstrtouint(p, 0, &threshold))
> > +             return -EINVAL;
> > +
> > +     while (isspace(*buf))
> > +             buf++;
> > +
> > +     p = strsep(&buf, " ");
> > +     if (p == NULL)
> > +             return -EINVAL;
> > +
> > +     /* Parse window size */
> > +     if (kstrtouint(p, 0, &win_sz))
> > +             return -EINVAL;
> > +
> > +     /* Check window size */
> > +     if (win_sz < PSI_TRIG_MIN_WIN_US || win_sz > PSI_TRIG_MAX_WIN_US)
> > +             return -EINVAL;
> > +
> > +     if (threshold_pct)
> > +             threshold = (threshold * win_sz) / 100;
> > +
> > +     /* Check threshold */
> > +     if (threshold == 0 || threshold > win_sz)
> > +             return -EINVAL;
> > +
> > +     *threshold_us = threshold;
> > +     *win_sz_us = win_sz;
> > +
> > +     return 0;
> > +}
>
> How well has this thing been fuzzed? Custom string parser, yay!

Honestly, not much. Normal cases and some obvious corner cases. Will
check if I can use some fuzzer to get more coverage or will write a
script.
I'm not thrilled about writing a custom parser, so if there is a
better way to handle this please advise.

> --
> You received this message because you are subscribed to the Google Groups "kernel-team" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
