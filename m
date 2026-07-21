Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7B73FCB11
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 01:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784598243; cv=none; b=XygZ8mzTpFtj/Y3B0hgfgIfvxMGI1F/w3uysGdRNlQ8lhxjN2sX/GWtV3s1eF9AcaLi2n3OXvKLhFyuP+tEKP4/Kx6e1mL+LWi6XZMRq6C1ey3e+dIU3To4a544o9DUYNP8p9ya6Ld1HEnmBubQR1DCbUsE8qCIQxRnP6uDAFeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784598243; c=relaxed/simple;
	bh=ilevQ6bwsQLzh3JOzjacrhtuo5GRlSwbuOUHgEo4Mkg=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=s/+77TboltmOQXkOyltzIvKBEYzpg30Q8tpuy7LM42nAcZ65PkPz93u4n7bHKAK2BFXLtL5Y2aWWQVfP46BaBJwhqG8owhRz+PXuUAaPLOZSqp0EEUa6gWJ9l1aMLPEnVfPVD4Yz9zws4pJVFxb04pWFnyo/cQq6t4aAObLV7wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VeY/KVCW; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VeY/KVCW"
Message-ID: <6b74b3cc-849a-4a0b-8971-e591f6ca3dca@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784598239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qP7GoR0yPXAUHlXfNNC43mw+8vkPdP3SqsgqwzlleZY=;
	b=VeY/KVCWjc9tx69DMreZ9TjyiVowIoVhcWQXCWRR8dOGiPYN9Zc2QUmrBSEPT2hxKL2eDM
	ajeJR7FI9VEGWt7eE8/evaUUTlFfnVEi2iRCYoW9a2J8xyMs1BCc0gszCdgRFe1NNeRggV
	lhVaHj52nTqqTA8akzGDbBmiGwe/OHw=
Date: Tue, 21 Jul 2026 09:43:51 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, cuitao@kylinos.cn
Subject: Re: [PATCH] cgroup/cpu: document cpu.stat nice_usec and
 core_sched.force_idle_usec
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
References: <20260718080100.2334415-1-cui.tao@linux.dev>
 <al46ipavC-KCaoHv@localhost.localdomain>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <al46ipavC-KCaoHv@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/7/20 23:26, Michal Koutný 写道:
> On Sat, Jul 18, 2026 at 04:01:00PM +0800, Tao Cui <cui.tao@linux.dev> wrote:
>> From: Tao Cui <cuitao@kylinos.cn>
>>
>> cgroup_base_stat_cputime_show() unconditionally prints a fourth base
>> stat, nice_usec, in addition to usage_usec/user_usec/system_usec, and
>> also prints core_sched.force_idle_usec when CONFIG_SCHED_CORE is enabled.
>> Neither field is currently described in the cpu.stat section of
>> cgroup-v2.rst, which still states it "always reports the following three
>> stats".
> 
> Just to better sense popularity of the fields -- have you found this out
> by:
> a) reading cpu.stat and being confused about semantics of the fields or
> b) scanning files/code vs docs looking for discrepancies?
> 
(b). I found it while auditing the cgroup cpu controller, comparing
what cgroup_base_stat_cputime_show() prints against the cpu.stat docs.
nice_usec is emitted unconditionally but not listed there, and the
"three stats" count was stale.

The audit is groundwork for a prototype daemon that monitors
per-cgroup resource usage and adjusts limits dynamically. The design
is inspired by DAMON, but DAMON targets a single resource domain,
whereas container workloads need coordinated control across several
(cpu, memory, io) — which is why I'm going through the per-controller
stat interfaces.

Thanks,
Tao
> Thanks,
> Michal

