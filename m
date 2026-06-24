Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5836033263E;
	Wed, 24 Jun 2026 18:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782327582; cv=none; b=qlz+mMEsXtX6Q1wRYJhZfBJ/uFYBzlFtOOrhqTTO1xlX5JTEm3rZC5hRqy+NAtaOsXO5tZjs4C2d0L+sFuE1ZeNBYwo6ogRFKIAKKxsN6w37/4XrudNA09mCDwltNYQ/Spok9O0J/NiB0cPqrju89DCzW03uihJjOM8hvT+Yubc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782327582; c=relaxed/simple;
	bh=kXFTnGraMbj1D69AOD10KUsFr3oPMiySCxIdVlZqu3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SJ7DXlXo4Z1rYLvNS0e2vZ0eVf5xmHUHZOXA4zcGo9QE+71+sa86YjAAxf8lwEPkk865PtHmJS2A4Fzgp2KBR4ueFZUzBSXYBVKruRY2mJl8YcG0RZyssZTw5P5+aaATk4e7ktk3CWId4bzWP77okZRPeWtmN8r7CduxKixJnQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bZIS9TQd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bZIS9TQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F2D1F000E9;
	Wed, 24 Jun 2026 18:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782327581;
	bh=LEnMGeMX+pqh8nu2I40EeK2wPm6s3yYAVoTPHrBf8zk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bZIS9TQdH/l2+c3xwIdqH9wNdiixoR7Mm96GT97H5k1gzXjCQeXaYRV8FIBamJq42
	 1gqSDyH1t9SLu469LNP2vpObVYqccyd0kkVo6vWNcMYCbh78xTdlyRtbcbIRFzB0vn
	 1PplS1M0v6EXT35izXgIGL/wsmWPwSvci+SGmtI7lbyNTPt9zmpUe+L4S/1zYFSH6G
	 u+nuhiJZwQGH+NU9VficHNqhhBLvTjqGeNOjcqKq5cVzsClE5v5XKZ8NhNRvt1nEso
	 RAftTQBx4IecSVozoQlwSqhE3m4PJZHiEfwFW54oxvL3DR185HsU9XwC60lIEB3+r0
	 fkdr5w4YXi82Q==
Date: Wed, 24 Jun 2026 08:59:40 -1000
From: Tejun Heo <tj@kernel.org>
To: Yousef Alhouseen <alhouseenyousef@gmail.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/cgroup: iocost_monitor: parse help before
 importing drgn
Message-ID: <ajwpHLIrr2uEOoAE@slm.duckdns.org>
References: <20260624123652.8108-1-alhouseenyousef@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624123652.8108-1-alhouseenyousef@gmail.com>

On Wed, Jun 24, 2026 at 02:36:52PM +0200, Yousef Alhouseen wrote:
> iocost_monitor.py imports drgn before argparse can handle "-h" or report
> argument errors. That makes basic usage help fail on systems where drgn is
> not installed.
> 
> Parse arguments before importing drgn so the help and argument-error paths
> work without the runtime debugging dependency. Normal execution still
> imports drgn before reading kernel state.
> 
> Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>

Applied to cgroup/for-7.3.

Thanks.

-- 
tejun
