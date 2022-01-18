From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Date: Tue, 18 Jan 2022 12:25:48 -0800
Message-ID: <CAHVum0e84nUcGtdPYQaJDQszKj-QVP5gM+nteBpSTaQ2sWYpmQ@mail.gmail.com>
References: <20211222225350.1912249-1-vipinsh@google.com> <20220105180420.GC6464@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=03H0oTsaoOJAVZroctwt5LNhXL/5/pvtJL1WK73zL4I=;
        b=EZI+N5TPNsYGSEEP5udv90ztg+d10rOBWo0oS6CZy6ayJg9vspmRINQQ23ZsK2x3WE
         fsVZ6UjHH11JuwZd2hHEdulDYeF0i/12p1N1+s6RAZ55S+4R0Oqe9IIPXwKFWG86TAPP
         MOOwht0RoXbyTwIzY0O/saU54N3BAvWM7e6tCAlScWSMZiXr5F2tI/kV4pApStDBfMUw
         d1JBMfvUzGjVD7DKs8P2oN54ssu0br9vA/ADCNDadV2WNfKCU+7kgpKh7+bHe9u6k/3j
         Q+Nobgcj8jm7ElmI6/ATWDOa8y4K9ktRrsOA9QZea9/WUpoQDnV4SPpO9Tz147NM/xry
         XTTQ==
In-Reply-To: <20220105180420.GC6464@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: pbonzini@redhat.com, seanjc@google.com, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, dmatlack@google.com, jiangshanlai@gmail.com, kvm@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Michal,

Thanks for looking into this patch. I will be using Sean's suggestion
and use real_parent of the task. This will avoid my ugly code in the
cgroup APIs.

On Wed, Jan 5, 2022 at 10:04 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote=
:
>
> Hi Vipin.
>
> On Wed, Dec 22, 2021 at 10:53:50PM +0000, Vipin Sharma <vipinsh@google.co=
m> wrote:
> > VM worker kthreads can linger in the VM process's cgroup for sometime
> > after KVM terminates the VM process.
>
> Why is it a problem? And how long are we talking about?
>

Automated tools/scripts which delete VM cgroups after the main KVM
process ends were seeing deletion errors because kernel worker threads
were still running inside those cgroups. This is not a very frequent
issue but we noticed it happens every now and then.


> > A VM process can terminate between the time window of exit_mm() to
> > cgroup_exit(), leaving only worker kthreads in the cgroup.
>
> Even kthreads should eventually have PF_EXITING set, they shouldd be
> treated as "user-space" zombies by cgroups, i.e. mostly invisible (e.g.
> it doesn't prevent rmdir'ing the cgroup).
>

Since that eventual time period is not known, we can either pause the
script for sometime before starting the cleanup or add some x number
of retries. Both of which are not preferable due to indeterministic
nature.

> (And after the last task_struct reference is gone, the cgroup structs
> can be released too. Maybe the cause is holding the reference to the KVM
> worker thread somewhere for too long.)
>
> > Moving worker kthreads back to the original cgroup (kthreadd_task's
> > cgroup) makes sure that cgroup is empty as soon as the main VM process
> > is terminated.
>
> BTW this used to be done for "user-space" tasks too (migrate to root
> cgroup) but it was replaced with the less transactional "ignore zombies"
> approach. So this change seems inconsistent.
>
Interesting, however, until PF_EXITING is set those threads will also
exhibit the same behavior if it comes to deletion. Thanks for the
background, good to know.

Thanks
