Received: from mta0.migadu.com (out-38.mta0.migadu.com [91.218.175.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E383D45C5
	for <cgroups@vger.kernel.org>; Thu,  1 Oct 2026 11:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790855076; cv=none; b=AV4O8pOmPx+7SWUGD67FAWPJejdYUPAzQ76SaIEHxh1P1CqYsxvfNyF8NSGM2Ul1GA5GdRzNeZCpKXUA6N4a5rmudwdYJm5K9xMJxhIK7OnskG0JcgmZ6jUaSNEetahUs3BEANupRq1Xkqpnbyr+MD+NgKxtkU0fqULqgjpf3So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790855076; c=relaxed/simple;
	bh=peXh9c6xAd6ckv+sJNrdXLiSAIKk1mP6MG42SI/sR/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R865jCHF+ILLt5xPW/nbtFtILKaOngvx76EBg3v5CVSSEtz1wQ53kwwXGXqFA53ldYExhuWbaCbFEbViJj7lMQsQNHtVfXBM6C73I+3a0RqIYsTEtFBvcFDraVUNWy881c0VL6m8CQu2+sX51XBltBwaBCHZy3zzdHFNLGkg4nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pQ812e+g; arc=none smtp.client-ip=91.218.175.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pQ812e+g"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=peXh9c6xAd6ckv+sJNrdXLiSAIKk1mP6MG42SI/sR/A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790855062; v=1; x=1791459862;
 b=pQ812e+gn3XmD5FZfEdcCS7cLDb7IJ98i87AUUpS80yJaLQAaeUptEAMO6fN4yq0BWYb6/oi
 KYyBzcrUE6f6L9LplCy4bSWWqmXB5SlUqdx6EWuNi/KON6CwEu2QS8wOjAVDpFxBbvT3ODS7WJF
 ruM3k3vc57GNMQk6XpsFkawM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bde4632800327e3b;
	Thu, 01 Oct 2026 11:44:22 +0000
X-Mizu-Trace-ID: bde4632800327e3b
X-Migadu-Flow: FLOW_OUT
Date: Thu, 1 Oct 2026 04:44:16 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>, 
	Paul McKenney <paulmck@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Christian Brauner <christian@brauner.io>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/7] locking: opt-in tracking of sleeping lock
 holders
Message-ID: <ar5GDz-NSJBWX3j9@linux.dev>
References: <20260924155025.949998-1-shakeel.butt@linux.dev>
 <10b93dce66eb13a23fbab563df259092@kernel.org>
 <20261001104154.GJ4121339@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001104154.GJ4121339@noisy.programming.kicks-ass.net>

On Thu, Oct 01, 2026 at 12:41:54PM +0200, Peter Zijlstra wrote:
> On Mon, Sep 28, 2026 at 01:34:30PM -1000, Tejun Heo wrote:
> > Hello, Shakeel.
> > 
> > On Thu, Sep 24, 2026 at 08:50:18AM -0700, Shakeel Butt wrote:
> > > The answer is a count in task_struct. Only the locks that ask to be
> > > tracked are counted. The mechanism introduced here is planned to be used
> > > by solutions for shared lock isolation scenarios [1].
> > ...
> > > [1] https://lore.kernel.org/20260921192559.2619635-1-shakeel.butt@linux.dev/
> > 
> > Let's resolve the discussion on the overall approach first.
> 
> So I must admit to absolutely hating these patches.

I think I should have started a conversation/discussion email before sending out
the multiple patch series which kind of doing multiple overlapping things and it
is causing confusion. Let me actually do that and I will CC relevant folks.
