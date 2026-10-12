Received: from mta0.migadu.com (out-123.mta0.migadu.com [91.218.175.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325794B8262
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 17:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791824942; cv=none; b=pjDv585ijUMuIPDHBlhqzhKpUoCZOjxrjs5G00TalRplMO5w36gBncJEIXVGmvkdnPcRGEZeXkDKud5yCifhQIlhkVOwZvzQb67IfjFXFonIaoEevQJQ7gvE3JryYXmQjdyNPQQbQWSu81y5nO2luAsL+WYO5LyZ9PFwUV5fIUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791824942; c=relaxed/simple;
	bh=jL6a5+5jBxh6aj08ydsTft9UH05ysF5Kx7zP21piuQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sac0pWYos7Dzt8Tuhf3Vcxb5gmj/AHiKi7Az8YpVapzMcOQLY819HmVMDPKfI7pHJQJuR7bd/E7hO7/9NXbzc4+ElzzAKpRiOKP1vf/ZTcL54NzRML1rmLv0r90FVjjiNO4KseiPr9KOp+D+GJRHGWWxcCoqMcQwwczTeSvopNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qGgzcnPo; arc=none smtp.client-ip=91.218.175.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qGgzcnPo"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jL6a5+5jBxh6aj08ydsTft9UH05ysF5Kx7zP21piuQU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791824936; v=1; x=1792429736;
 b=qGgzcnPoMZUPCLCcE2ToDjH++DVVM5ZdF9vZLkTh1Rsq9XJfI5Q30TkWbPNtCB4j6mX447ZC
 jD+Jj6p/26r95Ozgq5QAbi9hbnBMZBUsizB2qHEmjmxEJJ94iVlHx+kchJdzbnFE6JFNyk8h9Uj
 wOE1BO7RCty8T7n9Fxn0yFSM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0f25970896a4cd0f;
	Mon, 12 Oct 2026 17:08:56 +0000
X-Mizu-Trace-ID: 0f25970896a4cd0f
X-Migadu-Flow: FLOW_OUT
Date: Mon, 12 Oct 2026 10:08:55 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Sasha Levin <sashal@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "T.J. Mercier" <tjmercier@google.com>, 
	Amir Goldstein <amir73il@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: memcg: don't close an uninitialized fd
Message-ID: <as0UDixO6rPt8UHX@linux.dev>
References: <20261011223358.2327625-9-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011223358.2327625-9-sashal@kernel.org>

On Sun, Oct 11, 2026 at 06:33:37PM -0400, Sasha Levin wrote:
> test_memcg_inotify_delete_file() and test_memcg_inotify_delete_dir()
> jump to cleanup before the inotify fd is created when cg_name() or
> cg_create() fails, and cleanup then closes whatever fd holds:
> 
>   test_memcontrol.c:1685:6: warning: variable 'fd' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
> 
> Initialize fd to -1.
> 
> Fixes: 2de27980e1d46 ("selftests: memcg: Add tests for IN_DELETE_SELF and IN_IGNORED")
> Assisted-by: LLM
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
