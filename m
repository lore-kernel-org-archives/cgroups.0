Received: from mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F324AA1EB
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 14:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790950848; cv=none; b=e40lKuxG7lDtcEZECf/6jIz/7b2QKmvQixsi3kBq3aErB8cjemPLYlKft9BvrDHNgRKlzoZLPu+q8txFqbAYCNy745WPWN0Xp0HOq7igqBPDj0XxfoqPhlZvQmPoWgRI+9oT4DtzsY+snPdAu2u0OhTJ5haVJIt9y2Uudn7CVa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790950848; c=relaxed/simple;
	bh=sSuRpJtw6wT3cSv2S7x2+3y7hyVUzo2hMGuMjfIVABw=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Nq7Exynwr1rpbhQe5Su4YnoLwp2z8Fl/F9l19JwL1iT62ucydSCH+3Khv1IhPxlQgLAuc9o3wkEXnOVX00sfYo8Hqbc1G5yvNQqm9IHcdWzAs9ne/mYCv2A9DaifS/hb7rC8w/w9Lp9M22LxI4hr2HlDxyyaOlA47FrvmWH9rag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CaUg9wzx; arc=none smtp.client-ip=91.218.175.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CaUg9wzx"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=sSuRpJtw6wT3cSv2S7x2+3y7hyVUzo2hMGuMjfIVABw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790950844; v=1; x=1791555644;
 b=CaUg9wzxfWXIKjeO5MfRJI3X/T0mTfYemO4g5QbmXUSazZ78sNpTnm3w13WB/3Hd+OXzilFD
 h6cAFRunp2TsCH+YS6Kf/Y0XDFHfpJuXztx23M/3MX5sJO/Z/Gkp6UJoBJ5NJsj9O5zUXGKbDrx
 raEBqcDPe6KwJUR9D0W/UoV8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f5d7a9aa3c29816f;
	Fri, 02 Oct 2026 14:20:34 +0000
X-Mizu-Trace-ID: f5d7a9aa3c29816f
X-Migadu-Flow: FLOW_OUT
Message-ID: <206443c4-6a1a-4a7b-9e4e-032ff40fc6e4@linux.dev>
Date: Fri, 2 Oct 2026 22:20:28 +0800
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
Subject: Re: [RFC PATCH v8 2/4] selftests/bpf: add iocost cost model test
To: Tejun Heo <tj@kernel.org>
References: <20260930075154.189958-1-cui.tao@linux.dev>
 <20260930075154.189958-3-cui.tao@linux.dev>
 <50cb57cb36c935f24e3a5ec2d301c148@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <50cb57cb36c935f24e3a5ec2d301c148@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello, Tejun.

在 2026/10/1 08:20, Tejun Heo 写道:
> Hello, Tao.
> 
> The following is a Claude-generated review.
> 
> On Wed, 30 Sep 2026 15:51:52 +0800, Tao Cui wrote:
>> Add an example cost model implementing the full builtin linear HDD
>> formula at double cost, and a test which attaches it to one device:
>> the dev member of the struct_ops is written through the map's
>> initial value before load, as hid_bpf tests do with hid_id, and
>> loading the struct_ops attaches the model to the device.  The test
>> verifies the ctrl=bpf readback while attached, that a second model
>> on the same device fails with -EBUSY, and that detaching restores
>> the builtin model.
> ...
>> cgroup that comes back starts fresh.  opf carries the full bio->bi_opf
>> including REQ_* flag bits, so the operation must be extracted with a
>> mask, not compared for equality.
> 
> The description is out of date. The test reads back model=bpf and checks
> that ctrl=bpf is rejected, calc_cost() takes the bio so there is no opf
> argument, attaching rather than loading binds the model, and the
> multi-stream model and its test aren't mentioned at all.
> 

The commit message is rewritten to describe the current test,
including the multi-stream model.

>> +	if (fwrite(buf, 1, strlen(buf), fp) != strlen(buf))
>> +		err = ferror(fp) ? errno : EIO;
>> +	if (fclose(fp) && !err)
>> +		err = errno;
>> +	return err;
> ...
>> +		err = write_cost_model(dev, "ctrl=bpf");
>> +		ASSERT_ERR(err, "ctrl_bpf_rejected");
> 
> write_cost_model() returns a positive errno while ASSERT_ERR() wants a
> negative value, so this and model_bpf_after_detach fail with "unexpected
> success: 22" on a correct kernel. Return -errno. Can you double check
> that the posted runner passes against the posted kernel?
> 

Fixed, it returns -errno. The posted runner had not been run against
the posted kernel; it now passes against the v9 kernel.

>> +	/* dev is the first member of struct iocost_model_ops */
>> +	ops_dev = bpf_map__initial_value(skel->maps.iocost_2x, NULL);
> 
> The skeleton exposes the struct_ops shadow type, so
> skel->struct_ops.iocost_2x->dev = ... is type checked and drops the
> layout assumption. Same for iocost_ms.
> 

Done for both models.

>> +SEC(".struct_ops")
>> +struct iocost_model_ops iocost_2x = {
> 
> With a plain struct_ops map, a test that dies between attach and detach
> leaves the model attached until something deletes the map element. The
> hid and sched_ext selftests use ".struct_ops.link" so that closing the fd
> detaches. Can you use that here too?
> 

Done, both maps are ".struct_ops.link".

>> +	cur = *cursor;
>> +	if (cur && priced) {
>> +		seek_pages = sector > cur ? sector - cur
>> +					   : cur - sector;
> 
> A dataless flush is REQ_OP_WRITE|REQ_PREFLUSH at sector 0 with bi_size 0,
> so priced is set here. Once a cgroup's cursor is past 16MB, every fsync
> is judged a random write and charged 2 * (WRANDIO + WPAGE), about 5ms,
> not the one-page write the header comment describes, and iocost_ms.c
> prices the same bio with the sequential base. Can you gate the seek
> judgement on a non-zero size?
> 

Done: the seek judgement is now gated on a non-zero IO size, so a
dataless flush is priced as a size-zero sequential write, matching the
builtin model.

Thanks.
Tao

> Thanks.
> 
> --
> tejun

