From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Date: Fri, 25 Feb 2022 18:37:35 +0100
Message-ID: <20220225173734.GA26252@blackbody.suse.cz>
References: <20211222225350.1912249-1-vipinsh@google.com>
 <20220105180420.GC6464@blackbody.suse.cz>
 <CAHVum0e84nUcGtdPYQaJDQszKj-QVP5gM+nteBpSTaQ2sWYpmQ@mail.gmail.com>
 <Yeclbe3GNdCMLlHz@slm.duckdns.org>
 <7a0bc562-9f25-392d-5c05-9dbcd350d002@redhat.com>
 <YehY0z2vHYVZk52J@slm.duckdns.org>
 <20220120150502.GC27269@blackbody.suse.cz>
 <CAHVum0fOP-2XcUcG3PqW08DY7CmpDroG6Fcv9KoD1FqLmGpB8w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645810656; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GY0iFUW9uJV4Vgn8uP3pu0/kxNIDCy02Hy0asV7edUo=;
        b=TXIXb+dwDLgXu7FYESoUdvIw3WVo04Tn7lfRoljMYCviwhHmW1InDMG9ZQjzhXih8TqnNI
        ES+6S6tUSmYt1b2swWoy9lcUJ69gLBkQP4/kolRUjgAXtxWkGHRG+fNa8+fQejAvYGAu+U
        AhFlb6bQkB59K5/cvejRsALjZ6OA0UI=
Content-Disposition: inline
In-Reply-To: <CAHVum0fOP-2XcUcG3PqW08DY7CmpDroG6Fcv9KoD1FqLmGpB8w@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vipin Sharma <vipinsh@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Tejun Heo <tj@kernel.org>, seanjc@google.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, dmatlack@google.com, jiangshanlai@gmail.com, kvm@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Vipin.

On Wed, Feb 16, 2022 at 09:37:45AM -0800, Vipin Sharma <vipinsh@google.com>=
 wrote:
> On Thu, Jan 20, 2022 at 7:05 AM Michal Koutn=FD <mkoutny@suse.com> wrote:
> > Have I missed an obstacle?

Aha...

[
> I used few other combination where I put kernel_wait() call after
> put_task_struct(k) call.
>=20
> Every time during the module exit, kernel was crashing like:

Thanks for trying this out.
]

> Do you have any suggestions what might be the right way to use this API?

...it has occured to me now -- the KVM kthread is not a child of the
wanna-wait user task. So the kernel_wait() silently errs with -ECHILD
and task_struct is released too early and that (probably) brings about
the crash.

I'm sorry for not realizing that initially.

(Generally, any kthread_create'd task would be affected by this. I guess
the KVM worker threads can't be forked from the kvm_create_vm() callers?
(It could prevent the double migration to and from caller's cgroup
though.))

Michal

