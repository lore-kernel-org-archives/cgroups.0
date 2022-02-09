From: Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC 00/12] locking: Separate lock tracepoints from
 lockdep/lock_stat (v1)
Date: Wed, 9 Feb 2022 11:45:59 -0800
Message-ID: <CAM9d7cj=tj6pA48q_wkQOGn-2vUc9FRj63bMBOm5R7OukmMbTQ@mail.gmail.com>
References: <20220208184208.79303-1-namhyung@kernel.org>
 <20220209090908.GK23216@worktop.programming.kicks-ass.net>
 <24fe6a08-5931-8e8d-8d77-459388c4654e@redhat.com>
 <919214156.50301.1644431371345.JavaMail.zimbra@efficios.com>
 <69e5f778-8715-4acf-c027-58b6ec4a9e77@redhat.com>
 <CAM9d7ci=N2NVj57k=W0ebqBzfW+ThBqYSrx-CZbgwGcbOSrEGA@mail.gmail.com>
 <718973621.50447.1644434890744.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <718973621.50447.1644434890744.JavaMail.zimbra@efficios.com>
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
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: rcu <rcu@vger.kernel.org>, paulmck <paulmck@kernel.org>, intel-gfx <intel-gfx@lists.freedesktop.org>, Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, rostedt <rostedt@goodmis.org>, Radoslaw Burny <rburny@google.com>, Byungchul Park <byungchul.park@lge.com>, cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Waiman Long <longman@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>, Ingo Molnar <mingo@kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Wed, Feb 9, 2022 at 11:28 AM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> ----- On Feb 9, 2022, at 2:22 PM, Namhyung Kim namhyung@kernel.org wrote:
> > I'm also concerning dynamic allocated locks in a data structure.
> > If we keep the info in a hash table, we should delete it when the
> > lock is gone.  I'm not sure we have a good place to hook it up all.
>
> I was wondering about this use case as well. Can we make it mandatory to
> declare the lock "class" (including the name) statically, even though the
> lock per-se is allocated dynamically ? Then the initialization of the lock
> embedded within the data structure would simply refer to the lock class
> definition.

Isn't it still the same if we have static lock classes that the entry needs
to be deleted from the hash table when it frees the data structure?
I'm more concerned about free than alloc as there seems to be no
API to track that in a place.

Thanks,
Namhyung
