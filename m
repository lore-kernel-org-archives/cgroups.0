From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Thu, 19 Jul 2018 09:52:01 -0700
Message-ID: <20180719165201.GU72677@devbig577.frc2.facebook.com>
References: <1529825440-9574-1-git-send-email-longman@redhat.com>
 <1529825440-9574-8-git-send-email-longman@redhat.com>
 <20180702165322.GI533219@devbig577.frc2.facebook.com>
 <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
 <20180703155823.GS533219@devbig577.frc2.facebook.com>
 <20180719135224.GE2494@hirez.programming.kicks-ass.net>
 <1107494a-9667-df58-dcac-9366e969dc3a@redhat.com>
 <20180719153045.GT72677@devbig577.frc2.facebook.com>
 <de6f931d-613a-3e6a-2a4d-0e49b3bfe2e5@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=S11QxldGb2rueyxaC44wods7Mrexh/qBlnMNZmhzCsE=;
        b=d3I+R6/dVKJ/ByZS3i5E/MQVNNXGPhHTCGua0IYNTSIDDusgYui+slnnSmN3+H/SPU
         kHqRNrcKKUs3FAbLr9L8trLadP+IgJFvlE+M5ji1s7HOxjL8QCcetLrssg2qEYzg3Moz
         lG6+dpj96Qj4jSHkspN3M57Yhh1Qom5uauTlrCt7pz80Zo/h9cPKRj87vbePV8cTBx2d
         9zOkqYh118nmtn91wxo0yNlqhq2pE+vHRdnSerYMs0I1MvLhhV0glNffOTWwG4JH4AsN
         F6fJ4FJkvieSR5xqQChUN0/mS30fDvZj2kQgl0YueVLxWguforOnaV+dkFEE5bX3LDh2
         YOaA==
Content-Disposition: inline
In-Reply-To: <de6f931d-613a-3e6a-2a4d-0e49b3bfe2e5@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

Hello,

On Thu, Jul 19, 2018 at 11:52:46AM -0400, Waiman Long wrote:
> BTW, the way the partition is currently implemented right now is that a
> child cannot be a partition root unless its parent is a partition root
> itself. That is to avoid turning on partition to affect ancestors
> further up the hierarchy than just the parent. So in the case of a
> container, it cannot allocate sub-partitions underneath it unless it is
> a partition itself. Will that solve your concern?

Hmm... so a given ancestor must be able to both

1. control which cpus are moved into a partition in all of its
   subtree.

2. take away any given cpu from ist subtree.

Right now, I don't think it's achieving either, right?

Thanks.

-- 
tejun
