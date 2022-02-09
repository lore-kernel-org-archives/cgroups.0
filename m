From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 00/12] locking: Separate lock tracepoints from
 lockdep/lock_stat (v1)
Date: Wed, 9 Feb 2022 10:09:08 +0100
Message-ID: <20220209090908.GK23216@worktop.programming.kicks-ass.net>
References: <20220208184208.79303-1-namhyung@kernel.org>
Mime-Version: 1.0
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=kNBxEECZ8nYVRQBlRi4s4bPsYk+6wGvc+UHQLe+LfQY=; b=FuT01ILcnQE1hlwV0N6QoRzje7
 8leIgTUsGHbhfy7cNPjN8ZrjHcSG0wypOKtgyb8t04GcdHB5bH2yXofjaCs8wpl1CIqqOkec3R9OV
 nApYAVlzrV8ZfypyHa4mIELkzUQhBcEibVe6rjqueMf/NegoUT6rvZNNsoc4Uw2YqsFP9t1UTNqIf
 jNC72U1XwX8JGYxfA0nQlHqSjCcVfzkGjPBeAtSDlLt6otVC5r0jjKiMiAMeC9xmjVZ1sMuKSSBys
 rCFVdCTkXxb8dN7UTtpmiYJWVdWQaduq6Qanmd7JpqkCzBgIpJKnbvw5fQS2u7k6VjPF4p+ScGV/Y
 cDMFRHqA==;
Content-Disposition: inline
In-Reply-To: <20220208184208.79303-1-namhyung@kernel.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Namhyung Kim <namhyung@kernel.org>
Cc: rcu@vger.kernel.org, intel-gfx@lists.freedesktop.org, Boqun Feng <boqun.feng@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Radoslaw Burny <rburny@google.com>, Byungchul Park <byungchul.park@lge.com>, "Paul E. McKenney" <paul.mckenney@linaro.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Waiman Long <longman@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>, Ingo Molnar <mingo@kernel.org>, linux-btrfs@vger.kernel.org

On Tue, Feb 08, 2022 at 10:41:56AM -0800, Namhyung Kim wrote:

> Eventually I'm mostly interested in the contended locks only and I
> want to reduce the overhead in the fast path.  By moving that, it'd be
> easy to track contended locks with timing by using two tracepoints.

So why not put in two new tracepoints and call it a day?

Why muck about with all that lockdep stuff just to preserve the name
(and in the process continue to blow up data structures etc..). This
leaves distros in a bind, will they enable this config and provide
tracepoints while bloating the data structures and destroying things
like lockref (which relies on sizeof(spinlock_t)), or not provide this
at all.

Yes, the name is convenient, but it's just not worth it IMO. It makes
the whole proposition too much of a trade-off.

Would it not be possible to reconstruct enough useful information from
the lock callsite?
