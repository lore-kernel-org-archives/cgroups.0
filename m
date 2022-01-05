From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Date: Wed, 5 Jan 2022 19:04:20 +0100
Message-ID: <20220105180420.GC6464@blackbody.suse.cz>
References: <20211222225350.1912249-1-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641405861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I285agTL7MMNPRyO3Wp0TqKsq8WVrLiSnho8jMPnTkc=;
        b=aFsCA1NnRlrdQX1xT7reIq3L0VKqZSlIvdXLA7XJhLNT/q89yCOFr5XON4VbVZ7G7cvBpm
        HgZpjo44U4Co78g3KMsxUq5JYI6+JPe1N4QKevGPjRmwEcGI5lvuZgdw/k0sbscvbcnc04
        U5AyWHBn19jEbSdt+moEurjPuqZKS3o=
Content-Disposition: inline
In-Reply-To: <20211222225350.1912249-1-vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dmatlack-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vipin.

On Wed, Dec 22, 2021 at 10:53:50PM +0000, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> VM worker kthreads can linger in the VM process's cgroup for sometime
> after KVM terminates the VM process.

Why is it a problem? And how long are we talking about?

> A VM process can terminate between the time window of exit_mm() to
> cgroup_exit(), leaving only worker kthreads in the cgroup.

Even kthreads should eventually have PF_EXITING set, they shouldd be
treated as "user-space" zombies by cgroups, i.e. mostly invisible (e.g.
it doesn't prevent rmdir'ing the cgroup).

(And after the last task_struct reference is gone, the cgroup structs
can be released too. Maybe the cause is holding the reference to the KVM
worker thread somewhere for too long.)

> Moving worker kthreads back to the original cgroup (kthreadd_task's
> cgroup) makes sure that cgroup is empty as soon as the main VM process
> is terminated.

BTW this used to be done for "user-space" tasks too (migrate to root
cgroup) but it was replaced with the less transactional "ignore zombies"
approach. So this change seems inconsistent.


Regards,
Michal
