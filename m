Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4454B3CFF67;
	Tue, 26 May 2026 09:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779789155; cv=none; b=dFcbxZNrcZ9Ws1N/2TJft0GPKAOgIVc6LdhBqsrPbMY38/T1yQWC5ihGmFnywJGQeelATEzRWjMIz4LgQx77PWTsUJueJuwUw5ajIbMFpdZlEiBX2TF/e5LyN7lQ4Gkl6GsMLJSurDJjPX9M6VA8GRpnR2QZtAULxARjUE11W14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779789155; c=relaxed/simple;
	bh=mBI8A1A0erTKul6Uel9KCN5h05i6lf3Ls4nFDfcjxs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rCcJtQ66qYQzlsqRWV6FSQXPRjHBR+mUH+y2Y+n75OENJcEJG1TO8zxp9jVgCjoZqfhknuYjPOwe8Q2nHwMcQZJ6a3MExa4NJXAFwr4kA6gO0x0H7ExAl3ets6fMwt+xRDRlKIqVG8iMmJKS1djvN5zww8Dz2UqRbSIp1D/c3Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BE7s7HFT; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BE7s7HFT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mBI8A1A0erTKul6Uel9KCN5h05i6lf3Ls4nFDfcjxs8=; b=BE7s7HFTel1ofEzrNtbvfWpNg6
	lzj9xH15t+T1VwviDWoj/B8z+xpIcmopEISV/upQOKNKiGYz2qLdg4l89p6WWbX/MafMvhzGHyTjE
	7DcfpknCXcdOUwHmjVOK4rM/1k4YUgH6+TiCo2DMprSE90J7wLZg5g2xt/W179tYXA+UDj9sO7epd
	f2DWKrS22oHiTUT4i0MMosdMIW7j3XSBiiGJNDrcGaQjdvCeWQoJOok93pRBcEZFh2zQn0hg0IIF6
	5LoljaZa6Dx6RDKxfmHa4f9FQr5/2fbmQrS3MebrNBiug6XhgZ56tKmoSiZc10z6etM/ljINtZtCN
	wgvlDrWQ==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRoSK-00000000tl7-0Ah6;
	Tue, 26 May 2026 09:52:12 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0961A300673; Tue, 26 May 2026 11:52:10 +0200 (CEST)
Date: Tue, 26 May 2026 11:52:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Zhang Qiao <zhangqiao22@huawei.com>, mingo@kernel.org,
	longman@redhat.com, chenridong@huaweicloud.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, jstultz@google.com,
	qyousef@layalina.io, Hui Tang <tanghui20@huawei.com>
Subject: Re: [PATCH v2 10/10] sched/eevdf: Move to a single runqueue
Message-ID: <20260526095210.GC4149641@noisy.programming.kicks-ass.net>
References: <20260511113104.563854162@infradead.org>
 <20260511120628.206700041@infradead.org>
 <a06e4744-2393-724c-14ff-154f1caa22a6@huawei.com>
 <85116808-8643-47d7-b4e7-2a11c3999b20@amd.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85116808-8643-47d7-b4e7-2a11c3999b20@amd.com>

On Tue, May 26, 2026 at 02:45:45PM +0530, K Prateek Nayak wrote:

> The suggested diff above solves the crash in my case but your
> mileage may vary. Peter can comment if this is the right thing
> to do or not :-)

Is this a different issue than the one you raised before? We talked
about throtte, and you were going to make a proper patch of that cleanup
iirc.


