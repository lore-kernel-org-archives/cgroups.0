Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFD52BDC0F;
	Fri, 18 Sep 2026 13:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789739585; cv=none; b=HA9tUEjFxuptZGz7CMwAH7mITCdmynaBL3QitSWa+PN76okfMlRX7LPdikprXgOd7VPYYqdFdnOHJl7u97Zg3amvtFRI4vViHfItQfuqdGwKzgwnIJ4Z9LPyLTxKPKuN0IDscbNlgTo1SqlGdbbXU5ZADhDc5rYz0aVhHiuFRpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789739585; c=relaxed/simple;
	bh=j47wWgNed3Dy1tgOTLlnlr02ddYZmYZX5QouJSK+fjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hwZhKA/Y4MHLfI2UU+4EhiZbVpyb93LmyJ2gcWxJulKeOowSjWdppodwLFfRY8rPNq0Jww6Fnwt+5jSGzhIj++WS1CCRR7iS6mzhKL+1/ZSV7jQ6k09DmjK2yC0Fe4VHFmKHDpHBXFKqci8254daWDwlhkRBhX4pOr+aKM+5Gco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f97FyMau; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f97FyMau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EA31F000FF;
	Fri, 18 Sep 2026 13:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789739584;
	bh=0ofE/qDb5J9ar98eMmtKZuvLhg7PBCT+/uutvWytlvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f97FyMauyGj9dmrCQu8/VUgHVsqfD98mB3R6ooyXX6zZFElQVoVveAYDPw5FmZncy
	 n47bYrTrUw8mQJaj6Lv4gRI4x5JRZWzhYPrIfypqL6H7ef9Azgsx/9agLBWk8/b/RG
	 N5GeNQxoniykBE0BKv+ZA39TBtklWqviLDdCcANZ0jvuDreb+PPMTJXL/QWCXA1s6z
	 +B9pVjrRDFEpRQKtvptO5McpD71THnklpX3j9HGxGzV2o0Ti4LtwG5N7xkhNPW1vCa
	 0Rt+JrMFZQTTC6nF8y86RphpvVsc8Q2IDTwYStn1XDYQCb20PBBRNDTAZLVanIXE0G
	 bLTbRvWWJHx6w==
Date: Fri, 18 Sep 2026 14:52:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, xlpang@linux.alibaba.com, 
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, chris@chrisdown.name, kasong@tencent.com, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/1] mm: memcg: don't hand out large folios above
 memory.high
Message-ID: <aq1CIf0BPWFZLLmH@gremlin>
References: <20260915042546.279410-1-qinyuntan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915042546.279410-1-qinyuntan@linux.alibaba.com>


This is the friendly patch-bot of Lorenzo Stoakes.

You have sent him a patch/series that has triggered this response.

He used to manually respond to these common problems, but in order to save
his sanity (he kept writing the same thing over and over, yet to different
people), I was created.

Hopefully you will not take offence and will fix the problem in your patch
and resubmit it so that it can be accepted into the Linux kernel tree.

When sending emails to mm:

1. Patch series with 1 patch sent with cover letter

Please send single patches without a cover letter.

The easiest way of accomplishing this (+ our preference) is to use
b4 [0], otherwise format patches like this:

$ git format-patch HEAD~1

[0]: https://b4.docs.kernel.org/en/latest/contributor/send.html

2. Missing cc's

You are missing cc's. Fixing this is easy with b4 [0] (the recommended way
of sending patches to mm):

$ b4 prep --auto-to-cc

Alternatively, you can use scripts/get_maintainer.pl:

$ scripts/get_maintainer.pl --nogit-fallback <files-or-patches>

[0]: https://b4.docs.kernel.org/en/latest/contributor/send.html

Specifically, the following appear to be missing:

  chrisl@kernel.org

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Lorenzo will reply once he has dug out from the pending patches received
from other developers.

thanks,

Lorenzo's patch email bot

[ Idea shamelessly stolen from greg-kh ]

--
Cheers, Lorenzo
