Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7349F324B31;
	Sun, 13 Sep 2026 15:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789311789; cv=none; b=BEWFXcoIhyFo9nIub0RFEbepIPBDp1rslYiXkEdOAkWL2JeD7T6WQOiICSwSn6xenDDR3yck6KasTne+DTvBsXUs2zdQ6iwT63NWQ5tMzuZ31bwCrkdiPc8YhoGU2EInNIAWlqabEMmC7gODWu/zXotG+dS5vX91NMF1zVT/tH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789311789; c=relaxed/simple;
	bh=F59i3XU2/LdtKXNh0Y6c0S/9iA7cpIW+tG31CF8ZyFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=avzRmd7NUbl+OEsP9m5JVxx+JFpBvwMusXMojkZgjhnk1ZVFmFwbYFChaXHrg7Mv1zwMd5RH2uTKeGRPPw5akpvJlTeSXIDsiKM6olCLyVsDK3GfbrhEl9+0g0c2maPR2iU3sbDBVUS22zKETWey5a84Cw/D5f3ydma4t++DSyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OzWztuCD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OzWztuCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFC51F000FF;
	Sun, 13 Sep 2026 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789311788;
	bh=L7xUyrxRyhAVaccpZg2VvYQ5sM7UNg+rJCR9uxtJriM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OzWztuCDHqAlQl/ebTv1/XWOv/lL7lfRAuNrEP1FfjLinVU/givF6DJyUStdZgjS4
	 JHSBvpfJMkfrD3ZfCRpl8yVudnzz62BfuvDd8c/YwqvnCysNwqv84PlWnBGjDMuEYe
	 LCwxNtwABtZ4R9s7D9gIStr9gaNqAVX1vhJ4T9Zr3IBPh8eXGqsfTflM5mEshz2BQV
	 veX/GVf7rVn6gFxFJffWRuJ97Ut9w/M2nZLcjvcSzxBI74NIBNTjvKD0YLtOolhVAQ
	 ptomYXtvyJtN3MtfUeBJFHq2eZ3usJLOi2rUTQ2W4bwr9XRYwhSzMY829BEbJzPbz1
	 +1LLRMJ5ZwJbg==
Date: Sun, 13 Sep 2026 05:03:06 -1000
From: Tejun Heo <tj@kernel.org>
To: Chengfeng Lin <lin2530632123@gmail.com>
Cc: "T.J. Mercier" <tjmercier@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.cz>, driver-core@lists.linux.dev,
	cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [REGRESSION] kernfs: empty cgroup rmdir latency after
 delete-notification changes
Message-ID: <aqa7KgIJYGgf7INk@slm.duckdns.org>
References: <CANGjgdn=H50AaA-+O_GA-hkE9UwLANmkjx1zRsKUzxF5za8VfQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANGjgdn=H50AaA-+O_GA-hkE9UwLANmkjx1zRsKUzxF5za8VfQ@mail.gmail.com>

Hello,

On Sun, Sep 13, 2026 at 10:43:04PM +0800, Chengfeng Lin wrote:
> I found an increase in empty cgroup removal latency across 507d8ce13f5b
> ("kernfs: Don't set_nlink for directories being removed") and eea5d2bb34ba
> ("kernfs: Send IN_DELETE_SELF and IN_IGNORED"). With sched_ext disabled,
> rmdir() went from about 6.5 us to 9.6 us, an increase of 46-47%.
> The result held in two independent runs.

I don't want to make cgroup removal unnecessarily expensive but at the same
time it's not an operation that I consider to be a hot path, so as long as
the operaiton can finish in a reasonable amount of time and single digit us
definitely is, performance of rmdir usually isn't something which is high in
priority. Can you please detail why this matters for you?

Thanks.

-- 
tejun
