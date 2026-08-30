Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EC53F1070;
	Sun, 30 Aug 2026 00:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788050542; cv=none; b=YxM/EJbf3kjW5993N3FKnZhDT2ktPqk2kv3YrCGnvqTsMy0rQO8W3SGLHsz7NI43u8V22kVqBqFytlV3hp5jZgnVI8AoYM787e1kN2H2bl/YJZJ2SLWNa2jfdxL/58kbmvoXnjuoJ3FvrSdGvzg2KAQwJ/ONnV2VCl2lHfqTbj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788050542; c=relaxed/simple;
	bh=YQF5CuCO7WIHjehlv5gcy6XbMly9wNF79yRd4Ivs+Cc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=j4NwHEaaoNVPdjRi1Vzuac0HQW/APGPwY9XiYZIS1mpFgkslfQWft3o7Ie9G0wR0KrwSuWnRzZ/YcxvX0e3vUjCnPdaVS566iN7vOTazT7NdI0FcD5+l9/zjeec2rFVfOfet1K9M4RsJL8hV+7PKI3bROF9JBsrOMLeFLdprRgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SV0icf9X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SV0icf9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59161F000E9;
	Sun, 30 Aug 2026 00:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788050541;
	bh=Rb4xEC514rL8RB4hHk5hsrJ5d856ovaUy3Z49tjYAx0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SV0icf9XNL8ZxbctcyAIM46gZXeJQW3d+vRCQ/i3WsiaRhzeYIDMCtbcdETuI5hc1
	 onYQb8AgOZwAjr25Im4ziTtdVk+0TNtQoGiWrY7tbadrZxIJOnimL9gbA8ksuCossx
	 nViWZmlkCpuiiYK3QNwEou1JKddc/MCvEpYgrcu0=
Date: Sat, 29 Aug 2026 17:42:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Tao Cui <cui.tao@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 hannes@cmpxchg.org, roman.gushchin@linux.dev, muchun.song@linux.dev, Tao
 Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] mm: page_counter: reject empty string in
 page_counter_memparse()
Message-Id: <20260829174220.204771edba7c52511dc08641@linux-foundation.org>
In-Reply-To: <aoVUlFdZYLFn_gvJ@tiehlicka>
References: <20260817042652.74136-1-cui.tao@linux.dev>
	<aoMzchLCCz5hiFHp@linux.dev>
	<aoQNtIRvqXRh-x4u@tiehlicka>
	<aoRz72_zdMai_RNV@linux.dev>
	<aoSLxSBUPbEqimJq@tiehlicka>
	<9bd74181-2ce4-4d69-a353-614685559ceb@linux.dev>
	<aoVUlFdZYLFn_gvJ@tiehlicka>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Aug 2026 09:00:36 +0200 Michal Hocko <mhocko@suse.com> wrote:

> > Whether that benefit outweighs the compatibility risk is not mine to
> > decide.
> 
> And I am still not convinced. I do understand your frustration from the
> debugging the issue. In any way, if other maintainers decide this change
> is worth I will not stand in the way.

Shakeel seems OK with it.  Other other maintainers are being aloof ;)

I'll queue it for now, along with a note that additional poking is
needed.

A v2 would be nice, please.  Add details about that production incident
and make the requested update to
Documentation/admin-guide/cgroup-v2.rst.
