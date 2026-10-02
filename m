Received: from mta1.migadu.com (out-39.mta1.migadu.com [95.215.58.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A619C3C9898
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 14:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790951032; cv=none; b=DMNVKCjkAhbEXjFK4nNQsdd6lkyWGfEbV8xqrj9LhKBF8GKEADRltMJLR9DnlycvX5wAemZMhTE54m+azdzoOWb3WymxDnYnf7gRRNpZ5T0AJgMXY5ROgf1Gl57EfUmX23UfygcgC+eP8eyphmjTXDMlQjmAMgrodGuEkPsGRS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790951032; c=relaxed/simple;
	bh=oMtW3gNuramt0VHA8sxMo+VfNyV7hMxcbdmaOZv3KU8=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Eu5dKN34o3oDPtXvw+Yq3G15sOokcmwlMu1YI6PdPBPu7M3pUPmxEQWg20Q31gkLqc+qePfD1NgsxV4eN1rPU0m7Or6k+wOiI3/5RZe/0UTm/hqJB4n94O+hcezuuwYZEVNFnqKG0wwFBWIJSQWWze3pa/qBdoLGk0CjMzrmlIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gZTvs2r5; arc=none smtp.client-ip=95.215.58.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gZTvs2r5"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oMtW3gNuramt0VHA8sxMo+VfNyV7hMxcbdmaOZv3KU8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790951028; v=1; x=1791555828;
 b=gZTvs2r5f9HbdemwRT51PeNcYUKC+pXqdvohkwT6fyl7l5BzS0UiG7RFcR9Lxe+ejXfyJB/i
 BMG3WcrhgGJgFssOl/HE4h0fmuoow667VQvTAUz9E0MO+KvCDyW3TRIAoLw0DlcKgiIAna4Vv8C
 4a/jmx1DfAw8uth7oDGRrIbY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ba559b314145e725;
	Fri, 02 Oct 2026 14:23:48 +0000
X-Mizu-Trace-ID: ba559b314145e725
X-Migadu-Flow: FLOW_OUT
Message-ID: <10da1f58-89f1-4b9f-bf96-b2ed4ddd69c7@linux.dev>
Date: Fri, 2 Oct 2026 22:23:40 +0800
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
Subject: Re: [RFC PATCH v8 4/4] docs: cgroup-v2: document the iocost BPF cost
 model attachment
To: Tejun Heo <tj@kernel.org>
References: <20260930075154.189958-1-cui.tao@linux.dev>
 <20260930075154.189958-5-cui.tao@linux.dev>
 <95edaf582303f1a9404c989f9f0e6501@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <95edaf582303f1a9404c989f9f0e6501@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello, Tejun.

在 2026/10/1 08:20, Tejun Heo 写道:
> Hello, Tao.
> 
> The following is a Claude-generated review.
> 
> On Wed, 30 Sep 2026 15:51:54 +0800, Tao Cui wrote:
>> +	When CONFIG_BLK_CGROUP_IOCOST_BPF is enabled, a BPF cost model
>> +	can be attached to a device by loading an "iocost_model_ops"
>> +	struct_ops with the whole disk's major:minor in its "dev" member
> ...
>> +	switches back to the builtin model, and neither detaches the
>> +	struct_ops; only detaching removes the model, after which
>> +	"model=bpf" fails.  "ctrl" keeps describing the builtin
> 
> Attaching, not loading, binds the model. The test loads a second model
> fine and only its attach fails. Device removal also removes the model,
> and the user still has to tear down the struct_ops link afterwards. Can
> you mention that too?
> 

Done: the documentation now says attaching binds the model, that
removing the device ejects it as well, and that the user still has to
tear down the struct_ops link afterwards.

Thanks.
Tao

> Thanks.
> 
> --
> tejun

