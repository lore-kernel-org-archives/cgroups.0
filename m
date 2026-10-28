Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793218166;
	b=M+tWUfp6MypLCI5anve72X93Z4/NrU4kYjy98ty60D1GmKm4sI1DVQZFxJyCZerA2a1H
	 ECb07AMLpweZkXpa4qrX7MKZyOLVmwovbyTgPImo4Wc2RAMUXpjW4euD8b/sxSTdIsz6r
	 Mlg45qSo2EWfc1Pg8yU0N9uI2Qa/bXBPEtNrsWoxLQRJDAHoRtaz7Jc8+6esDg6cf5esj
	 v5vnVJD0Di0Dm+8441v347i/LbKNB3Xe6R3spgu65QjvcvhiSaGOLuR+5FdrvNOojUotn
	 A8X2bwOMkCjB1Vv95dZGMK6lbGaQVJk5exouMEgYCu4q6WW60KpGTpr7Ix9DYcktWDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793218166;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=rv05BjY0ynfB1fZvqPZHZs25gh6uMj3bUtTMjGnSWL0=;
	b=SLIom3XHxSxbGztM3KfIpviZtVHbOA7hPfSQm/o/OQ+narE49tBxmF0bJL3w0g8rQ+H1
	 YQj+iNTp4ubbjBp7FTGQCVY4RATUPsZsLUlHNk3MzQi8uJ9EbS/6AR8CgRFq5F8TTXdPn
	 ma+hNuAMgtlWuC9ZSG3zC5wB0FQYsr7gFMVr0Soj2kdx3ruRWuViIm+O7cXxXH1BOEtbj
	 6k5FmIOsnHBQelIVt6ZOMHyXFI2/6zuBHIAZPmVnFvgS6APvPLKyphKBwTeTYATazjevE
	 LI7e2+j/ffsjQ7k5OeghYs9imRymSyEK93ZDrdmBw8fFB68q9zsk4BdAqaFKCSaVE2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Vqxx/cuA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BF9606A31A;
	Wed, 28 Oct 2026 20:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vqxx/cuA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891951F01825;
	Wed, 28 Oct 2026 20:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218165;
	bh=rv05BjY0ynfB1fZvqPZHZs25gh6uMj3bUtTMjGnSWL0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Vqxx/cuA/x+fNPePqIugz+skwMlBbUblVuHoUsyjPJNoa7lLLUvmyvjUt+AQZcSL8
	 107IEJt6ptiTq7GHmpdhNULATmKXAKHvc6eZ9K3vvIYyOf1jhcfwHt5SpsJ5O3NVdd
	 hiGYjh0Py+AFsrMrunZeKHoNOnffqD8mpqySVsYrjP0G5TDAgBioaHDxg04diea94p
	 APfCe/qVOSYzkJrvqHfZY09qKEumOoqbDz38YJ1uAz5+jC+IoSohBTs0xGucMuFfc2
	 3gUP+Al23Vq494fJExzl385eDbbRgHBT6nyJMeerlBA6MLzWPVVurEBNKnt2NJZZEN
	 PvKxkBZ90IJNw==
Date: Wed, 28 Oct 2026 10:09:24 -1000
Message-ID: <046eabc08a80c27d17581a3ff591c70b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, daniel@iogearbox.net, linux-kselftest@vger.kernel.org, cuitao@kylinos.cn, ameryhung@gmail.com
Subject: Re: [RFC PATCH v11 0/5] blk-iocost: BPF struct_ops cost model
In-Reply-To: <DMGLGKYOLXFA.12EJEMVN58Y5P@gmail.com>
References: <20261028143534.135968-1-cui.tao@linux.dev> <DMGLGKYOLXFA.12EJEMVN58Y5P@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Alexei.

On Wed, Oct 28, 2026 at 03:58:57PM +0000, Alexei Starovoitov wrote:
> Lets drop them. A struct_ops can get new members later, when a model
> needs them.
> I'd like to hear from Tejun whether such a model is planned.

The callbacks would only be worth having if they could do something
calc_cost() can't, e.g. sleep, but I forgot that pd allocations are
opportunistic to begin with. A blkg and its pds are created on the bio
path under queue_lock with GFP_NOWAIT, so iocg_init() can't sleep
either. Agreed, let's drop them.

> ...
> calc_cost() runs under rcu_read_lock(). bpf_map_put() frees a struct_ops
> map after an RCU gp. So detach doesn't need to freeze the queue.
> The rest fits into blk-iocost.c and patch 1 is not needed.

Agreed on both.

Thanks.

--
tejun
