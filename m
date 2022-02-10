From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC 00/12] locking: Separate lock tracepoints from
 lockdep/lock_stat (v1)
Date: Thu, 10 Feb 2022 14:27:11 -0500
Message-ID: <52de2e14-33d9-bdda-4b37-3e72ae9954c7@redhat.com>
References: <20220208184208.79303-1-namhyung@kernel.org>
 <20220209090908.GK23216@worktop.programming.kicks-ass.net>
 <CAM9d7cgq+jxu6FJuKhZkprn7dO4DiG5pDjmYZzneQYTfKOM85g@mail.gmail.com>
 <YgTXUQ9CBoo3+A+c@hirez.programming.kicks-ass.net>
 <20220210191404.GM4285@paulmck-ThinkPad-P17-Gen-1>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1644521241;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=GNtwi8xnD/wpxMJkxYRgc+GcsRTLVGTfs9JYaKnP9Qg=;
 b=Xj47WjX8EdLO60xj3lY+608dTfJo2xaS5Nu4ydBnQHYkbm+swdg7EH3wtKMlY5Z9lCMWSo
 wSt4xG/TJZpYF/9AKrvIXdpnXheEadVP519jbrwDv+bx4LavfiA+p5OcTG0sZjkh9osDRz
 QUKpoMiB3z6DnCheNl7DTitBxEgj0aA=
Content-Language: en-US
In-Reply-To: <20220210191404.GM4285@paulmck-ThinkPad-P17-Gen-1>
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
To: paulmck@kernel.org, Peter Zijlstra <peterz@infradead.org>
Cc: rcu <rcu@vger.kernel.org>, intel-gfx <intel-gfx@lists.freedesktop.org>, Boqun Feng <boqun.feng@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Radoslaw Burny <rburny@google.com>, Byungchul Park <byungchul.park@lge.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>, Ingo Molnar <mingo@kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On 2/10/22 14:14, Paul E. McKenney wrote:
> On Thu, Feb 10, 2022 at 10:13:53AM +0100, Peter Zijlstra wrote:
>> On Wed, Feb 09, 2022 at 04:32:58PM -0800, Namhyung Kim wrote:
>>> On Wed, Feb 9, 2022 at 1:09 AM Peter Zijlstra <peterz@infradead.org> wrote:
>>>> On Tue, Feb 08, 2022 at 10:41:56AM -0800, Namhyung Kim wrote:
>>>>
>>>>> Eventually I'm mostly interested in the contended locks only and I
>>>>> want to reduce the overhead in the fast path.  By moving that, it'd be
>>>>> easy to track contended locks with timing by using two tracepoints.
>>>> So why not put in two new tracepoints and call it a day?
>>>>
>>>> Why muck about with all that lockdep stuff just to preserve the name
>>>> (and in the process continue to blow up data structures etc..). This
>>>> leaves distros in a bind, will they enable this config and provide
>>>> tracepoints while bloating the data structures and destroying things
>>>> like lockref (which relies on sizeof(spinlock_t)), or not provide this
>>>> at all.
>>> If it's only lockref, is it possible to change it to use arch_spinlock_t
>>> so that it can remain in 4 bytes?  It'd be really nice if we can keep
>>> spin lock size, but it'd be easier to carry the name with it for
>>> analysis IMHO.
>> It's just vile and disgusting to blow up the lock size for convenience
>> like this.
>>
>> And no, there's more of that around. A lot of effort has been spend to
>> make sure spinlocks are 32bit and we're not going to give that up for
>> something as daft as this.
>>
>> Just think harder on the analysis side. Like said; I'm thinking the
>> caller IP should be good enough most of the time.
> Another option is to keep any additional storage in a separate data
> structure keyed off of lock address, lockdep class, or whatever.
>
> Whether or not this is a -good- option, well, who knows?  ;-)

I have suggested that too. Unfortunately, I was replying to an email 
with your wrong email address. So you might not have received it.

Cheers,
Longman

