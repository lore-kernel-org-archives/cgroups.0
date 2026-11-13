Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794582268;
	b=cit3Rv2IIxhya7XczV45er4BTAwpUwzD/bTbRR+tG+0PE1DIFqYKEBZKDwEJ5/QseYr9
	 vClUZYtXKB0+ETrwJisqaUfVQOf0eLkhJ8gBHB0sbdWjOPnOYYjPlD8+fQh14SRNCL39D
	 YJwo0AzbCZOgs1lwkCYs+//f3r6y8lyPaRdvlfgJ7UE+7xzC30DlLouc1QeMuV6tugvhl
	 xTXhv4fZ86L/rkkvXjtHOnnCMRnHxzingeT5YzoyXozjWH/bIpSpg+dloRn/RAqr1G1ml
	 eJUlgfNomFgacu28d/6iLXF36+dlcbWACttTHIIE5eJ52bCl7UEDvj/+ed0fhEHqoWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582268;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=VBm4qF0y5CrLsLbvNlcB/jDiXe3RpYSa+rFP+kdVVgQ=;
	b=SC+88dklSoTwUSfWr+uSjRPy77KSssz/QM1tliC/5W+62uSKmLdLgfeVYyUNUSFJnAFp
	 lZe016zaxeeIufQSndhL6FCEUmK9CYmWu+yjife1BNmIolj5XqtL1lxFtxiwrg3/u69GO
	 c30oXRw5Hj0g8ICaRuSOg3zLQgTd21I3NFnXMgCSIP6QCH3flZy1g6fzo5QCYIDAlkylU
	 QeDKGYmQly1guedbD4JUgyI4Cp5R+srl7Rs+Q1rN9uFPJQbPA9MG+TtMpEkxYz3q+Hpui
	 ZoejNlGuiTqaE+za/p5TD9rgU++DpF6j6EUeSMElKZFJreIDuoj/6AcMhrJrBUTWyCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KLX4lNgu;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=thPwK+Pz;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86D9606A33E
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 15:04:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B86D9606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KLX4lNgu;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=thPwK+Pz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794582266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VBm4qF0y5CrLsLbvNlcB/jDiXe3RpYSa+rFP+kdVVgQ=;
	b=KLX4lNgujzpcMIQL7Nldo0j+S2mUCQ2SMEwgptTSlos4w41Eecs1hiwkPKCeJBoh4Smm99
	Q0d4mNrk1IdzUywpli0YZXJ2nJk03ed5PtYIupbrSNZLLowUUZeV7Zq46ZalfVBn53TQtQ
	Y9Ilz+24ykLOvlTJl+jfkK4T7eJsxmY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-Hbv5VE9YONCY4hd-jWoJ4A-1; Fri, 13 Nov 2026 10:04:24 -0500
X-MC-Unique: Hbv5VE9YONCY4hd-jWoJ4A-1
X-Mimecast-MFC-AGG-ID: Hbv5VE9YONCY4hd-jWoJ4A_1794582262
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a359b714f8so5685885e9.2
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 07:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794582262; x=1795187062; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VBm4qF0y5CrLsLbvNlcB/jDiXe3RpYSa+rFP+kdVVgQ=;
        b=thPwK+Pzd9I4+Mhs663WAfYiMVPwjLMkjMphD/LFkEJHcrsLaVpfftlGy93u+K9fFo
         roXBnrpuq5LE3KOJCYY4ieTKTHb9wY2xcFRyDzCDsYFSKBhAvcO5rHBZpiMXeUymGJeJ
         HwrosgpeL/AxWmQt0K/m4gJXK6VNhOEeJ8YzMpIQVSgVWPyXaNtVTdOA4LG8N65mCBSV
         x35nbw5PmvqOO6j0OW+R7aL0Wmjd2mcvZ7f1DS12ik3eQyrGqyRexaVXb05zTxoXpq1J
         BZAVIiFV6tDNHUBkQCwq4T8MUyl1J4+sleYblJx2/6Ba4PSZI2HXnL5rAzg3BdjdA892
         NUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794582262; x=1795187062;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VBm4qF0y5CrLsLbvNlcB/jDiXe3RpYSa+rFP+kdVVgQ=;
        b=rpgSBx/X1/0XxaB0zLY4hSlFn6fcOKFvdZZjkx3BZBI9kdIf524YYXHKspJWSFndIj
         OhT00Hrw8Car1iiVwkoyCwVUSamUnyUjj0Be9vkiLDtE7HvS9JlKzROT9kG2ac+ecq2R
         U+J/u6mV9GU6eOrf0T6Cs6cD2wA70vbuJOkVPtLsT+NiOH5PNYCZSIMOkWXl1Y4l5c1g
         GPiqxSi7IqX5vCU4ZYfZaDnjlV+t0ZCRn8igsUkQanQ9hefCPgwuP1wkoY3FPr8WkWc7
         N9LWUt5UwIuuglYN+JIGQdIZ/Hax87hCs3u3dqBNoBfKaZ4TMZPYGjoSR4iD2vwVAi4T
         hh3A==
X-Forwarded-Encrypted: i=1; AL+hErGWhB0mMqTINWXXCEmbYMSXzD5zI+v8I3vBiLYZcxObZlnfK89dT0hyST1d6WS1DkdfmYh3Mhab@vger.kernel.org
X-Gm-Message-State: APuU4Z/5M3YFVi/WtcfajGpJ0SNLKIsT74WA5th12Lt2rxt0HqWSyzXj
	OGARKUGyCiBTbcsZVsng5eyP/v4r9ufZiODNs+gPkwqyMnDeV4dT+EcZZYIUtqMXWEAscEc9OCA
	CRw0EBOA0UF3NNrvy1V17jozBV3cHHpjPQB+dpZv7u4bs3GiFEbRjNccE5Yg=
X-Gm-Gg: AYBFou3Le5e5lKhV5PwSeo93VWUeO99/DnrzBXwzi7QYHYIioEjqAr4ciDDPkjsiMBA
	VBuIDbgfnisdEurQC8iKb+371QvZ3AfIhqErqhhlltRMX4El+ALKV9dy/AB2GFgtcEOS6J303w5
	2TW8xWgtGkbVoOFWdhrKXpbF7IABaS9EcAECC93r36ITuyyVRCT0w1ymKwCud0IVmDQFAd7QyBc
	svccnsh34rI/Ufhe7HYsa6kS8gICcj6utjF6gKQYzH0QPAuileAqHP5Cqeki+jxqLWntMDy8RNk
	I4lH4x8i6iuMm95PUPp/uh86CTcpSxFmJfC/FoJEl2hj8WtPr2dnjPf/2YucXnKjKYsnWTrHVDi
	DQADeil4cseV1vnwz1nJo40QZrVcEzcPn9szEbWIbr+17YknWtZfrxwmlIC9ss7h2/uqbNqqmMT
	iYe1I=
X-Received: by 2002:a05:600c:a44:b0:4a2:a6e:80f5 with SMTP id 5b1f17b1804b1-4bb55a45045mr59742495e9.11.1794582260625;
        Fri, 13 Nov 2026 07:04:20 -0800 (PST)
X-Received: by 2002:a05:600c:a44:b0:4a2:a6e:80f5 with SMTP id 5b1f17b1804b1-4bb55a45045mr59741585e9.11.1794582260021;
        Fri, 13 Nov 2026 07:04:20 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb55af2901sm65285595e9.13.2026.11.13.07.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:04:17 -0800 (PST)
Date: Fri, 13 Nov 2026 16:04:14 +0100
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
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v5 26/29] sched/debug: Show the deadline bandwidth of
 each runqueue
Message-ID: <avcm7pyPqMx_r5Pl@jlelli-thinkpadt14gen4.remote.csb>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-27-mathieu.desnoyers@efficios.com>
 <avWWlEGGqVPYkuZw@jlelli-thinkpadt14gen4.remote.csb>
 <bcf6f03a-d596-4afc-9d3f-54219935bc2c@efficios.com>
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
In-Reply-To: <bcf6f03a-d596-4afc-9d3f-54219935bc2c@efficios.com>

On 13/11/26 08:36, Mathieu Desnoyers wrote:
> Hi Juri,
> 
> > OK, but we will still not printing additional useful information like
> > extra_bw, etc. Not sure if you are aware of tools/sched/dl_bw_dump.py
> > drgn script; maybe that is already useful for the needed additional
> > debugging information?
> 
> I did not know that script, thanks. It shows more than this patch does.
> 
> The two lines are there for the selftests. params_waking and random_mix
> of deadline_bw_test read running_bw and this_bw of each CPU from
> /sys/kernel/debug/sched/debug. A selftest cannot rely on drgn and on
> the debug information of the running kernel.
> 
> So I would keep the patch as it is. I would not add extra_bw: no test
> reads it, and your script has it.

Works for me, thanks.

