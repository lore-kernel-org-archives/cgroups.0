From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] memcg: flatten task_struct->memcg_oom
Date: Wed, 25 Nov 2015 18:44:49 +0100
Message-ID: <20151125174449.GD17308@twins.programming.kicks-ass.net>
References: <20150913185940.GA25369@htj.duckdns.org>
 <55FEC685.5010404@oracle.com>
 <20150921200141.GH13263@mtj.duckdns.org>
 <20151125144354.GB17308@twins.programming.kicks-ass.net>
 <20151125150207.GM11639@twins.programming.kicks-ass.net>
 <CAPAsAGwa9-7UBUnhysfek3kyWKMgaUJRwtDPEqas1rKwkeTtoA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <CAPAsAGwa9-7UBUnhysfek3kyWKMgaUJRwtDPEqas1rKwkeTtoA@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Sasha Levin <sasha.levin@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, cgroups@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>, vdavydov@parallels.com, kernel-team@fb.com, Dmitry Vyukov <dvyukov@google.com>

On Wed, Nov 25, 2015 at 06:31:41PM +0300, Andrey Ryabinin wrote:
> > +       /* scheduler bits, serialized by scheduler locks */
> >         unsigned sched_reset_on_fork:1;
> >         unsigned sched_contributes_to_load:1;
> >         unsigned sched_migrated:1;
> > +       unsigned __padding_sched:29;
> 
> AFAIK the order of bit fields is implementation defined, so GCC could
> sort all these bits as it wants.

We're relying on it doing DTRT in other places, so I'm fairly confident
this'll work, otoh

> You could use unnamed zero-widht bit-field to force padding:
> 
>          unsigned :0; //force aligment to the next boundary.

That's a nice trick I was not aware of, thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
