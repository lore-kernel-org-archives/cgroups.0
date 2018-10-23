From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/9] psi: pressure stall information for CPU, memory, and
 IO v4
Date: Tue, 23 Oct 2018 13:29:37 -0400
Message-ID: <20181023172937.GA21443@cmpxchg.org>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
 <20181018190710.fcea1c5f9c3b0c15d37ee762@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=p+GUZjTRskiLlmKpga5pTHMTouwhMfYvT279qB1hK60=;
        b=itbAAzwpNKBDUm2qri1EI6NDeyb6tJAFb0npG0uiL1Bq600UD6HkQpy+vxvjN4HUXB
         n83zpzv9aJikA4zNrmza5FkAr1idSFSEqp5RAeOi6YFUHJxwHcXX6pm0rQcGFCDv1AZw
         zcjNGkV488c3szCN7bC4kNlbtxWBnKjP6dNTnk5ETWDvVCyecCLmR0Cz+vwVb6vFKR8J
         kUdg65uNQrXS1rtZUQWPh7w+rZo0TX1NClFYees36oCx6xP7lSdUJ2uOUcT/4rzqMpNv
         SDRJ09r+Bcg1HbK24GY5pp02AGGs7At29N6iFDmRWrEp1RyDpp0niZ4FXKLHcuvr5zzR
         SqpA==
Content-Disposition: inline
In-Reply-To: <20181018190710.fcea1c5f9c3b0c15d37ee762@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Oct 18, 2018 at 07:07:10PM -0700, Andrew Morton wrote:
> On Tue, 28 Aug 2018 13:22:49 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > This version 4 of the PSI series incorporates feedback from Peter and
> > fixes two races in the lockless aggregator that Suren found in his
> > testing and which caused the sample calculation to sometimes underflow
> > and record bogusly large samples; details at the bottom of this email.
> 
> We've had very little in the way of review activity for the PSI
> patchset.  According to the changelog tags, anyway.

Peter reviewed it quite extensively over all revisions, and acked the
final version. Peter, can we add your acked-by or reviewed-by tag(s)?

The scheduler part accounts for 99% of the complexity in those
patches. The mm bits, while somewhat sprawling, are mostly mechanical.
