Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7532D3D9025;
	Tue, 29 Sep 2026 16:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790700171; cv=none; b=MTrpSshMe3m2xKZXkfTrdyeGNuYrhOTwy5ZPXuOHhXA6kTt/6US7nSaZAnvyJqw0ZBU6iiw+gaBYvyJAWJQxaaTx3MXNFXKjfRFS9lj4+qlo6TExLYXYrppM727ufowk6Blc+EGza3rAJzP4U1jofRzoe1wQcNPfWHlcXU5X6xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790700171; c=relaxed/simple;
	bh=PJTmzlkWnb+w88GrJxMt3YvCO0j2DpPdLmhH+hCDH70=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fyMoiM5Dehgxpn0v5UAsEHP3jftuPOv+DCauaUiqx5cySORys12ICpJjvLQVEbZAvpr+BbA2hyt/U5NL6BM1IcP37O68h2LGcvQwf1eBdEO1eFDAIWc6NzZSuQDrEZfDi85gT4SNHNVLni/BorVYZHI9GPhh2tYoWnz0SzZjtbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g13IqXb+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g13IqXb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25881F000FF;
	Tue, 29 Sep 2026 16:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790700170;
	bh=PJTmzlkWnb+w88GrJxMt3YvCO0j2DpPdLmhH+hCDH70=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=g13IqXb+hBCDavcvf9ZB7xrzN9NTHXrTTPEe96CQ1AAlB6I4qYe/3gYwf6dstDXe4
	 5CHjTAv7jBVyjszTne9boZ2F8MCPPHWY13+fALjG/JEhoIdRgFXr83twGlPd8tsGdr
	 8LuwWC6XngVfIVdSdKIrSblXWKLVQmERcDf+BIIT/a9Xcpr3XFOz0F0jMzMHgfEtr6
	 W7fWKDfrrhrX7+HbjiSz0iP/VggiA/Xld24WvDbiExL9JVqngiY3EQLUb/FB2V5iLj
	 XVqDmqN627QRK58qN3QfwALmMCtzHbac+ZWAE+Dc0tScRdyXwpYYebTuLdpG2bYcuH
	 iGFvro42V/Veg==
Date: Tue, 29 Sep 2026 06:42:49 -1000
Message-ID: <95e04dc55645c84c033ccca1a1359d84@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Hui Peng <benquike@gmail.com>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup/cpuset: Properly disable partition when
 partition state switching fails
In-Reply-To: <5e658521-1d8f-47bd-87a2-809a79a10186@linux.dev>
References: <20260928235159.515654-1-longman@redhat.com>
 <941e5affde16b803741ddaf87b937f3d@kernel.org>
 <07403332-9fc3-41cf-ba2c-63a1f83a231c@redhat.com>
 <5e658521-1d8f-47bd-87a2-809a79a10186@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello,

On Tue, Sep 29, 2026 at 03:40:27PM +0800, Guopeng Zhang wrote:
> However, after the parent is created, the ownership of full housekeeping
> CPUs can still change, so passing the check at creation time doesn't seem
> to guarantee that returning CPUs later is still safe.

I think any CPU under an isolated partition should count as isolated when
testing whether the system has a housekeeping CPU left, whether child
partitions carved some out or not. Those CPUs go back to the isolated
parent whenever the child partition is disabled or invalidated, so they
can't be counted on for housekeeping. In your example, making C isolated
would then fail.

Thanks.

--
tejun
