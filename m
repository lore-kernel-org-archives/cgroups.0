Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3498318EE6;
	Mon, 29 Jun 2026 19:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782760367; cv=none; b=hEOz8q95OMKlSHsGfwO0B73rCNKhrsRJb3njnqLvxmwTjOZfP9ZyPcHehq5cB56lIAnZaGmj9xyvYky6HScix3tDgVUTPUop4HCS097MwrNXW4FT3vB20DyIzbA3RKfxWC/h1DyYdA8/7omkC2SbX50mrSlveTSLuFKMqQdEYfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782760367; c=relaxed/simple;
	bh=IgkyJKi60WXCmh17XYm05cccG/GD8qQaAxSY1ZxWgM8=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date; b=WJXwQ0GE/ZZXYDw2YwwUjiMMsv2aj0jJy6s6IYEq4UzjlZoZMHKOwuSIONeetSHYD+VcX/AeTfnYtGYzEPhoabbLr8uvcQZxY3uD/bf2VFZHq0Z3mZowMUp+A1MQequNhh+bXUUFi6u2pSUDsRI6UCmhx+zvyY3d+15GyDjFrBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X2GEgV22; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X2GEgV22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B7C1F000E9;
	Mon, 29 Jun 2026 19:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782760366;
	bh=IgkyJKi60WXCmh17XYm05cccG/GD8qQaAxSY1ZxWgM8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=X2GEgV22QI+a6k3Vo7JEMVxpjU6PbRhuZHnwhO7HsJmf2NCpgi/VJxo1Oa/kWnG9c
	 WGBTJgaQFyMnA8B4/KLydRYskWtAkT99x7p/77q6/AQvwlpgUKibqcPD6gOp9b5GFO
	 tWLbobLdfvYqSwaiDzGS8MyvPSTmJY8MQUN79Em5k/MpQv5tJsH9u38Z5WG9ykv2Wq
	 oHXK2FnYDlk9PccNmSGLVyKn0Fk8Rsy3U1207v9B+3dSzrSO/C87cV09WIZB+K1mUo
	 WC65UcSW14DBibIhR11gVlIfusLAG9OUitNjtx36TR2vvTJvAfoRFvMulYSCcsJv4N
	 HaUiKIylSsXng==
Message-ID: <34e0c59bcaf01412e85ca387c8f8b094@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Sun Shaojie <sunshaojie@kylinos.cn>
Cc: Michal Koutný <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	cui.tao@linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] cgroup/cpu: document cpu.stat.local and clarify
 cpu.stat behavior
In-Reply-To: <20260629060636.200118-1-sunshaojie@kylinos.cn>
References: <20260629060636.200118-1-sunshaojie@kylinos.cn>
Date: Mon, 29 Jun 2026 08:55:12 -1000
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.3.

Thanks.

--
tejun
