From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 0/7] freezer for cgroup v2
Date: Fri, 22 Feb 2019 17:34:42 +0100
Message-ID: <20190222163441.GA5596@redhat.com>
References: <20190219220252.4906-1-guro@fb.com>
 <20190220143748.GA9477@redhat.com>
 <20190220220020.GA16335@castle.DHCP.thefacebook.com>
 <20190221162923.GA26064@redhat.com>
 <20190221173422.GY50184@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190221173422.GY50184@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>, Roman Gushchin <guroan@gmail.com>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi,

On 02/21, Tejun Heo wrote:
>
> So, I really wanna avoid allowing userspace to cause D state sleeps.
...
> ptrace support is a lot less important than kill for sure but if at
> all possible I think it'd be better to have it

Tejun, I agree it would be better. I did not argue with that.

The question is how this can be implemented. And how much uglifications^W
complications in the core kernel code this needs.

> To summarize, the ideal result is the frozen state to be "stuck in
> jobctl stop loop"

Not sure I understand, but I don't think this can work...

Let me repeat, imo the freezer should be "reliable", it shouldn't stuck
in CGRP_FREEZE state forever if, say, it races with vfork(). And personally
I think this is more important than (very limited) ptrace support.

So I think it too should somehow interact with freezable_schedule/etc.

Oleg.

