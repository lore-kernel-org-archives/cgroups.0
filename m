From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Tue, 11 Jan 2022 11:34:53 -0800
Message-ID: <CAHk-=wj9-9mFcoaD3rdHd+HKYpyTXkkE2iJkPoTTCrp-+sD=ew@mail.gmail.com>
References: <20220111071212.1210124-1-surenb@google.com> <Yd3RClhoz24rrU04@sol.localdomain>
 <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com> <CAJuCfpE3feNU=36qRUdCJsk41rxQBv1gRYy5R1dB1djMd0NLjg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=72nCaH0D5cVWOpCSRc18GR2eFwD5HF2lWhLZ438H8+E=;
        b=IbI2Ue6xwevdXzForB3sPC7JLpGCLW4aJaiaqGPQM519ZpN4Iw53D7dK6TEvItwJQM
         lU0w7yPNWbufVbo7aTy0WNF/06ot4HROv5RcW7EH+B/47POEIinAhzsJIzijm2pqH0rA
         32W/JrQJcTgkaHK2M1qJ6iERelYscbkX2JYhs=
In-Reply-To: <CAJuCfpE3feNU=36qRUdCJsk41rxQBv1gRYy5R1dB1djMd0NLjg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Jonathan Corbet <corbet@lwn.net>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, stable <stable@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, syzbot <syzbo>

On Tue, Jan 11, 2022 at 11:27 AM Suren Baghdasaryan <surenb@google.com> wrote:
>
> Thanks for the explanation!
> So, it sounds like the best (semantically correct) option I have here
> is smp_store_release() to set the pointer, and then smp_load_acquire()
> to read it. Is my understanding correct?

Yeah, that's the clearest one from a memory ordering standpoint, and
is generally also cheap.

                Linus
