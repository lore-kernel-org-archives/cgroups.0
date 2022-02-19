From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3] KVM: Move VM's worker kthreads back to the original
 cgroup before exiting.
Date: Sat, 19 Feb 2022 08:55:35 +0100
Message-ID: <70cc45dc-c1e3-9ad4-92c2-f6305b8e8574@redhat.com>
References: <20220217061616.3303271-1-vipinsh@google.com>
 <202202172046.GuW8pHQc-lkp@intel.com>
 <3113f00a-e910-2dfb-479f-268566445630@redhat.com>
 <YhA6QIDME2wFbgIU@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RrXiZDD7PTY+squB+2WTkj/JwujSEeOy/s6pDsbaDwA=;
        b=Ifefml411w6zWQeeeIHONvXpeYAlv7xgij/oqQRGyK2GZodau0R45cXCNx+JnO0IDA
         LE2NTO26p/aYyqCnXJXu5cc4Q/MAhwDcn/4y5349xiRaZBbqRe3fRLNyxHx9iIAd9J3B
         ryurI/v+z3Fj5f5eMBW09Ld5rq4e64ODtSbPdZ1TJTaOR0kZF9z5s2jkzU2Yp9dhf3UF
         W32MP7xw41aYVVwyhYvODl62T5u0YlYSxlFtcI50OcGvQsXPcJASCGdf4+33ZEKjFk0i
         WRZrOSwrgIUETv/XND7z4RxBnV168xmEo40hG8N8rh29BgZXJGbxm8qEApw43zaw2pb7
         qL7g==
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Content-Language: en-US
In-Reply-To: <YhA6QIDME2wFbgIU@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Sean Christopherson <seanjc@google.com>
Cc: kernel test robot <lkp@intel.com>, Vipin Sharma <vipinsh@google.com>, kbuild-all@lists.01.org, mkoutny@suse.com, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, dmatlack@google.com, jiangshanlai@gmail.com, kvm@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 2/19/22 01:30, Sean Christopherson wrote:
> 
> So I think this can be:
> 
> 	rcu_read_lock();
> 	parent = rcu_dereference(current->real_parent);
> 	get_task_struct(parent);
> 	rcu_read_unlock();
> 
> 	(void)cgroup_attach_task_all(parent, current);
>          put_task_struct(parent);

Yes, I agree.

Paolo
