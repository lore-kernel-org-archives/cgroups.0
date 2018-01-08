From: Tejun Heo <tj@kernel.org>
Subject: Re: Cgroups v2 thread mode "domain invalid" state
Date: Mon, 8 Jan 2018 08:08:46 -0800
Message-ID: <20180108160846.GV3668920@devbig577.frc2.facebook.com>
References: <CAKgNAkg2u=zt87tKk35vR+tQ7DnkJp9vbj+8n88=_MCcvmH9oQ@mail.gmail.com>
 <20171222001554.GH1084507@devbig577.frc2.facebook.com>
 <CAKgNAkhWhw8LNBdVZPzZ73VOmXDrxzSUD862AHduAhs3CF0bNw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wgcLCblIL8pyaFn5uB2AFCjirdNrmkQuW9z3rEPIGbc=;
        b=QCXlbqAJbPLjTl+QAqsPDBURMpJkDLtZTE2ONRAH5ukVPxxcsE58PKPrHC4XcIeA39
         +AiKqt0LrSAE1iAjhtSFKeoS384NNUf8ZDhOAn844Lto5zDyp5Hz3y1iM6iwdwhO5YfJ
         qYN2KH5rtT5qq3pIoigOJWDg/puZdWOW+il//Kn/ESDzAQps56+Q5rEw+fmUIr//8PAq
         +Vc/XvzcEAq3fmFSmtNBXRqnmWvUh/ieIJY5XwzjO8LyJ5oDpXN23GzYqlmv/J1kwtuU
         V336vJh20SgvVlZJWAmKMwCh9IYP95ubcKl3WK23EkpzStPSlLI8HUHh8Cldqit+1rgT
         PdJg==
Content-Disposition: inline
In-Reply-To: <CAKgNAkhWhw8LNBdVZPzZ73VOmXDrxzSUD862AHduAhs3CF0bNw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, longman@redhat.com, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>

Hello, Michael.

On Fri, Dec 22, 2017 at 10:11:00AM +0100, Michael Kerrisk (man-pages) wrote:
> I don't get the above. I mean, if we have the following hierarchy,
> where R is the cgoup v2 mount point:

You're right, I'm probably confused with an earlier variant.  I might
still be forgetting something in this area.  I'll ping back if I can
recall something.

> > * Possible extension to threadmode.  If we figure out how to do mixed
> >   mode further down in the hierarchy (and if there are actual use
> >   cases which require that), automatically switching would be really
> >   confusing.
> >
> > The invalid state while not the most convenient is straight forward
> > (only the operations which are explicitly asked are performed) and
> > keeps the door open for future changes.
> 
> The "allowing for future" extensions idea makes some sense to me.
> 
> One other point that occurred to me after I wrote my email yesterday
> was that if the threaded root reverts from being "domain threaded" to
> "domain" (because it no longer has "threaded" children AND either it
> has no member processes or it has no threaded controllers enabled),
> then the "domain invalid" descendants revert to type "domain". I'm not
> sure whether that detail also provides some rationale as to why all
> descendants of the threaded root cgroup aren't automatically converted
> to type "threaded". Any thoughts about that?

Currently, thread mode implementation doesn't allow reverting back to
domain.  The problem there is that it's impossible to tell which
portions of the domain consumptions that are accounted to the threaded
domain (the parent of threaded subtree) belong to the cgroup which is
trying to revert to domain.

But assuming we in the future allow reverting back to domain,
scenarios similar to what you suggested can become problematic.  All
operations always behaving recursively will probably be the only sane
solution but that blocks some possibilities for future changes.

Thanks.

-- 
tejun
