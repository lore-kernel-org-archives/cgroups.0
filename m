Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C57F4E06D4;
	Thu, 24 Sep 2026 20:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790283293; cv=none; b=pdPlW2beQ99r8NoStAWT+WISiBQiHh3d2fKKapplCeSj5su4GQbckyB1/qIG25IBWAkn4PWMu4uyf97jfIoAUj3R0VCmzjfFuVRIphlVXTK7rtZJl0g1VJdUtus/ZsptnANwHg7HmjxAPkr4y9HLe1MtSvLqMwSkgGTLcJsk6z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790283293; c=relaxed/simple;
	bh=b1P+dpAJd4ilROWRR7JOoHU3ZN+/43f++yN0FOOmJOg=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date; b=OnCYDObDjTT/qWu4sK7wKb6bYNW/6FwuywoBWZxJG30eoGGpQnQwtVwW5QQj9h5TadH6sOHZ70h574KYln54eJu5StDGtNLfhEwvYGyw472uWwqWC3Sd0SZQRB9mzrApmjvl6niQOnwMVObVS4jdu63JSRMY9tpmhNhNk6Vnmyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pfp05dVs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pfp05dVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2151F000FF;
	Thu, 24 Sep 2026 20:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790283291;
	bh=b1P+dpAJd4ilROWRR7JOoHU3ZN+/43f++yN0FOOmJOg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Pfp05dVs/nLmYIwmmnLuU0LGKKQVgRhmPpAa63GrlYfezIpIa8MiknbvumacL5KHr
	 aD5LGT1J4G+sxM3szSR/SVopfWCk9palAi+9ftWzHPYV/uH9CiblGWpQd7TxEKR1BX
	 vp/0x2ADg47hr0O/G0zNYtjv5gs7y6BpIJr9bgsOBUirZosc0dkx/+2RXmdIDx4IhY
	 B3xZjK/CVoI+D+NVjl+Jj7rM1eLEJ0n0OxU/ySHWKH9VDSc1BLuDmCsoNAeS1hyV11
	 8kxiyhLyfmz9UTxzFfAPuFHBBLbvUzI4zlSxTaIgOeeJY01834C2XRexO3sZT2b613
	 VeiSrrWV5JUGQ==
Message-ID: <b54f443b33e1637e31a4db8d56c11a1c@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	brads@mainlining.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cgroup: prevent css_set UAF after namespace
 publication
In-Reply-To: <20260924111036.3330268-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260924111036.3330268-2-Jeremy.Jean@oss.cyber.gouv.fr>
Date: Thu, 24 Sep 2026 10:52:45 -1000
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Jeremy.

On Thu, Sep 24, 2026 at 11:10:37AM +0000, Jeremy Jean wrote:
> copy_cgroup_ns() sets the root of a new cgroup namespace to the parent's
> css_set. When the child is created in a different cgroup,
> cgroup_post_fork() replaces that root with the child's css_set after the
> namespace is visible.

Looks good to me.

Acked-by: Tejun Heo <tj@kernel.org>

Can you repost with the namespace maintainers cc'd (Christian Brauner and
the NAMESPACES entry in MAINTAINERS)? I'd like their acks too.

Thanks.

--
tejun
