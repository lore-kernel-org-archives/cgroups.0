Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.129
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795745720;
	b=2YziU7d85YS1Bz8qG/JcwT24nzsf3q5SdLNzSvOydIJ0q8DN7gy4cmg3BePXj57bgCXH
	 k0kd2//7R9XrtYp9U5RwTG7qLCZXqYCU67ckMdyZJ6eN2eL7H2ShLfI7pd1N8VNiTLpTb
	 t9azIe3rPvrxjl6zdg91H7tTQQwa8BSRBAjAu7JbcM4LkKCQAmQQNB3hVC3VpehvDMIx9
	 ofNYBBB7uZcHYK/JZVmxwh09aXL2OKZ3RCxINMIEF4q41meFlVjAjDF1o4dtKb2gmUTuu
	 JPN3w+Yqk+iZvkXFVwOGUMjPM+6jdktpJ14ZAPGN1pNjPXYrBhtAGw3BUzdtanUSLbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795745720;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:From:To:Cc:References:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=oBOKoaA48rE8EF/1cfxHdI1AQ5POAWxUBxC+DwiRvrc=;
	b=bRU77ES6PHZvROx3IKJTazUQ3qcuSeiGfZ3KgFNjQDLhQ4V6Shs7y3knHAQbNJWL/PhV
	 Rz1JeLKgWKlJ92+NVTuFG7KyCRXrsXKcW6cBvQWZx+Ll9f9qQvKyEfWJWIgcGEPMF1Kkb
	 R8Zf1TFIcHNJK8ZSCtGo/votcQGwl9uRzIAAZnGa7hSZlzi2/H2VWaz2NBTZTBlaPNDLG
	 xwPCzPkvSwpzd2UW/jjyR2+m+CCIPgouiXpgUW71AR0ALGbAKjEiejzz/KQ7W7axgILB6
	 dtxQNe9JNLoWXha+ZinJUJ6h/iZLLJHK8q2UWgwdKGuqfqN39c/yij0ciNkOyX/n64g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iJYeMtg3;
	arc=none smtp.remote-ip=95.215.58.129
Received: from mta1.migadu.com (out-129.mta1.migadu.com [95.215.58.129])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D9F606A31C
	for <cgroups@vger.kernel.org>; Fri, 27 Nov 2026 02:15:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7D9F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iJYeMtg3
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=c4X+gqMxgHivpxeHUP0pL4+jrGpSF5DB2qBHND7Atd4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795745718; v=1; x=1796350518;
 b=iJYeMtg32CKMEIbnLIBA7hiHOVJYS114oHtCscOujFnaa9vHgOzRFhXqNNr9Zrhb16hjzgY7
 t+70VcK3qCPclSUGaWfRTXY96WODLmtysyI9JLu/goQO0nUgcUn23OLAAF9oloBZS8KVOMJ/16B
 UVjnJbA5D27HPyZUg6jUeZQw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 60c40adf911d4eda;
	Fri, 27 Nov 2026 02:15:14 +0000
X-Mizu-Trace-ID: 60c40adf911d4eda
X-Migadu-Flow: FLOW_OUT
Message-ID: <bc6e38f6-1412-49d0-95e2-76d5e9fc3858@linux.dev>
Date: Fri, 27 Nov 2026 10:15:07 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] sched/isolation: Publish new HK_TYPE_DOMAIN cpumask under
 cpuset_mutex
From: Ridong Chen <ridong.chen@linux.dev>
To: longman@redhat.com, frederic@kernel.org, tj@kernel.org,
 peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, hannes@cmpxchg.org, mkoutny@suse.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 guopeng.zhang@linux.dev, mathieu.desnoyers@efficios.com,
 Ridong Chen <chenridong@xiaomi.com>
References: <054a53a3-c038-48fe-ac01-fc24fd8065d0@linux.dev>
 <20261117083915.2971979-1-ridong.chen@linux.dev>
In-Reply-To: <20261117083915.2971979-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/17/2026 4:39 PM, Ridong wrote:
> From: Ridong Chen<chenridong@xiaomi.com>
> 
> Commit a84097e625f2 ("cgroup/cpuset: Call housekeeping_update() without
> holding cpus_read_lock") calls housekeeping_update() after dropping
> cpus_read_lock and cpuset_mutex, so the HK_TYPE_DOMAIN cpumask is now
> switched and freed outside of those locks. But readers holding either
> lock may still access it without rcu_read_lock() as allowed by
> housekeeping_dereference_check(), and synchronize_rcu() doesn't wait
> for them:
> 
>    CPU A                                  CPU B
>    rebuild_sched_domains()                cpuset_update_sd_hk_unlock()
>                                             mutex_unlock(&cpuset_mutex)
>                                             cpus_read_unlock()
>      mutex_lock(&cpuset_mutex)
>      p = housekeeping_cpumask(DOMAIN)
>                                             housekeeping_update()
>                                               rcu_assign_pointer()
>                                               synchronize_rcu()
>                                               kfree(old)
>      access p <- UAF
> 
> Fix it by moving the pointer switch into housekeeping_publish(), which
> is called before dropping the locks. Then CPU A either finishes before
> CPU B switches the pointer, or only sees the new cpumask:
> 
>    CPU A                                  CPU B
>                                           cpuset_update_sd_hk_unlock()
>                                             housekeeping_publish()
>                                               rcu_assign_pointer()
>      mutex_lock(&cpuset_mutex) <- wait
>                                             mutex_unlock(&cpuset_mutex)
>                                             cpus_read_unlock()
>      p = housekeeping_cpumask(DOMAIN)       housekeeping_update()
>          <- new cpumask                       synchronize_rcu()
>                                               kfree(old)
> 
> The rest of housekeeping_update(), including the workqueue flushes,
> still runs without those locks.
> 
> Fixes: a84097e625f2 ("cgroup/cpuset: Call housekeeping_update() without holding cpus_read_lock")
> Signed-off-by: Ridong Chen<chenridong@xiaomi.com>


Hi Frederic, Tejun,

There are two fixes for the HK_TYPE_DOMAIN UAF after commit
a84097e625f2, and neither is in linux-next yet:

[1] Waiman's v2, which takes cpus_read_lock and cpuset_mutex once
     before kfree(old), so readers holding either lock are done
     before the old cpumask is freed.
	
[2] This patch, which switches the pointer before dropping the
     locks, so readers holding either lock only see the new cpumask.

Waiman said either one works. Frederic, since this is your
housekeeping code, which one would you prefer? Tejun, could you
apply the chosen one to cgroup/for-7.5?

If it is this one, I will send a v2 rebased onto for-7.5, as it now
conflicts with housekeeping_set_cpu() from commit 884e88175b95.

[1] https://lore.kernel.org/all/20261117051853.2429410-1-longman@redhat.com/

-- 
Best regards
Ridong

