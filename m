From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock
Date: Tue, 25 Aug 2020 21:19:46 -0400
Message-ID: <20200826011946.spknwjt44d2szrdo@ca-dmjordan1.us.oracle.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
 <alpine.LSU.2.11.2008241231460.1065@eggly.anvils>
 <20200825015627.3c3pnwauqznnp3gc@ca-dmjordan1.us.oracle.com>
 <ec62a835-f79d-2b8c-99c7-120834703b42@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=VWKaRWmTmrlTrbnIky0PuQ3aZ0bL/HrXLsBsMQQqZo4=;
 b=jQNvNVHYVl0Oq89XEgsmuaLNiJpGZJT9brk12EKPFxStCdsik5I4IBEl6Bg/H3NtYf2Z
 cmzX1sVKVAwMR/9dtkl5+JbbWT934jfcpvNxDywlgqCg51YQs0e0n9qAHlHsLQ5ihWaP
 jfDlzlh4U6ZT4v89eaYGfzPPP/w9t5HO2yAgiNyJ1PgteJXcHlLGZW6e7NrjGNIVpSeB
 lU7mwgsqKocBkjf4K5fjzhl9uxqclIjlOPIoYhiqdyWwa04NYvZW7c+F0nPNNYYZ4/rV
 FMmXYE4rJEyLxS6Vur9iT/YFuDO8s0NbT0Q+rWL/Ni1XlHheonNF35vprX/YllYb3zk6 rA== 
Content-Disposition: inline
In-Reply-To: <ec62a835-f79d-2b8c-99c7-120834703b42@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, mgorman@techsingularity.net, tj@kernel.org, khlebnikov@yandex-team.ru, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com

On Tue, Aug 25, 2020 at 11:26:58AM +0800, Alex Shi wrote:
> 在 2020/8/25 上午9:56, Daniel Jordan 写道:
> > Alex, do you have a pointer to the modified readtwice case?
> 
> Sorry, no. my developer machine crashed, so I lost case my container and modified
> case. I am struggling to get my container back from a account problematic repository. 
> 
> But some testing scripts is here, generally, the original readtwice case will
> run each of threads on each of cpus. The new case will run one container on each cpus,
> and just run one readtwice thead in each of containers.

Ok, what you've sent so far gives me an idea of what you did.  My readtwice
changes were similar, except I used the cgroup interface directly instead of
docker and shared a filesystem between all the cgroups whereas it looks like
you had one per memcg.  30 second runs on 5.9-rc2 and v18 gave 11% more data
read with v18.  This was using 16 cgroups (32 dd tasks) on a 40 CPU, 2 socket
machine.

> > Even better would be a description of the problem you're having in production
> > with lru_lock.  We might be able to create at least a simulation of it to show
> > what the expected improvement of your real workload is.
> 
> we are using thousands memcgs in a machine, but as a simulation, I guess above case
> could be helpful to show the problem.

Using thousands of memcgs to do what?  Any particulars about the type of
workload?  Surely it's more complicated than page cache reads :)

> > I ran a few benchmarks on v17 last week (sysbench oltp readonly, kerndevel from
> > mmtests, a memcg-ized version of the readtwice case I cooked up) and then today
> > discovered there's a chance I wasn't running the right kernels, so I'm redoing
> > them on v18.

Neither kernel compile nor git checkout in the root cgroup changed much, just
0.31% slower on elapsed time for the compile, so no significant regressions
there.  Now for sysbench again.
