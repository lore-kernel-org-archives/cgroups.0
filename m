From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Thu, 19 Jul 2018 08:08:20 -0700
Message-ID: <CA+55aFw7t++BzEy-XsatNcauw3Wn22SSXfd3iTYECi4fJ97CCg@mail.gmail.com>
References: <20180712172942.10094-1-hannes@cmpxchg.org> <20180712172942.10094-9-hannes@cmpxchg.org>
 <20180718120318.GC2476@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k9XyS2+Bjfxgi4gGbi43c33wHKsoxIM0ST7EsX47Tuw=;
        b=cm5gGTFbP0qWGa010xXAjOG7WIcdtNXFTliB3RbeVdpfkaCwQPGf5oOrlhtA5OKL1n
         Za4Zxs4GzVrgvVJCTyYM+uxaN9LuROjHZ7MwRcm/RgaZ39EyrhqLqoSMnnoR9WZ4dAnn
         agoCsLjIFsyZy4xfZngAIaHd6zO4o4EoJqiRQ=
In-Reply-To: <20180718120318.GC2476@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, surenb@google.com, Vinayak Menon <vinmenon@codeaurora.org>, Christoph Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, shakeelb@google.com, linux-mm <linux-mm@kvack.org>, cgroups <cgroups@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>

On Wed, Jul 18, 2018 at 5:03 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> And as said before, we can compress the state from 12 bytes, to 6 bits
> (or 1 byte), giving another 11 bytes for 59 bytes free.
>
> Leaving us just 5 bytes short of needing a single cacheline :/

Do you actually need 64 bits for the times?

That's the big cost. And it seems ridiculous, if you actually care about size.

You already have a 64-bit start time. Everything else is some
cumulative relative time. Do those really need 64-bit and nanosecond
resolution?

Maybe a 32-bit microsecond would be ok - would you ever account more
than 35 minutes of anything without starting anew?

             Linus
