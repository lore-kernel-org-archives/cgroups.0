Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B74360EE9;
	Sat, 10 Oct 2026 22:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791671837; cv=none; b=Onej+9y/iU1TsneqsPtWDvQ1ETp8jS8DhSNND2J4dk1jQ6tImz1PsHqK11/xK+VTG75Hpf2IbJ6lPJRZtOPVlTi3KHvvahLRs96oiDvAj6VYu1Zv6QMjrtDHFDpx+/kOyUKd1lW4g2utCCOnkGwu6z7qE+Hy5fqJ1kVcV8g5jjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791671837; c=relaxed/simple;
	bh=2jQP3niKt8U/Ep7ahCao2qiOVSHp1AFhrCWpWfPsXnY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ZCyERyKQgaEqChCfvZe4HMULjgDdN1EjlzjrWVnbP8Gv2F0VfuNtC27edgGE9g1yzuLwsensxGFxd9s5O/gDTkb48UEMvXVb7QQb1scCPZNI7YE37nDZ+3K1ggihwiu+9ZnnwNdU3Se7b3+ft1r2LAEyw6fXvkw59bklGEssR1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fq/qR4nj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fq/qR4nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C9F1F000FF;
	Sat, 10 Oct 2026 22:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791671835;
	bh=F68y83UadITGcYpyHBAEFVCJXmV4RkKPjbHgQ41khuw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Fq/qR4njOEsOt6b95HccOD/dyBM+YGPreJy5+PLZjozQsmTx8UJ4N5YJSQi3SXJdX
	 ThoxZk3fp/mmy8AVHIAP4/oeGcHQ+ELd3CmTg4QQpFqC/tbt32RaCJxH7DwjyRGoCW
	 RzAWqoz62TQrfd4qA6gVJ3E8Kpfj/+OSaZ2jVrmI=
Date: Sat, 10 Oct 2026 15:37:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <kees@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Roman
 Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, Pedro Falcato <pfalcato@suse.de>, Kuniyuki Iwashima
 <kuniyu@google.com>, linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
Message-Id: <20261010153714.b9e91801ea93675da099e903@linux-foundation.org>
In-Reply-To: <202610092010.934197B@keescook>
References: <20261006092030.got.500-kees@kernel.org>
	<20261006092035.166776-2-kees@kernel.org>
	<asjhg2e4-WSeKuXd@thinkpad>
	<202610092010.934197B@keescook>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 9 Oct 2026 20:14:20 -0700 Kees Cook <kees@kernel.org> wrote:

> Anything with Fixes: will end up in stable, so I just leave off the
> stable CC these days.

-stable maintainers have been asked to Not Do That for mm patches. 
Other subsystems are doing the same.

I don't know how they determine whether something is an mm patch.  A
patch which covers do-do-that and dont-do-that parts of the tree is
likely to be mishandled.

So yeah, add that cc:stable to reduce the possibility of mistakes.
