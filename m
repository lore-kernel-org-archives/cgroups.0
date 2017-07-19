From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Wed, 19 Jul 2017 12:34:53 -0400
Message-ID: <20170719163453.GQ3365493@devbig577.frc2.facebook.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-6-tj@kernel.org>
 <20170717141409.sqafufjupsiffnri@hirez.programming.kicks-ass.net>
 <20170717142609.GC3519177@devbig577.frc2.facebook.com>
 <20170718172801.f56273tzgzn3xkne@hirez.programming.kicks-ass.net>
 <20170718175456.GH585283@devbig577.frc2.facebook.com>
 <20170718184135.auf6d2clsdxseka3@hirez.programming.kicks-ass.net>
 <20170718184714.GA3365493@devbig577.frc2.facebook.com>
 <20170719140728.3mcg6uemqyy5muc4@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z+YuA1uTioUEkq52voVi9daOQ1FJT2UW0+CBvoStc7E=;
        b=Slfw1MmEGeRwbOJd/2KVi9BhVGsphzn9HkB1HssUEl5LkmqjzSWNZ8hpVBWh0tFK5v
         oLogdjTgBQay3ovgpWvdoiS+WZFyn23tBBuKpdKjA9veoiUdE4WBg5jTxqXOoX1oxJWF
         Z8WFdEmmjvezh6Jr8oipO+9i29KNp6K4v0+cjZC5osUkF7VkPSUFT+//qazPXgxIMthn
         o4wujni8DPfcgLMyM3XhIld+pmVa6ADQg4HFb/VrZWGCuuhYuxcqs/a0H9tZxF2oObmy
         /MDfVXxX2O5swhKiHSkzDt0AzrKhpMq+lprEJcOMJ8dhpVhHCvbemLfxpFpXZ1vFNhcp
         td2g==
Content-Disposition: inline
In-Reply-To: <20170719140728.3mcg6uemqyy5muc4@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, longman@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

Hello, Peter.

On Wed, Jul 19, 2017 at 04:07:28PM +0200, Peter Zijlstra wrote:
> On Tue, Jul 18, 2017 at 02:47:14PM -0400, Tejun Heo wrote:
> > Were there other things that caught your eyes?
> 
> I didn't immediately see the point of "domain (threaded" output, and I

I'll probably drop the parens but I think it's meaningful to show the
state to userland as it affects what users can and can't do.

> think it might be useful to have a "threaded" column in /proc/cgroups.

Will add that.  We *might* want cgroup.controllers_threaded too but we
can think about that later.

> But no, I've been over this a few times now and I think we're good.
> 
> Yes, I think we can work with this. Thanks!

Awesome.  I'll update the patchset.

Thanks a lot for the inputs and patience!

-- 
tejun
