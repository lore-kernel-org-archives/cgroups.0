Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EBF4A13BD
	for <cgroups@vger.kernel.org>; Thu, 11 Jun 2026 17:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781198518; cv=none; b=m6CJhtagf12Bi4kSWFJmXGvnKDt7rAypmzXeyCVuSQCrWI0Qtn6H+E3tLpTZkm4LjoIJi80SJMvD9lBnlOUyxUfS5rFJK51HIQ1tC4LLij47VqUaT3qyWuJIZaPnvW8F8VI/lOG7dAWfax9G6eX7EWPBZZShYODjqwXnfJR2H8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781198518; c=relaxed/simple;
	bh=J41vScc8tWOTlu0rD6gFdr0xLnd16WiIM1stwB23ze8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PIt1TzAKOdNq9m6gJ9EoYWFKhXoyo2kC7OBzHZjiO7wiXQT0QAhato8mbxD4mys9tm4LNEUdYrrG2inu6frvsQbrZE/9g3fBnCmYO6gvnpdpxN7oxt6ukKDuFAPKVdHVmf9cSsENaWB5tfPgnkLcNbHDOJE7nxp+cpP1YCuGQtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QHcieltN; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QHcieltN"
Date: Thu, 11 Jun 2026 10:21:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781198511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Yb89dnim3jwXQsF33yzL/m+QYNw/vWjAYzs6MeYtKM=;
	b=QHcieltNPLyCj0doMAB67sVHLu2JhfhsnDfAxc61otPSi+Bm0Gp39yKZFr4vbb89v0xhNa
	b+eRQxHN6ksv8sJtAfXWxi9riE+TggyCxkY22OMoMlQicEZ376fzEW5D7j07Iy0YUj8FIS
	Vvk8zooGke9eFJLBHj3f6znMIYsVkyg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Longxing Li <coregee2000@gmail.com>
Cc: syzkaller@googlegroups.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [Kernel Bug] INFO: rcu detected stall in count_memcg_event_mm
Message-ID: <airuQ36pKQ8x8CZk@linux.dev>
References: <CAHPqNmzgCY+sHOOG8YVrCFO-7oh6TBeL4SCHEcfVvH6J1SUVdg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHPqNmzgCY+sHOOG8YVrCFO-7oh6TBeL4SCHEcfVvH6J1SUVdg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

Hi Longxing,

Thanks for the report.

On Tue, Jun 09, 2026 at 07:57:56PM +0800, Longxing Li wrote:
> Dear Linux kernel developers and maintainers,
> 
> We would like to report a new kernel bug found by our tool. INFO: rcu
> detected stall in count_memcg_event_mm. Details are as follows.
> 
> Kernel commit: v5.15.189

This is an old kernel, can you reproduce with the latest kernel? Also at the
high level this seems like CPU starvation. Can you also describe your system and
the workload/test which is trigerring this issue?

