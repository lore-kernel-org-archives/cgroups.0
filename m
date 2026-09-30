Received: from mta1.migadu.com (out-233.mta1.migadu.com [95.215.58.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31083932C8
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 04:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790741796; cv=none; b=WTfBtq37Pu8EkcshOtpjZls45IhH4IpKwNn5CSUbpWZCF4NC/WMsbvk9SiQe+Z26osu+olmpV0vg5DX8r2t5jQrGxPfN9vJLMuVj7a40KRSgETTakp6UVBXhGgeB60lBW/XYRam6odE1R+Nc5FlGejLNcg9shmZMkuKVFpLmuQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790741796; c=relaxed/simple;
	bh=tPVU3foMwqReFRMovxRBgLvssWCyPO87vgRcah7Bfo0=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hT4+iv2CDtT+uD8d4CpOY6/dPNAsoCiKB1pv2pbwpFcH7oD+PI1AanY8cEqHo/tMSrkC38GuzuZSSLZwUS4ELYHmmTgnbBBxMzWQaadDTmmy6kKC6kqVQhBANP31r0e1LTsc3q9GyFXCqksAzfl2TtsO47ItZCQWZslAmqAMt8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wqHb2/ug; arc=none smtp.client-ip=95.215.58.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wqHb2/ug"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tPVU3foMwqReFRMovxRBgLvssWCyPO87vgRcah7Bfo0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790741791; v=1; x=1791346591;
 b=wqHb2/ughpwmo8Yqw76dAyYf7g5CO7kMsJKwMBDIduf8Fhwl3YG1mLNjo2AACvtpNK8JqrD5
 Lvk1oFby5Xa4LsgBJzWuBuCsFK7uL/32KA9P9/F0j79yyGNCmcR1wjzuINwzmBQf9UWqy/DBUVS
 t6DWFuxq0qbzoE379Uw4QUqE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ac3d7e7d4a45a171;
	Wed, 30 Sep 2026 04:16:31 +0000
X-Mizu-Trace-ID: ac3d7e7d4a45a171
X-Migadu-Flow: FLOW_OUT
Message-ID: <4f0e79fc-9413-4017-93a2-414b4370781f@linux.dev>
Date: Wed, 30 Sep 2026 12:14:57 +0800
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
Subject: Re: [RFC PATCH v7 1/4] blk-iocost: add BPF struct_ops cost model
 support
To: Tejun Heo <tj@kernel.org>
References: <20260924054549.2271705-1-cui.tao@linux.dev>
 <20260924054549.2271705-2-cui.tao@linux.dev>
 <4412563645504aa9a87d3cafd544c97c@kernel.org>
 <daf428f7-d666-447f-9b6e-a77da4194e91@linux.dev>
 <aeb50cff4d3014a43ded85247a5786da@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <aeb50cff4d3014a43ded85247a5786da@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello, Tejun.

在 2026/9/30 00:27, Tejun Heo 写道:
> Hello, Tao.
> 
> On Tue, 29 Sep 2026 21:42:51 +0800, Tao Cui wrote:
>> That leaves one race: .unreg may observe a non-NULL ops->q before
>> ioc_rqos_exit() clears it, then block on rq_qos_mutex while the
>> ejection drops the last bdev reference.  This looks analogous to
>> hid_bpf's .unreg vs. destroy_device synchronization.
>>
>> Does that seem acceptable here too, or would you rather have .unreg
>> own the final reference unconditionally?
> 
> No, there can't be a crash window like that. The underlying problem is
> that .unreg sleeps on a mutex inside a queue it holds no reference on. The
> model should still be ejected when the device goes away, but exactly when
> doesn't matter much as long as it happens in a reasonable amount of time.
> 
> request_queues are RCU-freed, so maybe .unreg can rcu_dereference() ops->q
> and try to get a queue reference under rcu_read_lock()? blk_get_queue()
> fails on a dying queue, so this would need a tryget wrapper around
> q->refs. Holding its own reference, .unreg can then take rq_qos_mutex and
> test ops->q for NULL to tell whether removal already ejected the model.
> 

.unreg now takes a queue reference before entering the queue: it
rcu_dereferences ops->q under rcu_read_lock() and uses a queue
reference tryget helper to keep the queue valid across the mutex wait.  With
the reference held, .unreg freezes and quiesces the queue, takes
rq_qos_mutex and re-checks ops->q for NULL, so it can handle both the
normal detach path and the case where removal has already ejected
the model.
> Also, when .unreg detaches, the device is still live and the BPF code may
> be running. Freezing and quiescing the queue covers the IO paths but not
> iocg_init() and iocg_free() called from ioc_pd_init() and ioc_pd_free(),
> so the iocg_free() walk and clearing the model need to be synchronized
> against those too.
> 

Clearing the model and the iocg_free() walk are now synchronized
under q->blkcg_mutex.  This is the same mutex used when
blkg_create() and blkg_free_workfn() invoke pd_init_fn() and
pd_free_fn(), so the detach path is synchronized with the normal pd
callback paths.

While reworking the attach path, I also fixed two related issues I
noticed: the attach path no longer uses the ioc after releasing
rq_qos_mutex, and blkdev_get_no_open() failures are handled
correctly for unknown dev_t values.

v8 will follow shortly.

Thanks.
Tao

> Thanks.
> 
> --
> tejun

