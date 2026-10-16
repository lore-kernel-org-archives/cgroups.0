Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE26317166;
	Fri, 16 Oct 2026 22:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792191547; cv=none; b=E51CbjrcRI/9HoGVYwQOgLFGm1cglm3+u6FDhOmd7KOppYYILoOgv9B8KJ5VXedjFa1KOhu87Le7r43NB1zmErdOcGDXVvC7Zv8zbgKLC5ZbFG1usrPmRIipaxUVLymsrraPE1KhCra+EhBqPsugC+uNAiICEIp/eIE46CcV0Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792191547; c=relaxed/simple;
	bh=7CN2sWylHLMTfbtQ64it+kFHyCkbiD5pCb8+yR+bEjs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=h4VvcC4XBCpVii+6EFVrO5Viz6IigUMTGfwvmCYVS7Qg3p7lhL4qFBjjj/ABmI5HWgLl2cW3VSNPlPiZ3rRUpE7AOQfH9meUmJG89fXie6WjUWNd4WbcJg7TeSR59qoVy5ZHn2RDGPWSa6jrX1KNQutxvksZsYkObUeRCbFmLhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K0iehqGc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K0iehqGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B501F000C4;
	Fri, 16 Oct 2026 22:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792191546;
	bh=2XIZw4yIu0sI+8wa1+fQEbc6VQXsqxREgHYBNQYWVKI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=K0iehqGcH6OaYxRdNrNEpl3rtaVqerqvgIjRBbpdxMovHc2N5nmd5gk9tKrViP3B+
	 CVCq3cr9444LCA25tUNknkzy+Gm2THEOSPkIVShx18Q3s7BRkV6c/EuTXDzecbAv+6
	 2CwNsL4Eu6qrnPjbXX8WPiP+LUgzjNiLytIU2bIg=
Date: Fri, 16 Oct 2026 15:59:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wang Yingjie <x-professor@outlook.com>
Cc: Alexey Gladkov <legion@kernel.org>, "Eric W. Biederman"
 <ebiederm@xmission.com>, Manfred Spraul <manfred@colorfullife.com>, Vasily
 Averin <vasily.averin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org"
 <cgroups@vger.kernel.org>
Subject: Re: [PATCH] ipc/sem: account enlarged sops arrays to memcg
Message-Id: <20261016155905.2a659b7bb7d61f33467a3263@linux-foundation.org>
In-Reply-To: <20261016152609.2528805-1-x-professor@outlook.com>
References: <20261016152609.2528805-1-x-professor@outlook.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

(Alexey, Eric, others: please weigh in)

On Fri, 16 Oct 2026 15:26:11 +0000 Wang Yingjie <x-professor@outlook.com> wrote:

> Commit 50ec499b9a43 ("sysctl: allow change system v ipc sysctls
> inside ipc namespace") lets an IPC namespace owner change kernel.sem.
> The SEMOPM field defaults to 500 but has no semantic range check.
> 
> do_semtimedop() allocates nsops * sizeof(struct sembuf) with
> GFP_KERNEL. A blocking operation retains that buffer, so a user can
> raise SEMOPM and hold large attacker-selected amounts of host kernel
> memory without charging the calling task memcg.
> 
> On the current mainline base, one 10,000,000-operation call retained
> 60,936,448 bytes while a 32 MiB cgroup peaked at 909,312 bytes and
> reported no limit event. Sixteen 1,000,000-operation calls retained
> 100,860,416 bytes while the cgroup peaked at 1,310,720 bytes.
> 
> Commit 6a4746ba0619 ("ipc: remove memcg accounting for sops objects in
> do_semtimedop()") removed accounting on the premise that the buffer was
> at most two pages. Preserve that default-sized path, but account arrays
> larger than the default SEMOPM value.

OK, I think. But...

> With this change, both test configurations reach the 32 MiB cgroup
> limit and the caller is terminated by the memcg OOM killer before it
> can retain the enlarged arrays.

Only if memcg is enabled and the task's memory cgroup has an effective
limit.  Otherwise we can end up handing out idiotic amounts of kernel
memory.  Memcg accounting isn't a substitute for limiting the
allocation size.

> The sysctl also accepts negative SEMOPM values. Since nsops is unsigned,
> SEMOPM=-1 bypasses the intended operation-count check.

Let's fix this first. nsops is unsigned int, whereas ns->sc_semopm is
int. In the comparison nsops > ns->sc_semopm, a negative SEMOPM is
converted to unsigned, so SEMOPM=-1 effectively sets the limit to
UINT_MAX.

I'm thinking:

- Permit init_ipc_ns.sc_semopm to be set to any value from 1 to INT_MAX.
  This preserves the existing ability of host root to configure larger
  limits.

- For all other IPC namespaces, permit values from 1 to 1000. The
  documentation has long recommended 1000 as an upper limit, although
  it hasn't been enforced. This would be a new restriction, so the
  changelog should explain why we're introducing it.

- Validate the new values before installing any of them.  The current
  proc_ipc_sem_dointvec() updates the live array directly, and
  rejecting an invalid value afterward would leave a window in which
  other tasks could observe it.

- Update the comment in include/uapi/linux/sem.h. The warning about
  physical memory fragmentation is outdated now that the allocation
  uses kvmalloc(). Document the new 1000 limit for non-initial IPC
  namespaces instead.

Ideally, a new IPC namespace would inherit its parent's configured
limit, but currently every new namespace starts at SEMOPM=500. I don't
think we need to change that as part of this fix.

Then please redo your memcg-accounting patch as a separate followup,
with suitably adjusted changelogging. That would provide additional
protection for legitimately enlarged allocations in the initial IPC
namespace and for allocations between 501 and 1000 operations elsewhere.

Thanks.
