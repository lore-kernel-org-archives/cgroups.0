From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 0/7] freezer for cgroup v2
Date: Mon, 25 Feb 2019 16:57:25 +0100
Message-ID: <20190225155725.GA8096@redhat.com>
References: <20190219220252.4906-1-guro@fb.com>
 <20190220143748.GA9477@redhat.com>
 <20190220220020.GA16335@castle.DHCP.thefacebook.com>
 <20190221162923.GA26064@redhat.com>
 <20190221173422.GY50184@devbig004.ftw2.facebook.com>
 <20190222163441.GA5596@redhat.com>
 <20190222181740.GZ50184@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190222181740.GZ50184@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>, Roman Gushchin <guroan@gmail.com>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 02/22, Tejun Heo wrote:
>
> > So I think it too should somehow interact with freezable_schedule/etc.
>
> You mean freezer_do_not_count(), right?

yes,

> As long as the task is
> guaranteed to be trapped by signal stop afterwards (and they are), we
> likely can use them the same way.  The only thing to be careful about
> would be ensuring that we don't end up flipping group level frozen
> state inbetween.  Would something like that work?

I have no idea because I do not understand what exactly do you mean ;)

However. Thinking more about this, I am not sure my concerns were valid.
Yes, cg freezer can "hang" if it races with vfork(). But probably we should
blame vfork(), not freezer.

The problem is, even ^Z can "hang" if the foreground process does vfork()
and the new child stops before exit/exec. Now I recall that I even tried
to make a patch to fix this using ERESTART_RESTARTBLOCK, but had some nasty
problems with blocked signals...

de_thread() should use freezable_schedule() in TASK_KILLABLE too. Currently
it doesn't, but only because we have other (much more serious) problems with
cred_guard_mutex/exec. However, this is is fine wrt cg freezer, other threads
can't be frozen exactly because it is killable.

Anything else does freezer_do_not_count() in TASK_KILLABLE and waits for
another freezable process?

So it seems I have to take my words back, perhaps we can forget about
freezable_schedule/etc.

Oleg.

