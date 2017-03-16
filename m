From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] kthread, cgroup: close race window where new
 kthreads can be migrated to non-root cgroups
Date: Thu, 16 Mar 2017 13:41:14 -0400
Message-ID: <20170316174114.GG15810@htj.duckdns.org>
References: <20170315231827.GA13656@htj.duckdns.org>
 <20170315231920.GB13656@htj.duckdns.org>
 <20170316150233.GB24478@redhat.com>
 <20170316153925.GA26391@redhat.com>
 <20170316160734.GD15810@htj.duckdns.org>
 <20170316163158.GB27613@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Hl6huWm8voqvzn6e9K+1ndCfgAc6jvcXmPUxowfyGWY=;
        b=Tgai/qGe+yRjE/3D97Ve6wNw7KYt4ho0UxdcrImd5s1wxCkoKucEzjdJ7FlrZVvmOx
         b8O7pzO5Zn0L4vqv9i6kVVamfK6klKE7Ndo5yOHmfx06auxJb3s3nTui91HJBHMUeWtM
         U1XzT+J96jLQz3M/u5LpMSw0YKto2Ekm9OuGKSGD6we5rWNfB4RkvIPIkNq2MX+OqEHL
         mjL1tlfDQ8nCSkwJsz+EwjlqOLV/SB9XPvSCmzDItW1e6/vFlmYX7eG6S70jjV7ENFB/
         kuH3C9CKu/huZnJ/k8ZKgkXxL3cO/rc6YR2MeukVrlPcHdE7i+np+CQHBuDs7a4vd8aU
         meyQ==
Content-Disposition: inline
In-Reply-To: <20170316163158.GB27613@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Chris Mason <clm@fb.com>, linux-kernel@vger.kernel.org, kernel-team@fb.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

Hello,

On Thu, Mar 16, 2017 at 05:31:59PM +0100, Oleg Nesterov wrote:
> Or we can add another "unsigned no_cgroups:1" bit into task_struct,
> not sure.

To synchronize around initialization, a PF flag would be easier as we
can use wait_on_bit().

> Anyway, I do not understand the PF_NO_SETAFFINITY check in
> __cgroup_procs_write(). task_can_attach() checks it too, so cgroups
> can't change the affinity. Imo something explicit like no_cgroups
> makes more sense.

task_can_attach() predates the __cgroup_procs_write() and currently
doesn't do anything.  We can split the flag or rename it so that it's
more generic.  The reasons for disallowing cgroup migration have a lot
of crosssection with affinity, so it's not a complete misnomer.
Either way is fine by me.

Thanks.

-- 
tejun
