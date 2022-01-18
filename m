From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Date: Tue, 18 Jan 2022 11:53:39 -0800
Message-ID: <CAHVum0czVQqugNs4BhwJpUx-+f6GZQHFRkTpH01Mmsu0FXSd+w@mail.gmail.com>
References: <20211222225350.1912249-1-vipinsh@google.com> <YctGtWzYcNP2iTaN@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hLG3IDzGCmMuTJ6Lo7fCzvTJqI3hQH1J7qtya62FFTI=;
        b=FBf0wEoEZmYrfY/6yOjBzgydEx8VKqwZ8Ch024JkOhYKPMTXZB+t8YyjAURKEhqryK
         JN+VJ2NZigyahygOqJOGPDF/OmkyCI4BjOvNzGmnDmAfzUJVOodUutd9oqYw1AllHdEd
         jACTBytbhyPlqIQ4hYKIl96SBtUPCZix9Gbo0MUlRZmWis8a8xywWSmu3m6i+kmjrmuz
         t4LICgPw4Tb3O17gcn5o7I176EivuuydQKXTKooOxhMHJ94PoDUAxJuZYnigi201uoXq
         7f9XQQBHzAOvBB4PpEeWDjfOnw/UTG4F5Y5Dz6c3yFfHoq8npWj/4KkzcseYO1x+G1bE
         RXpg==
In-Reply-To: <YctGtWzYcNP2iTaN-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dmatlack-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Dec 28, 2021 at 9:17 AM Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Wed, Dec 22, 2021, Vipin Sharma wrote:
> > diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
> > index 81c9e0685948..81d4b2f2acf0 100644
> > --- a/kernel/cgroup/cgroup-v1.c
> > +++ b/kernel/cgroup/cgroup-v1.c
> >  int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
> > @@ -58,6 +60,9 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
> >       struct cgroup_root *root;
> >       int retval = 0;
> >
> > +     if (!from)
> > +             from = kthreadd_task;
>
> Rather than sully cgroup_attach_task_all() with this behavior, can't KVM do
>
>         cgroup_attach_task_all(current->real_parent, current)
>
> since AFAICT real_parent is guaranteed to point at kthreadd_task.
>

Thanks for the "real_parent" suggestion. This is much cleaner and
better than changing cgroup logic. I will make this change.

> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index b0f7e6eb00ff..f7504578c374 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -5793,6 +5793,19 @@ static int kvm_vm_worker_thread(void *context)
> >       if (!kthread_should_stop())
> >               err = thread_fn(kvm, data);
> >
> > +out:
> > +     /*
> > +      * We need to move the kthread back to its original cgroups, so that it
>
> Please state what is being done, not what "needs" to be done.  The need to do
> something is implicit, otherwise we wouldn't be doing it.
>

I will update the statement. Thanks.

> > +      * doesn't linger in the cgroups of the user process after the user
> > +      * process has already terminated.
> > +      *
> > +      * kthread_stop() waits on 'exited' completion condition which is set
> > +      * in exit_mm(), via mm_release(), in do_exit(). However, kthread
> > +      * is removed from cgroups in the cgroup_exit() which is called after
> > +      * exit_mm(). This causes lingering of kthreads in cgroups after main
> > +      * VM process has finished.
> > +      */
> > +     WARN_ON(cgroup_attach_task_all(NULL, current));
>
> This should not WARN, cgroup_attach_task_all() needs to perform allocations and
> will fail with -ENOMEM even in the absense of kernel bugs.
>

I will remove WARN_ON and print an error using kvm_err(), it will be
similar to the earlier call of cgroup_attach_task_all() in the same
function.

Thanks
