From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Tue, 18 Jan 2022 17:58:17 +1100
Message-ID: <YeZlCfZZkU5jyFS+@gondor.apana.org.au>
References: <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ebiggers@kernel.org, surenb@google.com, hannes@cmpxchg.org, tj@kernel.org, lizefan.x@bytedance.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, stable@vger.kernel.org, kernel-team@android.com, syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com

Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> Of course, in practice, for pointers, the whole "dereference off a
> pointer" on the read side *does* imply a barrier in all relevant
> situations. So yes, a smp_store_release() -> READ_ONCE() does work in
> practice, although it's technically wrong (in particular, it's wrong
> on alpha, because of the completely broken memory ordering that alpha
> has that doesn't even honor data dependencies as read-side orderings)

READ_ONCE has contained the alpha barrier since 2017:

commit 76ebbe78f7390aee075a7f3768af197ded1bdfbb
Author: Will Deacon <will@kernel.org>
Date:   Tue Oct 24 11:22:47 2017 +0100

    locking/barriers: Add implicit smp_read_barrier_depends() to READ_ONCE()

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
