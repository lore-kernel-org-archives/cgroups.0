Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56382E889C;
	Sun,  2 Aug 2026 06:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785653229; cv=none; b=rmJjRfoZDM6kxuzZ8p2XAY9Ih7GNkldJoJhHye85JG9LP4SJnS+1y6A4dktKPD7QU38yX6dpXBiqbaOKJqdz31+DYoc+9NNkr57NQMxmXAkHo0m1t8YJ4pCGTF8OBnQSLORaSvjN4rh441aTewhmIhFT5O0lfoo9TAPSClHeLMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785653229; c=relaxed/simple;
	bh=w1XnZZfX4CASt4ISwoSyVBUUeTx3MMjUHUrDepUmyLI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=aVzbcePsuzlg6BVXqOzurPR70m8d0y0hiHpzSPOUO2IuZlzyVv73XzCprpE/c5UkpkzJqpz6RO1JdiH+WrC1IV8X7dWwu8zaUesv8pkGi3pYfr+HjspzL/mYxGZoCdmDQr9Jzaz8xi6q4ozybFj7nU/V/P1i8Cj2qa58aIWmWF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=kaRh9z5z; arc=none smtp.client-ip=192.134.164.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="kaRh9z5z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=Xi+CuHa3gULM75LV5l9bfmB5xNp2lanprllCYc1ilL8=;
  b=kaRh9z5zshc3fOszGeepcMxf6SO1kxX57ZMdNx5rQ6CiIjJZF2h1WJCt
   lw4ixPmW88GQ561mDMA9exV9k125AEaGbxnFwn5PxxTmw0YETrY21Rr+e
   3oVaryt4T2+tCox5mWDt5/OWrEmB5Vti4dcUpFkiGKQ3IsW7/A/Tn//h0
   Q=;
X-CSE-ConnectionGUID: fJjSMKA6SCC/xsXpAkRo2w==
X-CSE-MsgGUID: qe5HC/awQMW1ZeDNawnnww==
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.25,200,1779141600"; 
   d="scan'208";a="288795703"
Received: from 88-188-149-159.subs.proxad.net (HELO hadrien.home) ([88.188.149.159])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2026 08:47:02 +0200
Date: Sun, 2 Aug 2026 08:47:01 +0200 (CEST)
From: Julia Lawall <julia.lawall@inria.fr>
To: Waiman Long <longman@redhat.com>
cc: Tejun Heo <tj@kernel.org>, kernel-janitors@vger.kernel.org, 
    Johannes Weiner <hannes@cmpxchg.org>, 
    =?ISO-8859-15?Q?Michal_Koutn=FD?= <mkoutny@suse.com>, 
    cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: drop unneeded semicolon
In-Reply-To: <8797e8b8-59ce-4934-ac0c-7f9731de454b@redhat.com>
Message-ID: <edfb8ac2-ef9-1a8b-4355-309644d71d33@inria.fr>
References: <20260801191002.1383835-9-Julia.Lawall@inria.fr> <8797e8b8-59ce-4934-ac0c-7f9731de454b@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1153082744-1785653222=:26964"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1153082744-1785653222=:26964
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Sat, 1 Aug 2026, Waiman Long wrote:

> On 8/1/26 3:09 PM, Julia Lawall wrote:
> > When a function-like macro expands to an expression, that expression
> > doesn't need a semicolon after it.  All uses have been verified to
> > have their own semicolons.
> >
> > This was found using the following Coccinelle semantic patch:
> >
> > @r@
> > identifier i : script:ocaml() { String.lowercase_ascii i = i };
> > expression e;
> > @@
> >
> > *#define i(...) e;
> >
> > Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> >
> > ---
> >   kernel/cgroup/cgroup.c |    2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > index 38f8d9df8..f87fc4550 100644
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -104,7 +104,7 @@ DEFINE_PERCPU_RWSEM(cgroup_threadgroup_rwsem);
> >   #define cgroup_assert_mutex_or_rcu_locked()				\
> >   	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&			\
> >   			   !lockdep_is_held(&cgroup_mutex),		\
> > -			   "cgroup_mutex or RCU read lock required");
> > +			   "cgroup_mutex or RCU read lock required")
> >     /*
> >    * cgroup destruction makes heavy use of work items and there can be a lot
> >
> The RCU_LOCKDEP_WARN() macro is basically a "do { ...} while (0...)"
> statement. It doesn't have a ';' at the end.  So your commit log isn't right.

OK.  Indeed I didn't take into account the definition of the macro.  The
usage context does have another semincolon, which is what is mentioned in
the commit log.

>
> An additional semicolon at the end doesn't harm. By removing the semicolon,
> even if not needed, may make people wonder if it is right when reading the
> code wasting their time to figure out if it is all right. So I don't see any
> advantage in removing it.

No problem to drop the patch if you don't think it's useful.

julia
--8323329-1153082744-1785653222=:26964--
