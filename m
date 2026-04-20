Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFE63750DB;
	Mon, 20 Apr 2026 01:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776650195; cv=none; b=boJ84oBcSPOPtLMzPs+kXoYEqr6T1rbTNHvrKHoKEEmNx3HljNe3U2hO6ZfQ1R4hb8tkJAMjtB/rZ+D8XLX/VkCo1dD0IVWHiE7NiosiFTRc25kfHaBrm3IgNcpma3DvB07YbDF9r5TdSpsWT91te8bw7NtedwUcQaqJp50Lpz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776650195; c=relaxed/simple;
	bh=ps2O/h7YWs5Cvc9MM/kMEaMctw4rcNeO18BU53tT4Ys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kTYiXeTtBeK5r8jEVLOWCvqibfdBDwW1t3cyT9GXN5XZS7aS8ii2a3IhwhAgohOE9DrcXqnkLyQuBR7NcC+YeOzyvJ1QuZgaZK5k9fMM6W2EN3Q++nzpjotSKwF88jjA2GSvt4UZTriadqZm6vfx5BQjD9aOv2Rvh3Bd8SZPzEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 24ebc6983c5c11f1aa26b74ffac11d73-20260420
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:93fc5f95-c01a-4aac-86b4-b807531424a8,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:93fc5f95-c01a-4aac-86b4-b807531424a8,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:1e2dd6753282f466d7052fa38a56210b,BulkI
	D:260418002317WT6C05PW,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil,RT:
	nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0
	,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 24ebc6983c5c11f1aa26b74ffac11d73-20260420
X-User: zhangguopeng@kylinos.cn
Received: from [192.168.109.140] [(183.242.174.20)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 201970121; Mon, 20 Apr 2026 09:56:27 +0800
Message-ID: <b58b460a-2b9a-4b22-90aa-352696699c96@kylinos.cn>
Date: Mon, 20 Apr 2026 09:56:14 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] selftests/sched_ext: add cpuset DL rollback test
To: Cheng-Yang Chou <yphbchou0911@gmail.com>
Cc: longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 void@manifault.com, arighi@nvidia.com, changwoo@igalia.com,
 shuah@kernel.org, chenridong@huaweicloud.com, cgroups@vger.kernel.org,
 sched-ext@lists.linux.dev, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, jserv@ccns.ncku.edu.tw, chia7712@gmail.com
References: <20260417033742.40793-1-zhangguopeng@kylinos.cn>
 <20260417033742.40793-3-zhangguopeng@kylinos.cn>
 <2yfjwt5s2h7lgr7dvm5fgsvogpt7b6f4oeto6nqu3snyjlwgjy@mnigfkcv2vqa>
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
In-Reply-To: <2yfjwt5s2h7lgr7dvm5fgsvogpt7b6f4oeto6nqu3snyjlwgjy@mnigfkcv2vqa>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/4/18 0:23, Cheng-Yang Chou 写道:
> Hi Guopeng,
> 
> On Fri, Apr 17, 2026 at 11:37:42AM +0800, Guopeng Zhang wrote:
> [...]
>> +
>> +#ifndef SYS_sched_setattr
>> +#if defined(__x86_64__)
>> +#define SYS_sched_setattr 314
>> +#elif defined(__i386__)
>> +#define SYS_sched_setattr 351
>> +#elif defined(__aarch64__)
> 
> Nit: Since RISC-V uses the same assigned syscall number as ARM64, it
> would be nice to support it here as well,
> 
...
> 
>> +static enum scx_test_status run(void *arg)
>> +{
>> +	struct cpuset_dl_rollback_ctx *ctx = arg;
>> +	char procs_path[PATH_MAX];
>> +	long long before_bw, after_bw;
>> +	int ret;
>> +
>> +	ret = read_cpu_total_bw(ctx->target_cpu, &before_bw);
>> +	SCX_FAIL_IF(ret, "Failed to read baseline total_bw (%d)", ret);
> 
> The first read_cpu_total_bw() call is redundant because before_bw is
> overwritten after spawn_dl_child(). Use a separate variable for the
> baseline if needed. Otherwise, the second call already handles the same
> error check.
> 
...
>> +	SCX_FAIL_IF(ret, "Failed to start SCHED_DEADLINE child (%d)", ret);
>> +
>> +	ret = read_cpu_total_bw(ctx->target_cpu, &before_bw);
> 
> Overwritten here.
> 
>> +	SCX_FAIL_IF(ret, "Failed to read pre-move total_bw (%d)", ret);
> 
Hi Cheng-Yang,

Thanks for the review.

Both comments make sense. The current test is implemented under
`selftests/sched_ext`. If this test case is later moved to
`selftests/cgroup`, I’ll address both points in the next revision.

Thanks,
Guopeng
