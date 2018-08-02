From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/9] mm: workingset: tell cache transitions from
 workingset thrashing
Date: Thu, 2 Aug 2018 08:28:52 -0400
Message-ID: <20180802122852.GA17974@cmpxchg.org>
References: <20180801151958.32590-1-hannes@cmpxchg.org>
 <20180801151958.32590-3-hannes@cmpxchg.org>
 <CAJuCfpGZGPD+k+jHDowWyvZPnUXzQ9n98wBycDZLAWOn=vV6Ew@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DCMyHA3qkDdppqTw/RcH7oFWVcJjBHKC8GDSBWiqQtM=;
        b=ukNRTZQVT3U4Phez9QF72NZQmJs6CgsjhoRmbbZKycNnC/voOfHJkjpyd53ruz9v04
         hQ83p9QjGY8DQog19IU5iTY9h61fl9V83yRFODCdbN0JPyxpt8yti9dr1QGBZfRXrV6P
         6Tw8v11zZPi7HkpZneIGe6pq60NH4eass6rp5kgnIg548A4Fcw3TDTkDihjy+x7F6Y89
         lqaUGBpUb/cIr2VufX2V5yf64YN/wm9G1j0lVTg7hD3nspwktFdmzi1EbY9HFCR3mmHW
         s3meXnysNjPPTF6ygSEK/3eyTG7PUKAP+eIZjvE+EyQsJ+IcPmJWe1vJjRZWqprdwaQB
         BENA==
Content-Disposition: inline
In-Reply-To: <CAJuCfpGZGPD+k+jHDowWyvZPnUXzQ9n98wBycDZLAWOn=vV6Ew@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, Peter Enderborg <peter.enderborg@sony.com>, linux-mm <linux-mm@kvack.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hi Suren,

On Wed, Aug 01, 2018 at 02:56:27PM -0700, Suren Baghdasaryan wrote:
> On Wed, Aug 1, 2018 at 8:19 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> >         /*
> > -        * The unsigned subtraction here gives an accurate distance
> > -        * across inactive_age overflows in most cases.
> > +        * Calculate the refault distance
> >          *
> > -        * There is a special case: usually, shadow entries have a
> > -        * short lifetime and are either refaulted or reclaimed along
> > -        * with the inode before they get too old.  But it is not
> > -        * impossible for the inactive_age to lap a shadow entry in
> > -        * the field, which can then can result in a false small
> > -        * refault distance, leading to a false activation should this
> > -        * old entry actually refault again.  However, earlier kernels
> > -        * used to deactivate unconditionally with *every* reclaim
> > -        * invocation for the longest time, so the occasional
> > -        * inappropriate activation leading to pressure on the active
> > -        * list is not a problem.
> > +        * The unsigned subtraction here gives an accurate distance
> > +        * across inactive_age overflows in most cases. There is a
> > +        * special case: usually, shadow entries have a short lifetime
> > +        * and are either refaulted or reclaimed along with the inode
> > +        * before they get too old.  But it is not impossible for the
> > +        * inactive_age to lap a shadow entry in the field, which can
> > +        * then can result in a false small refault distance, leading
> 
> "which can then can" - please remove one of the "can".

Good catch, will fix.
