Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794961382;
	b=uFP58sTFC7istJ6Fhtg5msNfwaoZ9PiqT7K2b2CP5a4InCcA7JOIqLr/QnyeKGA1Cugf
	 quVlxXrgp7575pc4VvLnEVFYWHAVV/1o0FmtccBYA2NF9m4IhcTyoFDmgDC9Mc3Aj90LM
	 fgHWdXZR8AQsx3p2rOLuqlTP+XtTENKaA6XrsnkDBogOrvWq6IWuXB98xYwZF+i+iiLFx
	 a9q2iTxOszr6twMqmnQlbeu0XHznY7Jt2CFrX6Wq5Dkj2kCvfuFRS4R62UDEPZaY+eYnz
	 QdWJqtghdQOyFpPxY3134fQvuBLy2B/6u5O4IXD1HLLwzssPCIYHdPPYBMEnigmHjLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794961382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=oy0tZArTQ8iY4s0PSPsEHwXzkcjVeEK/EWogk8QKuFE=;
	b=AH1CfGUP2InEZXhcto9rP14myKryyFJVMDrFQ29l/jD3dJRbVZDhY+dmBJ/HkBI1//bf
	 ryb9PUe3UIX4YfxCia95+z2uaNKoQmEW259d4rKg+qb+57c/bjXEZNEwcO3ZSjekgg1kG
	 E+j9N9Ogkd3BSLpJHkPyO4t/V1qZMAX2hrntmeSI5KMnEQ00UVQ7HdFMj3X34PtQ+FWTJ
	 LJ8ZI2HHb6INqlStluwL/McelrD0WagDcnWpWlF9J/PHbMZcY++mwkGLsfpn71KpdOr7a
	 0iiRoMcPgtUsjd2GxjGjONgrv8tLUt1W4iN0eYYkCUsXjIFAZj9PKJyX64jfUhJZB9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N6Kadfqw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AC8606A31C;
	Wed, 18 Nov 2026 00:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N6Kadfqw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA821F000C7;
	Wed, 18 Nov 2026 00:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794961382;
	bh=oy0tZArTQ8iY4s0PSPsEHwXzkcjVeEK/EWogk8QKuFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N6Kadfqwpfv/pGQ0wbQSrHki8QAA64Obzd0jDazYYcjyw3uObaNDeGJZ8ROsf/nsP
	 Hpciy6rJer6vdiu4lHcMEIuI80nSElpixOVVuWs5ZnCXASv50e1esRo8TqIv6ASzzX
	 J0NS/reN/W1//y0rkWMm39Cxzf2zNhx6IUa82lH8oOU3XxW41Y8+F6Zr6+PCljEdpD
	 fJIWZGXa4WUnim/G2nyYrqjKfd/4faIsmEm+aAIL3uwFGzKI8nz77SFJPs2e3UcUbX
	 rCXUuUDGZmshyVMIlwLyE6mxXPL4uhj7BL4sGzwF1r8MSIipjQpTsxn0s4aSKysA5Q
	 s1YYIGy501r0g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Tejun Heo <tj@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	reinette.chatre@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	rafael@kernel.org,
	dakr@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	shuah@kernel.org,
	jolsa@kernel.org,
	alan.maguire@oracle.com,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Christian Loehle <christian.loehle@arm.com>
Subject: Re: [PATCH AUTOSEL 6.12 486/486] kernfs: Use RCU to access kernfs_node::parent.
Date: Tue, 17 Nov 2026 19:22:57 -0500
Message-ID: <2026-11-17-1-daily-reply-0006@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <c6918c4e-060a-4968-a43a-1b1cbdafd27b@arm.com>
References: <c6918c4e-060a-4968-a43a-1b1cbdafd27b@arm.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20261118002257.8J0Hx6m5tGzALTBeIGOqKbPOrAmprGTL6yIh9GottK4@z>

> Sorry, my bad, this should've been to ::name, later in the series.
> Here's a lockdep:

Thanks for the splat. The fix for it is not one patch but the whole kernfs RCU
series, from 400188ae361a ("kernfs: Acquire kernfs_rwsem in
kernfs_notify_workfn().") through 741c10b096bc ("kernfs: Use RCU to access
kernfs_node::name."), plus its follow-ups. None of it is tagged for stable, and
one follow-up, 6034974e3aec ("kernfs: take kernfs_rename_lock for same-parent
renames too"), is not in 7.3 or 6.18 yet.

That is too invasive for 6.12 for a lockdep report, so I'm not queueing it. A
tested backport of the series would be considered.

-- 
Thanks,
Sasha
