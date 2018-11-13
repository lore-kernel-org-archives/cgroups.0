From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 3/6] cgroup: cgroup v2 freezer
Date: Tue, 13 Nov 2018 07:43:49 -0800
Message-ID: <20181113154349.GF2509588@devbig004.ftw2.facebook.com>
References: <20181112230422.5911-1-guro@fb.com>
 <20181112230422.5911-5-guro@fb.com>
 <20181113153700.GB30990@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bFMh3QKUJlc38kknui2bNuEA1AJIdxyJQX4fmBz4djQ=;
        b=NPmtN43PH6DhKus0hlh51X8Z/k3gg9A1AjLV0L7u7rOOSqLiKlFpbp+/163RD0emVN
         sjFvpcrQNY64FGZTkaH66iM9J+zpxHR36H17h0b2gO0QikfB2AmJbhvXGmcfZrWb2eoh
         rLNtOW0CFVjte8f4CAGQR9zKSP3XiKoafsWc8BtRDZbtaw4V3Pzu45bT2kQyGu3+kWju
         ph6LAcs1hlmbQAsIhXa/yk5puVWaVMUiWdb0SwwcBM3bA+59+6qFDut7OpSs3JuPPy57
         sg4r8A0H9yDzk50zhh0JaSGF/V2SV9pJufcP66AAg4gCXdw19KkxnB0UnAslrcDoGPjr
         p4qw==
Content-Disposition: inline
In-Reply-To: <20181113153700.GB30990@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

Hello, Oleg.

On Tue, Nov 13, 2018 at 04:37:01PM +0100, Oleg Nesterov wrote:
> On 11/12, Roman Gushchin wrote:
> >
> > This patch implements freezer for cgroup v2. However the functionality
> > is similar, the interface is different to cgroup v1: it follows
> > cgroup v2 interface principles.
> 
> Oh, it seems that I actually need to apply this patch to (try to) understand
> the details ;) Will try tomorrow.

Yeah, it's a bit of a head spin like everything in signal delivery /
ptrace paths.

...
> OK, please forget for now, but perhaps it would be more clean to add
> JOBCTL_TRAP_FREEZE to the JOBCTL_PENDING_MASK check in recalc_sigpending()
> and change get_signal to check JOBCTL_TRAP_MASK | JOBCTL_TRAP_FREEZE; and
> I am not even sure cgroup_freezer_enter() should live in do_jobctl_trap().

I'm sure you're aware of the context but just to refresh - one thing
which was really broken about cgroup1 freezer was that it piggybacked
on hibernation freezer and put frozen tasks in a state which is
undefined when seen from userspace - they're just stuck in D sleep
somewhere in the kernel.  That's fine when the whole system is not
gonna be running, but not when only a subportion is being frozen.

So, the primary goal of cgroup2 freezer is putting the tasks in an
equivalent state as jobctl stop.  It's a jobctl stop but controlled by
cgroup frozen state, meaning that they can be killed, PTRACE_SEIZE'd
and INTERRUPT'ed (PTRACE_ATTACH doesn't work as signal delivery should
be blocked but that's fine) and so on.

Thanks.

-- 
tejun
