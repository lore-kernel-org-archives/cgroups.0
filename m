Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477BA4C4F7F
	for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 13:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792331908; cv=none; b=uqDlma+l1ekzRgrFhdWaofV+yBKPVQLaKPZ+K7fGDDBB+2DAbkZqaw5bcCdAjHY7p6HREug+60cOuYL0181YxrL0m/ck8efMTOCWo1mDdqA+HoOt7rvu9nxVQezLTEhRViIXk2sb86qI3VSufhqxxhiU7YqTHLeE4fQ+RbmuPPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792331908; c=relaxed/simple;
	bh=IwHavXJVs5lyTOCcn+pET+ahPXOw4vfy6zPC2ELLFdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cRTU9PffhW6tTVHQlKg3ojOxzsd6mmJF5TF6FIA4WIlVZZz/8YgXXT7CdI3O+1wF/9/Xno1O6umYM+NS+70cAk3wT2IP8BqrmdCrAYrxq/dkmhXkfWdxvhsC/UAWD4hHTOTSl61nHxV71kRrHTgij6QSvWBqBNb9H//3de34Kbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=PZMI4w2M; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="PZMI4w2M"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-7c03744ef27so289753137.1
        for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 06:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792331906; x=1792936706; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ayMWfGshO3UNwVYFCcSN2BNh422miW8cad5xrtcnUvg=;
        b=PZMI4w2MQRZzUU9IeVIa38517zEmudcio4i+U+Rm7RBsKFrLnnc7KXRC2kSh3EA3bu
         K+DCOu8JjEzqnsxTysqWYUb2KU22ydIvG/HeV2q31xT6HylIqghGEsypGHngXgdjm7Cz
         SSx1awLt0YgW4pIXDtfIFCb79/sB8O+lfASlhuBb8/5kw8Zthi8BDbx0dATSOs42d2PP
         bG7NeKlNyfvVrizMWXJiftjgsHiS3BOZqo+Ep4RWC/nqOkDveesjVCmz18fqvtD9f+Jb
         vXLd1lmmXu2FuwpzWOgeDPlDu2EvO20KZ3glq82KNmw7yb8nqpyOdQZ9aC7mPiuT4gMy
         SlIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792331906; x=1792936706;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ayMWfGshO3UNwVYFCcSN2BNh422miW8cad5xrtcnUvg=;
        b=Uzj7Nk80ZC0xJvA8mXpfMLvZ/QSxr002AnnY7rzjb6Nnm/MXHoHQHyUTF6jCESIDaW
         PddE/h7Tc5wUk8R8yWniKyvYP6vM15UgAZhBLKHqeB6pPh67+uEWZqv8NJazY5230Nsv
         ymANaN0C/Pn36zGfFKOfrpDiky+GxAS9HSaL0odjR2Yc9kVfkB5+c4B4ig+JvAIPHRiu
         OgQYdYEn6ZdFiH4SObPC8XtrQKqbxpCTsNrG/aJo7Qx/KBZxK1iBxJB6y7JmL7vXjY6j
         LAE34x1g75o68l8wpVjW9SUk3kojcadFnNcC3sS7OPdOrutmQP5/hbzRcJ3wvU3h25ek
         QNoA==
X-Forwarded-Encrypted: i=1; AKwUvBxNOqgV7jeLrVvW08SzGnXhw+qwk4NfQUSWZnh79YVCD0EtovlW96oLNgcut5BS27sNlOGq2XjG@vger.kernel.org
X-Gm-Message-State: AFq9FYJKY7omQV+FDkjSn0MG/eNcBI3kj+ZW2I409BSqgxBFXvsbtV8E
	5U2Z8xlNyJ5GGoesuGIPtuDr5V9oapDrimow07rJVcN5k2jurO2mJS4zXHhey3DX4ng=
X-Gm-Gg: AYBFou00xrr/xAP02dxQmTPKeZkCfiMqxr1ohcGpu4oWTfCoZw4XFTcnZkXsSyeae2l
	3erhZGbBaZBzePmwUIRtkKl9E8ZZU6y3KBp9ZcQ23EoMPF0H+4+wzf27BGheS9ehjvG+nlNsKB7
	WoXdg8/T0MGpHnPBP8MPWKNkDitNxgZnxAfmwzEcw03SHEFCCKehzwg4vASZbkUJnYtgYP1my9P
	wVXsC6Yb04RBiqWV9TlSNaZa8dK+BvYqdXy8C8oiBEJ6RvQFq1xGTHv/4kwsHkh/lZRcNd8qwZ+
	HlbC1VMubylHtMBIK/Z+XQdIQfakTiUG/BoFZUqMKVKhLveIrXwcm/xMG94ExivRkDhQ+SD8Kam
	qiZD97XqM/a4pr2WCLcg6p9vr+eNnUVZSnzkM00ZdzmAROuHjZ9fTDCsxCYn4iJ1E67hyN0B8Kb
	95JJ3rSAUKqrasuggt05tTK1RQnTMwlzDuVZx3jFxyIMRklXTdK6eQziRYpAmtL7i4oR+EOfyzH
	QxPRA+196+pwJQKPthD/pFCN7Md4vJns4GLR8Wh0Xd1M4YueeFtYO1iZyjf6xNHkraUfHoZlNQ=
X-Received: by 2002:a05:6102:5809:b0:7a7:19aa:f0d4 with SMTP id ada2fe7eead31-7cc36af7150mr1191922137.33.1792331906038;
        Sun, 18 Oct 2026 06:58:26 -0700 (PDT)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9908366328dsm6405154241.12.2026.10.18.06.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 06:58:25 -0700 (PDT)
Date: Sun, 18 Oct 2026 09:58:24 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, kees@kernel.org,
	rppt@kernel.org, juri.lelli@redhat.com, nik.borisov@suse.com,
	tglx@kernel.org, vschneid@redhat.com, kprateek.nayak@amd.com,
	vincent.guittot@linaro.org, bp@alien8.de, thorsten.blum@linux.dev,
	cgroups@vger.kernel.org, david@kernel.org, mingo@redhat.com,
	akpm@linux-foundation.org, linux-mm@kvack.org, seanjc@google.com,
	ljs@kernel.org, zhangguopeng@kylinos.cn, dietmar.eggemann@arm.com,
	mhocko@suse.com, vinicius.gomes@intel.com, tj@kernel.org,
	vbabka@kernel.org, linux-kernel@vger.kernel.org,
	peterz@infradead.org, surenb@google.com, hpa@zytor.com,
	x86@kernel.org, dmatlack@google.com, tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org, pratyush@kernel.org,
	dave.hansen@linux.intel.com, rostedt@goodmis.org,
	gmonaco@redhat.com, jgross@suse.com, mgorman@suse.de,
	graf@amazon.com, linux-edac@vger.kernel.org, liam@infradead.org,
	ridong.chen@linux.dev, longman@redhat.com, bsegall@google.com
Subject: Re: [PATCH v1 0/8] x86, sched, mm: Speed up CPU hotplug on large
 systems
Message-ID: <atTQgM72TWSFZ0AX@google.com>
References: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
 <atFGxagFo50iG6IS@agluck-desk3>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atFGxagFo50iG6IS@agluck-desk3>

On 10-15 14:33, Luck, Tony wrote:
> On Thu, Oct 15, 2026 at 11:33:23AM -0400, Pasha Tatashin wrote:
> >    - Patch 3 bounds cmci_rediscover() on CPU teardown. Currently,
> >      cmci_rediscover() broadcasts an IPI via on_each_cpu() to all online
> >      CPUs, serializing them on cmci_discover_lock while reading up to 32
> >      MCA MSRs. Because any disabled MCA bank is shared at most with an
> >      SMT sibling, L2 cluster peer, or die/package peer, probing a single
> >      online topology peer via smp_call_function_single() (or returning
> >      immediately when no shared banks were orphaned) reduces 479-CPU
> >      offline time on Intel from 11.42 s to 9.63 s (-15.7%) and total time
> >      from 22.50 s to 20.74 s (-7.8%).
> 
> I took this series for a spin on a timy 2-socket Icelake (36 cores, 72
> threads per socket). My test was to just offfline/online the 72 logical
> CPUs on socket 1, and I saw some good speedups:
> 
> 	offline: 4.833s -> 3.17s
> 	online: 6.157s -> 3.796s
> 
> I noticed that your cmci_rediscover() improvements mean even better
> offline performance if you work from high to low CPU numbers as the
> shared banks are assigned to the lowest numbered CPU within the sharing
> topology domain. So working from high to low avoids creating as many
> orphan banks that then need to find new owners.
> 
> 	reverse order offline: 2.984s
> 
> I haven't looked into the code yet. But the general direction seems
> good.

Thank you for the data, and your point about the ordering is spot on. 
However, once single-thread performance is adequate, my end goal is to 
parallelize the operation so the number of CPUs won't significantly 
affect the total time it takes to remove them and add them back to the 
scheduler. This is crucial for the live update work, as transferring CPUs 
to Caretaker is part of the brownout, and in some configurations, the 
blackout of the live update process.

Pasha

> 
> -Tony
