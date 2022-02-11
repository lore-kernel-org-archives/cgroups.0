From: Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC 00/12] locking: Separate lock tracepoints from
 lockdep/lock_stat (v1)
Date: Thu, 10 Feb 2022 21:57:43 -0800
Message-ID: <CAM9d7cj-PhX16jKu8DT=tfVf=OfH78xYYaMB8BVk-Hj_eoR4kQ@mail.gmail.com>
References: <20220208184208.79303-1-namhyung@kernel.org>
 <20220209090908.GK23216@worktop.programming.kicks-ass.net>
 <CAM9d7cgq+jxu6FJuKhZkprn7dO4DiG5pDjmYZzneQYTfKOM85g@mail.gmail.com>
 <YgTXUQ9CBoo3+A+c@hirez.programming.kicks-ass.net>
 <20220210191404.GM4285@paulmck-ThinkPad-P17-Gen-1>
 <52de2e14-33d9-bdda-4b37-3e72ae9954c7@redhat.com>
 <20220210201058.GP4285@paulmck-ThinkPad-P17-Gen-1>
Mime-Version: 1.0
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <20220210201058.GP4285@paulmck-ThinkPad-P17-Gen-1>
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
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: rcu <rcu@vger.kernel.org>, intel-gfx <intel-gfx@lists.freedesktop.org>, Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Radoslaw Burny <rburny@google.com>, Byungchul Park <byungchul.park@lge.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Waiman Long <longman@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>, Ingo Molnar <mingo@kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

Hi Paul,

On Thu, Feb 10, 2022 at 12:10 PM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Thu, Feb 10, 2022 at 02:27:11PM -0500, Waiman Long wrote:
> > On 2/10/22 14:14, Paul E. McKenney wrote:
> > > On Thu, Feb 10, 2022 at 10:13:53AM +0100, Peter Zijlstra wrote:
> > > > On Wed, Feb 09, 2022 at 04:32:58PM -0800, Namhyung Kim wrote:
> > > > > On Wed, Feb 9, 2022 at 1:09 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > > > > > On Tue, Feb 08, 2022 at 10:41:56AM -0800, Namhyung Kim wrote:
> > > > > >
> > > > > > > Eventually I'm mostly interested in the contended locks only and I
> > > > > > > want to reduce the overhead in the fast path.  By moving that, it'd be
> > > > > > > easy to track contended locks with timing by using two tracepoints.
> > > > > > So why not put in two new tracepoints and call it a day?
> > > > > >
> > > > > > Why muck about with all that lockdep stuff just to preserve the name
> > > > > > (and in the process continue to blow up data structures etc..). This
> > > > > > leaves distros in a bind, will they enable this config and provide
> > > > > > tracepoints while bloating the data structures and destroying things
> > > > > > like lockref (which relies on sizeof(spinlock_t)), or not provide this
> > > > > > at all.
> > > > > If it's only lockref, is it possible to change it to use arch_spinlock_t
> > > > > so that it can remain in 4 bytes?  It'd be really nice if we can keep
> > > > > spin lock size, but it'd be easier to carry the name with it for
> > > > > analysis IMHO.
> > > > It's just vile and disgusting to blow up the lock size for convenience
> > > > like this.
> > > >
> > > > And no, there's more of that around. A lot of effort has been spend to
> > > > make sure spinlocks are 32bit and we're not going to give that up for
> > > > something as daft as this.
> > > >
> > > > Just think harder on the analysis side. Like said; I'm thinking the
> > > > caller IP should be good enough most of the time.
> > >
> > > Another option is to keep any additional storage in a separate data
> > > structure keyed off of lock address, lockdep class, or whatever.
> > >
> > > Whether or not this is a -good- option, well, who knows?  ;-)
> >
> > I have suggested that too. Unfortunately, I was replying to an email with
> > your wrong email address. So you might not have received it.
>
> Plus I was too lazy to go look at lore.  ;-)

Sorry for the noise about the email address in the first place.
It has been so long since the last time I sent you a patch..

Thanks,
Namhyung
