Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F6F26FD97;
	Sun, 13 Sep 2026 15:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789314493; cv=none; b=IuwQjDv+1DRvN3WAtdHMj7cbNA7f4ONRsR6F+WN66ixgaargAneqRqao0YT6Nfkuem6pbyvth8PgvDTKLDVOZ3sSD5dG0QTfugXHAHNTWjnM78HgAwQtz9nGltARUQo3AZzYm0ZxzdaXCrCYMZQJ3+7JCgH1G4U8zqfrzkjyszI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789314493; c=relaxed/simple;
	bh=P+a3p/+lviu3Vae+u11I/8ybHXcW/ldxcrbeMBsSRzI=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=GXKQp51oLEUuFIMS/BEw7tPp2oHrq1f7uQo+qDvYW9TH1dRs6VwB6EugtA/vFGWjkmSUZcKrYgvmNQuWf3+0/AEVo+OPcUscrtoqoVIE/h83VeAF46R3zqC4b9B+qlO3Hf5vggk+KhWyBq3ObQOcSzmDJ6ZSBPK9udwWY6IdjIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YN0MKBiN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YN0MKBiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD701F000FF;
	Sun, 13 Sep 2026 15:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789314491;
	bh=CAGATFrGjpOdjdzUWpav8LQXEkXQtN7HhfR1h1EQFfQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YN0MKBiN+C7HzmSBLfKYjsR26sJjS8t4zc4Bu3LioLMPeP5xNJknXDpllqCIT/5bl
	 keReoClozwAGEAr6PDecz6gZCSv5JU9kFYSNKpfVK51MciopDToVO/0jsZD34ovmtF
	 cg/VZuqQUPIFN9MWwPx9NqoxO9QiBPq6xhXOU0xwqIY/+GSE9dAM11fa1dt4Mqvw+w
	 8OfIx9TECTA4vSIqfyXxeQjsE+XSOmmQcVM3O4ILGlHdhMZz505XRNeaRZwiAMVIp+
	 /D6MKxdmESSARpbccb5HpRi9J2ljsmtDftlS409MK+SdQXkz6b2LcVXDbvwN54LunY
	 MU+R+qrmBia4A==
Date: Sun, 13 Sep 2026 05:48:10 -1000
Message-ID: <9d772dcc9c7331c239c8cb513331b399@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>,
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>,
 Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com
Cc: cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup/dmem: Fix eviction helper reference in
 dmem_cgroup_try_charge()
In-Reply-To: <20260911220833.6958-1-kmehltretter@gmail.com>
References: <20260911220833.6958-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.4 with the comment rewrapped.

Thanks.
-- 
tejun
