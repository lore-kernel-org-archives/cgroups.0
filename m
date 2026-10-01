Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA0D2BCF4C;
	Thu,  1 Oct 2026 00:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790814059; cv=none; b=GLpehKR//ORrlIx7BQaYSQNlov1DYGtiHX81imkxj1h/8Q/0ydNTP2ZwuiTcfeQlAeZjnt5Xd9LN+kfke5W6w7kxxaJWCeuAqmXMknj0K3deGpQMZuoEFko4WCQMaChQpaBB3QZNvS1CiKmBOfWtXoqGrAfyQOyqT5ymDigk1HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790814059; c=relaxed/simple;
	bh=iD+W5tOd6rzZ/EvSduabToCEIt8D/QP5DnEYsrL58lw=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=Tr/rRxLvsNGZrESFJcrTtkWAvDaLkAVl+eSEr7N1AzSnwqgTXTOYmGDxIjFvTdL9R6NgEd5prOqwIplTxfuT2OyhVyTAPPPzRAcbEb+BYrr7fE1/XHQOrOQZ+1twOE1BFThigEDnJpmVUYNXM/6+jSF3lKofszwc70VHNoxflk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EGPBpMKT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EGPBpMKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F0B1F00898;
	Thu,  1 Oct 2026 00:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790814058;
	bh=Locet4wNAte/Pi9J29JLBsvThdCGg6zldHZQc7ssGV8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=EGPBpMKTIeniDKFmz7/fJD23xh2vmjZN96/0Q3HRRk2MaAWpCnnBjwbWg4OrQsKoO
	 qVd4xi2rIUUV0+1FtLh65d5+1H3Q+AdmtKyGdgabEfgGolHIbzNfqlPg09IZQMeQtV
	 zMiT3ZwaRgpis0R8bT/ipQKOwiYD2UOC9xr4JuXyzyuRnBWFyQ9CTJcab/mOyK4p5b
	 IEsRxscuYviE8rhhYmImJFLfZqcn2JPLzgenzgm+ZZCaXn8RJsqwCDLi5gWtSYWFHO
	 DDy/S6KYFbrPfiH3Kbc4lV2ZTrDio3vEGJi3liiJi57FbMuLaOwi46VObA6QJZEx8t
	 gyylprqziyNzA==
Date: Wed, 30 Sep 2026 14:20:57 -1000
Message-ID: <50cb57cb36c935f24e3a5ec2d301c148@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com,
	ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>, ameryhung@gmail.com,
	alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v8 2/4] selftests/bpf: add iocost cost model test
In-Reply-To: <20260930075154.189958-3-cui.tao@linux.dev>
References: <20260930075154.189958-1-cui.tao@linux.dev>
	<20260930075154.189958-3-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Tao.

The following is a Claude-generated review.

On Wed, 30 Sep 2026 15:51:52 +0800, Tao Cui wrote:
> Add an example cost model implementing the full builtin linear HDD
> formula at double cost, and a test which attaches it to one device:
> the dev member of the struct_ops is written through the map's
> initial value before load, as hid_bpf tests do with hid_id, and
> loading the struct_ops attaches the model to the device.  The test
> verifies the ctrl=bpf readback while attached, that a second model
> on the same device fails with -EBUSY, and that detaching restores
> the builtin model.
...
> cgroup that comes back starts fresh.  opf carries the full bio->bi_opf
> including REQ_* flag bits, so the operation must be extracted with a
> mask, not compared for equality.

The description is out of date. The test reads back model=bpf and checks
that ctrl=bpf is rejected, calc_cost() takes the bio so there is no opf
argument, attaching rather than loading binds the model, and the
multi-stream model and its test aren't mentioned at all.

> +	if (fwrite(buf, 1, strlen(buf), fp) != strlen(buf))
> +		err = ferror(fp) ? errno : EIO;
> +	if (fclose(fp) && !err)
> +		err = errno;
> +	return err;
...
> +		err = write_cost_model(dev, "ctrl=bpf");
> +		ASSERT_ERR(err, "ctrl_bpf_rejected");

write_cost_model() returns a positive errno while ASSERT_ERR() wants a
negative value, so this and model_bpf_after_detach fail with "unexpected
success: 22" on a correct kernel. Return -errno. Can you double check
that the posted runner passes against the posted kernel?

> +	/* dev is the first member of struct iocost_model_ops */
> +	ops_dev = bpf_map__initial_value(skel->maps.iocost_2x, NULL);

The skeleton exposes the struct_ops shadow type, so
skel->struct_ops.iocost_2x->dev = ... is type checked and drops the
layout assumption. Same for iocost_ms.

> +SEC(".struct_ops")
> +struct iocost_model_ops iocost_2x = {

With a plain struct_ops map, a test that dies between attach and detach
leaves the model attached until something deletes the map element. The
hid and sched_ext selftests use ".struct_ops.link" so that closing the fd
detaches. Can you use that here too?

> +	cur = *cursor;
> +	if (cur && priced) {
> +		seek_pages = sector > cur ? sector - cur
> +					   : cur - sector;

A dataless flush is REQ_OP_WRITE|REQ_PREFLUSH at sector 0 with bi_size 0,
so priced is set here. Once a cgroup's cursor is past 16MB, every fsync
is judged a random write and charged 2 * (WRANDIO + WPAGE), about 5ms,
not the one-page write the header comment describes, and iocost_ms.c
prices the same bio with the sequential base. Can you gate the seek
judgement on a non-zero size?

Thanks.

--
tejun
