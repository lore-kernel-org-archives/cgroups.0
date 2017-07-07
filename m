From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 14/15] kernel: convert futex_pi_state.refcount from
 atomic_t to refcount_t
Date: Fri, 7 Jul 2017 11:52:57 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1707071149500.1871@nanos>
References: <1499418269-3686-1-git-send-email-elena.reshetova@intel.com> <1499418269-3686-15-git-send-email-elena.reshetova@intel.com> <20170707092603.rmt4ne4c75k5qg56@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170707092603.rmt4ne4c75k5qg56@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tj@kernel.org, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, keescook@chromium.org, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>

On Fri, 7 Jul 2017, Peter Zijlstra wrote:

> On Fri, Jul 07, 2017 at 12:04:28PM +0300, Elena Reshetova wrote:
> > refcount_t type and corresponding API should be
> > used instead of atomic_t when the variable is used as
> > a reference counter. This allows to avoid accidental
> > refcounter overflows that might lead to use-after-free
> > situations.
> > 
> > Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> > Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: David Windsor <dwindsor@gmail.com>
> 
> I'll let tglx comment on the SoB chain, I know he likes those :-) You
> did Cc him right, seeing how he's the maintainer of this stuff..

Right, that SOB chain is crap. It suggests that the patch was written by
Elena and then carried on by Hans, handed over to Kees and from there to
David. And now it's resent by Elena. Circular dependencies or what?

Thanks,

	tglx
