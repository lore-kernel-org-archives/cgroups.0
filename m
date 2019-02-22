From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 0/7] freezer for cgroup v2
Date: Fri, 22 Feb 2019 18:04:12 +0100
Message-ID: <20190222170412.GB5596@redhat.com>
References: <20190219220252.4906-1-guro@fb.com>
 <20190220143748.GA9477@redhat.com>
 <20190220220020.GA16335@castle.DHCP.thefacebook.com>
 <20190221162923.GA26064@redhat.com>
 <20190221224352.GA24252@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190221224352.GA24252@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 02/21, Roman Gushchin wrote:
>
> > > Generally speaking, any process hanging in D-state
> > > for a long time isn't the nicest object from the userspace's point of view.
> >
> > Roman, this is unfair comparison ;)
>
> Why not?

OK, you are trolling me, let me troll you back...

So, generally speaking, the very idea of freezer looks wrong, any process
hanging in do_freezer_trap() for a long time isn't the nicest object from
the userspace's point of view.

> > And, apart from reading/writing the registers, what can ptrace do with a frozen
> > tracee? This doesn't look like a "must have" feature to me.
>
> I think the minimal requirement is that the tracing application should not hang
> and wait for tracee to be unfrozen.
> So, imagine you're trying to debug an application in production with gdb,
> and occasionally gdb just hangs because some cluster management stuff froze
> the tracee's cgroup. Not the best user experience.

Firstly, gdb will likely hang anyway. Say, single-step will hang and ^C won't work.

Secondly, just imagine you're trying to debug an application in production with gdb,
and occasionally gdb just hangs because some cluster management stuff froze the
gdb's cgroup. Not the best user experience.



Roman, may be it was not clear, but I never said that ptrace/kill makes no sense.
But yes, we probably disagree about how much this is important. I won't really
argue, but so far I am not sure I understand how this can be implemented.

> > At least, may I ask you again to make (if possible) a separate patch which adds
> > the ability to kill/ptrace?
>
> I'll try, but not sure if it can make the code easier for review.
> It looks like this ability defines the implementation.

OK, I won't insist, I understand that this is not simple.

Oleg.

