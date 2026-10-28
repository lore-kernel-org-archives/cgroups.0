Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793218170;
	b=Dn/vkiQtRqk1NwG1B+EEq8YZRJylmodEg6zVtPceww5Mb2UKZEkxQylnL5cf/jIqD2Ep
	 4+N2syeFELGJQSqHqOs3+Xriw1//N7r7+TKQrGCR8rj361sOgufBXKLn6Cb+lEe+OjBUR
	 U6X8YIbxXPCJkCw8f2Kek5aBTG/AmEKPLQCtKnrVcsbnc/06+bo/JKzG/jKI30Bv9N/ka
	 dwSaTKsLrrXizsslbHftY3kTsGw87tXg/vF3pT+yEBwPgqL2ldI+gGzGb7ulBWXWUXd9O
	 qO1etKMrnAOGB+c6S1Fa/HaYn0Qcb/bA/aBrfZ4mA6hRUh1THRQrn6LKKHZe4Tvw4mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793218170;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=A0SoP+W2Ylzai32YncZqgehMd2spWJOL4Ra8zJeBLMc=;
	b=O8k1Cad0vc9VyfZrnsADeq2Oi+YxRmr15eyPSXYb89yeyHrsdWCzFX/Ttd+bc/MSt44d
	 PaNpA4ySY+TCIAE1nOm9xhgfNrqm0SsxCe/gQ2CngDZUJc9FZA1XGyRnedAMZ6j+3oZgc
	 0T/7yKxygNDQPrqQO5Lb0ienHikaqWL4vanRLS0H9aE+iIRAJgjK+rqoj+wg8xuXR8Yqr
	 ncnX1OQxzS1xYWjzqORydDZ+4ebi3FNR+cWDqUMQqRNK8f3icZt5eQvndEHkp2dmznuPC
	 evlzAX6VKxCSYykw3nuXDKl7QGi9neVyhitWJnj4wfVjRbDsSFnMUva2rzw+XiZotLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F06060A2631;
	Wed, 28 Oct 2026 20:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CAC1F031E2;
	Wed, 28 Oct 2026 20:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218170;
	bh=A0SoP+W2Ylzai32YncZqgehMd2spWJOL4Ra8zJeBLMc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VGy58csZN31r8aoABGjrMS2S8VmwRqqyzOjc+yh6KtZj6Qb5kvGENOJfz5MKyZac0
	 +96HIAVZJAFeZJ6zoZU3i7udNRXHp9sPOPWd5mK/M7XTWKpC+Ov/TW51gu6uX0u0IQ
	 gQBxNRU9IeP3Phe59HrsUBj+npbiuTycUJfFW20GyKRX0Tb0kA5CPekQhaFIb+HyMG
	 9HVfO+hC9fwiOQOjBUwa1Dx4vQ8qFfvyNYKtXKhPy95ScSfQliyU1ihruvcsCNbm3g
	 A4KrSsQBbSYXVmop1yhEEaDOue97Hz3deALG4jRfiyVOkczASwgmF22h4u5DbtRXsV
	 kOGE0Mk3Fi6yw==
Date: Wed, 28 Oct 2026 10:09:29 -1000
Message-ID: <b69d96a507aec382c279d62cfb038fa9@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org, cuitao@kylinos.cn, ameryhung@gmail.com, alexei.starovoitov@gmail.com
Subject: Re: [PATCH 3/5] selftests/bpf: add iocost cost model test
In-Reply-To: <20261028143534.135968-4-cui.tao@linux.dev>
References: <20261028143534.135968-1-cui.tao@linux.dev> <20261028143534.135968-4-cui.tao@linux.dev>
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

Hello, Tao.

On Wed, Oct 28, 2026 at 10:35:32PM +0800, Tao Cui wrote:
> +static bool iocost_bpf_supported(void)
> +{
> +	FILE *f;
> +	char line[128];
> +	bool any = false, on = false;
> ...
> +		if (strstr(line, "CONFIG_"))
> +			any = true;
> ...
> +	return on;

any is set but never read, so every test skips without /proc/config.gz.

> +	/* isolate the configfs and cgroup mounts from the host */
> +	if (unshare(CLONE_NEWNS)) {

unshare(CLONE_NEWNS) alone doesn't make the mounts private, so the
configfs mount propagates to the host, one more per test.

> +	ASSERT_OK(configfs_write("/sys/fs/cgroup/cgroup.subtree_control",
> +				 "+io"), "subtree_io");
> +	if (!ASSERT_OK(cgroup_mkdir("/sys/fs/cgroup/iocost_pairing"),

The "+io" write to the root cgroup's cgroup.subtree_control is never
reverted, the cgroups are created directly under /sys/fs/cgroup and
test_progs stays in the root cgroup. cgroup_helpers handles all of this.

> +	err = iocost_model__attach(skel);
> +	if (err == -EOPNOTSUPP || err == -ENODEV) {
> ...
> +		test__skip();

-ENODEV and -EOPNOTSUPP from attaching to the test's own null_blk device
are failures, not skips. The same goes for
serial_test_iocost_model_streams().

> +		ASSERT_GT(skel->bss->iocg_inits, 0, "pair_init");

This passes on the root blkg alone, so it doesn't show that the test
cgroup got iocg_init(). The same goes for eject_had_inits and
pair_init_again.

> +		/*
> +		 * detach implicitly by closing the link fd instead of
> +		 * calling bpf_link__destroy() explicitly: the release
> +		 * path must detach the model just like the explicit
> +		 * call does
> +		 */
> +		lfd = bpf_link__fd(skel->links.iocost_2x);
> +		bpf_link__disconnect(skel->links.iocost_2x);
> +		close(lfd);
> +		skel->links.iocost_2x = NULL;

This leaks libbpf's link struct. The reason in the comment doesn't hold
either. bpf_link__destroy() on a struct_ops link does the same close().

> +void serial_test_iocost_model_streams(void)
> ...
> +	if (ASSERT_OK(err, "attach")) {
> +		err = readback_model(dev, model, sizeof(model));
> +		if (ASSERT_OK(err, "readback"))
> +			ASSERT_STREQ(model, "bpf", "model_bpf");
> +
> +		bpf_link__destroy(skel->links.iocost_ms);

The test never enables the controller, so iocost_ms's calc_cost() never
runs. The multi-stream results in the cover letter aren't exercised by
the test.

Thanks.

--
tejun
