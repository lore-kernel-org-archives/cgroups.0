Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9791DEFE7;
	Sat, 21 Feb 2026 17:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771696649; cv=none; b=kEp39czo4+Ryg3M5lt9cMvlAggU6QyPtFygCnhC1STtcIW7V0xa0GCpzdbubtWXRWLK21IAv84c5C7pfR4yfdx68Jo3OZ0ohf5rgor/MLJZM0QKu5mvWSG+jCPfw1hWAX9dy8eF2exWyXNi7K3mliNxwwaZN+Vu3CWP5erlu4NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771696649; c=relaxed/simple;
	bh=O+AE15WvIgEMw98m/o+ma1tw18+b69pKGmAY39S8DK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RaJ1z5PIIpWX2+AgKYL/JQtrfj20Z72Wxml7YPFLaPFE6XgUeQkABPjEXljLkRU0LzRgDSakpk73l6JDcvyzu6QSdZpBDiJpJY8C7eTPPcF2Fomp33fsQ2FtWeTMeej74NNHa/+ECun3GU32dWI0HFhtJLWOLC0Px7f6tqEiEgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dzZocsBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dzZocsBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7F3C19421;
	Sat, 21 Feb 2026 17:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771696649;
	bh=O+AE15WvIgEMw98m/o+ma1tw18+b69pKGmAY39S8DK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dzZocsBxfbp4aXPxn5bjx04RTNIbrWbHf+Rx8ogoZPljjhzaS2j+XrXePA2YehGLo
	 x24kGk6WfBoEhfHgYrtIvrcFMIDUyPijpZIdftnE2psUqpTJJwlRSTah0xfQRkrM8P
	 nwy3UeSzJgTFlK6fI2Gsk75D/Nby3o+7GhiMQa87o0vAdiNEnpfC0BP525XKuEPaag
	 dhov6yIGE+vG5ikPcl5yyfEsMIaI9k+UqLai423HZ5I99mHwSzTCiSKiAQWALzlHW3
	 qPItYd2tsC+BHlkQ2qZLGK4cYVtGcoMdtVxKdGB+Mcek7riXAX7lzs4axCbWb80Bih
	 NlGKgiOBo+qmQ==
Date: Sat, 21 Feb 2026 18:57:24 +0100
From: Christian Brauner <brauner@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH 2/4] cgroup: add bpf hook for attach
Message-ID: <20260221-salat-meiden-1283869d1038@brauner>
References: <20260220-work-bpf-namespace-v1-0-866207db7b83@kernel.org>
 <20260220-work-bpf-namespace-v1-2-866207db7b83@kernel.org>
 <aZh6vebjDcrccqNP@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aZh6vebjDcrccqNP@slm.duckdns.org>

On Fri, Feb 20, 2026 at 05:16:13AM -1000, Tejun Heo wrote:
> Hello,
> 
> On Fri, Feb 20, 2026 at 01:38:30AM +0100, Christian Brauner wrote:
> > Add a hook to manage attaching tasks to cgroup. I'm in the process of
> > adding various "universal truth" bpf programs to systemd that will make
> > use of this.
> > 
> > This has been a long-standing request (cf. [1] and [2]). It will allow us to
> > enforce cgroup migrations and ensure that services can never escape their
> > cgroups. This is just one of many use-cases.
> 
> >From cgroup POV, this looks fine to me but I'm curious whether something
> dumber would also work. With CLONE_INTO_CGROUP, cgroup migration isn't
> necessary at all. Would something dumber like a mount option disabling
> cgroup migrations completely work too or would that be too restrictive?

It would be too restrictive. I've played with various policies. For
example, a small set of tasks (like PID 1 or the session manager) are
allowed to move processes between cgroups (detectable via e.g., xattrs).
No other task is allowd. But that's already too restrictive because it
fscks over delegated subcgroups were tasks need to be moved around
(container managers etc.). IOW, any policy must be quite modular and
dynamic so a simple mount option wouldn't cover it.

As a sidenote, there would be other mount options that would be useful
but that currently aren't that easy to support/implement because of the
way cgroupfs (for historical reasons ofc) is architected where it shares
a single superblock.

I have a series (from quite some time ago) that makes cgroupfs truly
multi-instance. It would effectively behave just like tmpfs does. A new
mount gets you a new superblock. But once you have that you can e.g.,
simplify cgroup namespaces as well. I've done that work originally to
support idmapped mounts with cgroupfs but I can't find that branch
anymore.
