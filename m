From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Getrandom wrapper
Date: Mon, 26 Oct 2015 14:32:56 +0100
Message-ID: <562E2B88.60909@redhat.com>
References: <CAPM31RKx0vT-9VFN=XASYM4iv4U5ZGZW93XRtJd_7mOHwu76NA@mail.gmail.com>
 <20151023222110.GA4390@mtj.duckdns.org> <1445661367.3218.62.camel@gmail.com>
 <20151025021829.GA15471@mtj.duckdns.org>
 <CA+55aFzMdG5VPA0ZvoFANj-H-7LHeu=JUvvqPykF_w5Nd0pnSA@mail.gmail.com>
 <20151025093331.GA4834@gmail.com> <20151025104145.GE27558@thunk.org>
 <562CB328.3090906@redhat.com> <20151025115842.GA13940@thunk.org>
 <562CD663.5010506@redhat.com> <20151025134000.GB13940@thunk.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151025134000.GB13940@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Theodore Ts'o <tytso@mit.edu>, Ingo Molnar <mingo@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Mike Galbraith <umgwanakikbuti@gmail.com>, Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Andrew Morton <akpm@linux-foundation.org>

On 10/25/2015 02:40 PM, Theodore Ts'o wrote:
> On Sun, Oct 25, 2015 at 02:17:23PM +0100, Florian Weimer wrote:
>>
>> I think we can reach consensus for an implementation which makes this code
>>
>>   unsigned char session_key[32];
>>   getrandom (session_key, sizeof (session_key), 0);
>>   install_session_key (session_key);
>>
>> correct.  That is, no error handling code for ENOMEM, ENOSYS, EINTR,
>> ENOMEM or short reads is necessary.  It seems that several getrandom
>> wrappers currently built into applications do not get this completely right.
> 
> The only error handling code that is necessary is a fallback for
> ENOSYS.  getrandom(2) won't return ENOMEM, and if the number of bytes
> requested is less than or equal to 256 bytes, it won't return EINTR
> either.

Not even during early boot?  The code suggests that you can get EINTR if
the non-blocking pool isn't initialized yet.  With VMs, that
initialization can happen quite some time after boot, when the userland
is well under way.

> As far as ENOSYS is concerned, a fallback gets tricky; you could try
> to open /dev/urandom, and read from it, but that can fail due to
> EMFILE, ENFILE, ENOENT (if they are chrooted and /dev wasn't properly
> populated).  So attempting a fallback for ENOSYS can actually expand
> the number of potential error conditions for the userspace application
> to (fail to) handle.  I suppose you could attempt the fallback and
> call abort(2) if the fallback fails, which is probably the safe and
> secure thing to do, but applications might not appreciate getting
> terminated without getting a chance to do something (but if the
> something is just calling random(3), maybe not giving them a chance to
> do something insane is the appropriate thing to do....)

I'm more worried that the fallback code could be triggered
unexpectedly on some obscure code path that is not tested regularly, and
runs into a failure.  I suspect a high-quality implementation of
getrandom would have to open /dev/random and /devurandom when the
getrandom symbol is resolved, and report failure at that point, to avoid
late surprises.

Florian
