Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC02926738C;
	Tue,  1 Sep 2026 00:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788223568; cv=none; b=fy0cOgk7Sv2VTBmOCCop1Pv+5A4WKv/bvwXfy7UCokgwX8zPGrlxFfArxee6BmPJ6OiHJtOdPjQVkZqJPrVQaFiIT8jW1KKQZZY7Z95Lr6orw9PJ1qEJHJ3T45JkvUSORFD4o0mP8U9A+X96fE43DFqxzUaNq/4t2sCwiEtSnYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788223568; c=relaxed/simple;
	bh=d+fwOcwzgoPY3iYiDpoERorpIcEI2FlvPaYKLnA04ik=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=kv000PrDjEXgtiJiBYOP/zZAnFdwgOQLOggPCCvuZYrEzfzPR7vJJIXR4scl+XEdfEB79XEtvegXCtX571kmtbp+hfj3Fff/+MBARxEzcQrdYrj+bbyAIfo62/4xbIHM0H54ZAs61prQYnFTYmAqxVxpUfw+e74ls4DsQv7FEQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hq5cMU1S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hq5cMU1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973F31F000E9;
	Tue,  1 Sep 2026 00:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788223566;
	bh=wfI4nJW4NZXTURLLniIaQtBfHGjWmn+gqY78i2JXq1g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Hq5cMU1S8uQbYuvCrodD6jKmSm+wxowLUmyrGzsBsHCmq4D3xzPMTIi4Q/BnBxm80
	 JtL7GP8is89pIBLJGtMFrDDaxmAKdnDP8dQo/uLQhHxF+1yhsoB/wUgdYfuthBFmjk
	 tppIR+WsAf7ommFZeRL6lw0jdWpBKDxTpsuvCxks=
Date: Mon, 31 Aug 2026 17:46:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ziyang Men <ziyang.meme@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Johannes
 Weiner <hannes@cmpxchg.org>, Michal =?ISO-8859-1?Q?Koutn=FD?=
 <mkoutny@suse.com>, Jiri Kosina <jikos@kernel.org>, Benjamin Tissoires
 <bentiss@kernel.org>, David Vernet <void@manifault.com>, Eduard Zingerman
 <eddyz87@gmail.com>, Viktor Malik <vmalik@redhat.com>, Andrea Righi
 <arighi@nvidia.com>, Changwoo Min <changwoo@igalia.com>, Michal Hocko
 <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, JP
 Kobryn <inwardvessel@gmail.com>, Mykola Lysenko <mykolal@meta.com>, Nathan
 Chancellor <nathan@kernel.org>, kernel-team@meta.com,
 linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org,
 linux-input@vger.kernel.org, sched-ext@lists.linux.dev, linux-mm@kvack.org,
 bpf@vger.kernel.org, llvm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] selftests: shared lib.bpf.mk for building BPF
 progs and skeletons
Message-Id: <20260831174605.4f76fe0a643fac90fce740b5@linux-foundation.org>
In-Reply-To: <apX9zb+3awc99Pfh@devvm16600.scu0.facebook.com>
References: <20260814075054.507089-1-ziyang.meme@gmail.com>
	<apX9zb+3awc99Pfh@devvm16600.scu0.facebook.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 31 Aug 2026 15:18:53 -0700 Ziyang Men <ziyang.meme@gmail.com> wrote:

> Just want to follow-up on this patch series. Please let me know the possible
> issues and I will fix them.

It was sent two weeks ago, during the merge window and bpfbot said lots
of things and Sashiko said more:

	https://sashiko.dev/#/patchset/20260814075054.507089-1-ziyang.meme@gmail.com

Under these circumstances I expect most reviewers would choose to await
the next iteration!
