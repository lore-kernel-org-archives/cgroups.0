From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v6 1/7] psi: introduce state_mask to represent stalled psi states
Date: Tue, 19 Mar 2019 18:53:58 -0700
Message-ID: <CAJuCfpHyGmhkF+LThARQTrcpAYf2ASMxLokE56dZcOEOHb7QtQ@mail.gmail.com>
References: <20190319235619.260832-1-surenb@google.com> <20190319235619.260832-2-surenb@google.com>
 <20190320110249.652ec153@canb.auug.org.au> <CAJuCfpFEqv+x2GnSeU_JLQ3ahvfgNVPYyoRAxkDHcvVw-4r=jg@mail.gmail.com>
 <20190320111516.6e151efe@canb.auug.org.au>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hdt+D6p9E7l7lnV6StTuQf0AYgJKugS80mLd0f4DexY=;
        b=h+CutXz8gO4OJgPl4VPG+zVIErRIvBJ8IxVKR32U5P2BVfmfeiaWXN7ZnnV1dGf6fb
         Tk47u6O1mN4D5oYTSKa5XtllNaJr2T7aO4WIG9hhBUaxObEn7tCGDa6n4Hm27rE/gEFj
         d8B6FAW+YaLKbyQsPUaqaZR3n+2QTxBLkja8nEru3FSUt/wECjlLIYZqlA/Yw7VGSJJh
         3hnP5mpWolKnbsea1EaCRevc9gqsr2lSEAfK7tmp2V0kE5D+N4awLn2afGVYdLAWYoky
         s0OH+E3KsStUuymTAzcYImjUKzgt0oQZodQB4Hww8g+JYnFSxi27ETyPUOlkgoioW5eJ
         077w==
In-Reply-To: <20190320111516.6e151efe@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, axboe@kernel.dk, dennis@kernel.org, Dennis Zhou <dennisszhou@gmail.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@android.com>

On Tue, Mar 19, 2019 at 5:15 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi Suren,
>
> On Tue, 19 Mar 2019 17:06:50 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > Sorry about that. This particular patch has not changed since then,
> > that's why I kept all the lines there. Please let me know if I should
> > remove it and re-post the patchset.
>
> As long as anyone who is going to apply this patch is aware, there is
> no need to repost just for that.  In the future, if you are modifying a
> patch that you are resubmitting, you should start from the original
> patch (not the version that someone else has applied to their git tree
> or quilt series).

Got it. Thanks!

> --
> Cheers,
> Stephen Rothwell
