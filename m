Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B182D73B5;
	Sun, 19 Jul 2026 16:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784479501; cv=none; b=eZhyPpMstf/G/n7Tez7wSxU7XeqMaqtScgLLxmFmGmr63yan/6j/jmuI6uvb+qhI3zFUDzNhbyTwr4h6yl3SGRebfhoxgSarat6guTSq6L9ADgi5wr3REa/4VNxLQ4rn34nJ2XvtN3PjGsSq37TcHKBtZbcd5LqO0Zsmu6zM3Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784479501; c=relaxed/simple;
	bh=wc50sP0AmGWbixR3GzVVok7tAs+ZYWZkMJdv27f7gws=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Zt5XdhspvtNYaVm8aVloWFMng5AHaoE7W7ZFSc62I0VVEisaP2qGSnm79pl4SniK/wM8yGjH8eCiMBx/FX9yBfuJVRVZKbW+3uQ+52yCS2CbrR9mfpzbhSp09a97bK+dbORlfjAKbHa/e3TvRFMpmGUvZPlTyypctmUMEL9DoHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=ARUYvNwj; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="ARUYvNwj"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 4C73140430
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1784479493; bh=Jbnl6b3SUNwv4XwJjBQ66TGVnrSTzvNb7MNjAp2yYV0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ARUYvNwjeH4HiVE1/LZYT3S28dqyRDEQF/7igk/wAG2Y8THBJRX6yKzW9nLFJSy3r
	 pqE8SbtRimyRijpQtNHlyr5CzLcdlb1335o5H/immzdQXDk44u1dlCws9MyybhJF0i
	 +PDplyf/0qcgbWxXryq94DPatFP4axamnnF+vd/82FqQwoitNJB11OjJKesuh0VjVX
	 yp0wsGzIeVxu9JIQa1XvmQzbIqARzKb+RvT8JpBEwxbstUCq2Wr/4GxO1SQ0EatpmD
	 sSKmXrVOIvL+OdNLKqX6mcPfhLjQ/PHeCCp/wEr+Im/JyC4K7NcElRt5gQMXK5v7mC
	 L2i4NIMatG+vQ==
Received: from localhost (c-71-229-227-126.hsd1.co.comcast.net [71.229.227.126])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 4C73140430;
	Sun, 19 Jul 2026 16:44:53 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Weijie Yuan <wy@wyuan.org>, Yahya Toubali <yahya@yahyatoubali.me>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal
 =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan
 <skhan@linuxfoundation.org>, "open
 list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open
 list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] Documentation: admin-guide: fix trailing whitespace
 in cgroup-v2.rst
In-Reply-To: <alumXzlDApA_iMbY@wyuan.org>
References: <20260718151913.1892547-1-yahya@yahyatoubali.me>
 <20260718151913.1892547-2-yahya@yahyatoubali.me>
 <alumXzlDApA_iMbY@wyuan.org>
Date: Sun, 19 Jul 2026 10:44:52 -0600
Message-ID: <87zezn3p4r.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Weijie Yuan <wy@wyuan.org> writes:

> On Sat, Jul 18, 2026 at 04:19:08PM +0100, Yahya Toubali wrote:
>> Remove trailing spaces on lines 1335 and 2197.
>> 
>> Signed-off-by: Yahya Toubali <yahya@yahyatoubali.me>
>
> Hmmm, for a file that might be modified, I wonder if it makes sense to
> include fixed line numbers in the commit message. i.e. When the line
> number changes, your commit message will become meaningless.
>
> I'd love to hear others' comments.

Honestly, I question the value of churning the files for a couple of
trailing blanks in the first place.  There are *so many* ways in which
our documentation can be improved, and this doesn't approach any of
them.

Thanks,

jon
