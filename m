Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A60438E124;
	Thu,  9 Apr 2026 12:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775737736; cv=none; b=hr96Z3sBbbL26NS5KhfI1yOb4n8MvfRoKrjiFjwDKhPl1Vew7DtYcyX2QDWklFv1ZFieept2X+nnOsfISJEx4FjsOPN9jHV7O4yKcQAgnOIL8uwyX+5yQzs89SA/0727BMADUxsaOjCqxG3Jq0ppDDPLWpwruUAENqQ2seATqmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775737736; c=relaxed/simple;
	bh=poFyMGo63glTH1EOk1zjTv3TeTeGbJgJ2107WbU5brA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JsvYjYJvFIuTjvj8wE0XjKkKvbPR0dYwLyfuJynMWz0VvH6pP2RvGvGIA9GrOU7KhpSEfvhVPymlyBGrk1e/PrFG0qhqYA03EuWn5bJSUonZjE6LUiUJ0E9OAo2iSXzLMoAWhGtzWAvHFO14Z6oZNrhSGr56NY7aE2011A7Itzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uf+2dWZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uf+2dWZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9590C4CEF7;
	Thu,  9 Apr 2026 12:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775737735;
	bh=poFyMGo63glTH1EOk1zjTv3TeTeGbJgJ2107WbU5brA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uf+2dWZ/soHkgYOgxmTde/ijjsQS1O8DP90fjnG9JAyp/Au5FI2z0NkfwRwXXCin+
	 b+keKtDjXz+KwENf+l03YkTB7YjVFBuqQKZS0Ok48OOcgP9N3z8t0Hm38SuRA91Zmq
	 i1p9jkKyWIPKUS9tbp8k1S7UDYoLYzHjm5spcho61sk4Hbi5DGDf2+Aqwn9FO0XJV0
	 qeNimGTiN4xpUrB3knaWyrD/3AmHSim4/mL+AN2BCVg0Tdq3TQTLCgBY4NmP+DWHjL
	 SREFa45sHGGWdDW4MAR3BGpoR99KJ3l8ii/R3jUp2L2lZAaIZucDiDymXcLdRqw/aT
	 KIVGqv/Weqd1Q==
Date: Thu, 9 Apr 2026 14:28:50 +0200
From: Christian Brauner <brauner@kernel.org>
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, cgroups@vger.kernel.org, 
	davem@davemloft.net, kuba@kernel.org, edumazet@google.com, tj@kernel.org, 
	hannes@cmpxchg.org, tom.hromatka@oracle.com, kamalesh.babulal@oracle.com
Subject: Re: [RFC PATCH 0/1] netlink: Netlink process event for cgroup
 migration
Message-ID: <20260409-unvorbereitet-pizzen-c479b7bc6f85@brauner>
References: <20260407172339.2017158-1-prakash.sangappa@oracle.com>
 <pd3vkzvgr233tkuocyvpgxc4kttsi5nlggcxuskvwi3mocoqkm@cfefi6hh74s6>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <pd3vkzvgr233tkuocyvpgxc4kttsi5nlggcxuskvwi3mocoqkm@cfefi6hh74s6>

On Wed, Apr 08, 2026 at 02:54:17PM +0200, Michal Koutný wrote:
> Hi Prakash.
> 
> On Tue, Apr 07, 2026 at 05:23:38PM +0000, Prakash Sangappa <prakash.sangappa@oracle.com> wrote:
> > With cgroup based resource management, it becomes useful for
> > userspace to be notified when a task changes cgroup membership.
> > Unexpected migrations can lead to incorrect resource accounting
> > and enforcement resulting in undesirable behavior or failures.
> > Applications/userspace have to poll /proc to detect changes to 
> > cgroup membership, which is inefficient when dealing with a large
> > number of tasks.
> 
> You may want to check [1] (and followup discussion).
> 
> > Add a new netlink proc connector event that gets generated when
> > a task migrates between cgroups. This allows applications/tools
> > to monitor cgroup membership changes without periodic polling. 
> 
> This CN_IDX_PROC netlink API haunts me at night.

Yeah, let's not go down that route...
