From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 4/7] cgroup: cgroup v2 freezer
Date: Thu, 21 Feb 2019 17:44:04 +0100
Message-ID: <20190221164403.GB26064@redhat.com>
References: <20190219220252.4906-1-guro@fb.com>
 <20190219220252.4906-5-guro@fb.com>
 <20190220144202.GB9477@redhat.com>
 <20190220221423.GA17163@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190220221423.GA17163@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 02/20, Roman Gushchin wrote:
>
> On Wed, Feb 20, 2019 at 03:42:02PM +0100, Oleg Nesterov wrote:
> > On 02/19, Roman Gushchin wrote:
> > >
> > > @@ -2363,7 +2419,8 @@ bool get_signal(struct ksignal *ksig)
> > >  	 * we should notify the parent, prepare_signal(SIGCONT) encodes
> > >  	 * the CLD_ si_code into SIGNAL_CLD_MASK bits.
> > >  	 */
> > > -	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
> > > +	if (unlikely(signal->flags & SIGNAL_CLD_MASK) &
> > > +	    !(current->jobctl & JOBCTL_TRAP_FREEZE)) {
> >
> > Hmm, why?
>
> If a process is going from the stopped to the frozen state, it looks like
> it's better to delay parent's notification up to the moment when it will
> actually run.

Perhaps I missed something but I do not understand why it is really better,
at least why it deserves this (small but still) complication...

OK, if nothing else, suppose that SIGCONT races with cgroup_do_freeze(true).
With or without this change CLD_CONTINUED can be reported or not depending
on /dev/random, do we really care?

Oleg.

