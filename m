From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Date: Wed, 19 Jan 2022 10:49:57 -0800
Message-ID: <CAHVum0fqhMQd2uFic5_7RN=Ah6TTH2G2qLNZuxnQXSazR57m6g@mail.gmail.com>
References: <20211222225350.1912249-1-vipinsh@google.com> <20220105180420.GC6464@blackbody.suse.cz>
 <CAHVum0e84nUcGtdPYQaJDQszKj-QVP5gM+nteBpSTaQ2sWYpmQ@mail.gmail.com>
 <Yeclbe3GNdCMLlHz@slm.duckdns.org> <7a0bc562-9f25-392d-5c05-9dbcd350d002@redhat.com>
 <YehY0z2vHYVZk52J@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wj3R0FRfn1yO5ogKeGc8aripFNfSyJxmajRu2on35kY=;
        b=pe1iWhZirUTGmhYFeMyFbD34nGrpS52XKubMcy7XhUsPHYDaweveoSSJ0xnTHhRHWK
         20m5NC6R9tJIDsHjIbD1VFPqYLDmsG/N0Szv1UrZm9xhVPlG9AJJli7CV6iYMrgR6Rwu
         NhOEIJxv0osNjyejn4S6X35hD31YubMuEqCY2s7DYdDUc6uTefMSQbbc/Se0C5xs8nmB
         ccI4yd5EFGZv+k4tvN8+95FjVBq0L8Uub4f5y/1nX/vM3XeUsEW7Audld9eBL5dk72Yu
         AAkeVbwfhIrCNp+6Q4qlOOkWhGRMnA9Tb8TOCRMyLgl9GUZrTl+LJ2hRvgWNXwivZO25
         2x+w==
In-Reply-To: <YehY0z2vHYVZk52J-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dmatlack-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 19, 2022 at 10:30 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Wed, Jan 19, 2022 at 07:02:53PM +0100, Paolo Bonzini wrote:
> > On 1/18/22 21:39, Tejun Heo wrote:
> > > So, these are normally driven by the !populated events. That's how everyone
> > > else is doing it. If you want to tie the kvm workers lifetimes to kvm
> > > process, wouldn't it be cleaner to do so from kvm side? ie. let kvm process
> > > exit wait for the workers to be cleaned up.
> >
> > It does.  For example kvm_mmu_post_init_vm's call to
> > kvm_vm_create_worker_thread is matched with the call to
> > kthread_stop in kvm_mmu_pre_destroy_vm.
> > According to Vpin, the problem is that there's a small amount of time
> > between the return from kthread_stop and the point where the cgroup
> > can be removed.  My understanding of the race is the following:
>
> Okay, this is because kthread_stop piggy backs on vfork_done to wait for the
> task exit intead of the usual exit notification, so it only waits till
> exit_mm(), which is uhh... weird. So, migrating is one option, I guess,
> albeit a rather ugly one. It'd be nicer if we can make kthread_stop()
> waiting more regular but I couldn't find a good existing place and routing
> the usual parent signaling might be too complicated. Anyone has better
> ideas?
>
Sean suggested that we can use the real_parent of the kthread task
which will always be kthreadd_task, this will also not require any
changes in the cgroup API. I like that approach, I will give it a try.
This will avoid changes in cgroup APIs completely.
