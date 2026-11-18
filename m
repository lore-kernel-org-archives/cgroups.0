Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001209;
	b=vTq8zxDQlXmLRs4YdmMveWUXNnnZkNX38yoGjTlBUOu62N12oikqX/46IQUpaXn5E/qj
	 M7646RZaX6xxGXyf018usLDSAP0SeqC+cEiOvVFEwU4JgvszR61m1QByRIFPIPrNk+qRQ
	 28lA/i8q+MOlTPLSLvYhZSCkghxG4IMW7gfRF7Yfg+KJA2In8CzNpqXSzcFSaBTWL+fuX
	 ZMREKKwhSMPOdErd6cPEvOAcWi8Jfkxfo+VOSTr7om1yekjMmmTvR05k0CMhb861sPSde
	 ob5fF6RLWz78wB6aqLIfsVI8k3hxEIWJKZLSp2/k0nHw2AKY/k0i8SLI7Ak0kRbrrnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001209;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=brXugAcDbaCylrm2Wl7ARVAM15xweZmcyeF8T+2xKUM=;
	b=LZOjYzioNn7PijKtT/d1pAktBsxhprNxo0s8JOW+BAuvxYGA9t2clBYm0ANQThCqxRlU
	 L7aGkXteXdLZfS6xmq4bhxTrDjXXak6WJe2vJgAU5ukCWkfxTgO1GDWn0Q6EUGp0DHMvH
	 4vcgCDlIywJuV5o96a8RvcPNfktODz1jpyb/v88M/WOmct4daLxvhU8VGCpyMzjdcd0lB
	 chWlc4FctEDQKyj7ud0ekZY2b2koK5wFg1wqQr/I4l77HYQejAyWKDgBFjz0swLIJTb/o
	 5PKUYZD+7epXzFW4j2BYbdts3DwpzkyL59rZmJqhx8eTjm8bPMZvySz9uMjEGdKDwpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MTSCO9KN;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=O0eeRLPA;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008B960A2619
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 11:26:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 008B960A2619
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MTSCO9KN;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=O0eeRLPA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795001208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=brXugAcDbaCylrm2Wl7ARVAM15xweZmcyeF8T+2xKUM=;
	b=MTSCO9KNWcHiY7wfpX0H9Di7lOMSsi28OWm3cotM7G3xoIOeF98RiUjWzm6TIRrqiP/7r3
	KUWQ6ihgyUBMfoqpXByi6EeqJeBgYQoNpWqDCzYxUQTKOAiFe9JVW61myXg4TBo5T7mO2D
	4f1o5u9Fl+gnh5e9syrfoBZy4vu+7hk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355--5nI4j5cM9GaEEzqK4eG_A-1; Wed, 18 Nov 2026 06:26:46 -0500
X-MC-Unique: -5nI4j5cM9GaEEzqK4eG_A-1
X-Mimecast-MFC-AGG-ID: -5nI4j5cM9GaEEzqK4eG_A_1795001206
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a70b42bab0so6517245e9.1
        for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 03:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795001205; x=1795606005; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=brXugAcDbaCylrm2Wl7ARVAM15xweZmcyeF8T+2xKUM=;
        b=O0eeRLPA2ARzYnZFoi7oaRzFa2OHAmOJiZj7W8CAE7ead+K0VAgogP99KxPGFqvuGP
         aXXaTFDIWZFvw2pIkBHCDKOh2UU4QAZFyYP2Eur1RM/3zuxKaltahntpPIP/Cql+YMO3
         3fwENYMS/+ByjhIehCsWgFVjAgpeuICH+WEYfIUtPXUzO20MatTg+ZqAXCZBWivVWHkJ
         vL++nntqmPpaEYF8CHdjCWnk/Y8zZ065mGsVqrjoSUVd9GOu5TLmFI40S3jhP06b2Cz1
         t1gbjFOdC/+QmfaOkvuC/9Ni2PcwfuotYJgoiyRn0v9OyIEnmckmMqfgmKhM5prfSXU2
         3Vtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795001205; x=1795606005;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=brXugAcDbaCylrm2Wl7ARVAM15xweZmcyeF8T+2xKUM=;
        b=WkzIBY2KL2gdEEUjvjayNqYqP9nV2lYls+8EbLZYDeER08WdF7vU1VcSHD6uwBFF69
         sjbItL7AL1ih5/iMdsVYn0TEnRMrt+FV82aLwTuLtU30cleBsFVzGl89Ewp3ne/ITaeX
         YiFUujXqSRINTGLBWdrV/isaCfSv8D40SAw32Uze2WLyBQ+2hdqqHKmoI5vHE+WuyF70
         7W4X+AzYWDiJRmWOaCA2SLpPQ19Ony/vzQdA3eZj2klAn/9F1wp17I5Z66xcGGpF1jRp
         gRBvhALp3xfz6hmVqWgL3i7bnvipuizA5wNnASmycUOOvRXGFNGBsekkcCmFmXO3lNX6
         PDdA==
X-Forwarded-Encrypted: i=1; AL+hErFSljEtrqmeRiobQsGyWfskVRw0VNEm5PTRvIDUKDP7ib23BJT15PHkqzcbnRBTU46i1HfZaOBb@vger.kernel.org
X-Gm-Message-State: APuU4Z/K49YOxD9fgDduPNeUEUy0kojwMgQaPwpRoZfsyObhi+mSXOvS
	RpbJEgWix9CTImYHEvykjES/F5QtxUtiL+Xh+kYOp7rZ145t7/ROJZRQqgDhvsTsvRifrCkcQtX
	8RRtBtYaHs55Hvy4RV0762gKrVO/JbTOCl8vMVOIKsAQDCdutUcwVSBw+Uzk=
X-Gm-Gg: AYBFou0ptD+gWFZTCzB7DkyPzw0fULLLOd3LRalUJYdrBOj2rkKkp2XHmGTRRF4OhOs
	AbS0e1v4JEGMUApY23CTKpNTafh4nREs4OoYDVKWMq+aRz4m/kdTdnR156dQO27PYfTydFwlXvo
	ig0Nh4FnXPINz73fhCWsiGNgvDqya9DFQrUHrTwq68lc3cUVGIzboXJdcS6PwgeFqzwAWhJjd1F
	jWFgYZ3+pyTFzGSXDr5nSad+lBrZFmoR/hBmzYKmwgeCYS8xSuuRlkNk8RRJWYmbdPvp6m1ZKrs
	C1FerhLo3t9dyCQZW9Kfkae0PjKwLGvq0wKizP5KiSB3impew/peI0ZPE7T3uzxJJtAkV9vlWc2
	iSe+JVmFua9hIm/h4ObmXFBMMp9+C3PWi8sB303B6Odqyzgcow4RPno6oiAqf/g0BBTRuFsnfDe
	EKHO4=
X-Received: by 2002:a05:600c:1d8e:b0:4b9:f90b:1c4d with SMTP id 5b1f17b1804b1-4bb783aec42mr139593305e9.5.1795001205702;
        Wed, 18 Nov 2026 03:26:45 -0800 (PST)
X-Received: by 2002:a05:600c:1d8e:b0:4b9:f90b:1c4d with SMTP id 5b1f17b1804b1-4bb783aec42mr139592495e9.5.1795001205361;
        Wed, 18 Nov 2026 03:26:45 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a65560b2a1sm4049093f8f.32.2026.11.18.03.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 03:26:44 -0800 (PST)
Date: Wed, 18 Nov 2026 12:26:41 +0100
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
Subject: Re: [PATCH v7 05/40] sched/deadline: Refuse dl_server debugfs writes
 while the rq is offline
Message-ID: <av2LcczdGk37WJLm@jlelli-thinkpadt14gen4.remote.csb>
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
 <2bee6a143319301f082855a15274f0563e99b8a5.1794922146.git.mathieu.desnoyers@efficios.com>
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
In-Reply-To: <2bee6a143319301f082855a15274f0563e99b8a5.1794922146.git.mathieu.desnoyers@efficios.com>

Hello,

On 17/11/26 09:10, Mathieu Desnoyers wrote:
> Commit 4043f5498416 ("sched/deadline: Reject debugfs dl_server writes
> for offline CPUs") refuses a write to a dl_server's runtime or period
> on an offline CPU. Its message says that such a write has no meaningful
> semantics.
> 
> It tests cpu_online(). But during hotplug the CPU is still online while
> it sits in the default root domain. This lasts from the rebuild in
> sched_cpu_deactivate() to the offline, and from the online to
> sched_cpu_activate(). That root domain does not count the server's
> bandwidth. A write in the window still goes through admission. With
> admission control off, it changes total_bw there. On v7.4-rc2, a write
> of the current value divides by zero in that window. The previous patch
> removes the division, not the write.
> 
> Fix this by testing rq->online instead. It is set under the runqueue
> lock when the CPU joins a root domain that counts it, after
> cpu_active() is set.
> 
> A write now fails with EBUSY while the CPU goes offline or comes
> online, as a write on an offline CPU already does. Writes at any other
> time are unchanged.
> 
> Applied without the previous patch, this patch alone also stops the
> oops. The reproducer survives 20 rounds with no warning, in 3 VMs of 3.
> 
> Fixes: d741f297bcea ("sched/fair: Fair server interface")
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: stable@vger.kernel.org
> ---

Reviewed-by: Juri Lelli <juri.lelli@redhat.com>

Thanks,
Juri

