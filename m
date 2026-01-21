Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910A537F0F6;
	Wed, 21 Jan 2026 16:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769013328; cv=none; b=EO6WwEx+3rh+V9kKCj/yFhenk7FBH+u9AD2OYRdcbc1rP7JTWQCDR1RRcMOJ+H2ZtPB5Se1FdQjcNAEsGTuDuB+0ysjXa6cPzWk1U/N3jQWod49mMpMyACkpmCdxRq81jor3KaThYTucnnBx/oViaDltAkYg7BIWUC+IvijmRlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769013328; c=relaxed/simple;
	bh=3zPMWVBv7t5iAJv3hnpBDclZ49++f9lUq423MascAHA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=TlGSd0eE8L0EUt1j3VO0NS4jelxtKVtwh/Ll37Cy+NClwkhm5+PIjPq9k0lTCe6CBg+yD5uensw9+R8uuHcvt7q10impoPLJE85mEovK+DgD605H3yS7DHHKKbKivB4gL67ByOZuKDckcWeuqlsdnjK8wIkalRFCPqomykDIv58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2bDfcyhm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2bDfcyhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3285C4CEF1;
	Wed, 21 Jan 2026 16:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769013328;
	bh=3zPMWVBv7t5iAJv3hnpBDclZ49++f9lUq423MascAHA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2bDfcyhmX+KhXJ8DHt4vIF2snsRM458gDGeLB6zECJsuEbYlq1q1gowyffUhb5bUe
	 FEJDbI+5di4SdAiAnrexsRvuaySiN0wo78jIo2+/NlrO/kvjke4vk8BN2RbBe0Ycqi
	 Fl/q/E8L/79I9V94mbmL2UH/DL6T+LJYoeT0sXlo=
Date: Wed, 21 Jan 2026 08:35:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, syzbot
 <syzbot+079a3b213add54dd18a7@syzkaller.appspotmail.com>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 syzkaller-bugs@googlegroups.com, Muchun Song <muchun.song@linux.dev>,
 Minchan Kim <minchan@kernel.org>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [syzbot] [cgroups?] [mm?] WARNING in memcg1_swapout
Message-Id: <20260121083526.81996ffd70ff4efc8484fd4d@linux-foundation.org>
In-Reply-To: <aXDponX2AQoACOaI@cmpxchg.org>
References: <696b56b1.050a0220.3390f1.0007.GAE@google.com>
	<20260117165722.6dc25d72fd58254cb89e711b@linux-foundation.org>
	<CADhLXY6ACKeyLrjARTTdfWyrvUdLbtD-wXiQvsvhsbGjwmUqDA@mail.gmail.com>
	<CADhLXY7FJqRLjX7X2yJfa0=iDbUAMwhS35cOEExW+qBJWAnt+A@mail.gmail.com>
	<20260118125311.e1894f598e2a8ef626f47f25@linux-foundation.org>
	<aXDponX2AQoACOaI@cmpxchg.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 21 Jan 2026 09:58:42 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:

> > > I tested with the latest linux-next in sysbot. It is working fine
> > 
> > Great, thanks.  But we still don't have review for this one.
> 
> IOW, this is not necessary anymore. Kairui's (cc'd) fix which you
> picked up fixed the syzbot reported problem.
> 
> > For some reason I don't have cc:stable on this - could people
> > make a recommendation?
> 
> So this:
> 
> > From: Deepanshu Kartikey <kartikey406@gmail.com>
> > Subject: mm/swap_cgroup: fix kernel BUG in swap_cgroup_record
> 
> can be dropped.
> 

OK, thanks, I'll drop Deepanshu's "mm/swap_cgroup: fix kernel BUG in
swap_cgroup_record".  I understand that Kairui's
mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix
(https://lkml.kernel.org/r/CAMgjq7CGUnzOVG7uSaYjzw9wD7w2dSKOHprJfaEp4CcGLgE3iw@mail.gmail.com)
has addressed this mm-unstable issue.


However Deepanshu's "mm/swap_cgroup: fix kernel BUG in
swap_cgroup_record" has

	Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT")

Which I assume was mistaken?
