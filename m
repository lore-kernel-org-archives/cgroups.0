Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795009747;
	b=lji9x8VrleceZF2xv97ZaR3voEW+6drIV5muDEOTsfs8uF/URmTiQsyzJ8xnMKreyhF3
	 rG1/i2q7UBP8T6o7QVlwpq4JwvFyxEOCqN2m81n61KvwBojTHvE02KESrevDbO0WuE134
	 m90ItUtatd0el+rdkIj2/sfLBof9wESPmBZGwP3dneDoq5IpKe8Xql4rDmIPAbI0GuTXz
	 AvFgUs71c86tB/oI/8Yms7kJuLWQ7u8WtZlG+6M2UWUCCHt+WKFgbneqH5By9qiTBMQCD
	 B/mD7ytGv6OWIhtCTXG1L2EebrcBG3BHaVXnDI+MhY7VKU3a4fsBRudjIVSdBfUzmhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795009747;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=Lf9IjcA2+oZMwxII2T5OD9H6hKAKYAUPWKlQiPhHjMg=;
	b=hxVrvi6/zNsM8VAVay0H2KGYA8HMMfJVfTpyjtpSSk9ksOjaYp0vTCGNk4wmxReFFuz1
	 uYWplrOGgF+3CoPBHvjc3cgXx+TSi2P8GQ451RF6GnxxsLSkxFdAd5XQHlbVi/UH0s7ei
	 rtSFTAA6eTPMWHAwfa6sizSCpziaEn/pCvVz8TRKO4JxnDZZuEMH4UHsGZ9ppzC/fIU4m
	 P4I7IlHf5D/MjM3uzG35VO0Ijxmu1o8szlncR4wTt6sCS4AYwzIl7IQyIOng5fHItTF8s
	 GJrYbyWVAj9TAlcFhxkOm0twVqzHtPa6poAHKT3SRz7voDWIW5QS7JEpILrBK37OKRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CoLY0off;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35010606A33F;
	Wed, 18 Nov 2026 13:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CoLY0off
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CFD1F000CB;
	Wed, 18 Nov 2026 13:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795009747;
	bh=Lf9IjcA2+oZMwxII2T5OD9H6hKAKYAUPWKlQiPhHjMg=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=CoLY0offtUoehSU0pfUjtBAVA181JYa2POkTHHcFfM5OZa2QqBkjiINTqBnP6IYT1
	 S0oTZF5X6GGrn6PlyKl/OiPoMp9jhlTgKOn7Rz1E1z6DrW3ce99hAkhlFcK46x5X7z
	 5Eq+er2X6Py1mHOGaqfj09HG41fVTCgcvrt3Mvla1rT+4uAI8xgY6DLqXiJmIVQZRN
	 vg+kUVRDr8bTW1j9tSSB4Uxo4uTMY3OKDEvdvvAGV5QhL8wbqcRDB8hM2u10PKcsAF
	 uqLB6nEsbV4jDkyjUqiGmXXo4TI9YPai25yTPp74HfrkGDQ0aKfm7EIkDLugboK5mZ
	 cL5Ei7yRfijgg==
Content-Type: multipart/mixed; boundary="===============4220229775293101488=="
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <59496aca38bf7cf3d4d3e11d5ac32e144ae92bf9fa8b3d2420ae65464fea51df@mail.kernel.org>
In-Reply-To: <20261118131029.797007-4-cui.tao@linux.dev>
References: <20261118131029.797007-4-cui.tao@linux.dev>
Subject: Re: [RFC PATCH v14 3/4] selftests/bpf: add iocost cost model test
From: bot+bpf-ci@kernel.org
To: cui.tao@linux.dev,tj@kernel.org,josef@toxicopanda.com,axboe@kernel.dk,ast@kernel.org,alexei.starovoitov@gmail.com
Cc: cgroups@vger.kernel.org,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,daniel@iogearbox.net,linux-kselftest@vger.kernel.org,cui.tao@linux.dev,cuitao@kylinos.cn,ameryhung@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 18 Nov 2026 13:49:04 +0000 (UTC)

--===============4220229775293101488==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/bpf: add iocost cost model test

TL;DR: In the iocost selftest, the setns() unwind on the skip path may reset
test_progs' cwd to "/" (and possibly leave a chroot), so later unrelated tests
could fail with -ENOENT when null_blk is unavailable.

> diff --git a/tools/testing/selftests/bpf/prog_tests/iocost_model.c b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
> new file mode 100644
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/iocost_model.c

[ ... ]

> +static bool iocost_test_env(void)
> +{

[ ... ]

> +	/*
> +	 * Isolate the configfs and cgroup mounts from the host. A
> +	 * failed setup unwinds the namespace so that a later retry does
> +	 * not stack private namespaces.
> +	 */
> +	orig_ns = open("/proc/self/ns/mnt", O_RDONLY);
> +	if (unshare(CLONE_NEWNS) ||
> +	    mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL)) {
> +		printf("%s:SKIP:cannot make mounts private: %s\n",
> +		       __func__, strerror(errno));
> +		test__skip();
> +		goto out;
> +	}
> +	mkdir("/sys/kernel/config", 0755);
> +	(void)mount("none", "/sys/kernel/config", "configfs", 0, NULL);
> +	SYS_NOFAIL("modprobe null_blk nr_devices=0");
> +	if (access("/sys/kernel/config/nullb", W_OK)) {
> +		printf("%s:SKIP:needs null_blk with configfs support\n",
> +		       __func__);
> +		test__skip();
> +		goto out;
> +	}
> +
> +	ready = true;
> +	ok = true;
> +
> +out:
> +	if (orig_ns >= 0) {
> +		if (!ok)
> +			setns(orig_ns, CLONE_NEWNS);
> +		close(orig_ns);
> +	}
> +	return ok;
> +}

When a prerequisite check fails after unshare(CLONE_NEWNS), for example
when access("/sys/kernel/config/nullb", W_OK) fails because null_blk is
not built, not installed, or modprobe is missing, this goes back with
setns(orig_ns, CLONE_NEWNS).

Can this change the cwd of the test_progs process?  mntns_install() in
fs/namespace.c ends with:

	/* Update the pwd and root */
	set_fs_pwd(fs, &root);
	set_fs_root(fs, &root);

unshare() keeps the cwd, so only this skip path moves the process to "/".

The serial tests run in the test_progs main process, so the new cwd
persists for every test that runs afterwards.  Many of those open objects
by cwd-relative path, for example serial_test_kfree_skb() loading
"./test_pkt_access.bpf.o", select_reuseport.c opening
"test_select_reuseport_kern.bpf.o", and l4lb_all.c using "test_l4lb.bpf.o".
The flavored runners also lose the chdir() done by cd_flavor_subdir().

So on a kernel with the iocost BPF support but no usable null_blk, would
the iocost tests report SKIP and then unrelated tests fail with -ENOENT?
If test_progs runs inside a chroot, does the root reset also leave the
chroot?

The comment says the unwind exists "so that a later retry does not stack
private namespaces", but serial_test_iocost_model() and
serial_test_iocost_model_streams() call cgroup_setup_and_join(), and
setup_cgroup_environment() calls unshare(CLONE_NEWNS) every time, so
namespaces stack regardless.

Would it work to drop the setns() unwind and cache the failure in a
static, or to save the cwd with open(".", O_RDONLY | O_DIRECTORY) before
unshare() and fchdir() back to it after setns()?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44312765238
--===============4220229775293101488==--
