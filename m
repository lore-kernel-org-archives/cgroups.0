From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v10 4/9] cgroup: cgroup v2 freezer
Date: Fri, 26 Apr 2019 19:40:19 +0200
Message-ID: <20190426174019.GB24755@redhat.com>
References: <20190405174708.1010-1-guro@fb.com>
 <20190405174708.1010-5-guro@fb.com>
 <20190419151912.GA12152@redhat.com>
 <20190419161118.GA23357@tower.DHCP.thefacebook.com>
 <20190419162600.GC12228@redhat.com>
 <20190419165600.GC23357@tower.DHCP.thefacebook.com>
 <20190420105838.GA17468@redhat.com>
 <20190422221116.GA10341@tower.DHCP.thefacebook.com>
 <20190424154619.GG16167@redhat.com>
 <20190424220634.GA22896@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190424220634.GA22896@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 04/24, Roman Gushchin wrote:
>
> On Wed, Apr 24, 2019 at 05:46:19PM +0200, Oleg Nesterov wrote:
> >
> > OK, how about the ABSOLUTELY UNTESTED patch below? For the start.
>
> It looks good to me (and all freezer selftests pass).
>
> Just to be sure, is it a solution to avoid the busy loop in the signal handling
> loop, right?

Yes,

> Because it doesn't allow to drop the ->frozen check from recalc().

Yes. Because we can race with unfreeze after leave_frozen().

> The JOBCTL_TRAP_FREEZE check without siglock initially looked dangerous to me,
> but after some thoughts I didn't find any case when it's wrong.

I think this is fine... Yes, JOBCTL_TRAP_FREEZE can be already set when we take
siglock, but I don't think we need to recheck this flag.

The only important thing (afaics) is that CGRP_FREEZE is stable under css_set_lock,
so we can't wrongly set TRAP_FREEZE.

> Do you prefer me to master a patch

Yes please ;)

Oleg.

