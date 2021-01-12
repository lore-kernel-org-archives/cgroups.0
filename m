From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: prevent starvation when writing
 memory.high
Date: Tue, 12 Jan 2021 14:53:06 -0500
Message-ID: <X/3+IgDVb+Jn4XfQ@cmpxchg.org>
References: <20210112163011.127833-1-hannes@cmpxchg.org>
 <CALvZod4VFA52dsdkW79-gUbiCf2ONfFJj6LkRU+3-fQpvYXL+A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r3RcTfMe7SWAKR9ZPaILuwCLkjEw52kXwdvMKFbxE+Y=;
        b=xNb+jXyynOtMDGYrXvcjUcO1CyQWacGxvJvRvEKyedu3WJVOTOZbv25S2m8yr5PD/y
         esanXfysmROgybxXxP9XniQQQPP+U2ROGwezs7psAGDv45Xpm5aWrVI8oSxAVXF1XtCn
         j5i8fxDNcSlJlDnjAONEV3qx3q4PnJeW4KW1ON266+jtRWCH+DPrg2eRcpmlBAutB4/a
         zBURoO0FdYjVF4uJ1NUQ1lfOMejaHhbbPKJeIoEd394wvVxBNxnPBewf6fmWsbc25Qg+
         SDeiRf0JkL/dhE75JqCf1XLpbdDd2fNM/edlnqtoxuKLhsbdAoz1qszvoTfX+R/IRXXI
         yQEg==
Content-Disposition: inline
In-Reply-To: <CALvZod4VFA52dsdkW79-gUbiCf2ONfFJj6LkRU+3-fQpvYXL+A@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Tue, Jan 12, 2021 at 10:59:58AM -0800, Shakeel Butt wrote:
> On Tue, Jan 12, 2021 at 9:12 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > When a value is written to a cgroup's memory.high control file, the
> > write() context first tries to reclaim the cgroup to size before
> > putting the limit in place for the workload. Concurrent charges from
> > the workload can keep such a write() looping in reclaim indefinitely.
> >
> 
> Is this observed on real workload?

Yes.

On several production hosts running a particularly aggressive
workload, we've observed writers to memory.high getting stuck for
minutes while consuming significant amount of CPU.

> Any particular reason to remove !reclaimed?

It's purpose so far was to allow successful reclaim to continue
indefinitely, while restricting no-progress loops to 'nr_retries'.

Without the first part, it doesn't really matter whether reclaim is
making progress or not: we do a maximum of 'nr_retries' loops until
the cgroup size meets the new limit, then exit one way or another.
