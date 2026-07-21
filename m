Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBAE33065C;
	Tue, 21 Jul 2026 13:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784639354; cv=none; b=Bl7B4jZ7NrVDoMto2prCZ47WIe2+1qMyalE0D/FgD54NnAJZTecmFBhopzSsRI4ArgWgUO0glPql59pGWRw8zl8+YTxLi2zRp8ltijzwtQLoRqzQUcL4YT0nJw4I8qWvPw78Nj9d2tECRZRqs19ETyFUbvIPCYjOOyfS442yF+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784639354; c=relaxed/simple;
	bh=v/dpsJ5BJG3kqd5+NSUMO0nVKTSMYcIkLfQ++H5Dwj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IQXpR6htLK84c+zbjVOzgPqSFSd3joIL2mLrIzvVKkV3af+3TB7X5ETQcbysoKI0X+1h3tzFwYT2KfFgoO+QX4aBLk56O6BJ1HPIoO8539L9fDz+RB+sxQXOkpLSvhMuLC9CANOPWJIbeVkF3cMEOtNYzr+OaHlTTpmloBmOckw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8vw7ZZJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8vw7ZZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67411F000E9;
	Tue, 21 Jul 2026 13:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784639353;
	bh=v/dpsJ5BJG3kqd5+NSUMO0nVKTSMYcIkLfQ++H5Dwj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K8vw7ZZJQT27H+zmyocexArEEiJaXnMcFYg6tPmb5X8E8UUpDVuXkg2q4uwZW4E2T
	 zcGaCeQKRlIvcBC7FpUJUGO1CDQXGgv31vupzd6LzBNzn7ASDCM6Ysk+JVEnjPIYzj
	 UZdhSi8nxjk5voQ6YhWwcXWkH3qt3keK/raD8vgE=
Date: Tue, 21 Jul 2026 15:09:04 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Philo Lu <lulie@linux.alibaba.com>
Cc: stable@vger.kernel.org, tj@kernel.org, hannes@cmpxchg.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	eadavis@qq.com, surenb@google.com, akpm@linux-foundation.org,
	dust.li@linux.alibaba.com
Subject: Re: [PATCH 6.6.y 0/2] sched/psi: fix race in pressure_write
 (CVE-2026-52991)
Message-ID: <2026072145-living-december-c5ac@gregkh>
References: <20260715084256.43412-1-lulie@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715084256.43412-1-lulie@linux.alibaba.com>

On Wed, Jul 15, 2026 at 04:42:54PM +0800, Philo Lu wrote:
> This patchset is same as that for 6.12.y.

Where is the 6.12.y version?

thanks,

greg k-h-
