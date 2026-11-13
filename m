Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794582405;
	b=pKROuFZxn9lvfF2Fr+IH3xthzA2DvpIRXUAsU3CkeicEXE72QBwB9P4YM8oqQRO1D7+w
	 teqc8Im+drOlasC/yL4RR2jps/YxYEIkN68nletC9e/AAwS9mTv5rL5e2zonakGQE3U7F
	 hCbg8TR609zS2FG9mh+9leu0VXSC1/2KR1RAil8l2wjiHIRhea4mZDYIuuLjpSJUevD4N
	 bcv3lPkeYuiJ4Hlln/I8E8nuWVYxvreJQ8URy9qkjsL0P0RbvElLQpZoxvypyldowob+N
	 NkgouritoMPNWIQt7qT2e/5vfy1tx34BjpHhD4OxHzjfivQA5hBSzNctw/mRT0cA2Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582405;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=2Tp6iQjkfangii/DKRnGc80WH6QKMSA/4QcC/JVtYtI=;
	b=ekV2mpG0NQ9WdVO63b0u2lKqpbSv+mWsMZAS/HOHFKpMhcf89PwG6eMPtAqVN1U6dL2q
	 p8ndmCc+ntvYx1SVJr5ddQh822WyFcl4SbrkUhcQlQ/a0TBidseKG4IKdO0JoPUuCz2RF
	 vkf8J570P8DZeyO8z4ZhyYAtbR/bvYv0nU5cD357H80FPjFWi1MaVBEL2xgpxg4AMjmBa
	 89qhgmwQyAZubundGrfR0KuVn3RZJ56jGgPLGGFZmQX/AqkEg7lvHzjwPyWKTAvIYOYMp
	 ByAr5STaYCDSBXaycFG8PmuTvFZGjmOAutcDwK26ZqDNZfty3EzO6dvD8oHzgPbK2Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TciBMSmE;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=ns5S0Tu7;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BF460A2604
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 15:06:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02BF460A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TciBMSmE;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=ns5S0Tu7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794582404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Tp6iQjkfangii/DKRnGc80WH6QKMSA/4QcC/JVtYtI=;
	b=TciBMSmE/FFXG9MYsN+ix7zwV6Y6/GUs5mmtdk4MHuNf8la8FlUCTpWUPSiAEpOvvbOcOe
	XjOsiRDLwQu3u7vdeSK/7pE6jiIQjWE4OjHh5/Yv9KTgGj/jTqW1e4pG2TfE86saEgepzz
	FBPEkedIRBc4UF6w6Twyl8zXqj5XgQs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-nmIU4WZMNYWOUe1Bq14CAA-1; Fri, 13 Nov 2026 10:06:42 -0500
X-MC-Unique: nmIU4WZMNYWOUe1Bq14CAA-1
X-Mimecast-MFC-AGG-ID: nmIU4WZMNYWOUe1Bq14CAA_1794582402
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a20fd059ddso6765975e9.0
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 07:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794582401; x=1795187201; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2Tp6iQjkfangii/DKRnGc80WH6QKMSA/4QcC/JVtYtI=;
        b=ns5S0Tu7MrONZXzIzknq9qO83Czobv4jEAo3Ald3QMyVHS3ISoFwgkL7ShfNZ2GFkE
         0Jk0Fl5u8nkgUaJG9HLkJ1vmAj3Mhf+MuOr3LlU5CRjQsDtNyQ4ro5pnSosiHing3aGj
         CSVsPusCsNEZ+tFBSX+rvrv/WMErUp0AiSLlbKDl0jnduSPaNh1YYWUwETX0vGso1dx7
         5g8Bp2hlHDkXrZhrBqhEtigFDnd5SCvAs9gxkf6YOp0Rhz9P5nI7zdKSQaOo4kh41dG1
         wur3/LJkw8oKkiO+EeTI5cmtNZzHnebHw0cgM1EW8ajBuRPJ2n28z8pNw4gDCd9kXi/V
         54gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794582401; x=1795187201;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2Tp6iQjkfangii/DKRnGc80WH6QKMSA/4QcC/JVtYtI=;
        b=Ztg4WYXcuJGhj7Dd4bxwway7GID0YlHEo8IOj4D/6lvrF/ylaDpxG1fOV9VESCu37K
         EaLzHCBe16FSvJ/K5Zd10ArKU1jSTfFqFChN+C0QLH4yHoN4j/NOLDSXnNFnLZYTjLJO
         S+V3adOYM/SjUTia9d9MvgacLewfJK1zWZ9G5kqUMhi9e1Bb735wSLWgOKSrdOADqYJc
         mwNVTwnqjQT2XgEu0Md91ZJG641jQOt/DVRYzXzKyjfD2XnlD9T3OrET7V4bv3kBPyug
         NThTwS1RWHabgkkTYGnXYO8J7sTlAbZYeotYODu7CoUGG+4us9k52JqHSrm1s9qSE4j7
         K4tw==
X-Forwarded-Encrypted: i=1; AL+hErHmAPAqJQ9YigvXzkdYrVxvBhRjwDiX6kEKkdmw1fr2rtrxlLLazAs8gXPprVNZFD1DPIZK22Dv@vger.kernel.org
X-Gm-Message-State: APuU4Z/L83OMGku3YqJmQdS2LGd88NqY9d5LBYPBjDU7NtrDpxIva+HV
	Eek3JlAebl8CMFbfT3AlZPb6eaGTSbbg4pcSxRgkP11JxkLe4vqe12/OvR8Z/6kni3TorMpvTj1
	/f6vMpJMjTgGmWOItqMf+azHn4BYMEsqKBSJrvPJCx6SD59Ty39MgHiKtT/8=
X-Gm-Gg: AYBFou0obOH1E07lMYUYx9+uxlngn8havXOIue2JC7jMaJ/vAkl56qevkJbfSaZj8Xy
	phTYL307gZ+CkGXwJ9ZNY7+/6BAvwlfdDFL6XqpfnjJrK60aY4276n6w/+NSGdNODYR0tE6dJtI
	qU+UbFbFPsE2hIjBd/HKJFeyovVcBlFk3GYu9IbFUrJ4ASZscnYO2diqDa88ne+l3Z5sLb1UHsj
	pPBryJTZn+VojljlhXt5skPjFGg7+IBLozYWAMJrZDuBBrqgf+I8FTDQT3p1/USzv6HzUSJX8Az
	8rDPHySi659Tp24hATKj4iXfqPXdYWXcHhpq+34EHZ/L9Fthxc29k+eqYxoHOq+WF6GNkiUQBCW
	5MBQUDz4O+6HkMU8FBo8fZ+q+ba9nUcwqbW64NQC2oJ5SIX04ZyQiSCaapus8cFsmWy1Y9JYEK8
	/1vKg=
X-Received: by 2002:a05:600c:a30e:b0:4a6:42cc:bf66 with SMTP id 5b1f17b1804b1-4bb55a5d63fmr51094595e9.11.1794582401500;
        Fri, 13 Nov 2026 07:06:41 -0800 (PST)
X-Received: by 2002:a05:600c:a30e:b0:4a6:42cc:bf66 with SMTP id 5b1f17b1804b1-4bb55a5d63fmr51093885e9.11.1794582401031;
        Fri, 13 Nov 2026 07:06:41 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb5d2872edsm20774755e9.12.2026.11.13.07.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:06:39 -0800 (PST)
Date: Fri, 13 Nov 2026 16:06:37 +0100
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
Subject: Re: [PATCH v5 16/29] sched/deadline: Record the root domain holding
 a task's bandwidth
Message-ID: <avcnfTqZzNGLlbHk@jlelli-thinkpadt14gen4.remote.csb>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-17-mathieu.desnoyers@efficios.com>
 <avSPoSnNATnwZ8cS@jlelli-thinkpadt14gen4.remote.csb>
 <7459ff0d-d8e1-4fe4-b2de-4b4f06be9bb9@efficios.com>
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
In-Reply-To: <7459ff0d-d8e1-4fe4-b2de-4b4f06be9bb9@efficios.com>

On 13/11/26 08:33, Mathieu Desnoyers wrote:
> Hi Juri,
> 
> > > +           if (p->dl.dl_bw_gen == dl_bw_gen) {
> > 
> > So, this is not guarded by dl_departed_lock, but then this gets fixed in
> > later patches?
> 
> Yes, but only as a side effect, and the patch should not rely on it.
> 
> dl_bw_gen changes in a rebuild, which holds cpuset_mutex. From patch 18
> on, set_cpus_allowed_dl() reaches this test only from cpuset_attach(),
> which holds cpuset_mutex too. At this patch, from reading, other
> callers still reach it without cpuset_mutex: select_fallback_rq(), and
> sched_setaffinity() with admission control off. A rebuild can then
> change dl_bw_gen between the test and the __dl_sub().
> 
> The planned next version takes dl_departed_lock around the test and the
> update of the record, from this patch on.
> 
> > > +    * enters the class. A runtime below about a millionth of the period
> > > +    * gives a bandwidth of 0. It counts for nothing, and no move updates
> > 
> > Ah right, quite cryptic corner case buried in this comment. :)
> > 
> > This is the 1024ns/2s of the test. Which indeed gets dl_bw 0. Don't
> > think it's a huge deal from a theory/practice pov as to actually make an
> > impact we probably need quite a lot of these admitted (fork bomb style).
> > But it's still weird :P. Not sure if we want to impose a min of 1 dl_bw
> > for these. If it actually complicates the accounting (for no good
> > returns) or not.
> 
> I agree that it is odd. I left it as it is upstream. The accounting
> needs no special case for it beyond this comment: a bandwidth of 0 is
> added and removed like any other. The case move_zero_bw of
> deadline_bw_test covers it.
> 
> A minimum of 1 would change what sched_setattr() admits, by one
> millionth of a CPU for each such task. I would rather not do that in a
> series of fixes. I can send it as a separate patch afterwards if you
> want it.

Makes sense, thanks.

