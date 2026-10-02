Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9001A342C80;
	Fri,  2 Oct 2026 18:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790966350; cv=none; b=qheV/kFli4/oFDbAeTMqxMpUjMVAphqPkRgc6sDpR19vaIQv/Z05knZjlluDYM6sKDafLP09HSPBclZeIj2HWnMH+2uWYYKbwE2ZNMgMbDs+YVuq/xkiu5o9wsMv62oDpPJuFO7oOaOn2vth1vuQGzveAviII9UehG3enTrzuYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790966350; c=relaxed/simple;
	bh=0UDRBfmhI0tAjUkuyTfjPYv6VlXpVARAoUfgLbuSjr8=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cfc2iydpNnVKqH0qv3h2fIJWUoUMRAy2tL+U5fwdUr/PYChcLR8gS06kjPI7lTeKruJAuCP7fghBeRvx/w3Ey0cfQsSBK9GmHBn1PljDCAdH8f7JqyPFsihqKonUTl3EUrx2zaDbXsdQZklL/ltG9OuctLnSZlPORQwtpxPOzCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LHlmoXQK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LHlmoXQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C801F000FF;
	Fri,  2 Oct 2026 18:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790966349;
	bh=YnmYqM14oidyo+alFbzDt4rEXRQW1eTvKWOsfdzLCNo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LHlmoXQKeZDUMe4HTP+HQL4C1Fx9GohPKAP3uFK0SbiDkkD9waMVV8H8BoJoQPfcE
	 3KmPU9cfZX72EopYhLk0FpcvPkbkGNsmvmuzv8120vxX/mV4C52D8bgP/JYGkjxv+T
	 iiC69hgwa21nMeqUjDPL1m7CE+UK1lHYwD2oI6hAdv2Jm2SOWdm9kLQAlbgROQ5DuJ
	 AWVlwZ3VHex/NXowheEJ7ZmPKWFfA+fllD1SaiBBrfdA6S3N3t1NOsoCUNwOaC5vVW
	 w8rVepQe1FdY+2cQvKHK9mmWd/QQZ60F0RIWtMxDsEVqRXUpLTbM9W1k5CeiI6XkkQ
	 XSZZ//mw/iCZA==
Date: Fri, 02 Oct 2026 08:39:08 -1000
Message-ID: <17a3acfd8b57e96b03dab38fc44a7031@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cgroup/cpuset: Handle cpu hotplug race in
 guarantee_active_cpus()
In-Reply-To: <20261002165438.951550-1-longman@redhat.com>
References: <20261002165438.951550-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On Fri, Oct 02, 2026 at 12:54:38PM -0400, Waiman Long wrote:
> With commit 2125c0034c5d ("cgroup/cpuset: Make cpuset hotplug processing
> synchronous"), the cpuset hotplug operation becomes synchronous. That
> commit also removes the code that handles race between cpuset_hotplug_work
> and cpu hotplug notifier with the assumption that race is now gone.
> Later commit 7a0aabd9ce69 ("cgroup/cpuset: Always use cpu_active_mask")
> updates the cpuset code to always use cpu_active_mask instead of
> cpu_ohline_mask in some places including guarantee_online_cpus() which
> is renamed to guarantee_active_cpus() in that commit.

Applied to cgroup/for-7.3-fixes with two typos fixed and the following tag
added:

  Cc: stable@vger.kernel.org # v6.16+

Thanks.

--
tejun
