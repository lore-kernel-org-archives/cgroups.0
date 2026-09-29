Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C3C51B18F;
	Tue, 29 Sep 2026 16:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790699267; cv=none; b=pZ33on5YEw/T1br/D5GNg2aqDsKuOBeeM/db0X0NiHMZHyPGt7FCmyJ0Dg+cmal5N/8QBMatYPhM+NU8WCYZ5TbJPilLrBNLXUPvDibPAVxw6w1BsAqlRa56m8eWyHm+MOb3v8fo9sbodSpIZc6qmS/KgzUBsA/3a9GME9IYy/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790699267; c=relaxed/simple;
	bh=FToVisFcHGImeZQTI0lUkw0nqou7C9qIziIjjD3y+Rw=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y7xsRemAu9DWSzlARkV1EfH8Vu089pYIYnjsAArW+UbRvFuAjqLFmXt6NizGzHdqRoei8mDpCtmt9ALUwXiuLgqtMpoUUA6u5sdkggHRO5xrcO61eumqU5bNFOFvF2UPeMIsXMIyhP1V+KyNgeMHjhvEihX9Qp43gvWCgahasfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bCpQ48o/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bCpQ48o/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEB01F00893;
	Tue, 29 Sep 2026 16:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790699266;
	bh=o0Zicd12ssGapXPbpFh0mo1gZMSR9A8dcAbcZMHgOb8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bCpQ48o/2PCA1BJxDW+3lH5GraekOEYVsFTTXKTroQoSuAWJA3P2LIRTQAtqf5PLK
	 lCLByBMEG9FSS30LH1uMM3Nglgue5PKm2a5b1H4AQrDzh3Vv9b89Arv5aE5LUc4toa
	 EACu2NXquzjy3NdhbYi2I9VMpQT/IEGpz81FyiNtR190W+UuEx6XkkpLpEIx0TBDd6
	 IZVRRVgMawC2bVNGWMq26BRHPBNZLEYdDgFE/FK3n0d6ZCuhxc56bqHHLlCO3sOHoa
	 4/sFqhyMVLI3CXBVk/B1mFFHTNkH1JfI2YSRThC1H9qCdFIYi33H0HczHalmJBFM3h
	 H3uAG4IJfrr3Q==
Date: Tue, 29 Sep 2026 06:27:45 -1000
Message-ID: <aeb50cff4d3014a43ded85247a5786da@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org,
 daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>, ameryhung@gmail.com,
 alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v7 1/4] blk-iocost: add BPF struct_ops cost model
 support
In-Reply-To: <daf428f7-d666-447f-9b6e-a77da4194e91@linux.dev>
References: <20260924054549.2271705-1-cui.tao@linux.dev>
 <20260924054549.2271705-2-cui.tao@linux.dev>
 <4412563645504aa9a87d3cafd544c97c@kernel.org>
 <daf428f7-d666-447f-9b6e-a77da4194e91@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Tao.

On Tue, 29 Sep 2026 21:42:51 +0800, Tao Cui wrote:
> That leaves one race: .unreg may observe a non-NULL ops->q before
> ioc_rqos_exit() clears it, then block on rq_qos_mutex while the
> ejection drops the last bdev reference.  This looks analogous to
> hid_bpf's .unreg vs. destroy_device synchronization.
>
> Does that seem acceptable here too, or would you rather have .unreg
> own the final reference unconditionally?

No, there can't be a crash window like that. The underlying problem is
that .unreg sleeps on a mutex inside a queue it holds no reference on. The
model should still be ejected when the device goes away, but exactly when
doesn't matter much as long as it happens in a reasonable amount of time.

request_queues are RCU-freed, so maybe .unreg can rcu_dereference() ops->q
and try to get a queue reference under rcu_read_lock()? blk_get_queue()
fails on a dying queue, so this would need a tryget wrapper around
q->refs. Holding its own reference, .unreg can then take rq_qos_mutex and
test ops->q for NULL to tell whether removal already ejected the model.

Also, when .unreg detaches, the device is still live and the BPF code may
be running. Freezing and quiescing the queue covers the IO paths but not
iocg_init() and iocg_free() called from ioc_pd_init() and ioc_pd_free(),
so the iocg_free() walk and clearing the model need to be synchronized
against those too.

Thanks.

--
tejun
