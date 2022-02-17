From: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] KVM: Move VM's worker kthreads back to the original
 cgroup before exiting.
Date: Thu, 17 Feb 2022 17:05:45 +0100
Message-ID: <3113f00a-e910-2dfb-479f-268566445630@redhat.com>
References: <20220217061616.3303271-1-vipinsh@google.com>
 <202202172046.GuW8pHQc-lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645113950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q8C5mBTF/zQPiu7mRTQ0V1X+3+5OQ4DWAsdzOSei6/I=;
        b=g0/DkOjF130rSLL0p9nt5505Y/iggj+13Tzt4sfNyOz/3X4rjSLPiNKNyZFolR9QqMVaa8
        nQ/dVp9CScKvddp+4umIV9KQELbcV7X3b81qf2qDxshcoySmCKlIMhH+Rq9tIwHYsf7pOM
        6wc0NE72ghfjO/qbzvcwh0T/XrAnELI=
Content-Language: en-US
In-Reply-To: <202202172046.GuW8pHQc-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dmatlack-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/17/22 13:34, kernel test robot wrote:
>> 5859		reattach_err = cgroup_attach_task_all(current->real_parent, current);

This needs to be within rcu_dereference().

Paolo

>    5860		if (reattach_err) {
>    5861			kvm_err("%s: cgroup_attach_task_all failed on reattach with err %d\n",
>    5862				__func__, reattach_err);
>    5863		}
>    5864		return err;
>    5865	}
>    5866	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
> 

