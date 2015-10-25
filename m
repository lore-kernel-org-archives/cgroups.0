From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified hierarchy
Date: Sun, 25 Oct 2015 12:54:48 +0900
Message-ID: <CA+55aFzMdG5VPA0ZvoFANj-H-7LHeu=JUvvqPykF_w5Nd0pnSA@mail.gmail.com>
References: <20150824221935.GN28944@mtj.duckdns.org>
	<CAPM31RK08pC3g9qx+TEw6PQvtHk8idKE3OALQN8cFr_QOuT3FA@mail.gmail.com>
	<20150825210234.GE26785@mtj.duckdns.org>
	<CAPM31RJvrPL7S37=yhxMA5OGUFNUfPurTZ21nfH6eFRb15ZGtw@mail.gmail.com>
	<20150912144007.GA8942@htj.duckdns.org>
	<CAPM31RLAtuaDbE9+nvMvgMB8zaOpxVcriCyE9qqszNM3XXTo5Q@mail.gmail.com>
	<20151001184629.GB26498@mtj.duckdns.org>
	<CAPM31RKx0vT-9VFN=XASYM4iv4U5ZGZW93XRtJd_7mOHwu76NA@mail.gmail.com>
	<20151023222110.GA4390@mtj.duckdns.org>
	<1445661367.3218.62.camel@gmail.com>
	<20151025021829.GA15471@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=UnlwYy6P7hQ8YtU5NuBIG77WnRtgD7IFvD/RvW/GcaE=;
        b=CvAlLB1fZ29MLGELOA6v2jJ1tTph2hd4RHYIwg+oPszGPzvg1D6ho+XLRqxjhJ/z0M
         AS/mYZeQKp5q6PzznANdrfuMaEvO4fAZHIdAI/zmg6vAwafj17ZeYPZTnMk21xwDLzrM
         E+J/tySdJyvCy8BAX46ZAWM09Cw/LJInGPrzPL4zS8nbpBVbIuFge1BjKG5IYdJvnUgN
         BYScZ0bNihtaHPu9PeHNRe5HGj9VOhCFtz6ZEPWsHjxCpGBnQ/jsy2QLLo+m0taRks20
         oAiNEsWdgIdTZbFospwef9e/2zj061r+fnW6JQZ3TeRxenkCYPWFvKjyyP0S3NkALEVg
         GseQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=UnlwYy6P7hQ8YtU5NuBIG77WnRtgD7IFvD/RvW/GcaE=;
        b=RgwNipqbr4CEv/xJfGZCFjjERK67Q27TQzoasdOalWM2tRy6cc6NdE8zIUnwrJhs8e
         9pEg43vq6gFJ0dvLRUMMbbiuP9Zk+Tt/w7MKp638nuIKmDs4CnMFFIUhyYxO1pkq3WdP
         HCRwdt4n0gwBAqbTZFc5zFCEPVsVIu0q8kW4M=
In-Reply-To: <20151025021829.GA15471@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Andrew Morton <akpm@linux-foundation.org>

On Sun, Oct 25, 2015 at 11:18 AM, Tejun Heo <tj@kernel.org> wrote:
>
> We definitely need to weigh the inputs from heavy users but also need
> to discern the actual problems which need to be solved from the
> specific mechanisms chosen to solve them.  Let's please keep the
> discussions technical.  That's the best way to reach a viable
> long-term solution which can benefit a lot wider audience in the long
> term.  Even though that might not be the path of least immediate
> resistance, I believe that google will be an eventual beneficiary too.

So here's a somewhat odd request I got to hear very recently (at
LinuxCon EU in Ireland)..

A least some game engine writers apparently would like to be able to
set scheduling priorities for threads within a single process, because
they may want te game as a whole to have a certain priority, but then
some of the threads are critical for latency and may want certain
guaranteed resources (eg audio or actual gameplay) while others are
very much background things (garbage collection etc).

I suspect that's a very non-google use. We apparently don't really
support that kind of per-thread model right now at all.

Do they want cgroups? Maybe not. You can apparently do something like
this under Windows and OS X, but not under Linux (and I'm reporting
second-hand here, I don't know the exact details). I'm just bringing
it up as a somewhat unusual non-server thing that is certainly very
relevant despite being different.

                 Linus
