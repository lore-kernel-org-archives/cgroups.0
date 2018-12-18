From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 6/6] psi: introduce psi monitor
Date: Tue, 18 Dec 2018 12:30:00 -0500
Message-ID: <20181218173000.GA4733@cmpxchg.org>
References: <20181214171508.7791-1-surenb@google.com>
 <20181214171508.7791-7-surenb@google.com>
 <20181217162223.GD2218@hirez.programming.kicks-ass.net>
 <CAJuCfpHGsDnE-eAHY1QnX949stA3cvNA=078q1swqVnz95aJfg@mail.gmail.com>
 <20181218104622.GB15430@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gUey7Zbt0/b42GYcDqdXluKToQHKpjhH7c7i9g2qAPQ=;
        b=07Kj4DIqpm3qGJrMz5nve9A4ZGGKM2wV5SM0fLcyYiPgFD383RDtI8GCbLnKYpyJoZ
         q5M2bWJ3BpkxaIxeWrO5JRbJWvzXmWeeVWkWgOqzfCJRoaatMVkheQb6JRb4hQ6o2RCj
         riUiEFXdQNyx3l7nlOT0N+p3h2zjL97Gekt3+IHb/HgCJWBQAiM0kXdlWRgrrWU2bxyC
         tyDnlJcu86Ue/BYguoXWsyZIbmRCO7foD9F/e3bn4JOquWM1/Q1nN68kk3vLxvbEMYbq
         qfpfNF94PtsWNp+xoBJJfF6BBd4AEZijMnkieXM6lzH+GWo0q3OGRSyPrEIoxKG2jCba
         ShTA==
Content-Disposition: inline
In-Reply-To: <20181218104622.GB15430@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, axboe@kernel.dk, dennis@kernel.org, Dennis Zhou <dennisszhou@gmail.com>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@android.com

On Tue, Dec 18, 2018 at 11:46:22AM +0100, Peter Zijlstra wrote:
> On Mon, Dec 17, 2018 at 05:21:05PM -0800, Suren Baghdasaryan wrote:
> > On Mon, Dec 17, 2018 at 8:22 AM Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > How well has this thing been fuzzed? Custom string parser, yay!
> > 
> > Honestly, not much. Normal cases and some obvious corner cases. Will
> > check if I can use some fuzzer to get more coverage or will write a
> > script.
> > I'm not thrilled about writing a custom parser, so if there is a
> > better way to handle this please advise.
> 
> The grammar seems fairly simple, something like:
> 
>   some-full = "some" | "full" ;
>   threshold-abs = integer ;
>   threshold-pct = integer, { "%" } ;
>   threshold = threshold-abs | threshold-pct ;
>   window = integer ;
>   trigger = some-full, space, threshold, space, window ;
> 
> And that could even be expressed as two scanf formats:
> 
>  "%4s %u%% %u" , "%4s %u %u"
> 
> which then gets your something like:
> 
>   char type[5];
> 
>   if (sscanf(input, "%4s %u%% %u", &type, &pct, &window) == 3) {
>   	// do pct thing
>   } else if (sscanf(intput, "%4s %u %u", &type, &thres, &window) == 3) {
>   	// do abs thing
>   } else return -EFAIL;
> 
>   if (!strcmp(type, "some")) {
>   	// some
>   } else if (!strcmp(type, "full")) {
>   	// full
>   } else return -EFAIL;
> 
>   // do more

We might want to drop the percentage notation.

While it's somewhat convenient, it's also not unreasonable to ask
userspace to do a simple "threshold * win / 100" themselves, and it
would simplify the interface spec and the parser.

Sure, psi outputs percentages, but only for fixed window sizes, so
that actually saves us something, whereas this parser here needs to
take a fractional anyway. The output is also in decimal notation,
which is necessary for granularity. And I really don't think we want
to add float parsing on top of this interface spec.

So neither the convenience nor the symmetry argument are very
compelling IMO. It might be better to just not go there.
