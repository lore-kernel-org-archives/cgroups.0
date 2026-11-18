Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017191;
	b=tp7Q5FUjjXzeQTRwb/xp46ct1Mx+L9sDajm6GXT2M50UXMok+kl2RWnDF5U1f3U9FpMu
	 I8EDXeHuFA9jVs4gd4uhUVEuY/p0k4EO47XIZVXg69mviNuNcP9GlEc0eNSsIWN2SokuS
	 OVBBKGWWXhGV81qV87xCkWZyXGmJx6adusDauLu1ngyvgkqQYra8c5ZkRiidqonhy3p4s
	 S9K9Z/9UqhDrKdFh1/zknreDdCeyaQm3XuzXXbXw2vxzhul2qyiFZFhyRdWSluS5EGSpW
	 oOJjrLOnpuSKER5HLlcum3eUZwqWcUE6qu+5Q+wnLYI0HghKoVn92BkDmQ9W+WSBhSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017191;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=a85wi9zMKa3ITk5iiE5QycHbAdVE4Knzk7eFGcpu7xQ=;
	b=C2a+w23pTwLsb99lDA0gdjg/E/PdY6oDVpASgSqi0XPBqt7GS0uvRU/sfVtIg9EEhfZT
	 cHhAuNn6garqHclRT62fXjJMpfbGy2GfbuPj3jFhZKM0mZlHaBjr2Ron9ypUpH4z1hzCg
	 EGLe9IZl42Ca319IwmITp5X/HS5BQndBLT5jXxAh2bT160QSmZtuaXMruGqwImTMVRmI5
	 K+CIEf0xBlnix2IXZaQRxfd2ymhQkl0EybQFt8Hv+nrQlux6fRLB+WFebW8DASGiNmdeQ
	 Tnlkfxj0FCuf7oRvwy+Sj6Ws0iMXLcJtaakgy33r4iPZhEVoNPv2L1GVx8i1EzBDA0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GntU17sT;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=TGw4wEhA;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F3F606A32C
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 15:53:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20F3F606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GntU17sT;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=TGw4wEhA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795017190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a85wi9zMKa3ITk5iiE5QycHbAdVE4Knzk7eFGcpu7xQ=;
	b=GntU17sTwCEPiLDxsAqaaHOhZPXKJ7NLXyZMmlw3JzRCYtB0alzbzQZycSXIpOriK7VLHv
	t8hAaNRiK99MmrAtT7qhu3446lEtrafcw8570cbYm37YyB5TDVQWZnHfOAuKh2yrlzPW41
	PT4IZ5RMTOA4Sr8sl9fSZETH13RTWSk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-Sc9IuD-cMDmF4gGbV5PmDQ-1; Wed, 18 Nov 2026 10:53:08 -0500
X-MC-Unique: Sc9IuD-cMDmF4gGbV5PmDQ-1
X-Mimecast-MFC-AGG-ID: Sc9IuD-cMDmF4gGbV5PmDQ_1795017187
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4a68703d177so506882f8f.2
        for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 07:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795017187; x=1795621987; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=a85wi9zMKa3ITk5iiE5QycHbAdVE4Knzk7eFGcpu7xQ=;
        b=TGw4wEhAEYz6dqxQddcwF2q5nSNk0fQ5KZjLd4qAAC0huj85vW++9H7xg052kqQirP
         4/7ZflEl59RJrPbO/EwbDUqXwmzPJxlBDlLJ6s7npb3cYtAN2ekn4ofpZVQwed46KD2c
         Eqs5qRBbPDEBSz2TL+ZkYV7lvc4UvrGUUE9R9vhHD+DOnNoRQUchIlmhv7hs+g8wY2nL
         J0JBUz2GRuOtN6+q4vogAaMvpb3HTZlwBUp2c/VYqaiYtc09cziupcrDNI/jGLDgWAfZ
         cGBjqv0W6tTxOfu4dSrjQALmErhn9ZYqntp25FkEf9b/XdZoC5XKRUbvE5UBGfnETMIh
         vWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795017187; x=1795621987;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a85wi9zMKa3ITk5iiE5QycHbAdVE4Knzk7eFGcpu7xQ=;
        b=FX/IMfRX5Jh+6ZGYNAIP8k9IS/FoBE8SajUV/v9Eph+84COgPHxgrwTrkUXPaDGOyz
         lF7sTnEqc5aQ4GZvI9cK3YWgEpLGmTbWanp5RKKuRfz91mVzWCzy7X0DsDS/lJl8nO1E
         fyg5TPebHt+ffly730XqiUUCv6HJQGOYtKyqSNl25jRfGqtE/R7nzR5Hb1l7Cg78OdVB
         o82c43/+K++Mwz1CKrQM1aagIHyS6CIGs7ZLT8TSGW/FU1t35mfBn8t5qoQ2BteSxQxm
         X+kz4zmGa7AbcrGNjsqVHnfW2GnyxR5joIgVF1dVQQVlQalbjyFkHwf+75PcePVTDWVq
         6wew==
X-Forwarded-Encrypted: i=1; AL+hErFtN6GzWfSoQHtzp0L4jN7mbsjtp3wfIjnsevSfx2XniTkgmRPsOPKnq81wKxmD682BVIj/mesT@vger.kernel.org
X-Gm-Message-State: APuU4Z+RvvUy9mlClfzFuI9SzzOPjPrxtfJTqOa033QHb9cMGMdYlEvF
	TDMhDqGu0hiccVP13kH6vJ7Z8lTdjLSIjuAtGo9EgMl9osZmfXgZZVX3fRBSZOT+pYHucTwuI8Y
	NMKAEqJtTDqOY9YykJ6dLgyc3MPksQMTAd6v/QjONuPFTEh0vPKkzenhKskg=
X-Gm-Gg: AZFdTZduETGMlZJut08jM5ZYeMbQeZoJct9oWX982g/LiT80OcjdRTcqJ5SOFxgeXym
	oRv1sfnu1cilvSSHJyVh7T4ruTcGkLoJPRKIeN+r9syVTa3LHwao+Xx/DjJu6EubwpulW/lQvbg
	cRSDjg1lK0zPb3l1u7H6wskco0TmvNdaDuFEz215IY1f1xtSLGWd6tYDlIxExCOfiJwEC1f7p+u
	rIFQQQFUk0ajBtIrYO9bx78cFCMpkAwWIKuT4x+iWbFDWbOu4Ob6NxZS3Y7spgFAPGarzSV5xxM
	+HkfR/KXSdJ8pTd+AFK5FeFTbUKEd/DuJL1vHAuM5TeHZC98DN3oFN3FM1ajWM8Rv3HdPvPn5ez
	GRQFDuoIlhb0b1xQRGnQ12htgb/emed8n3UFRVy6c/VG4LBacA1usU9RMDjwiHKwgX+lspa8yDj
	RE+zo=
X-Received: by 2002:a05:6000:310e:b0:4a8:7115:fa0f with SMTP id ffacd0b85a97d-4a87115fd47mr1608200f8f.32.1795017187537;
        Wed, 18 Nov 2026 07:53:07 -0800 (PST)
X-Received: by 2002:a05:6000:310e:b0:4a8:7115:fa0f with SMTP id ffacd0b85a97d-4a87115fd47mr1608144f8f.32.1795017187160;
        Wed, 18 Nov 2026 07:53:07 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a65683d5a2sm5699651f8f.43.2026.11.18.07.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 07:53:06 -0800 (PST)
Date: Wed, 18 Nov 2026 16:53:03 +0100
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
Subject: Re: [PATCH v7 00/40] sched/deadline: bandwidth accounting fixes and
 selftests
Message-ID: <av3J3zMfkRplg-N4@jlelli-thinkpadt14gen4.remote.csb>
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
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
In-Reply-To: <cover.1794922146.git.mathieu.desnoyers@efficios.com>

Hello,

On 17/11/26 09:10, Mathieu Desnoyers wrote:
> Hi Ingo, Juri,
> 
> This series fixes 36 bugs of SCHED_DEADLINE. Most of them are in its

...

Thanks again for all the work on this!

So, I feel we are making progress, but the set keeps growing/changing.

While we spend more time on the "upper half" of it, would it maybe make
sense to split the lowest part so that foundation fixes can start to be
merged. I'm thinking 1-8, 10, 13, 14, 16, 20, 37 (37 is not a fix but
harmless). Not all associated test will pass of course, which is not
super nice, but we know they pass with the complete set and can maybe
come later.

Just a thought, happy to continue iterating over the complete set.

Thanks,
Juri

