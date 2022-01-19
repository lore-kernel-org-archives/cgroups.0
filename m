From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Date: Wed, 19 Jan 2022 08:30:43 -1000
Message-ID: <YehY0z2vHYVZk52J@slm.duckdns.org>
References: <20211222225350.1912249-1-vipinsh@google.com>
 <20220105180420.GC6464@blackbody.suse.cz>
 <CAHVum0e84nUcGtdPYQaJDQszKj-QVP5gM+nteBpSTaQ2sWYpmQ@mail.gmail.com>
 <Yeclbe3GNdCMLlHz@slm.duckdns.org>
 <7a0bc562-9f25-392d-5c05-9dbcd350d002@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pILDFV1B0pcs8CFlfnc4VuEEfnu7s3r3AjaWa+U4qlU=;
        b=G/3SbGpYSVIOIGF7kh+kzHoGUA5tjQNhhwD8Ct/g4lU1Vu7oi22nFS+AZudtTGWnr3
         rrhbbDLZytfxj5YVdB3iT4iolvT7lMZWM+MNINx7AQydBvXsMdbYOmkzq2tgcTNbGPWu
         Qpa+33b4JH7QozpPtVL7r0KodsrkmTOGQP2niwVLRhBjZo9fy3C+npjUu6X50dKpWeEM
         yKN/XtEo/mnaJhpjliB+QNljmjRXxQlYGPfYEPyyoxvCI5hzEnSFX540cpRZtqmRW9A+
         Ji9zM1OR2SJi0kJeAZdohbNCC1kjFVNUXaYGmn8+JxFeoizkJJ86x1FDWsXiU1XNd3oN
         hbag==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7a0bc562-9f25-392d-5c05-9dbcd350d002-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dmatlack-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 19, 2022 at 07:02:53PM +0100, Paolo Bonzini wrote:
> On 1/18/22 21:39, Tejun Heo wrote:
> > So, these are normally driven by the !populated events. That's how everyone
> > else is doing it. If you want to tie the kvm workers lifetimes to kvm
> > process, wouldn't it be cleaner to do so from kvm side? ie. let kvm process
> > exit wait for the workers to be cleaned up.
> 
> It does.  For example kvm_mmu_post_init_vm's call to
> kvm_vm_create_worker_thread is matched with the call to
> kthread_stop in kvm_mmu_pre_destroy_vm.
> According to Vpin, the problem is that there's a small amount of time
> between the return from kthread_stop and the point where the cgroup
> can be removed.  My understanding of the race is the following:

Okay, this is because kthread_stop piggy backs on vfork_done to wait for the
task exit intead of the usual exit notification, so it only waits till
exit_mm(), which is uhh... weird. So, migrating is one option, I guess,
albeit a rather ugly one. It'd be nicer if we can make kthread_stop()
waiting more regular but I couldn't find a good existing place and routing
the usual parent signaling might be too complicated. Anyone has better
ideas?

Thanks.

-- 
tejun
