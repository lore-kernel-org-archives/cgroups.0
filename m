From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 11/17] cgroup: Implement new thread mode semantics
Date: Thu, 1 Jun 2017 14:47:40 -0400
Message-ID: <20170601184740.GC3494@htj.duckdns.org>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-12-git-send-email-longman@redhat.com>
 <20170519202624.GA15279@wtj.duckdns.org>
 <b1d02881-f522-8baa-5ebe-9b1ad74a03e4@redhat.com>
 <20170524203616.GO24798@htj.duckdns.org>
 <9b147a7e-fec3-3b78-7587-3890efcd42f2@redhat.com>
 <20170524212745.GP24798@htj.duckdns.org>
 <20170601145042.GA3494@htj.duckdns.org>
 <20170601151045.xhsv7jauejjis3mi@hirez.programming.kicks-ass.net>
 <ffa991a3-074d-ffd5-7a6a-556d6cdd08fe@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2F4HN0qrjNf1ZX5TqBZtvCFa56kDah8rlpWfurm4p4g=;
        b=qA5zn3+RlBp+Dj0i36mspZMyhdjngOpD7QeeVwld5Y2BkQj2u6UAyG69tY1cVdji3z
         g5y/Mm7vn5wq1gUVn+NTxYYOVsHgmU/N6/t5Elw4e1gvbSW2cjk4Ow82nM6Atb8rr54+
         JjmeefTV9XSu3xcrFwwE8GG8vqSdshXU4aEJx4IFbK58PJM+4Zbq7ht87HLnK2PUv9P7
         JdjLXx54uRRqAOrNXO17KAMQw41NujuzXeIykyHcQw7Rr9DIDQssJNoKxxptD5RxUpuw
         qzbfW3LrhLhhEdlR4Tith0PFDZ5dJicps3Tm9tGRFZhjKixz+MN9PcwO2777z9cuss+P
         Gwtg==
Content-Disposition: inline
In-Reply-To: <ffa991a3-074d-ffd5-7a6a-556d6cdd08fe@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

Hello, Waiman.

On Thu, Jun 01, 2017 at 02:44:48PM -0400, Waiman Long wrote:
> > And cgroup-v2 has this 'exception' (aka wart) for the root group which
> > needs to be replicated for each namespace.
> 
> One of the changes that I proposed in my patches was to get rid of the
> no internal process constraint. I think that will solve a big part of
> the container invariant problem that we have with cgroup v2.

I'm not sure.  It just masks it without actually solving it.  I mean,
the constraint is thereq for a reason.  "Solving" it would defeat one
of the main capabilities for resource domains and masking it from
kernel side doesn't make whole lot of sense to me given that it's
something which can be easily done from userland.  If we take out that
part, for controllers which don't care about resource domains,
wouldn't thread mode be a sufficient solution?

Thanks.

-- 
tejun
