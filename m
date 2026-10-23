Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792787192;
	b=EWf8QEO5azo/fyzDZqcXZ7DLi/xPE7N/nBCWNI8xkMeZ+gcsJew6AhDz5DV8gifewUm4
	 AlehMT95pVUAxKE44rLtjOE6B4jJHIBAJJB8bnTqtm42wbtgAbLHLvMCiTtHF/U0oXK4I
	 5tnHEebu+JAbQdX2oJsFouKgV3JNXwUo3VJs3GjVPU+5HOHOuMfPbD2WC+QCBESn6fEwJ
	 iMUzsSE/13B0Pke/UQmo6lXLh5Xh3K1nsb3noh3FKk0ETz0YZlSDcdE+n3WjwZROcF8/1
	 NmEpeqUR/OYfqv23XNT42LMpXU09GITBinVZyAiVL7L0prox7bKnIlCY2kwdoYfllqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792787192;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References;
	bh=bzWNPK46eAIw1eDkMclbdycEdK5XtHh8k+peej1q8aI=;
	b=r0RJ4a/2VjqpjKN16hSdkakSa+LD+L+jxBi7HDByZBcN8pEKUZtt+apm2f8R9QbCJb5f
	 OTcLTQ5fi1WNJ7y19NmQaTTJAuDFD88bsE8udDwi10lci4LDR5WxEbsrjExVoJGYSP2VW
	 vYtYTS5bx9QwWNACDGZpQ2soTkex6A2z0p1yPcHmOlg3iTPi7Jp9S8pUxPZboNOhO6+zq
	 zV6yCnj2mX4/5FfKRZ7W/ELHsBR/VWlHnQFAvg6jDgawWN9LkEesXhtJsozt/wVENNZYP
	 2qud/yOC10jD2Ri35Yk0/CpGxz0/0CR5ytSolX70ekEDHR/eDYDV9D5lYIW7lFMnXZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="oPSfs0y/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B4D606A31A;
	Fri, 23 Oct 2026 20:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oPSfs0y/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1181F01825;
	Fri, 23 Oct 2026 20:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792787191;
	bh=bzWNPK46eAIw1eDkMclbdycEdK5XtHh8k+peej1q8aI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=oPSfs0y/pqeNRUF77SVKj1Sa3k165FWzvtmwoGmp+VRfhKIDCXtXmYN+wG3XRxZat
	 /bWrDmgGc9Q1j6lp4AP7NC7x4og4mEK0+3Achlp8ThpPNzQvO1uJm7uJMRZhYmTfhR
	 uSwQI11tilgqgSZefXrydseTCbiIBPLF5cxL/QsDFVqtuLf/Kwg6gPxcUOUPrf1RQT
	 THGEyDWxkuRqBO/mJOXFqDoi1wNXcGaWONv8g2x/XE9pN59BfR9qH50fsTfMeLYfB9
	 S46IOMgr//zSopeugI5LhCt/DZ7wRG0WAsjN0Jjp7S380RzTFrwrxPnL60F5rIzMi+
	 5v0MOMW44ixnQ==
Date: Fri, 23 Oct 2026 10:26:30 -1000
Message-ID: <aee729fd53ef9c7c084a443216cfeb39@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Peng Yu <yupeng0921@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>, Keith Busch <kbusch@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>,
	Maurizio Lombardi <mlombard@arkamax.eu>, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9] nvmet: add cgroup_id to charge namespace I/O to a cgroup
In-Reply-To: <20261023043423.176002-1-yupeng0921@gmail.com>
References: <20261023043423.176002-1-yupeng0921@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

Hello, Peng.

On Thu, Oct 22, 2026 at 09:34:23PM -0700, Peng Yu wrote:
> +	/*
> +	 * The I/O commands of a namespace with a cgroup, except Reservation
> +	 * commands, are executed from ->blkcg_work on ->blkcg_wq, so the
> +	 * cgroup's throttling doesn't put a transport context to sleep.
> +	 */
> +	struct workqueue_struct	*blkcg_wq;
> +	struct llist_head	blkcg_reqs;
> +	struct work_struct	blkcg_work;

All commands of the namespace go through the single blkcg_work, so they
execute one at a time on one worker. Can't each command embed its own
work item and be queued on blkcg_wq instead? For an unbound workqueue,
max_active applies to the whole system, so blkcg_wq's max_active can
just be set to the number of CPUs. That would be simpler and might
remove the performance degradation too.

Thanks.

--
tejun
