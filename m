Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDB949B464
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 08:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792399657; cv=none; b=GqIXj5bPZV2jHMIC48PogB/XT3kRXJj9vuZtNACFdqXea7Fd/rgdKfE/QWcCVpg7SWr0X9Zpxw1NoupO1+AyhRnY04DxeaERt0Rb/st8IE/gLX2NmztfWS5LQwmGbxTxWOoUgXHF0+GWlv1+Av6LMb5LUgPryRQ2mpkSyPUw7nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792399657; c=relaxed/simple;
	bh=jFAkyj5yoPWtYLC+zOW72R2wyKdGUE2qk/tecO0yjmA=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=p87TCJqMvNhYAGi/nFxaBQv95nqoLbjIMXPIATNi4DJgNGt9cgI0DwSZ3PvdQa72A/RM+fYhFL+9EKb/R+tAj1vlwfGoOLMUl3KvjvKl24J1wwQ7nwVBlIN3/sIYWEMDNR4pdaJ9OlL15ff3flMiz3QUxFqPON3RZsDo3vQ3aUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JZ1ZcpQ6; arc=none smtp.client-ip=91.218.175.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JZ1ZcpQ6"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jFAkyj5yoPWtYLC+zOW72R2wyKdGUE2qk/tecO0yjmA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792399653; v=1; x=1793004453;
 b=JZ1ZcpQ6rs/nEXE0tIhJ2SEUgsoq0dF8fHk1c2XZC/ntxtHo0YRtOJW3N9MnO5OHSt69/45h
 cFJMesqOXbslNCCjA7t3qGuv7hGFkdkt++X/8EHLPGzVWC05S1O2uL/N48ZTniAem+GJ/Kw3DVX
 UvENTPelfBKUpx6sW5sqAEW8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d39df06ac6c62a0f;
	Mon, 19 Oct 2026 08:47:33 +0000
X-Mizu-Trace-ID: d39df06ac6c62a0f
X-Migadu-Flow: FLOW_OUT
Message-ID: <6f2cb853-5eb5-4f3b-9021-ab24735a61c3@linux.dev>
Date: Mon, 19 Oct 2026 16:47:26 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 linux-kselftest@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>,
 ameryhung@gmail.com, alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v10 0/4] blk-iocost: add BPF struct_ops cost model
 support
To: Tejun Heo <tj@kernel.org>
References: <20261003124045.1289305-1-cui.tao@linux.dev>
 <a3dfbc2d-8580-478c-8189-3794d49aee11@linux.dev>
 <20e2b2a51fd97292add8d8e527b14a45@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20e2b2a51fd97292add8d8e527b14a45@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello Tejun,

在 2026/10/17 01:49, Tejun Heo 写道:
> Hello, Tao.
> 
> On Thu, 15 Oct 2026 20:00:20 +0800, Tao Cui wrote:
>> When you have a chance, could you take a look at this series? I'd
>> appreciate your thoughts on whether the implementation still matches
>> what we discussed, or whether it has drifted somewhere along the way.
> 
> The behavior matches what was discussed, but the implementation needs a
> lot of cleanup, and there are bugs in the detach path and the
> iocg_init()/iocg_free() pairing. Details are in the replies to the
> patches.
> 

Thank you for the careful review, and especially for confirming that
the behavior is where we wanted it.

The two bugs are mine to fix, and v11 reworks both. The detach path
follows your map-reference suggestion, and the iocg_init()/iocg_free()
pairing moves to ioc_pd_online() as you described, with iocg_free()
keeping the delivered flag per your catch about bios still holding the
blkg across offline. 

>> Sashiko flagged a possible ABBA between the BPF paths and
>> ioc_cost_model_write(): attach/detach take the queue freeze before
>> q->rq_qos_mutex, while the cost-model write holds rq_qos_mutex across
>> its freeze. That is indeed the current ordering, but I don't think this
>> can deadlock because the queue freeze is a depth counter
> 
> The attach and detach order matches ioc_qos_write(). The reverse order in
> ioc_cost_model_write() predates this series and is better fixed
> separately. An earlier attempt to convert it ran into blk_iocost_init()'s
> percpu allocation under the freeze:
> 
>   https://lore.kernel.org/all/aV5OwAvw1sRF1IW1@fedora/
> 
Agreed. The write path ordering predates the series and
I've left it alone there.

The implementation cleanup from the patch replies is in v11 as well.

Thanks,
Tao

> Thanks.
> 

