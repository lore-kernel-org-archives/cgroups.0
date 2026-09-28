Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E499849AA22;
	Mon, 28 Sep 2026 23:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790638472; cv=none; b=g4ZGT+L0FztWtUbFKwxJaIDD2S6uTDDYESKQbG5ZiNNMOCuUtyWjHMhjdVwEkSpl7J1n+sTTcZWlatUdiwOeMrJs+PbwG/ddk98V1LGiFUxXByOhuTMxN+NBYRbhqu09RmkgOgMl3Akj4ntk+5x4czvniImLo5q4RdQuu+zGYnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790638472; c=relaxed/simple;
	bh=n4MJciKrYjjPj+OcWZcPc+5VriGUuRJC4IeiUyuMfIY=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=Mjspcmug4qO2/wsKVXDrhQMBHPkOC2rTXR9H0ju37XrveMn6wovJNPfVHwFswTzuYijC2yAqLAErXeX/R1UgphzbRduTgl0CBfuzbDP1XXUhYoPqEC+7RckIaNp3Jvmna8S4P0OZYS9/Yz+DpQ/XNeGIa7JzeqA6IO8v2dBsjoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DGbEg+2l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DGbEg+2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C76B1F000FF;
	Mon, 28 Sep 2026 23:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790638471;
	bh=Odo7Wy05BdvbXbI9R8Wg3jQ4lGBNXbyVWTo5mvx8N9c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DGbEg+2lzPnCv5aHAWJdCcdESbbi8c+wlMNFJq4Yywrple1wwcqFlHSbHvFBTdeWo
	 LfLrnfEsqfkhz1np+lpP6lnlhXyO/QnBtwVHo4MOJ4bFjG2V6lslyKz0Emwq+JaYeB
	 7wMbmC3ZEqe0IJquhcyjfIeU+1gzWCvRrnSwlsvMFJ70DSV5AyeRt0ZvTpWx2HWwF4
	 3ZBZ4kIJIxaMKL6H8GiFVryDnaZkICjhCaBZRoZ6kG5xMqxJUhjGvvvCsf8bxjovm0
	 wKNCBbxUv81EFPe+WK+zdAPWbyLwckiZUYPqCQRVkLsQjAC3aqNmmtfbqjkBQ/qwT2
	 IMgZAe+Bl68Lw==
Date: Mon, 28 Sep 2026 13:34:30 -1000
Message-ID: <10b93dce66eb13a23fbab563df259092@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Paul McKenney <paulmck@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Christian Brauner <christian@brauner.io>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/7] locking: opt-in tracking of sleeping lock
 holders
In-Reply-To: <20260924155025.949998-1-shakeel.butt@linux.dev>
References: <20260924155025.949998-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Shakeel.

On Thu, Sep 24, 2026 at 08:50:18AM -0700, Shakeel Butt wrote:
> The answer is a count in task_struct. Only the locks that ask to be
> tracked are counted. The mechanism introduced here is planned to be used
> by solutions for shared lock isolation scenarios [1].
...
> [1] https://lore.kernel.org/20260921192559.2619635-1-shakeel.butt@linux.dev/

Let's resolve the discussion on the overall approach first.

Thanks.

-- 
tejun
