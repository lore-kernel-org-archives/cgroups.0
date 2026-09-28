Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C503DC87B;
	Mon, 28 Sep 2026 13:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790600435; cv=none; b=Gyckz3sC/n7suP5oDX2Vi9ThxQdjJzMc2tLnQDxnkd9PSBsnEKpElZGDP6Vrpc28MuzsnVDOipueqEXSk1KoDBGZcXBHODsP+FPQog4I9ZmTP7biyEdVMep+WTe6YguVvoQGOyIyKbluL69qLJqpGkBwfXhUiyXwjkFkC+WrGVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790600435; c=relaxed/simple;
	bh=0ji0m/7TpVUZJeEnAvLR1aKypQLulQY/QfB/5mfR66U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dCt0brk9Nz+kSSAFtn48CLoXpJL62e06FL/MNF3t5gT/LWzIPJffS7PFR0Amn66PgizA4i+xL5ByaPTExoEWAxr92K34QM3SO1N5hch3BiBFz2u5f38TgG3Ij54FnyppjIZtLRvBLJOmvN0yvdXsxdlltfORSXZS9s2FdDo9kCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=efault@gmx.de header.b=fcFd6Mcs; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=efault@gmx.de header.b="fcFd6Mcs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1790600410; x=1791205210; i=efault@gmx.de;
	bh=YAXNPyYicVcBhKqsD1VcCjlEC2QfNeAe0Jk7ZO+USv8=;
	h=X-UI-Sender-Class:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:MIME-Version:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=fcFd6Mcsvn0HotrW1JbzaJipB2uaZe1IfncghthKkkAAqy/4iE4R0IM0zJyRQsfu
	 Hd58+/cjh5rSRgJ6TtvH8LkMPM6zuS+wtegxIyp/BeYso9QRXcApDJ8fproG40Jnc
	 ZxXBxA4VwADA2B4KE0ssm30IMHaNAYNY6DMLU2/BaraKsls8HkmbUvaa1b8fwA4Rh
	 9t98xxRG1jtwvvAVSb5U0wpZ/vKm6pYv39gsCboXXYe52VN1dI9e/wbGiejg6++CH
	 SU8Vx+mWboFGL08gS64IGbx9HNHyGq9NkVOTtOze6buW3Eo4+POti0tlLUFD463v0
	 B+D/QAQ8HE/kcQb0KA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MVN6t-1xKhCv2HoN-00LaQL; Mon, 28
 Sep 2026 15:00:10 +0200
Message-ID: <4d4f5fdee4d1f462ba3490a6b3921006285e7fcc.camel@gmx.de>
Subject: Re: [REGRESSION] [PATCH v3 7/7] sched/eevdf: Move to a single
 runqueue
From: Mike Galbraith <efault@gmx.de>
To: Chen Yu <yu.c.chen@intel.com>, kprateek.nayak@amd.com
Cc: Aishwarya Rambhadran <aishwarya.rambhadran@arm.com>, Peter Zijlstra	
 <peterz@infradead.org>, mingo@kernel.org, longman@redhat.com, 
	chenridong@huaweicloud.com, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, 	dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, 	vschneid@redhat.com, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, 	cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, jstultz@google.com, 	qyousef@layalina.io,
 Ryan Roberts <ryan.roberts@arm.com>, chen.yu@linux.dev
Date: Mon, 28 Sep 2026 15:00:04 +0200
In-Reply-To: <arnbKNWNIIEcQ0a-@chenyu-dev>
References: <20260605105513.354837583@infradead.org>
	 <20260605124052.227463677@infradead.org>
	 <bd81bbec-ee59-401a-bec6-116196ad3a34@arm.com>
	 <arQCykkkCnADu5ek@chenyu-dev>
	 <128e93ca1424630546e39f9e9c1377f8185f7644.camel@gmx.de>
	 <arnbKNWNIIEcQ0a-@chenyu-dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Provags-ID: V03:K1:KUUPpKNXiKaXxpr5TCfYnbGZgGReCwKZl8TJDsOn10FYsPmYo2E
 8avXXY8zGppimPpHwpm1Rlh8iig+/oaLZJENSS6MOjoLceMhKKz2YfWHQTphT9NyeuFxojf
 lfzA5y3aur1vvww0FzBiUdbRBhKXhfol0/YGrDu/rhKffJ0E4LTTLfamT5X3Jy3Gu/x2DJc
 J0q6ZfRhM+qQhmvesQ3tw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:68HU/8K76ik=;CEjxExAdS33Sh03NX1XGf+QbKYf
 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
 KF8aGuZ2dXpIstTfsC113+nXWGmRo+5

On Mon, 2026-09-28 at 11:12 +0800, Chen Yu wrote:
>=20
> According to my test last week, stacking the waker and wakee on the same =
CPU brings
> a big improvement on my machine, iff the memory bandwidth is saturated. B=
y comparison,
> if the memory bandwidth is low, stacking the wakee on top of the waker ca=
uses harm.

Ditto CPU wise.  The impact of even modest waker/wakee concurrency is
considerable.  For much of netperf, the post-wakeup tail becomes a CPU
service latency injection for the wakee when unnecessarily stacked.=20
While cache misses sting, those hurt.

As box approaches saturation, stacking of somewhat synchronous stuff
becomes a better bet.  Aiming for having only waker's tail between
wakee and CPU has decent chance of being a winner in a box full of
wider obstacles.

	-Mike
