Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B608E2FF164
	for <cgroups@vger.kernel.org>; Fri, 20 Feb 2026 16:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771606663; cv=none; b=hIg7pCfrCwaJH000pTmJ7+jmlAuIJuHtX3RJBrxC0y8UqvrzdghTqZM8211LmOXNjlnpjGqF4MLFfo2rev9/p6TV4VfGRZVIzDJQM1pC0fbGfknzZKfT5CmgJTdTh/N99BeNBkJeSNtzptOftbJAAjHbYuubhOZDhnlP/we9uUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771606663; c=relaxed/simple;
	bh=cAS+G5NxeRxa2EgBonAJ6Nr0/6q4BTUxv7Uxpi8YpVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y2jRkdH9AVTgRAlqWJxTEGH3fpY9gBR5WXExhHFdm4/iykqgVDIB9RsLUtc2WOVD4XKEpBinn0pvAm2rE61wBbIAsaRsL+LCHOgwYzcU+1jL7+jp5CY/LhAwe93M1ew4+QD0yi2YpDR9uE6r4zq8OSywEpJ1DPRZFgZAUFCaVR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hvID6KTk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hvID6KTk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771606660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ppw4K3DbmN7RYbMzOdLadd1esQw4LW4oIH3NAVRbdGA=;
	b=hvID6KTk7cJ8KfTm12IqeVih2XA09Q3i3rzjImHhHCPiHxq5AMXVUSMU+KqjpNgSXcLFFe
	wBIZ1v/3sCDyMeS42hFCZfGu3I5Yz2tlqnNwHLFl1Ef8QiCSpdv4E3VGl50ut5S+Io5E8p
	kwbp/Z/BVKXdzTrg6Bqt0vPvmQ0q+PE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-252-3ATclVuAMMCAteY8vl0Zow-1; Fri,
 20 Feb 2026 11:57:37 -0500
X-MC-Unique: 3ATclVuAMMCAteY8vl0Zow-1
X-Mimecast-MFC-AGG-ID: 3ATclVuAMMCAteY8vl0Zow_1771606655
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2210B180057E;
	Fri, 20 Feb 2026 16:57:35 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0CC61800671;
	Fri, 20 Feb 2026 16:57:33 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 6B833401E19EF; Fri, 20 Feb 2026 11:30:16 -0300 (-03)
Date: Fri, 20 Feb 2026 11:30:16 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Leonardo Bras <leobras.c@gmail.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aZhv+Bw7nKKmbFdq@tpad>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
 <aZdk19MqYhWK90Do@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZdk19MqYhWK90Do@tiehlicka>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Thu, Feb 19, 2026 at 08:30:31PM +0100, Michal Hocko wrote:
> On Thu 19-02-26 12:27:23, Marcelo Tosatti wrote:
> > Michal,
> > 
> > Again, i don't see how moving operations to happen at return to 
> > kernel would help (assuming you are talking about 
> > "context_tracking,x86: Defer some IPIs until a user->kernel transition").
> 
> Nope, I am not talking about IPIs, although those are an example of pcp
> state as well. I am sorry I do not have a link handy, I am pretty sure
> Frederic will have that. Another example, though, was vmstat flushes
> that need to be pcp. There are many other examples. 
> 
> [...]
> 
> > You can't delay either kmalloc (removal of object from per-CPU freelist), 
> > or kfree (return of object from per-CPU freelist), or kmem_cache_shrink 
> > or kmem_cache_shrink to return to userspace.
> 
> Why?

Because kernel code might need to use that object right away, so it
needs to be allocated right after kmalloc returns.

> > What i missing something here? (or do you have something on your mind
> > which i can't see).
> 
> I am really sorry for being really vague here. Let me try to draw
> a more abstract problem definition and let's see whether we are trying
> to solve the same problem here. Maybe not...
> 
> I believe the main usecase of the interest here is uninterrupted
> userspace execution

The main usecase of interest is uninterrupted userspace execution, yes.

It is a good thing if you can enter the kernel, say perform system 
calls, and not be interrupted as well.

> and delayed pcp work that migh disturb such workload
> after it has returned to the userspace. Right?
> That is usually hauskeeping work that for, performance reasons, doesn't
> happen in hot paths while the workload was executing in the kernel
> space.
> 
> There are more ways to deal with that. You can either change the hot
> path to not require deferred operation (tricky withtout introducing
> regressions for most workloads) or you can define a more suitable place
> to perform the housekeeping while still running in the kernel. 
> 
> Your QWP work relies on local_lock -> spin_lock transition and
> performing the pcp work remotely so you do not need to disturb that
> remote cpu. Correct?
> 
> Alternative approach is to define a moment when the housekeeping
> operation is performed on that local cpu while still running in the
> kernel space - e.g. when returning to the userspace. Delayed work is
> then not necessary and userspace is not disrupted after returning to the
> userspace.
> 
> Do I make more sense or does the above sound like a complete gibberish?

OK, sure, but can't see how you can do that with per-CPU caches for
kmalloc, for example.

