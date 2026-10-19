Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A182836B913;
	Mon, 19 Oct 2026 04:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383319; cv=none; b=V0rMqVuBPSaRm1yGSUaeI2ovhbrWnNSqAJ7q2KIn1HcVPQ4k1fIjPAMXUsRZY+l4Ccq49UeKFeHgBoEqQA+E64xgrG/+V03xpl+FMTKBOBuSV3fY9IjjGbl5quq4o4NVLoWlAowalXOcFcU7VLyThGUmTo2mg1rGHTuLN522ETI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383319; c=relaxed/simple;
	bh=TrUgULCObwvAj6sB827ol0DTcAdZxmFbjyO8N2F1jUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iiN0ZaL59pjeEF9adcDP+64OJM07Fh6pdFXHoiBKbywlG8iCI5I3K3WM0ReWem9aemElmWVOaEdfoiwTBBjDpzUoNPHe4telijA9dPyceRJCK0oM+3OivOxpU3IwyLq7CLofd9z4JEKhZtyLzdkK+fhX6i3WkNm1C+FB8Jbzkus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=krQRunRK; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="krQRunRK"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D5B6740E015B;
	Mon, 19 Oct 2026 04:15:11 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ErKCFo8JYxqO; Mon, 19 Oct 2026 04:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1792383308; bh=p7h+Wad+pyLNKMyu/1QoznQu9hqJDkJyBcK35tN0uCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=krQRunRKTqK6d2hTGjOH7yn/uQLDHxmKKlr1aGOby1aaVDc3GQrHaj1IbHWOFlLpQ
	 T0aQX0GmkWvWAFeSOegTniHGVsARBfFAB06fcbjuLrWPhIKC/oAX7Bl601zhD8ndNq
	 ptyxCShUW2IE9OxOjox9vj5EQMH1EUUctJ2JrLryVXfJ2dV6U9hoowGqsxUAxz9nZ7
	 b8/vjju9uRSXpWyG0+CVSObizaWmtlropor31KW9i7tzRE0Z5aZEpEjEOKu4sYvDgX
	 MlHm5C5wZcM+6vPu+wG5g7WynB++k1HYbh8B4mEwhJiTNThdlr0MSohDfmpmAh4gD3
	 iyIu+YfaXIYay+jjre1VSA+hD5Rp5W4+Cf0O1E1baJaIVH4Fh00se5dOdIn/FjZZ8f
	 x9IAGu5v8nRy7U82DAPnJGWcEto1cmy0Y7wrdvheY+mSWJfVs/GWse7sW+GdrOlMP1
	 7ukpv+FOUfYnAl/Twyohy2+MffdW2FXFdcg0WMVznkid71/QccRVzn+MK8mNW1TLiw
	 AicMdVAv7J5PoXdnDUeE0PXklFDbyX+au9v0CfMXAD70lX/nXv7mFSGiQuM0KDy90M
	 9XuIeljxPNEzFtqGVD9zd+gQm/o9UaoecMe/PHoqwnbBVuPeUYOCdfvvvCMIh1un+a
	 1RBQnMXpnN4JqWjZTLBCi1W4=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 465DE40E021A;
	Mon, 19 Oct 2026 04:14:23 +0000 (UTC)
Date: Sun, 18 Oct 2026 21:14:20 -0700
From: Borislav Petkov <bp@alien8.de>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kees@kernel.org, rppt@kernel.org, juri.lelli@redhat.com,
	nik.borisov@suse.com, tglx@kernel.org, vschneid@redhat.com,
	kprateek.nayak@amd.com, vincent.guittot@linaro.org,
	jpoimboe@kernel.org, cgroups@vger.kernel.org, tony.luck@intel.com,
	david@kernel.org, mingo@redhat.com, akpm@linux-foundation.org,
	linux-mm@kvack.org, seanjc@google.com, ljs@kernel.org,
	zhangguopeng@kylinos.cn, dietmar.eggemann@arm.com, mhocko@suse.com,
	vinicius.gomes@intel.com, vbabka@kernel.org,
	linux-kernel@vger.kernel.org, peterz@infradead.org,
	surenb@google.com, hpa@zytor.com, x86@kernel.org,
	dmatlack@google.com, tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org, pratyush@kernel.org,
	dave.hansen@linux.intel.com, rostedt@goodmis.org,
	gmonaco@redhat.com, jgross@suse.com, mgorman@suse.de,
	graf@amazon.com, linux-edac@vger.kernel.org, liam@infradead.org,
	ridong.chen@linux.dev, blum@kernel.org, longman@redhat.com,
	bsegall@google.com
Subject: Re: [PATCH v2 0/8] x86, sched, mm: Speed up CPU hotplug on large
 systems
Message-ID: <20261019041420.GCatWZHINJx7DIhXSP@fat_crate.local>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261019011446.834487-1-pasha.tatashin@soleen.com>

On Sun, Oct 18, 2026 at 09:14:38PM -0400, Pasha Tatashin wrote:
> For live update we require a fast CPU online and offline capability.
> However, sequentially offlining and onlining all application processors
> on modern high-core-count x86 servers exposes a series of hardware and
> algorithmic bottlenecks across arch/x86, the scheduler topology builder,
> deadline bandwidth accounting, and vmstat.

From: Documentation/process/submitting-patches.rst

"Don't get discouraged - or impatient
------------------------------------

After you have submitted your change, be patient and wait.  Reviewers are
busy people and may not get to your patch right away.

Once upon a time, patches used to disappear into the void without comment,
but the development process works more smoothly than that now.  You should
receive comments within a week or so; if that does not happen, make sure
that you have sent your patches to the right place.  Wait for a minimum of
						     ^^^^^^^^^^^^^^^^^^^^^			

one week before resubmitting or pinging reviewers - possibly longer during
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

busy times like merge windows."

+ the merge window just opened.

So stop the spamming please.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
