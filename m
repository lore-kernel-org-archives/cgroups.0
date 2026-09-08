Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31DC483BD8;
	Tue,  8 Sep 2026 21:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788901417; cv=none; b=mrBxMhizKTQ9MXmes4qqQMiEUh/2JpCmLv7bp7PZqQdr3OqLsQe/WfRgzNGx76jVZB3eLQJWR9bcZWEW0TAMb/+Lur4dTZmFX/2oNtizCR+Ufr0ckr5s4fSBm/Weg0psPC8Tcx6eMgX/D9+C7AspbspaNM1xVOnjHg/sfm5pQI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788901417; c=relaxed/simple;
	bh=0TXV1+uuvA2AEY0E6bElvINIJZOSpwwyZ2/iBsisImk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KStMK1+w7kFS9anlfXPCKmcUUUCVYzCcoCb2aVBNaMThpNqGFkUjCOQPuT7yP+cl2DCfMFuleRZa40W8yv/8Q9PO9MFytv7T0CV1FG8wrlwIoU3TcdDtItTlMrlQbRLrKrwaFq5IdgGneNVNs/DL1h/j/BwKBZPtNNaPhKCNR8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ijp8bKDD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ijp8bKDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1001F00A3A;
	Tue,  8 Sep 2026 21:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788901416;
	bh=xYZU48Q5YI0a4FaRSaEZUnwzmCxEfV20qAzngQf7dAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ijp8bKDDIn9DCCso7OvjicAeL7j5vwEuCfFsvIgOnJNJmRVOO6gL8rlrPXtkxGO54
	 TlvVRBJax0sRRzrPHZvV1mKeJUPMCXIo6+YU9wpmxnDz9ND8ewGw2Sa4jcGKqmGXI2
	 4YEkg5DrvA6lLyJnYagyGvk4k81OJeByEOhtJtYdHTi2m/X2CezdD8g0Arik1PVOqU
	 i5pJy+c/vt2F7B1FCnMkWdrwD42mKdGE9yOqBrSzG7/q9QaLaNf8XAIeV5MIHZ6tv+
	 PpzXQ7CNcDXEH5I3Vd4uaxfIY1OErj8GNtVjlaYbAsJO4dHMtIvouf9al2QNgSDUGH
	 bLAZSuaPO0DVw==
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 3/8] blk-iocost: implement BPF struct_ops registration
Date: Tue, 08 Sep 2026 10:31:11 -1000
Message-ID: <178889947167.2.9168058946538747939@kernel.org>
In-Reply-To: <20260908100143.47598-4-cui.tao@linux.dev>
References: <20260908100143.47598-1-cui.tao@linux.dev>
 <20260908100143.47598-4-cui.tao@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello, Tao.

On Tue, 08 Sep 2026 18:01:38 +0800, Tao Cui wrote:

> +static struct bpf_struct_ops bpf_iocost_model_ops = {
> +	.verifier_ops = &bpf_iocost_verifier_ops,
> +	.init = bpf_iocost_model_init,
> +	.init_member = bpf_iocost_init_member,

Please add a .check_member callback rejecting sleepable programs. The
generic verifier permits sleepable struct_ops programs, so a model can
currently call bpf_copy_from_user() while iocost_bpf_calc_cost() holds
rcu_read_lock().

Thanks.

-- 
tejun
