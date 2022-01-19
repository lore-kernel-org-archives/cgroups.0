From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Date: Wed, 19 Jan 2022 19:02:53 +0100
Message-ID: <7a0bc562-9f25-392d-5c05-9dbcd350d002@redhat.com>
References: <20211222225350.1912249-1-vipinsh@google.com>
 <20220105180420.GC6464@blackbody.suse.cz>
 <CAHVum0e84nUcGtdPYQaJDQszKj-QVP5gM+nteBpSTaQ2sWYpmQ@mail.gmail.com>
 <Yeclbe3GNdCMLlHz@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642615380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=czyQcT5AvdpFdccMDnqOJP5PsUxctttwWttnV2WSAI4=;
        b=T8gJ1i0aTtAdERDiXt4BeCytBiK3KhfgQQy9Gq7Wy33WoF52ZUe1UW1dpuvLrqAZdZVAQB
        mbM9i88E0JobMJbh78/r6smiQDdfg3k/CFFEMRiopgN6fK8/XeV8daj3NXQucuCFGqgUIe
        b/Dq+MExsOJjzxQeUHntfBfnK5am6XA=
Content-Language: en-US
In-Reply-To: <Yeclbe3GNdCMLlHz@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Vipin Sharma <vipinsh@google.com>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, seanjc@google.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, dmatlack@google.com, jiangshanlai@gmail.com, kvm@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 1/18/22 21:39, Tejun Heo wrote:
> So, these are normally driven by the !populated events. That's how everyone
> else is doing it. If you want to tie the kvm workers lifetimes to kvm
> process, wouldn't it be cleaner to do so from kvm side? ie. let kvm process
> exit wait for the workers to be cleaned up.

It does.  For example kvm_mmu_post_init_vm's call to
kvm_vm_create_worker_thread is matched with the call to
kthread_stop in kvm_mmu_pre_destroy_vm.
  
According to Vpin, the problem is that there's a small amount of time
between the return from kthread_stop and the point where the cgroup
can be removed.  My understanding of the race is the following:

user process			kthread			management
------------			-------			----------
							wait4()
exit_task_work()
   ____fput()
     kvm_mmu_pre_destroy_vm()
       kthread_stop();
         wait_for_completion();
				exit_signals()
				  /* set PF_EXITING */
				exit_mm()
				  exit_mm_release()
				    complete_vfork_done()
				      complete();
cgroup_exit()
   cgroup_set_move_task()
     css_set_update_populated()
exit_notify()
   do_notify_parent()
							<wakeup>
							rmdir()
							  cgroup_destroy_locked()
							    cgroup_is_populated()
							    return -EBUSY
				cgroup_exit()
				  cgroup_set_move_task()
				    css_set_update_populated()

I cannot find the code that makes it possible to rmdir a cgroup
if PF_EXITING is set.

Paolo

