Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201612;
	b=XcEev5z4icnxQdfmipPfL7zelk281fhKt/dMpDTIoGj0kEKfM+T5VboV3I07eMyUff2n
	 pH9llUXrd/eAatyOUC32c/KVCGUdQYpJs58oKgLjzDYHLOSrFAVWPqdmbQ3DW22k3gZDa
	 4zokQy0m0Oil3Vienq5oAyeMKxF8MHE4cgx9D2KK+kZ7M6rRsb1vSae1uJTApNJiASDuh
	 xSJb/M7ooD2i4rNp6BkUYDxrAahnZlbt5Maxa6f1ceih87cG/5FuthcIXjxv7j2Ulg4Za
	 lPZJkLMjFXpcICnNR1LyfKlxRPBocQ4DfhxTBtC3P/1mHOQYmYqlNHFcBl/uRuMZp0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201612;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=Sc6OK2gaP5PHJJL+FHAqB8O3d7CSsEQRTSfxIIRDKaA=;
	b=plVMsBHuAO6KMRV0KFx5yEL7afRHNBFgXw8Vg0ZkiUCCnfwdFcqf7EBzbfhPOYPnmZwf
	 8sd42g/hD/BPWSR+h4c5aXuWawtlLVwHIj5j847L3TpRYI736J8JR+dxPJd5+6D2yveO8
	 NWYlYNXhcV4zmkqZSdaBo1n/e3C0QgIlQO7//iZGq/xvDeRd30K/3ELfiriK2REldqP9f
	 4XWqKd+Pj8eGI7b0l1+smlhi/lBeqhk9aATFjSb6uQ4YAFJswXUe2HHFxVAMBAWamRt5c
	 kA822nND64EwciiNSLDXASPotfDyzZQUI5hXNUGuc55R1map8Fbjw8npuPRTurTkxgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DuvAgA6i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085D8606A31A;
	Wed, 28 Oct 2026 15:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DuvAgA6i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AE61F01825;
	Wed, 28 Oct 2026 15:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793201611;
	bh=Sc6OK2gaP5PHJJL+FHAqB8O3d7CSsEQRTSfxIIRDKaA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=DuvAgA6isxh7sOCl6pmimmq5UMQ3yHst6k3mAnooGpLlX5GSth0mRCqtpLusVny2P
	 OqMnW9qDwC4bmOsg+7NBX5W7JEL+IO5W1SU40Lig/PVE7TMiLCbiQDX2f8IeN1aKrV
	 NEJpt2rkI0v10RdLBOiCvFDFN9JwqXeXhNcu2C6iZ4Ykp6+CJf73mJsN2rLMW9yeCw
	 d8qqr76kCfpeiNAxmhtfkQAUHpTml6HD/WJbt/M/5f7od8ySY/HfAm16e444qSBLda
	 f68tou3HNUIjsCPdBn8FcwKTOWmIBfx3OxqCSTo+g6HZPpse7QLWkatl8DvyVj0e+2
	 JwcVzaqKy8zww==
Content-Type: multipart/mixed; boundary="===============5448043565086908133=="
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <6e0cec7622bf79c97ff108b4c1499e28b0109ecc8fa9cc8f72cb3c4f1ba47ee8@mail.kernel.org>
In-Reply-To: <20261028143534.135968-4-cui.tao@linux.dev>
References: <20261028143534.135968-4-cui.tao@linux.dev>
Subject: Re: [PATCH 3/5] selftests/bpf: add iocost cost model test
From: bot+bpf-ci@kernel.org
To: cui.tao@linux.dev,tj@kernel.org,josef@toxicopanda.com,axboe@kernel.dk
Cc: cgroups@vger.kernel.org,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,ast@kernel.org,daniel@iogearbox.net,linux-kselftest@vger.kernel.org,cui.tao@linux.dev,cuitao@kylinos.cn,ameryhung@gmail.com,alexei.starovoitov@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 28 Oct 2026 15:33:31 +0000 (UTC)

--===============5448043565086908133==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/bpf: add iocost cost model test

TL;DR: Nit only: in the iocost_model selftest, the comment before the final
"pair_balanced_again" assertion describes the re-attach init check, not the
detach-time init/free pairing it actually tests.

> diff --git a/tools/testing/selftests/bpf/prog_tests/iocost_model.c b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
> new file mode 100644
> index 000000000000..5373d52d93a6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
> @@ -0,0 +1,806 @@

[ ... ]

> +void serial_test_iocost_model_removal(void)
> +{

[ ... ]

> +	err = iocost_model__attach(skel2);
> +	if (!ASSERT_OK(err, "attach_again"))
> +		goto out2;
> +
> +	err = readback_model(dev, model, sizeof(model));
> +	if (ASSERT_OK(err, "readback_again"))
> +		ASSERT_STREQ(model, "bpf", "model_bpf_again");
> +	ASSERT_GT(skel2->bss->iocg_inits, 0, "pair_init_again");
> +
> +	bpf_link__destroy(skel2->links.iocost_2x);
> +	skel2->links.iocost_2x = NULL;
> +
> +	err = readback_model(dev, model, sizeof(model));
> +	if (ASSERT_OK(err, "readback_after_detach_again"))
> +		ASSERT_STREQ(model, "linear", "model_linear_again");
> +
> +	/* the re-attach walk delivered init for the recreated device */
> +	ASSERT_EQ(skel2->bss->iocg_frees, skel2->bss->iocg_inits,
> +		  "pair_balanced_again");

This isn't a bug, but the comment above the final assertion doesn't seem to
describe the check below it.

The comment says "the re-attach walk delivered init for the recreated
device", while the assertion that follows compares iocg_frees against
iocg_inits after bpf_link__destroy(), which is the detach walk delivering a
matching iocg_free() for every iocg_init().  The init side is the
ASSERT_GT(skel2->bss->iocg_inits, 0, "pair_init_again") check a few lines
earlier, right after the attach.

Should this comment sit next to the "pair_init_again" check, or say that the
detach walk paired every init with a free?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/40710751825
--===============5448043565086908133==--
