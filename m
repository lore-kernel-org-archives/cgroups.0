Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7621C2324
	for <cgroups@vger.kernel.org>; Mon, 22 Jun 2026 19:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782155035; cv=none; b=YiYNTf5dN+roZxFkshOknICJtn47cccdC6p6MnVswMo5UEZHB0owqujCVZXSztWctVCrCaYq62S6Ufr4QRJn2qD2+iMSvRMFq36g8c2OvxxK1jGHCShfnGgbljkOFLXDl4ZBm/dl1rdYXjFKxxmqANiIVKAEqe/3SvROW9vZU1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782155035; c=relaxed/simple;
	bh=uM6rjwv+rWrcNEl8KjTKnVcDSG3oUNpsPUMqnFOcLeE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=F8XfVL0JZ538CgPlZZ6gTwgXnmVB9ai4mZT3t1gMO6BPYUtw2388vIUWmpZznH1Dj0dJogIn7puvJzwM7ArdqI14JFbleRUG40v5PtlDBJDSbFM/mh/AiYWjjSf/czbsoV88jOVeZmoTT46RlJfsfymDWqgeShcCXivAPi2Q/gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LFiZE21b; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LFiZE21b"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-3042a388168so186233eec.1
        for <cgroups@vger.kernel.org>; Mon, 22 Jun 2026 12:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782155033; x=1782759833; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uM6rjwv+rWrcNEl8KjTKnVcDSG3oUNpsPUMqnFOcLeE=;
        b=LFiZE21bJOd27mvhUeQY65zQorGfroSNylZhnl5pr3qjxqG/eN1p6cReYMi7Y8XHb0
         7P2yUKScTc7SL9KBMwdl8WT1nEKnGZf9ur45NKJJuEmRNsVr4TarSwghnJCBC39U5FT/
         hbLMbAuZB7Uhid7P768tqQ5oB5rNa0UgEghjqL8I6E/OiecFdkW7XXJUCVzAvM2Bcvqj
         aAAg70ofC8G+A3+uW7Vx2nk3e0tc12ATFJvEbWA6+4EjPe4CrUqJXP2Emg2HT57KZ67b
         LsX6aiKqdjYFThFXLMKvM5eHENHiOf+kS4D8rdkQabgcObx3aWN/R9FVWrU0LGgqTlRe
         mYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782155033; x=1782759833;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uM6rjwv+rWrcNEl8KjTKnVcDSG3oUNpsPUMqnFOcLeE=;
        b=APR/m0XQ0/rLON8F2YoeTfuhuVnC+i1bHDBGUbEMxbATM/o+Zd2XQovxWjroPuGaUD
         r58FMd5M5dmyrlSQr4C2JqAeWsF7jTct0XvaysfWAmPmO9oe+ePaF0OH077ANo2ca7Cf
         r/AY3uMGTcLXWFY0s8Sc3ApydZWbBv3zF1/sdaKp5k61RBtQ1B0Log0ppf4tPVrgZwAB
         dires44FPIAD3rYLLI6AkfQ0fMRE3x1RUp8vxgEXDku0pEDuCKrCb24O8eE4Th7j2skZ
         EVNTj4MP2sIvKt02Sf4H5fPPMaAM7+QzGTcfddGI+9iJZijKUcuauPsnYVoOsGgU8H3s
         bNdw==
X-Forwarded-Encrypted: i=1; AHgh+RqEPoXT0a98AKfu0xZSmaS461nBJHtXtjV8IiC5q1cltpjpTF/aK10jMth02HUowtNS6kgH8q0t@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8Q/j3IKE+I1b/FW/bb0U5R1Idc7grGLKeqCATzooO+c+MzSqW
	eHc839IYcv+n3kt1/N3P5L1uTcqtVJsn7zO6EiRezp+CQDAG3laTi10Q
X-Gm-Gg: AfdE7ckwQqo/CiEHplBZKsKceRawIAQISAk0wN4/7g4kKcmFDjhZdTfofgFnzeRcsj8
	4jCKFCa7gXeSmyWIK+nesmqtUoy8p1l844k5fJ6jxnFjkBAVjKfJsOkojiwOnGsijmC25AB+prH
	tLUNt+osQ6xH1RALJHX/6Fhvr4PCQUtpcU+g/BFkMmvWNrSjhutaoklI5NDlHlI9oexnpgg0UZU
	YO177v7lurBYa7DVrdxxAWXsvTOdOVJPRFmI9FmAQXVz4tc9uqxj47Na2DBgLZJjDA19ZFGADPC
	5dF4TtbUIpYM+/8ZOjZTDSuSNZtNRCmZIuTBQxX8/70Qhc/bIG6Oh2XiaXM7SPcwzEerOLEnCIS
	a/mWnNevSFhIFO+44HbJUGHQ/yRrpxE6apN7WCrNtNlkZlIay0R47e46yZR1IzEOzEW3gWKfY67
	Gpz7Huzmk0U92WoN2T8W3PoJIpvvB+ZcbhB0kI4JFsjv31UNNI4ONcpxBmFUCXnwVi3pQ=
X-Received: by 2002:a05:693c:2887:b0:30b:cc4e:6396 with SMTP id 5a478bee46e88-30c5553b105mr382073eec.7.1782155033135;
        Mon, 22 Jun 2026 12:03:53 -0700 (PDT)
Received: from ?IPv6:2a03:83e0:115c:1:6e2:c699:67c:63fe? ([2620:10d:c090:500::1:5387])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c1be4967fsm10549199eec.26.2026.06.22.12.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 12:03:52 -0700 (PDT)
Message-ID: <1979fc81ae7bdaabda8616cd9698a40ef8bbfaee.camel@gmail.com>
Subject: Re: [PATCH v3 5/7] kernel: Use mutable list iterators
From: Eduard Zingerman <eddyz87@gmail.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>, Paul Moore <paul@paul-moore.com>,
  Eric Paris <eparis@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann	 <daniel@iogearbox.net>, Andrii Nakryiko
 <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Jakub Kicinski	 <kuba@kernel.org>, Jesper
 Dangaard Brouer <hawk@kernel.org>, John Fastabend	
 <john.fastabend@gmail.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner	
 <hannes@cmpxchg.org>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, 
 Maarten Lankhorst	 <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>,
 Natalie Vock	 <natalie.vock@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar	 <mingo@redhat.com>, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Namhyung Kim	 <namhyung@kernel.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov	 <oleg@redhat.com>, Peter
 Oberparleiter <oberpar@linux.ibm.com>, Andrew Morton	
 <akpm@linux-foundation.org>, Baoquan He <baoquan.he@linux.dev>, Mike
 Rapoport	 <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav	 <pratyush@kernel.org>, Naveen N Rao <naveen@kernel.org>,
 Josh Poimboeuf	 <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes	 <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Will
 Deacon <will@kernel.org>,  Boqun Feng <boqun@kernel.org>, Luis Chamberlain
 <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,  Daniel Gomez
 <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, Steffen
 Klassert	 <steffen.klassert@secunet.com>, Daniel Jordan
 <daniel.m.jordan@oracle.com>,  "Rafael J. Wysocki"	 <rafael@kernel.org>,
 Davidlohr Bueso <dave@stgolabs.net>, "Paul E. McKenney"	
 <paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>, Frederic
 Weisbecker <frederic@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes	 <joelagnelf@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Juri Lelli	 <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Kees Cook <kees@kernel.org>,
 Balbir Singh <bsingharora@gmail.com>, Anna-Maria Behnsen	
 <anna-maria@linutronix.de>, Thomas Gleixner <tglx@kernel.org>, John Stultz	
 <jstultz@google.com>, KP Singh <kpsingh@kernel.org>, Matt Bobrowski	
 <mattbobrowski@google.com>, Nathan Chancellor <nathan@kernel.org>, Martin
 KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>,  Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, David Vernet	 <void@manifault.com>, Steven
 Rostedt <rostedt@goodmis.org>
Cc: audit@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, 	netdev@vger.kernel.org, cgroups@vger.kernel.org,
 dri-devel@lists.freedesktop.org, 	linux-perf-users@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, 	kexec@lists.infradead.org,
 live-patching@vger.kernel.org, 	linux-modules@vger.kernel.org,
 linux-crypto@vger.kernel.org, 	linux-pm@vger.kernel.org,
 rcu@vger.kernel.org, sched-ext@lists.linux.dev, 	llvm@lists.linux.dev,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Date: Mon, 22 Jun 2026 12:03:46 -0700
In-Reply-To: <20260622042811.31684-1-kaitao.cheng@linux.dev>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
	 <20260622042811.31684-1-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (3.60.1-1.fc44) 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-06-22 at 12:28 +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>=20
> The safe list iteration helpers require callers to provide a temporary
> cursor even when the cursor is only used internally by the loop. This
> leaves many functions with otherwise unused variables whose only purpose
> is to satisfy the old iterator interface.
>=20
> Use the mutable list iteration helpers for those cases. The mutable
> helpers keep the same removal-safe traversal semantics, while allowing
> the temporary cursor to be internal to the macro when the caller does
> not need to observe it.
>=20
> Convert list, hlist and llist users under kernel/ where the temporary
> cursor is not used outside the iteration. Keep the explicit cursor form
> where the next entry is still needed by the surrounding code.
>=20
> No functional change intended.
>=20
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---

Beside the fact that this does not apply,
I don't see a reason why is this needed for BPF sub-tree.

[...]
