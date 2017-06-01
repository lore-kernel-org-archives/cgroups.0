From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 11/17] cgroup: Implement new thread mode semantics
Date: Thu, 1 Jun 2017 11:35:28 -0400
Message-ID: <20170601153528.GB3494@htj.duckdns.org>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-12-git-send-email-longman@redhat.com>
 <20170519202624.GA15279@wtj.duckdns.org>
 <b1d02881-f522-8baa-5ebe-9b1ad74a03e4@redhat.com>
 <20170524203616.GO24798@htj.duckdns.org>
 <9b147a7e-fec3-3b78-7587-3890efcd42f2@redhat.com>
 <20170524212745.GP24798@htj.duckdns.org>
 <20170601145042.GA3494@htj.duckdns.org>
 <20170601151045.xhsv7jauejjis3mi@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=y0MKgZ2Bis6BmsdaE3Xdd30hC1Vaf8Bz+UoSv0pLXlM=;
        b=LofrmMkQD4I+MRlZTdNNP9467FSddP8u220q/h7lFcESbJCoSsI9PqAFqx97oGj6Cb
         FijePgfMll8WyteQgT2nkHTg4AMSw0XiBPnHc/LnQMdByEovI0R7ZMt0LM7QA1T0oND5
         zHDF/oG5lLzDs7BYoXBxJ0BONtkHBT4UmdkU6l52SBTtPBxjodNqADpOMyxa7n25OnBG
         B9QcBh0Tik7unMjmgKuS0gE5dyr+FwkI56ZakXzQ2DLh3uQ3m9HIXfikDAC+hQymLz2z
         RaPzHZzqcaAoKLN8F7lGgt3uPYoSffQT1YvE72rmnlkEfLLDM+6QuLxfCGpf82CD4aGe
         tVYA==
Content-Disposition: inline
In-Reply-To: <20170601151045.xhsv7jauejjis3mi@hirez.programming.kicks-ass.net>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <longman@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

Hello, Peter.

On Thu, Jun 01, 2017 at 05:10:45PM +0200, Peter Zijlstra wrote:
> I've not had time to look at any of this. But the question I'm most
> curious about is how cgroup-v2 preserves the container invariant.
> 
> That is, each container (namespace) should look like a 'real' machine.
> So just like userns allows to have a uid-0 (aka root) for each container
> and pidns allows a pid-1 for each container, cgroupns should provide a
> root group for each container.
> 
> And cgroup-v2 has this 'exception' (aka wart) for the root group which
> needs to be replicated for each namespace.

The goal has never been that a container must be indistinguishible
from a real machine.  For certain things, things simply don't have
exact equivalents due to sharing (memory stats or journal writes for
example) and those things are exactly why people prefer containers
over VMs for certain use cases.  If one wants full replication, VM
would be the way to go.

The goal is allowing enough container invariant so that appropriate
workloads can be contained and co-exist in useful ways.  This also
means that the contained workload is usually either a bit illiterate
w.r.t. to the system details (doesn't care) or makes some adjustments
for running inside a container (most quasi-full-system ones already
do).

System root is inherently different from all other nested roots.
Making some exceptions for the root isn't about taking away from other
roots but more reflecting the inherent differences - there are things
which are inherently system / bare-metal.

Thanks.

-- 
tejun
