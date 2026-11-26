Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795710845;
	b=vlsgltPI7Sp/rhOu9ccAGMcKmldqERT+6ts8CvEuPn+Z38bDiucHbw+FP8AwU1wMJED2
	 kwPeeXTRsDYMg1LEcI4+OBEbkatMfjsX3jS5RtnLsBfk+LIX3+xd/8H7BXflZThdHEkPH
	 +K68w7f/BMg7KFLCGRQQ+SHPsmdx4M0BfMuN46IKJN2SqtU9GQXeETGZ0D9S1ADjCvXL0
	 r0S8NGw5HKQW+J6fpwN9lTrQg1bBiWP/YVB1yoJojQmU6Fd9C1IQ6RYM20Ab1HC+y3mFx
	 wSPAJHyYSwFcT+J+BqawOoLlaBS5qgI7L0cn5SSkKLVFQoxdxCmGqr2GypOydfSavPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795710845;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=PDQh4Crk4HMl6k2OmnDfKytSQVD4stRFrNvCtlRZkH0=;
	b=JQC2VqG3O285coMzltsFJ5IGMpOtxIXGvM7oc9wZ4mEAUVH5MmCPjS5xGnlFlvIDdy/N
	 6WNt6JLDg1JbZ/stEzJ65Hm+PMBuvnUOYhXAhSTGOqorWykIonn4zqKY3fdXBqA8bycXT
	 5gt/AqwtpukQiv4kMQp/nAzAl1Wv7aK7vQj80f6lFXaYbGOVUIZBh59eA1j7s4oI21M3G
	 kKvBjFN2/ykotlIpe/rRPdVGt0t84KLxlHrIFJYpFqseAy9iyznMs6//SUqmaZoMpQrqt
	 5AGiOXA/KmNAIimjWCI4aebLO0KN/M8I1spBtQFdEDrI5asYJBp3LNefZdL165F0hzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=elQgKMeb;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=ofUVuq9t;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF799606A31E
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 16:34:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF799606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=elQgKMeb;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=ofUVuq9t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795710843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PDQh4Crk4HMl6k2OmnDfKytSQVD4stRFrNvCtlRZkH0=;
	b=elQgKMebSdzuIhgkztbmSxCP8Uvo6QTd/9wnxUsr71TQiy3+yZF24LJ5/RTgliX6TAOW3P
	VU1quu4BJBWJYjJT7K+tK+worP+zxR0GcTgrQ9Chd/9TRpXD3GA0XP77jDsCIbi9Z/25TR
	vIbhYATnEOt2NrCABK0jy/KQFQUmonk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-SKNdGvraOOqAWPOa4_QV5w-1; Thu, 26 Nov 2026 16:34:01 +0000
X-MC-Unique: SKNdGvraOOqAWPOa4_QV5w-1
X-Mimecast-MFC-AGG-ID: SKNdGvraOOqAWPOa4_QV5w_1795710841
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a80bd45e1cso40702865e9.3
        for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 08:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795710840; x=1796315640; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PDQh4Crk4HMl6k2OmnDfKytSQVD4stRFrNvCtlRZkH0=;
        b=ofUVuq9tTLt7pCnggrubrOqVYuGpVXVUDUIViJOAHlCfZ1BBvc9vgs1Hv/ot4fR/Ek
         EUkKps02ZmBMXgdyt+mWP1yn5YokrL7UTjPFl2sUCfui/KwjJi+CLuXwmW58wvsbn6Wv
         A4gdLft+J0Lp2kqWM/84ZUpqrnGgswWn5CyUXrg1NBI9C6nr5VjI1FYXSf7/h3tPcerS
         N0oQNqAPiGV2EfUKSp0sDfOn7JkDjMmSFUt/8RnSuI/HlbggeMuzgDaKO8EkKHyyA8Hw
         xM6R6ax58zE29qZ/7akaVw0ds4XeEYkHw+Xywp00mrVCxx+BGgNTuiQOjmVjkA569JG/
         xlRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795710840; x=1796315640;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PDQh4Crk4HMl6k2OmnDfKytSQVD4stRFrNvCtlRZkH0=;
        b=bFsGvU4OP0ZABkGEfU1PGiN77l7KyiMrBx8OqNMr45GJ3g5cs/yPV9SM5CWdRoaBlN
         oL/WQB/vrP8ep9gzqkBs/vjOhwtZYBTqaYkaC5U9wgPJfBl587jIOSUu2D5Zmn3noIKU
         gNIQjQkCD7M7Jv7yyHyb82xHymfs8GfsYfz+BuX3+xCtigk3sw+ziji0Ydg3J7F9XRCn
         ruIP5xWlBUNDmf/MrKF1agQRWtSE+kwea5WfWQM6h/Louax20PGcxiLRvmJXvH4Ac+I5
         O0apbcE5RuqcUUkcZDA/cb60wJJpx/QbzCmxKUM3LYrjcy2ZVvezABHFKDtiz5yVgYbW
         jiCA==
X-Forwarded-Encrypted: i=1; AL+hErGtAYJRV+e3G5PImIL0FeMLqgaRo3Vye6yTdn33mhJAYZXuJe1qmsBxggnju6VD1i9O+GA5VRC4@vger.kernel.org
X-Gm-Message-State: APuU4Z8bK9zdjbCPG3plgMTSEC8o1iJi+ubKKm0Fw+U6di3KerDMDD5L
	AxdqVEC6ih7jZmx+mvTyPJ0BhezVNp9uKgoDhMoJDpbGcNX/21P8iIqpDkMU6hro+0UVkxwZ1zR
	Vxa3/vHm84B7igbWYnTWNW8OB0hMtayStMguFJSClBORWtZD5fWJYXoPjWeE=
X-Gm-Gg: AZFdTZcbb3BgHW51hRck2PFoVB/oi5wnoXarGhm1/ixlrhH96DFBl7zT6mjaLFr3pF5
	ejpdyVr7ng9GGy2K27mdbv/cSnd8SP9OPVmpUkDkj1NNrLRCsEr+jtntBfHG6d/jUFNKiumxTYr
	WDj1VMuoGxKvyHaPec0z7N6ol5S8Kjw8w0yNGxg9T/GMVDFLejDDbwN8DYrZNG2JcW1ba+6AoyQ
	92KDFtquSl8LZuKBerRhQMB7sCRcTxnjk/SvBIR5yvMf9ml6WYHf4uuu/bfJ2pO2AUmzziBud7F
	O+y9NtmNLb6boAA9ye/JMQk6m0SyFbKAQK+jpLs10PjLGQtU2ego+sLYH/SWH9oxKztzl4Ks/hn
	6/kVVrPe/xIQp7ipf9Loq30wX6QX4pqcTZkmhhTBsuOvWwm9wO4WxMDi0p9P+Al44atoBAmviUi
	qUSCju
X-Received: by 2002:a05:600c:530f:b0:4bb:781f:6067 with SMTP id 5b1f17b1804b1-4bb887e21e4mr425796225e9.1.1795710840577;
        Thu, 26 Nov 2026 08:34:00 -0800 (PST)
X-Received: by 2002:a05:600c:530f:b0:4bb:781f:6067 with SMTP id 5b1f17b1804b1-4bb887e21e4mr425795515e9.1.1795710840185;
        Thu, 26 Nov 2026 08:34:00 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.146.153])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6bc8ce06sm40151988f8f.47.2026.11.26.08.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 08:33:59 -0800 (PST)
Date: Thu, 26 Nov 2026 17:33:57 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: luca abeni <luca.abeni@santannapisa.it>
Cc: Tejun Heo <tj@kernel.org>, Yuri Andriaccio <yurand2000@gmail.com>,
	bsegall@google.com, cgroups@vger.kernel.org,
	dietmar.eggemann@arm.com, hannes@cmpxchg.org,
	kprateek.nayak@amd.com, linux-kernel@vger.kernel.org,
	mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com,
	peterz@infradead.org, rostedt@goodmis.org,
	vincent.guittot@linaro.org, vschneid@redhat.com,
	yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <awhfdTbfDhpklaTN@jlelli-thinkpadt14gen4.remote.csb>
References: <471bf8d446becabfca00041fb2a78067@kernel.org>
 <20261120120659.2e902463@linux.fritz.box>
 <6fef47e08a37079c08806b3c57994778@kernel.org>
 <20261120212418.10221f2e@linux.fritz.box>
 <06f4c157677f99fc5386dba4c9d68cd2@kernel.org>
 <20261123084345.4e24e3ca@luca64>
 <awQTy09VbrDn9RpA@jlelli-thinkpadt14gen4.remote.csb>
 <20261123151846.3fdcbf4e@linux.fritz.box>
 <awfe_r5McCTzr84x@jlelli-thinkpadt14gen4.remote.csb>
 <20261126155736.20e64e65@linux.fritz.box>
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
In-Reply-To: <20261126155736.20e64e65@linux.fritz.box>

On 26/11/26 15:57, luca abeni wrote:
> Hi all again,
> 
> sorry about sending the n^th message, I just have an additional
> question to check if my understanding is correct.
> 
> 
> On Thu, 26 Nov 2026 08:25:50 +0100
> Juri Lelli <juri.lelli@redhat.com> wrote:
> [...]
> >   P/          cpuset.cpus=0-10
> >               cpu.rt.max: 4-10 runtime=400 period=1000
> >   P/noncrit   cpuset.cpus=0-3   (threaded, no cpu.rt.max entries)
> >   P/crit      cpuset.cpus=4-10  (threaded, no cpu.rt.max entries)
> > 
> > Threads in P/crit are served by P's servers on CPUs 4-10. Threads in
> > P/noncrit find no entry up to the root on CPUs 0-3 and run as plain
> > FIFO, as they do today. cpuset keeps the two sets apart, so no task
> > ever moves between a server and the root runqueue, which I think
> > addresses Luca's concern about tasks changing reservation on
> > migration, at least for setups that care about the analysis.
> > 
> > The mixed config ends up on P because of _delegation_. P's cpu.rt.max
> > belongs to whoever delegated P, and it's what bounds how much the
> > container can reserve. The application only arranges its threads below
> > it. If a cgroup had to be "all or nothing", the admin would have to
> > give P either zero on CPUs 0-3 (no RT threads there at all, not very
> > flexible) or a budget there (reserving DL bandwidth for threads that
> > don't need it).
> 
> Uhm... In my original "all of nothing" idea, my plan was not to set
> cpu.rt.max in P, and to set it only in P/crit. In this way, the RT
> threads in P/nocrit should be served by P's parent (up to the root),
> while the RT threads in P/crit are directly served by the dl servers
> configured in P/crit/cpu.rt.max.
> 
> Would this solution address the requirements of this use-case?

If the admin configures the whole tree, yes, I think so.

In my understanding, it doesn't if P is delegated, though. Moving
threads between P/noncrit and P/crit needs write access to P (the common
ancestor), so P is what the container gets. P's own cpu.rt.max then
stays with the admin, while P/crit's is the container's to write. With P
at "max", nothing bounds what the container can reserve in P/crit, other
than what's left at the nearest configured ancestor (or the root).

So the admin has to put the cap on P. If P also had to carry entries
on CPUs 0-3, P/noncrit would be served by P there: with zero its RT
threads couldn't run at all, and with a budget they'd use a reservation
they don't need. Leaving P without entries on 0-3 (i.e. the mixed
config) is what lets them keep running as plain FIFO, as they do today.

