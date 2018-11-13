From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 3/6] cgroup: cgroup v2 freezer
Date: Tue, 13 Nov 2018 12:58:31 -0800
Message-ID: <20181113205831.GP2509588@devbig004.ftw2.facebook.com>
References: <20181112230422.5911-1-guro@fb.com>
 <20181112230422.5911-5-guro@fb.com>
 <20181113020817.GE2509588@devbig004.ftw2.facebook.com>
 <20181113184751.GB21629@tower.DHCP.thefacebook.com>
 <20181113191541.GM2509588@devbig004.ftw2.facebook.com>
 <20181113205507.GB15590@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=S60uROdWn0WL7K7ecFcE3+FHfbw6BesWS23KZQCAEPE=;
        b=FLZWfjcsr1Gt3kuyzezxsRzj3iWOkeZzbXJIqDPo/+0ZtHx68ZPEyW0xbRT5/qIRI6
         TiuMMbEGmcrxOx3P7/z6n6jYNgBfk/jCV6XSMl6Pgg/ZLQYQgBWZlk4wJAlQCLZzramo
         eNT0CrG3P1/3nL6/EYg0EvvdD8GtNAL8P1pme8+9hFvGXzLyd83GJgJQv9lbXhPEod4E
         2WGgRw7RIaTw8S45D1FUr5KC9B7qmElhvXPIZh+R3rCfWAx1pb3ILp9/fQFhUSiuMB9R
         ed6qNoRHYCw8v/r9JcnIMjgDDk8CghN/k8nnWEwNnZxpqUJv118YUf8nrnomhAbPWh0R
         P6vg==
Content-Disposition: inline
In-Reply-To: <20181113205507.GB15590@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Oleg Nesterov <oleg@redhat.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>

On Tue, Nov 13, 2018 at 08:55:11PM +0000, Roman Gushchin wrote:
> > > > > +	if (lock_task_sighand(task, &flags)) {
> > > > > +		if (test_bit(CGRP_FREEZE, &dst->flags))
> > > > > +			task->jobctl |= JOBCTL_TRAP_FREEZE;
> > > > > +		else
> > > > > +			task->jobctl &= ~JOBCTL_TRAP_FREEZE;
> > > > 
> > > > How are these flags synchronized?
> > > 
> > > Using the css_set_lock.
> > 
> > But other JOBCTL_TRAP bits aren't synchronized by css_set_lock, right?
> 
> But if we don't touch this bit anywhere else, should be fine, right?

But other JOBCTL_TRAP_ bits aren't synchronized with css_set_lock, so
they can be updated (read-modify-write) concurrently and clobber each
other, no?

Thanks.

-- 
tejun
