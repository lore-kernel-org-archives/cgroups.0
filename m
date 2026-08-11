Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141851DB95E;
	Tue, 11 Aug 2026 00:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786407457; cv=none; b=eswJD9+gzWVDS+2YdazleGKhmL4JRbH1rgnipyjyf+EKX+WZPqrFhajEJFqtyx+X0q4e2mMTS3Zgms8HfwoLxAfzJoA7KrZqX4i+JccOObZHN97u7qv6rT5V3POf/pXvFTPudN4AVvvyREVShnKSJmB/J6Qn7UCDlhcXHkHYUrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786407457; c=relaxed/simple;
	bh=fKO3PCwqdUycjDKKA3zllYcKF3xrw5UX5mN0GnoqEfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aE3kcNZoOEqpOLfTZw7HnSugAnimJqk7lNo7LV98Zet4rUqydQ9sdaZ4xD6gD/w5ThOZKyHiNPoALrrJy8zvzEIiZTm+iIQ+MRld8lqT+QMiBhGTK01fsJ4vDke2Nbpr/o+W4lkREGTodNHHC4SkrUpqNuNoIKzH48HlIEYFIK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Nkv7Mbhf; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Nkv7Mbhf"
Message-ID: <4306439e-a00f-4b10-b8a0-9be6e046873d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786407453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0FbObMeyvKUb5vzu1M8X9q3Z4AyeRD9aHK9DZu6JVXk=;
	b=Nkv7MbhfNGLeWCuNuA5m4yIf98dnAV8j3uWTkYacuGjz1nVr3UsBKPl+FP+pL9Hf+negcf
	jUuapBpEk7D2VDreJEeEnwEzc5uQ6yR2LshtaMI2WL2eQw4FlR62cNByaQ8IRDfp8Ub/qZ
	QuW51Nlt5bC3MIA79WeGOYCC74gYfrk=
Date: Mon, 10 Aug 2026 17:17:26 -0700
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] block: add BPF kfuncs to read blkcg io.stat
To: Ziyang Men <ziyang.meme@gmail.com>, Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Mykola Lysenko <mykolal@meta.com>,
 kernel-team@meta.com, linux-block@vger.kernel.org, bpf@vger.kernel.org,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260807193732.4073299-1-ziyang.meme@gmail.com>
 <20260807193732.4073299-2-ziyang.meme@gmail.com>
 <anot9w6mg9538RWm@slm.duckdns.org>
 <anpU4oV46MDVDixj@devvm16600.scu0.facebook.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <anpU4oV46MDVDixj@devvm16600.scu0.facebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On 8/10/26 3:46 PM, Ziyang Men wrote:
> Hi Tejun,
> 
> Thanks for your review and suggestions!
> 
> On Mon, Aug 10, 2026 at 10:00:55AM -1000, Tejun Heo wrote:
>> Hello,
>>
>> On Fri, Aug 07, 2026 at 12:37:31PM -0700, Ziyang Men wrote:
>>> +__bpf_kfunc struct blkcg *bpf_get_root_blkcg(void)
>>> +__bpf_kfunc struct blkcg *bpf_get_blkcg(struct cgroup_subsys_state 
>>> *css)
>>> +__bpf_kfunc void bpf_put_blkcg(struct blkcg *blkcg)
>>> +__bpf_kfunc void bpf_blkcg_flush_stats(struct blkcg *blkcg)
>>
>> I wonder whether making the above deal with css's would make more 
>> sense so
>> that we don't end up with per-subsystem iterators. If casting to per- 
>> subsys
>> type is necessary, we can provide RCU protected cast kfucns.
>>
> 
> Good idea! These do nothing block specific and we already have some common
> helpers for it such as the bpf_get_root_blkcg(). What is missing is a 
> way to get
> one controller's css from a cgroup with a reference held, and the cast. So
> I would add in kernel/cgroup/
> 
>    struct cgroup_subsys_state *bpf_cgroup_css(struct cgroup *cgrp, int 
> ssid);
>    void bpf_css_release(struct cgroup_subsys_state *css);
> 
> where the @ssid is an enum cgroup_subsys_id value. Afterwards, the only 
> piece for
> blkcg left is:
>    struct blkcg *bpf_css_to_blkcg(struct cgroup_subsys_state *css);
> 
> Note the bpf_blkcg_flush_stats may keep its current shape as it mirrors the
> blkcg_print_stat() which skips the root.
> 
> With these helpers we can also replace the existing ones in
> mm/bpf_memcontrol.c as well:
>      bpf_get_mem_cgroup()
>      bpf_put_mem_cgroup()
>      bpf_mem_cgroup_flush_stats()
> 
> they map onto bpf_cgroup_css() plus a bpf_css_to_memcg() cast the same way.
> 
> Hi Roman, JP, Shakeel: Do you think it is worth applying above changes for
> the memory controller as well? If you are happy with the direction I am 
> glad to
> send the conversion as a follow-up once the generic kfuncs are in. Would 
> you
> take it?

The get/put kfuncs above use KF_ACQUIRE/RELEASE so the verifier can
reject memcg access after the put. Replacing them with a generic API
would call for tracking a new lifetime relationship between the css and
memcg (or other derived) pointer.

For generic flushing, css_rstat_flush() is already a kfunc. The
memcontrol version above uses memcg_vmstats_needs_flush() for skipping
as needed so that should remain intact.
