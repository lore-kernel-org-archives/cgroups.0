From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: Query regarding deadlock involving cgroup_threadgroup_rwsem and
 cpu_hotplug_lock
Date: Mon, 15 Aug 2022 11:05:56 +0200
Message-ID: <20220815090556.GB27407@blackbody.suse.cz>
References: <8245b710-8acb-d8e6-7045-99a5f71dad4e@oracle.com>
 <26d0e4cc-be0e-2c12-6174-dfbb1edb1ed6@oracle.com>
 <bbc01477-231b-3dbb-3e09-9338f5413f06@oracle.com>
 <ba48eac5-8ef7-251b-11fe-8163bb7a2d54@quicinc.com>
 <224b19f3-912d-b858-7af4-185b8e55bc66@quicinc.com>
 <YthDz4BnfYHce1od@slm.duckdns.org>
 <YuGTBLkFerUboctl@slm.duckdns.org>
 <dc0cff0e-b744-9d5d-e727-70d1c31b2a74@quicinc.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660554357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wmyLVShEDIO9zR9fd/Zd6KIwqvJ7WmFq3Q+f4veJxx4=;
        b=Hr7FJApvmpacg+qsEsJ9ov0c/tj4crcwwKaC5VvYz8JZ5R2TTE2h7cECeD9EJfzdYfYWAc
        cN6spABRKoxVA3aiXtRq3fSz0vQiAI+DH1UU/0eoeqEB7IGt1oHlgnYia5D4+XmpkvfT97
        uWu7YDaPLs1jhiKEkKAQrGk8nHMwqEU=
Content-Disposition: inline
In-Reply-To: <dc0cff0e-b744-9d5d-e727-70d1c31b2a74@quicinc.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mukesh Ojha <quic_mojha@quicinc.com>
Cc: Tejun Heo <tj@kernel.org>, Imran Khan <imran.f.khan@oracle.com>, lizefan.x@bytedance.com, hannes@cmpxchg.org, tglx@linutronix.de, steven.price@arm.com, peterz@infradead.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Zhao Gongyi <zhaogongyi@huawei.com>, Zhang Qiao <zhangqiao22@huawei.com>

+Cc: Zhao Gongyi <zhaogongyi@huawei.com>, Zhang Qiao <zhangqiao22@huawei.com>

On Fri, Aug 12, 2022 at 03:57:00PM +0530, Mukesh Ojha <quic_mojha@quicinc.com> wrote:
> The original patch of yours [1]  and the revert of [2] is fixing the issue
> and it is also confirmed here [3].
> Can we get proper fix merge on your tree?
> 
> [1] https://lore.kernel.org/lkml/YuGbYCfAG81mZBnN@slm.duckdns.org/
> 
> [2]
> https://lore.kernel.org/all/20220121101210.84926-1-zhangqiao22@huawei.com/

The revert + Tejun's patch looks fine wrt the problem of the reverted
patch (just moves cpus_read_lock to upper callers).

I'd just suggest a comment that'd explicitly document also the lock
order that we stick to, IIUC, it should be:

	cpu_hotplug_lock // cpus_read_lock
	cgroup_threadgroup_rwsem
	cpuset_rwsem

Michal

> 
> [3] https://lore.kernel.org/lkml/CAB8ipk-72V-bYRfL-VcSRSyXTeQqkBVj+1d5MHSVV5CTar9a0Q@mail.gmail.com/
> 
> -Mukesh
