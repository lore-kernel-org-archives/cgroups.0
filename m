From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH-cgroup 1/6] cgroup: Relax the no internal process
 constraint
Date: Wed, 21 Jun 2017 18:02:03 -0400
Message-ID: <20170621220203.GA18600@htj.duckdns.org>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
 <1497452737-11125-2-git-send-email-longman@redhat.com>
 <20170621204050.GA14720@htj.duckdns.org>
 <0c752151-f4aa-cda0-ba36-77cdc7dc25c6@redhat.com>
 <20170621213905.GD14720@htj.duckdns.org>
 <6c115cf4-e229-413c-f63f-26fb8fd870d9@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9WMXVITbirZeBZYacS1mbqtZOLajFAGa5D47j/CTb6s=;
        b=gDDaXN2W68uVJQshZswAh/wkmi6DQd1Jtl96ZnJc52+19v4+0WN/frGDrhLdTnjsV7
         3n7lL+XMaHnHgpjrNKxRLyjvSPqcJQjWLmc8/WERCrF1PNyacrJJijeE8GwKRvsceSCE
         kJ2gSDcaGeRfHYpwWVedQkJ0OPqvs4xcyyr9vpZO/jcfTGptSsUM2ZkqrOf7H/KSaU35
         XosRbjj6ocGz3cBGqbn+Sh276UgW2rGaR7IZ45OiGkbbDDaHC3vf+pm5eMeIAh1vIIRL
         UJdwQNmWfT/gzqLiMwcSqMXgkppyl96V+JWN+DSPZMIUKfTiVZ2w/bRNIHHSXf8br+BJ
         mryg==
Content-Disposition: inline
In-Reply-To: <6c115cf4-e229-413c-f63f-26fb8fd870d9@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org

Hey,

On Wed, Jun 21, 2017 at 05:50:09PM -0400, Waiman Long wrote:
> >> I think CPU isn't a good example for that.
> > Can you please elaborate?
> 
> CPU is probably the most prominent controller where deep hierarchy has a
> performance cost. So I can't envision that it will forbid internal
> process competition.

I think there's a fundamental misunderstanding here.  The internal
competion thing is about how to account for resource consumptions
which aren't tied to specific processes or tasks.  Thread mode allows
building sub-hierarchy beyond the domain point while still keeping the
domain at the root of the thread subtree.  It is true that as
currently implemented, CPU controller has performance issues for some
workloads even with a moderate level of nesting (and quite a bit of
other artifacts from nesting too); however, supporting control of
anonymous resources or not is an orthogonal issue.  People can enable
thread mode at the root if that's applicable to the workload at hand
but you can't change what the basic topology means because a
controller has performance overhead.

> >> Another alternative is to treat no internal process as a controller
> >> attribute. Then we don't need to worry about this intricate question and
> >> let the  controllers decide if they will allow internal processes.
> > Isn't that what "threaded" is?
> 
> That is exactly what this patch intends to do. However, you raised
> concern that threaded may not be equivalent to the need of allowing
> internal process. That is why I propose that. If your concern is only
> about the documentation change, we can certainly fix that.

I'm really lost on what this actually achieves.  Can we please first
talk about what you're trying to enable?  Let's talk about features
and capabilities first because it feels like most of the changes in
this patchset lack them and we seem to be talking past each other.

Thanks.

-- 
tejun
