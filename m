From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC 00/12] locking: Separate lock tracepoints from
 lockdep/lock_stat (v1)
Date: Wed, 9 Feb 2022 13:19:07 -0500
Message-ID: <24fe6a08-5931-8e8d-8d77-459388c4654e@redhat.com>
References: <20220208184208.79303-1-namhyung@kernel.org>
 <20220209090908.GK23216@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1644430759;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Qax2p4QYoRES22yBVTV0pqT1gnZb7y7VCXsID9Egc7E=;
 b=HxJEaVkm1+6kPS7grqpovtsOHCaQxxc+wGPrASmnMP6uZEM2YJTV58f0iqRwVqeqfqi987
 GU9vsUD5YB6oCFZEqjYG5UBgoc9pffdQVg45qSCwR7M1Do3Ei2KpoLwx8SJ4Cxethw99JE
 JnS10x/+R76ulgyHd0ZRozRAyOaXpEA=
Content-Language: en-US
In-Reply-To: <20220209090908.GK23216@worktop.programming.kicks-ass.net>
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
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <peterz@infradead.org>, Namhyung Kim <namhyung@kernel.org>
Cc: rcu@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Radoslaw Burny <rburny@google.com>, Byungchul Park <byungchul.park@lge.com>, "Paul E. McKenney" <paul.mckenney@linaro.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, intel-gfx@lists.freedesktop.org, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>, Ingo Molnar <mingo@kernel.org>, linux-btrfs@vger.kernel.org

On 2/9/22 04:09, Peter Zijlstra wrote:
> On Tue, Feb 08, 2022 at 10:41:56AM -0800, Namhyung Kim wrote:
>
>> Eventually I'm mostly interested in the contended locks only and I
>> want to reduce the overhead in the fast path.  By moving that, it'd be
>> easy to track contended locks with timing by using two tracepoints.
> So why not put in two new tracepoints and call it a day?
>
> Why muck about with all that lockdep stuff just to preserve the name
> (and in the process continue to blow up data structures etc..). This
> leaves distros in a bind, will they enable this config and provide
> tracepoints while bloating the data structures and destroying things
> like lockref (which relies on sizeof(spinlock_t)), or not provide this
> at all.
>
> Yes, the name is convenient, but it's just not worth it IMO. It makes
> the whole proposition too much of a trade-off.
>
> Would it not be possible to reconstruct enough useful information from
> the lock callsite?
>
I second that as I don't want to see the size of a spinlock exceeds 4 
bytes in a production system.

Instead of storing additional information (e.g. lock name) directly into 
the lock itself. Maybe we can store it elsewhere and use the lock 
address as the key to locate it in a hash table. We can certainly extend 
the various lock init functions to do that. It will be trickier for 
statically initialized locks, but we can probably find a way to do that too.

Cheers,
Longman


