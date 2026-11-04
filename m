Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793760318;
	b=oq1gBlZJMY3qScBcoYmeu4R3tQVo25l/2E37Oft8dtmegPDtsHkxu6QWi65CC5UgQQWl
	 LhJ9/nUkgMPS1unaARTQN6YuIyl1/pKod6x+CmjP+QcOwC7RJeXpQRdx9itwGe6TuSIc+
	 RRLxihi/O5tBM2rNzcd4bazrlHZLg1bYhrIkk8oqcERNRjF87yy10ovIZCZzzVKdY8f9Z
	 2Ylvt0pGy42u6479Tix6QTBOqhLnKm8KZ1njJn/2sXgv9wT0qVjQrPqIxcKMckQdguwdF
	 xfD/monh6m84NLySbyI0KHoaLVJrQSzqLk+PDrPwShqRxT8sKAIiEFI6//uxhwQPZqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793760318;
	h=DMARC-Filter:DKIM-Signature:In-Reply-To:Mime-Version:
	 X-Lms-Return-Path:X-Original-From:User-Agent:To:Subject:Date:
	 References:Cc:From:Content-Type:Message-Id:Content-Transfer-Encoding;
	bh=rRzhUBlhk/MV6qetpAub4eArNWxfVuqj/T9Xhffcs+I=;
	b=ghz53jGJgaE7CKG+zeYLtXiE+OmB8eFu6yFsINeIyv83MrV3ckh4gjGTliaQZbBtma6a
	 +WrU5zSEQJ4ifiWmDQwoLKkLuBPpkCQadlSgjXZIeRSOG/FhH18QYDMqC3F1yZPIvaHBw
	 68Agn2WWFlMz1zTwonOTn4CfLqkaBVeiCzPTR4OQQm31GS2x9toSLBufbKAAoZ0nl0goK
	 kAsTYlP6w+lKsW06nYv2Kcrx5N/zNYd0y5H70xW+L0ODfZPPLP1rviW6Da1tWcCNvDSBK
	 lExx3LcJlfd7CcbY99tAUFe2JFdsP4Gllbkdfp7+MWS84lwCQy5Xgb0IPYjRM8DB11g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=a3uy0tnS;
	arc=none smtp.remote-ip=209.127.231.111
Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4DC606A31B
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 02:45:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C4DC606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=a3uy0tnS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793760311; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=rRzhUBlhk/MV6qetpAub4eArNWxfVuqj/T9Xhffcs+I=;
 b=a3uy0tnSn2cJBr5aBLK8fXX5Ap+fy0xWiabvtBdkU30DxrO5TfMZMmfSbqWVG5UQ8DMX7Y
 5SRrXF+D395hSWT3hX2UJD8DMrWn+XO6vzfJg3g1BOd5xn80IPBmZUdxN32Avvk37foB0w
 DoeDyCoPlToHA3kZLB0gLh3AZXqdubVxF33fnCvt8hlM4qhfgswauCoccOk8e/tzyk/Ug+
 9eFkJ6+CDc8x/15HlMWqXDrg2sgq+G+HdygOrKyXCzCsQZw+dHnSbNo6ltBSg2EsNfIcmz
 eFMexcSAP5x7RHi9SLOwKv3OG1hKtQGuYICvLX7N3y7szk/xK9DSjU/NKP7XQw==
In-Reply-To: <0efbf4db1decd8e6bb6a5fcdcf897314@kernel.org>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26aea9c34+3f4f81+vger.kernel.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
To: "Tejun Heo" <tj@kernel.org>
Subject: Re: [PATCH 0/3] mm/mempolicy: add per-cgroup weighted interleave controls
Date: Wed, 4 Nov 2026 10:44:46 +0800
References: <20261103122816.48037-1-lizhe.67@bytedance.com> <0efbf4db1decd8e6bb6a5fcdcf897314@kernel.org>
Cc: <hannes@cmpxchg.org>, <mkoutny@suse.com>, <akpm@linux-foundation.org>, 
	<david@kernel.org>, <gourry@gourry.net>, <ziy@nvidia.com>, 
	<joshua.hahnjy@gmail.com>, <ying.huang@linux.alibaba.com>, 
	<ljs@kernel.org>, <liam@infradead.org>, <rppt@kernel.org>, 
	<surenb@google.com>, <mhocko@suse.com>, <cgroups@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<bpf@vger.kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <03bceb67-d362-47a6-b555-ed5aa1f9bd3e@bytedance.com>
Content-Transfer-Encoding: 7bit

On 11/3/26 11:35 PM, Tejun Heo wrote:
> Hello, Zhe.
>
> On Tue, Nov 03, 2026 at 08:28:13PM +0800, Li Zhe wrote:
>> MPOL_WEIGHTED_INTERLEAVE currently has one system-wide weight table,
>> configured through sysfs or auto-derived from node bandwidth. This series
>> adds an optional BPF control plane that lets privileged BPF syscall
>> programs install manual weighted-interleave overrides for individual
>> cgroups.
> ...
>
> I don't think this has much to do with cgroups. Weighted interleave is
> already a per-thread/per-VMA policy chosen through set_mempolicy() and
> mbind(), and the weights are parameters of that policy. I think this
> should be tied to the memory policy instead. This is different from
> the per-cgroup NUMA balancing kfuncs. NUMA balancing has no per-task
> opt-in and acts on memory with no task context.
>
> Gregory Price's mempolicy2 series already proposed set_mempolicy2() and
> mbind2() with task-local weights:
>
>    https://lore.kernel.org/all/20240103224209.2541-1-gregory.price@memverge.com/


Hi Tejun. Thanks for taking a look.

I agree that MPOL_WEIGHTED_INTERLEAVE itself is selected by the task or
VMA through the existing mempolicy interfaces. This series is not trying
to make cgroups select that policy for tasks. A task still has to opt in
to MPOL_WEIGHTED_INTERLEAVE explicitly.

The part this series tries to make cgroup-scoped is the weight table.
Today that table is already outside struct mempolicy and is configured
as a system-wide administrative parameter. The problem we are trying to
solve is that different co-located workloads may need different DRAM/CXL
ratios while using the same MPOL_WEIGHTED_INTERLEAVE policy.

I have looked at the mempolicy2/mbind2 direction. It would model the
weights as task-local or VMA-local policy parameters, but it also requires
new syscall ABI and a much larger mempolicy UAPI extension. This BPF kfunc
interface was intended as a smaller administrative control plane for the
existing global-weight model: keep the existing mempolicy ABI, keep the
global sysfs table as the default, and allow a privileged manager to
install an override for a cgroup in the default hierarchy.

Does that distinction make the cgroup-scoped override acceptable? If not,
could you suggest a better way to support this kind of administrative
weight override without adding new mempolicy syscalls?

Thanks,
Zhe

>
> Thanks.
>
> --
> tejun
