Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7611E471432;
	Wed, 30 Sep 2026 08:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790757915; cv=none; b=c06r4cmAoWS4oFpVySQfAh8jxVGl86aCCFreQ334IF3ml+iCmDuQ7ToJZVD8uRaz2PthZKXTGdN/TMrUM7r8vA9z35qbtxwAIQ7HFeCfEJpnS8cNbXsuR4xAQiRYcHOjIZNQeoHMHi01bjsGC+wkCHqc2vDL5wnc0FYR1nKfIh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790757915; c=relaxed/simple;
	bh=+xtx+T+y3RrRKTqC8Bf8SkRbgyyqyiqJI5xvwc6gtGU=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=X/U+p3Zxfxa7OahS0orI3JmP0Xj37qiLckj+b8JbBbRdFvBzAoehSgR3hcZpHz6Kby0R6JE6mZQF7q2wwFffarrCn6sx1sZ8BHxjLXs9/0m10WDeRURqmfXtyRlMxUByuxgItFmsFxtBQUlyhxKAtxTALPREiZrybuAxus3Kp74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LlqXmAPW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LlqXmAPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C661F000FF;
	Wed, 30 Sep 2026 08:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790757905;
	bh=arDYhxHpGG4MOLTb9VLYxs9bYjwV6esCnhBx9b/qxHs=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=LlqXmAPWub7bJ2s18Jgni9t8rZyX5fg6Eoppdh5lzZrOiHJ15zFibMPXPnb8/rE8m
	 tvuQZM8ZriEmMMvIpgPjJvWW+dE1DhnWGMUXtS5amNKLJgt45TmNN5/2GQU1nbbd+b
	 NMrUu8G7gZAVztaQTtalB5Ck11+q+SAXtGmBt8n61htXj8IBi/n2yIBol7UsTmaz74
	 LjaEsFtNwXlFWASq25ieB1sDYR8gFPM2M6She53J9fXsiPckztvuGws/8wyi/h1Ogl
	 Gb7gCestXo3tQd4ayOXIn6leHZgcqmZkRQaxilPHrilqbFrFf75+uvEnd9k2YdBkiX
	 t5t2S5YAgY2qA==
Content-Type: multipart/mixed; boundary="===============5156715475000709067=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <17920ecc726c484de4a46eb61ddbe63000838a799bdb87783f55c50ca743af94@mail.kernel.org>
In-Reply-To: <20260930075154.189958-5-cui.tao@linux.dev>
References: <20260930075154.189958-5-cui.tao@linux.dev>
Subject: Re: [RFC PATCH v8 4/4] docs: cgroup-v2: document the iocost BPF cost model attachment
From: bot+bpf-ci@kernel.org
To: cui.tao@linux.dev,tj@kernel.org,josef@toxicopanda.com,axboe@kernel.dk
Cc: cgroups@vger.kernel.org,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,ast@kernel.org,daniel@iogearbox.net,linux-kselftest@vger.kernel.org,cui.tao@linux.dev,cuitao@kylinos.cn,ameryhung@gmail.com,alexei.starovoitov@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 30 Sep 2026 08:45:04 +0000 (UTC)

--===============5156715475000709067==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> docs: cgroup-v2: document the iocost BPF cost model attachment

TL;DR: Commit message only: it claims the docs cover detach restoring the
builtin model and ctrl= never selecting a model, but the added text may not
say either; add a sentence or trim the message.

> docs: cgroup-v2: document the iocost BPF cost model attachment
>
> Document the BPF cost model attachment in the io.cost.model section
> of the cgroup v2 documentation: attaching an iocost_model_ops
> struct_ops to a device by its major:minor, the model=bpf readback
> while attached (ctrl keeps describing the coefficients), that
> detaching restores the builtin model, and that ctrl= writes never
> select a model.
>
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>

The commit message says the patch documents "that detaching restores the
builtin model, and that ctrl= writes never select a model".  Does the added
text actually cover both of those points?

The new paragraph says:

    only detaching removes the model, after which "model=bpf" fails.
    "ctrl" keeps describing the builtin coefficients, ...

It never says that the device goes back to the builtin model on detach,
although ioc_bpf_detach() clears ioc->model and the readback then shows
"linear".

It also never says that a ctrl= write cannot select the BPF model.  That
is what the code does:

block/blk-iocost.c:ioc_cost_model_write() {
    ...
    accepts only ctrl=auto and ctrl=user, and any other value takes
    'goto unlock' and returns -EINVAL
    ...
}

Could a sentence be added to the documentation saying that "ctrl" accepts
only "auto" or "user" and that detaching returns the device to the builtin
model?  Otherwise, could those two clauses be dropped from the commit
message?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/36689638400
--===============5156715475000709067==--
