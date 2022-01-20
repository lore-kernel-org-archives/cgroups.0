From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Date: Thu, 20 Jan 2022 16:05:02 +0100
Message-ID: <20220120150502.GC27269@blackbody.suse.cz>
References: <20211222225350.1912249-1-vipinsh@google.com>
 <20220105180420.GC6464@blackbody.suse.cz>
 <CAHVum0e84nUcGtdPYQaJDQszKj-QVP5gM+nteBpSTaQ2sWYpmQ@mail.gmail.com>
 <Yeclbe3GNdCMLlHz@slm.duckdns.org>
 <7a0bc562-9f25-392d-5c05-9dbcd350d002@redhat.com>
 <YehY0z2vHYVZk52J@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642691103; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2nAWydtx5DdzNGZYqxu4dZV+DvOfZYEZrc2cFUMKL8M=;
        b=r4jbhqQWwY/Z9/hjXZ6h6tTz6bY/SVcBXO+CmBi9g+75D0cuyPbDmkpjc728sDJnOVvvUg
        GSRqyxC3n/bFkiYIHZLVo1Q54qisS0YiIA6eTwz1IKvQIMGe/KUqnFLxNPV4kD0lm2dGRZ
        ZF6TjHvRug8R3uO8y+6aOd77NnCuOzA=
Content-Disposition: inline
In-Reply-To: <YehY0z2vHYVZk52J@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vipin Sharma <vipinsh@google.com>, seanjc@google.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, dmatlack@google.com, jiangshanlai@gmail.com, kvm@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jan 19, 2022 at 08:30:43AM -1000, Tejun Heo <tj@kernel.org> wrote:
> It'd be nicer if we can make kthread_stop() waiting more regular but I
> couldn't find a good existing place and routing the usual parent
> signaling might be too complicated. Anyone has better ideas?

The regular way is pictured in Paolo's diagram already, the
exit_notify/do_signal_parent -> wait4 path.

Actually, I can see that there exists already kernel_wait() and is used
by a UMH wrapper kthread. kthreadd issues ignore_signals() so (besides
no well defined point of signalling a kthread) the signal notification
is moot and only waking up the waiter is relevant. So kthread_stop()
could wait via kernel_wait() based on pid (extracted from task_struct).

Have I missed an obstacle?


Michal
