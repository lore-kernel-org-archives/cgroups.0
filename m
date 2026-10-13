Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1C83264F4;
	Tue, 13 Oct 2026 03:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791862824; cv=none; b=NRzrY+39B/QYx6aBvuZxdRnqVCM4jbcPzeFUsMdZTcftnGpmn3faZ6sC31igjf8ylbpc/lyYKbPEHwZC0LFkg00bC2r9dNxV3GsPc1dBY7Ai+noX2adCy69OtLzkNHu+PJV0i2QhmQUqU3at0FSuVh4ryE+NkWyr47mPjB56Jhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791862824; c=relaxed/simple;
	bh=Pf8PDlvhGyxPRJ04hgjmStlPo6N2sQGF+ut0PITXAXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K22IihbqoQvCLepeqjlL0JgZTwKIC3mxLq12oyk7M1MY6S+t5hKD6+eKYmGxc9pSqrn//6EIWDEitJ4op83z+LTl3W4/4DZolh7HMWJyGOr7Sk2Wy0XhW/wvD6RIbx73Xmq1gtQafq+0GcWQkpigFxJYqOynVAJAq408+pkzhxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oj5zpxoG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oj5zpxoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4831F000FF;
	Tue, 13 Oct 2026 03:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791862822;
	bh=MHKRBDHmsXsK48oKqrexgIqndzfvmbI+AVfd803mUSA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Oj5zpxoGgdzmeIog+7KO1QLrI4HUFkQNtnMsz/Sf/iwRjmXaISNO5VFNexwDOfA7I
	 QLiRzOMZyLuAs0cGPMstdgayiiW91bVrnPRgVfDxA9f45B1BQKQ9Sgcl3vWBYynlem
	 9eFhgaA4Z7w3AHx2qx192F+EVD8bM8OD2lg7BcxAX3RJCu4AEjGD+/ajUMxe/+F0lU
	 vAUsbFr/Gr22WvlIBVGbtqHob5Fevhl6bJtrxBAtC9YFcaDUeubtmBEl3k1SWaU16P
	 wOPAnsesfWb+rpki9Z4AUpY3luNT5svEsOgbs3aNHBuDM0iTMVRSnTo5Z6/YR5f3Xg
	 YheZMVbSKLEoQ==
Date: Mon, 12 Oct 2026 20:40:22 -0700
From: Kees Cook <kees@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
Message-ID: <202610122032.A63BB70@keescook>
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org>
 <asjhg2e4-WSeKuXd@thinkpad>
 <202610092010.934197B@keescook>
 <20261010153714.b9e91801ea93675da099e903@linux-foundation.org>
 <4866a382-42d9-44da-b68b-377d36642528@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4866a382-42d9-44da-b68b-377d36642528@kernel.org>

On Mon, Oct 12, 2026 at 06:46:48PM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/11/26 00:37, Andrew Morton wrote:
> > On Fri, 9 Oct 2026 20:14:20 -0700 Kees Cook <kees@kernel.org> wrote:
> > 
> >> Anything with Fixes: will end up in stable, so I just leave off the
> >> stable CC these days.
> > 
> > -stable maintainers have been asked to Not Do That for mm patches. 
> > Other subsystems are doing the same.
> > 
> > I don't know how they determine whether something is an mm patch.  A
> > patch which covers do-do-that and dont-do-that parts of the tree is
> > likely to be mishandled.
> > 
> > So yeah, add that cc:stable to reduce the possibility of mistakes.
> 
> There's also this from the list of pain points at
> https://lwn.net/Articles/1099594/
> 
>     Kroah-Hartman: subsystems that do not add CC: stable@vger.kernel.org
> tags to patches, but which still expect the stable team to pick up the
> important fixes anyway. The stable maintainers are overwhelmed as it is and
> are not doing that.

tl;dr: yup, sorry. I will add CC:stable in the future.

I went to go figure out where I had gotten this misunderstanding.
netdev dropped their special handling in 2021 in commit dbbe7c962c3a
("docs: networking: drop special stable handling"). But I
really thought I had Greg tell me (in person somewhere?) that
"Cc: stable" was redundant, and I think what I misread in current
docs was, "... such tagging is unnecessary if the stable
team can derive the appropriate versions from Fixes: tags." in
https://docs.kernel.org/process/stable-kernel-rules.html#stable-kernel-rules
but that, on closer reading, is about the _versioning_ syntax of the
"Cc: stable" trailer.

-- 
Kees Cook
