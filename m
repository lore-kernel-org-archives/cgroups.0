From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Tue, 18 Jul 2017 14:47:14 -0400
Message-ID: <20170718184714.GA3365493@devbig577.frc2.facebook.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-6-tj@kernel.org>
 <20170717141409.sqafufjupsiffnri@hirez.programming.kicks-ass.net>
 <20170717142609.GC3519177@devbig577.frc2.facebook.com>
 <20170718172801.f56273tzgzn3xkne@hirez.programming.kicks-ass.net>
 <20170718175456.GH585283@devbig577.frc2.facebook.com>
 <20170718184135.auf6d2clsdxseka3@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w54S3DoX5M2e29sBaZ2YPFD6ZeivMcAEt3Ejmhpu2t8=;
        b=tA++bITppYXU8MGLdbvUOnFUJucq8zZ8fOZURYdfJUcHk+vy3a1jFC/6eHwqhjy7Q5
         Xjg+hjm0RQuSYQYga07xYGTG0TPOhu5OjivUXESvBDROrKcqPT6b47amnh2DejfXuIQU
         smrKbk12h5Kj49hDJ+2N8ZpUsPWvXjpUcmPkP/CGDWN2uqDAR9o3yo27NtG98kUQs1XP
         pwTp/h0phJLf4IjQjHonMi8wON4VACwCwDBplekMrpOJ8LhnUDZEHDjcjAfR7O7d+MUM
         sWA1PstM/7/Qv+AaOymCdlGp4oth6RtUBvjV7FOYutKh4cfAmnCkIEDvEB4FIeYbMqOv
         QwHA==
Content-Disposition: inline
In-Reply-To: <20170718184135.auf6d2clsdxseka3@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, longman@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On Tue, Jul 18, 2017 at 08:41:35PM +0200, Peter Zijlstra wrote:
> On Tue, Jul 18, 2017 at 01:54:56PM -0400, Tejun Heo wrote:
> 
> > Okay, we're kinda off the rails now.  Just to verify that we're on the
> > same page, are you also saying that the following should be a valid
> > configuration?
> > 
> > 	R (D)
> >         |
> > 	A (D and has processes in it and controllers enabled)
> >         |
> >         C (D and has processes in it) 
> > 
> 
> Argh, the no internal process thing again -- I completely forgot about
> that :-(

Heh, yeah, we wouldn't be talking about all these otherwise.  The
restriction is pain in the ass but at the same time useful for
full(er)-scope resource control.  Were there other things that caught
your eyes?

Thanks.

-- 
tejun
