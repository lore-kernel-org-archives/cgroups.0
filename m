Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794239018;
	b=dyTTCa1m/hPNDk+Z7JkKADW/ks6hLGKXv6LIEYU6w2p4F1ws4x+S1teSXTfh9B19i92w
	 h/jYgrXnR/8B2Ub18gJKldZEvnNu/B3r6TlbyfYtnaq4rM2YBqbkBIgD6pe9R3ilQpB4Z
	 6/l2UdFeSrQX8zlG5J9tnMJP2uV/Z1lEKoqiDg9FxnMLd8j4mylMyEZi7+Q3Ls4uLx1tv
	 kX5Ji7E5bu6MZu+kB9JPM7APe6OvnBfVOzTpCx+YyDGUtl6htQglWFA/jN45raquW2f+x
	 bG6frH4NBi5YBCUHpmklX5aq/j149oo7t0xeKxW9fj4HGWMsW1prANwhtyzoxkqM1Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794239018;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=wU1ifyjtBHXzPL8O1JAUpouGxPg8mwJS5MT55/0wkts=;
	b=2ofN3rypyqt5t8mqg0Z6ynHvrH0iJT0GMLZHJxgUcF+P/ZMilqQJ/2RisqPG8u3zeKx/
	 rFyvoPrqcu8Pq35oL9kW3/AS0ArQedIG1jiDLSGZ/Erv76YUwf7ND0XN1uJpzCVSdnbVC
	 tzi2tTuknA8+kTlDGbGyvhTUGBjvn/5wpXIDz/iBjGGIha6DpJbYvYF8wjmI79feE72cE
	 C7lYaa7a3xITQKZTvCLqchVX1peQPoMr82nh86aS/wmBj89q+0/ND8ABukMVAfaEqMAQu
	 FGg/HpyzNOIt4SMgxa8PpvXJ+t7S2O0/n41hHoFiTi3qB28hXNJ65GFBtkToC9bcZPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UyxFsy5j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2A0606A31C;
	Mon,  9 Nov 2026 15:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UyxFsy5j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAAD1F0089F;
	Mon,  9 Nov 2026 15:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794239017;
	bh=wU1ifyjtBHXzPL8O1JAUpouGxPg8mwJS5MT55/0wkts=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UyxFsy5j1uexnMSXrnWEqLslhhH0CGTrpUNXtaJTFYNOhnN/7dWCA3huzZo/1zWgw
	 o8ymlQoJFHCJloqJEPTKAyabLAwSbDevxBPr/35tfSMrGJNSoWqmvsli4ng6t1Z7Rc
	 YksbunXIId3fAAGQvqiZoyzVkQ5NYXr5xodbdmfnUoafUMgB6+vDkQUtWGoYf3iyv9
	 +vyZoBlMeSYqFB2G5fhXw22XGNnOF9zy6u4rctcmy+1lnJpB8U+YIoYAKCUg8ZnkAF
	 Mhmhbn/eWpog5qz9Pb0/+iMkdkIiEn+d/r2Wn5nRbWbzOwrX7S8p+H8VWhRpTU/5GC
	 YTAQcn+/ugMew==
Date: Mon, 09 Nov 2026 05:43:36 -1000
Message-ID: <91fa9a5de005245ed3c1bde305fc6778@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, driver-core@lists.linux.dev, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kernfs: Build paths in linear time with respect to depth
In-Reply-To: <au_pnu4s141ylqHD@chrisdown.name>
References: <au_pnu4s141ylqHD@chrisdown.name>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Chris.

On Sat, Nov 07, 2026 at 07:16:46PM -0800, Chris Down wrote:
> kernfs nodes only point to their parent. To build a path top-down,
> kernfs_path_from_node_locked() walks back up from the leaf for each
> name, so the work grows with the square of the depth. Reading
> /proc/<pid>/cgroup does this with IRQs off and css_set_lock held, so a
> read from a deep delegated subtree can hold up fork and exit elsewhere
> on the machine, which is certainly suboptimal.
...
> In terms of operations, with a 15,000 deep path chain and a 4 KiB
> buffer:
>
> 1. Parent and name pointer reads go from 112.6 million to 75,003 with
>    this change
> 2. On my machine the second read of /proc/self/cgroup takes 99.86% less
>    time.

I don't think a 15,000 deep cgroup chain makes much sense as a use case.
A lot of other stuff in the controllers will break down at five-digit
depths, and quadratic isn't that expensive when the base number is
small. Did you see this overhead in more realistic scenarios?

> +	/*
> +	 * We can only walk towards the root. Fill from the end and wrap
> +	 * so that if the path is too long we keep its first bytes.
> +	 */

Even if it is worth doing, the implementation looks too convoluted. Most
of the complication seems to come from supporting wrapping to keep the
head of an overlong path. The only callers that care about what the
buffer holds on overflow are debug outputs. How about changing the
contract so that on overflow the buffer keeps the tail end of the path
instead of the head, which is more useful anyway, and the function
returns -E2BIG rather than the length?

Thanks.

--
tejun
