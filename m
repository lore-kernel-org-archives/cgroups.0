Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794589044;
	b=mz77wmivoYSnPz3ULHe5iI3mk5hzdUjuNrtm/eZ7OAzpEBEW37+gDCPO9bIdccH7Ew0y
	 oHE5f5VaOi+fYTggiDAy5tjpUrnhLDT+ltUhMgCgYwv/RllkI52O6zmcHIK9ymHO/4MTn
	 NJ186kIoUOIV1BsiCzvngao1/OwVW3le1xQeWduWpPyfFbsH4Y5B9pkmHk58jv/juqD4d
	 YQVWactHOgUSl1vKIcDIZZCXwlUmAYSheeT0gKZTM+DcQG5ZfU0tdQGHavUrsRC59dAC2
	 lG5oh09ZQHIzrUyvTKIXOACEJgfkyZM27tHynFq1tqE924oc0NTibGv+HtqCq9p9pzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794589044;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=t7R90zeBhuCAPBYRWGVInzQKZ8XGZNdOKwhHfCCRUDk=;
	b=WL4OiJHxKrSSFjmNc4wTdBsLAaa8LW4/PxL8DWORZ7p6/rLdw3JkIWYOsD2gM9LKJIAN
	 NuFyuoYY6KjB0IEGn6nDN0mpAluQJSy1MJmeGnq15OOV4Gon/IsJKJNatd3eay7GXyZpD
	 FlxlEGjUSFvwJnNsi6Pxkw/hGG4nwFbOe9x9m2Qai7tDNJZQJVy5rfClVbyrAXCqDAKtw
	 SDXW+V41Pg5YbZSbyA6vSICQoLXlZpDPC5+geh0BYkQ4NjUb6Zw33wz/N4puMTg7+PI+s
	 1//ebe6Wkn3QW2gPjIlLLXqLGAkiCskEWPR+GOyHEvT1/FkmH0sregWnZ2VRXCpnx/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MF3zm1Je;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=AZRJTjLl;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE40606A335
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 16:57:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACE40606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MF3zm1Je;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=AZRJTjLl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794589042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t7R90zeBhuCAPBYRWGVInzQKZ8XGZNdOKwhHfCCRUDk=;
	b=MF3zm1JeiL5WZQ9A1terY6B/MuTQJMZnTn8mF1WR048ahPKE42s9Gn1jts4fs1imaTW9tY
	jxGOk5dUXc8DzDE1s8luwNroMgmVagJ/YgFMtFYUmt9f3t0v72IOdSlm83g6gBBhsIQ6jQ
	Q3HtHUC01cmhXmlPlA9roJG5TnDIyBE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-XTfnCu5DMeKwtN9akZhJgA-1; Fri, 13 Nov 2026 11:57:21 -0500
X-MC-Unique: XTfnCu5DMeKwtN9akZhJgA-1
X-Mimecast-MFC-AGG-ID: XTfnCu5DMeKwtN9akZhJgA_1794589040
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-490c1867460so616888f8f.2
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 08:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794589040; x=1795193840; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t7R90zeBhuCAPBYRWGVInzQKZ8XGZNdOKwhHfCCRUDk=;
        b=AZRJTjLla20/bOP0upZA9DbntAjJGTMNRT3S8PlEwzRNCXOTwmz7ChdydZogcVmJTR
         Mc++h2/Ld2VCoAw45JbOfNAh3ny0mAlqq3Q/RvvMzAHMKTCwOpE/n0UJVUzLctm8haox
         hGH0v5bA8SPIRiEW8/+44HBLPtSeJ8AMb8OTNDcwsOHv4B2vKE8HWmhDwLRez/1Wo45U
         RCkHO0FuuHyBehHWDdybkyuk4wqSlnTfAXMS/on79RCztKaeIZJh64cHBnjbBVvFAdMG
         IQyjPw7EolOtSCaEtc4/wrP4kITjqCJW2BaQ6TNsAJtcgRSaTVjjYwLGxrVs5WTFEFQt
         tbeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794589040; x=1795193840;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t7R90zeBhuCAPBYRWGVInzQKZ8XGZNdOKwhHfCCRUDk=;
        b=JWHZH70AJkI5n+vt/5l2pL9i4oBinm3JHS1fH/AIJuHByLEztL3Y+fKu14i6fZcfYQ
         D735A3dWR8tWZv2XOKLXrTtfEecc8QmJKiWL5wmv86zNhlofkNe8Lzi5Rrd8FTG4JlHJ
         6cZCfZ4MG/zSoAvrKfn4+BxFGp2QJpNhwMMr2S+NIhPns0zcMGZhdRhvu2uO05ru7Ol6
         lTyn3CzJ2JSXpieT/vAUGF9evDBoAiKjNqTsb7GpGYqaUQZ0p8a41YKuMN7VKOFdoRIF
         t24QuXot70WMSNwOZ+3M0QPihZmZIGY6HDrfvpXy1CocUYY/LLyp/cOcNpzCZxcXhn/o
         cOkw==
X-Forwarded-Encrypted: i=1; AL+hErEPLYt3iOeK6q7ildQe/XwUs5OUh3wV8eD6bi9IMjz/GZYqvRD0L7LlFPwbbQERyqQBNTY2QaA5@vger.kernel.org
X-Gm-Message-State: APuU4Z/d2uQJ8VXlXQ6q+rK82oQZs6HVPoWz5q9A+ZcUwDRgCBCQvPyf
	/WGngTRznRzo0YFEh4vAjD45FtvcM51T0r/GDko9mhsiQa4JRFlSPMYgtQTj8/IhJUNfy5y1R+E
	yAlTDA5E8gRjscnqyisXJ9SOyGIYiuRVIa6hsLffk/+jKpdt8SUhU0TBnKX4=
X-Gm-Gg: AYBFou2sBz3Yxab/Xw/r6v+4GL50EjzRCwUjpuVkaZml6kgb7t5j/5aiyR8ZLG1HoZ8
	VDtpTggG3/Ga6jq88Y3s92e2L+wk3LVF0iJnGOZjcqDjhlYVHA1dbhgTY0rbc3Krgs5C5/t8MM4
	sNMvNHN1/s8MWc5DpUlLgS3B9yfEa/opGK74kpZCLG8VfH9LCga833qJ+3y9SQEwtgI03CbtyJt
	LrOVvI6Ma/I2FeTY/hsNt6kyftXZ2y/iP/elw4kbAzASrvyxJ3CrY5vn3aCYiv0WhY1FzkvorFu
	PB80n3h3HvOItTty7iTPmm7k7DcvxmpMQIC5AS4QgOH3DBCrBDW+ONbI8i5ahDRIeiHt1DR8mO1
	vUvyCFh9Yk7jqBR5MigYpD64gp7Fho0qs7jVuG36W55tKAdz8XR2bSLOz08boYk3GG9NRsjwqbi
	koFCQ=
X-Received: by 2002:a05:6000:4804:b0:49d:57b6:55eb with SMTP id ffacd0b85a97d-49d57b65632mr3158295f8f.17.1794589040111;
        Fri, 13 Nov 2026 08:57:20 -0800 (PST)
X-Received: by 2002:a05:6000:4804:b0:49d:57b6:55eb with SMTP id ffacd0b85a97d-49d57b65632mr3158249f8f.17.1794589039729;
        Fri, 13 Nov 2026 08:57:19 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c604ee47dsm5790370f8f.38.2026.11.13.08.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 08:57:17 -0800 (PST)
Date: Fri, 13 Nov 2026 17:57:14 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org, tglx@kernel.org, will@kernel.org,
	boqun@kernel.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	kprateek.nayak@amd.com, luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org, longman@redhat.com,
	ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, shuah@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, parri.andrea@gmail.com,
	m.szyprowski@samsung.com, kayracizmeci@gmail.com,
	weihengqiuu@gmail.com, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH v5 20/29] cgroup/cpuset: Give back the bandwidth an
 attach did not move
Message-ID: <avdBakhOOFb_j6y3@jlelli-thinkpadt14gen4.remote.csb>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-21-mathieu.desnoyers@efficios.com>
 <avWEta7b9X4K6hF7@jlelli-thinkpadt14gen4.remote.csb>
 <e21aaf40-b929-444c-b707-3200e21d7301@efficios.com>
 <avczaaXEh_xUhxpa@jlelli-thinkpadt14gen4.remote.csb>
 <3b2419e4-3874-4ccd-8af1-3ca76df20717@efficios.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b2419e4-3874-4ccd-8af1-3ca76df20717@efficios.com>

On 13/11/26 11:14, Mathieu Desnoyers wrote:
> Hi Juri,
> 
> > I believe we already have (maybe broken in-kernel) EBUSY on trying to
> > hotplug last cpu with bw standing?
> 
> Yes, in dl_bw_manage(), for dl_bw_req_deactivate. It refuses a CPU
> offline in two cases:
> - the CPU is the last one of its root domain, and that root domain
>   counts deadline bandwidth;
> - the CPUs that remain lack the capacity for that bandwidth.
> 
> Both look at the root domain as a whole. The planned next version
> leaves that check as it is.
> 
> The new refusal looks at each task. The root domain keeps other CPUs,
> but none that the task is allowed on.
> 
> The case hotplug_last_refused of deadline_bw_test shows it, in a guest
> booted with isolcpus="domain". I1 and I2 are isolated CPUs, in the
> default root domain. H and K are housekeeping CPUs, in another root
> domain. B is a cpuset of I1, I2 and H, and is not a partition root. T
> is a deadline task, counted in the root domain of H and K. Without the

Oh, wow. So, this is indeed possible today, but of course completely
broken from a theory/AC point of view. Urgh. :)

IIUC, what you propose for v6 makes sense, in that at least it should
close holes we have today. We will then need find time in the future to
address what dl_bw_capacity() already points out:

 * XXX Fix: If 'rq->rd == def_root_domain' perform AC against capacity
 * of the CPU the task is running on rather rd's \Sum CPU capacity.

In the example above T should be restricted (and its bw accounted for)
to either I1, I2 or (H,K). It shouldn't be possible to admit it in a
cpuset spanning both isolated and housekeeping cpus like B.

Thanks,
Juri

