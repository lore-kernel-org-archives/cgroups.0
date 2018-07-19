From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Thu, 19 Jul 2018 08:30:45 -0700
Message-ID: <20180719153045.GT72677@devbig577.frc2.facebook.com>
References: <1529825440-9574-1-git-send-email-longman@redhat.com>
 <1529825440-9574-8-git-send-email-longman@redhat.com>
 <20180702165322.GI533219@devbig577.frc2.facebook.com>
 <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
 <20180703155823.GS533219@devbig577.frc2.facebook.com>
 <20180719135224.GE2494@hirez.programming.kicks-ass.net>
 <1107494a-9667-df58-dcac-9366e969dc3a@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g4Zr28DVOj84QY7szq3yRIAxlimqHglCuCxjWlH9YW0=;
        b=YWMBkxfelbOQ+qIePoSMIS0ClcZXhErnpXQJcKCxs+GJ3zKUkIaFrP+OkGff2hF+yV
         DhLkJCLXllK4yRhyKJ8i0zyzYgmm56r9gYQezioRNuhqwr7zYAjCfhV0iwYPL/MLXDAx
         6epXNN2p5sZrnKS2wt1SU83Mp6jpuYNyaqcmv+shflalBkRaCU0PMInb9ffeXRbBiHYp
         7cvhH+ccy1PxpKAhmyKdEijC/X01jn3NfBJBilXjrypKN5SmyURb2o4Qa05Itj3K0qIf
         u4IqgBHCsCXLHA0QCQ1fIrE9MwZXS0J192mG1RbGTfgbvXppttUtdHkxFrtdfUi3gvXj
         zZug==
Content-Disposition: inline
In-Reply-To: <1107494a-9667-df58-dcac-9366e969dc3a@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

Hello,

On Thu, Jul 19, 2018 at 10:04:54AM -0400, Waiman Long wrote:
> > Why would a container not be allowed to create partitions for its
> > various RT workloads?
> 
> As far as I understand, Tejun has some concern about the way that
> partitioning works is inconsistent with how other resources are being
> managed by cgroup v2 controllers. I adds an incremental patch to
> temporarily disable the creation of partition below the first level
> children to buy us time so that we can reach a compromise later on what
> to do. We can always add features, but taking away features after they
> are made available will be hard.
> 
> I am fine either way. It is up to you and Tejun to figure out what
> should be made available to the users.

So, the main thing is that putting a cpu into a partition locks away
the cpu from its ancestors.  That's a system level operation which
isn't delegatable.  If we want to allow partitioning in subtrees, the
parent still be able to take away partitioned cpus too even if that
means ignoring descendants' configurations, which btw is exactly what
cpuset does for non-partition configs.

I don't think this would be technically too challenging to implement,
but unless there are immediate use cases for it, we can start simpler
& restricted.

Thanks.

-- 
tejun
