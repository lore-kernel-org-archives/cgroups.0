Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794930618;
	b=iTQzDGqN/iolc+hKiX3FO/GwS1OWfq4K4meeuktb9r4yCdZqSGHUpkqPQX0euLskzozc
	 ZZmDUGyJc6kI8M708D1ePqdA9bovzNMlCor8KdGxLNygrXLYpmOo8zx0Xl5kcUTalTk3h
	 COkG6gU/5CXkpnfBtfnFVd2Eqn2HuY1P0+iL9V+VInFlwowWmXDgnkhK/iZmK8llJPG1F
	 obs5SbEkg5oGuWcm85wpGuJNOEMTwmQIChpwkyznE+3bN0j2hTXDmesGFmhfI4YpXqtf2
	 NMgiVmPsqsLPpzS3TblsTIx8wMLC8OwtWQ2FK/0v+WP/briKTepN7U473wGyCgFarTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794930618;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=DWGBw+ma+bMigxCgLDrq/Q/j3clEUU2w1Ctfb4UCi3E=;
	b=FlzX6tHEdQX4WqiitJ721n4FvkZLf1dCq7p18xX2bku2zkJwMV3nmgwNLUomFi+yobSE
	 TzM/dMDCA1dTuXbYbaYnzJZNJgXEXNheZ8Z++DtMZR0Xflk69i9GpEfV/oitkdZFz+rOq
	 9+ooCaT5Vxf7iOtq8m0HCANORwf2h6hcVSiD6fqsHFxKlqSQ4RiP1tzrN5rxDviTBaWxa
	 Fpyd/alLfeMuIn0IHK7IYcYdh5YeZnjfEo1LyuwJCy10haGqI7UpwYFjuwVExzrpuN/GD
	 j3g9F2hKfmmhELEr2ak6nB1Rg1qDEemIt/4UC7/KLLrzu9EkddoITnBjJxsll/V8kQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LmUqiC1l;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=ak7sinso;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41870606A31C
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 15:50:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41870606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LmUqiC1l;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=ak7sinso
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794930617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DWGBw+ma+bMigxCgLDrq/Q/j3clEUU2w1Ctfb4UCi3E=;
	b=LmUqiC1lfDZ+NEYifoGqjhtyPbPnHTUPnHhNqVSP0VANcxdPWEKbRjfaaoBZtMFWey1YdF
	Anjzs5vaYTp7W2E2sTNVFGajUdMNo+q9wtHrM/WtE4uno1M9XkEtHw+Wvma6dKeNUPWk66
	AHAYuL8rIf9FDO1eW3msle72aSshD9k=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-ZCdu02_EOiiHo9-eA5p3iw-1; Tue, 17 Nov 2026 10:50:16 -0500
X-MC-Unique: ZCdu02_EOiiHo9-eA5p3iw-1
X-Mimecast-MFC-AGG-ID: ZCdu02_EOiiHo9-eA5p3iw_1794930615
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-490c1867460so3107967f8f.2
        for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 07:50:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794930615; x=1795535415; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DWGBw+ma+bMigxCgLDrq/Q/j3clEUU2w1Ctfb4UCi3E=;
        b=ak7sinsom3feMrz1/XDpcYkXy3ZCzXP5caP8YQw8MKBmBvOmJftsTQ+pYR9nd/KHmX
         4pdU7TBXNnnh2YawYrUel9wy7nEfafmSvxTwTq0Pc53r7SVbjQsbnlw4x2TEIJXWjOXG
         q37lxkcRkXAhIKYXnhyL7jheNIedltMkuTaqrrrc+zdvid2iCOadxpfzytF5FJcvH/Wd
         ffP9uV2UnjGQjOG41mX+NAy12pSAr0CLWEMVjRGz1RiP3D5xjD6UQ/3zBPXWohJlhDoG
         DYfwL822jwI4NTyfF2cosYo0AjBZsYSTpheJCzytntDH6STykplrV2Lbm3GvCDfLHg4R
         9Iiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794930615; x=1795535415;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DWGBw+ma+bMigxCgLDrq/Q/j3clEUU2w1Ctfb4UCi3E=;
        b=C/xYeN1+olYdYPHYU+tGgONZmqfR2ETETuxJ5kmipXIkVsA0R1Qn193PgqibZSg7DM
         z2dHzczbaKgjW6qh/As6D6FfeJXAoFM6gMB8KB9XVkFmKTH1Q5l16/tRXWY8gxmsJ+Bi
         PoMyBhQR0AEOC0n6k3nWJlMKEb/CpTc6RFLIYZDrM5PTNtLDKuJHtJwlaZwoeaxL71G4
         TK+L4NUa8FAz086KuXynxDTGV65tu0nU+JyHUk7tA6QVaGXatZHDMUL92dEyqPzvNClr
         WfVHcXNC9HLXjpwWmoVHVOOK/2ov3bgKSwOI8gpr0HYDJ6jbo6gg01+trvEdMFD3fH0L
         vcEA==
X-Forwarded-Encrypted: i=1; AL+hErElXoP+TYHDREapP/0vV3LqYepRvcdmISJBiE3pjg6+eTvYt66f7i0/0lrxV8VxqJanGYnT4mXz@vger.kernel.org
X-Gm-Message-State: APuU4Z94dw/xnzdR4gJhSayKhe6HeexEtTEXCG80CGKgdF4Y477krdyB
	c3y5Sqc0x5y2c75rFx5+WiEtEyhwyD5BDWWARvipASJkgpzXyVhChgQRqROHBLSiCCjthueHdTt
	bmUaK+Jrv/x/WOaPT6kRGBO++Ztep0iRde0JkpclPCQtxwVlUDm0MaCbvS7A=
X-Gm-Gg: AZFdTZdthgxOAu9oY5P/ZQEEi9gkwxyTzs7Lxi30vDg+BC8Fg4xEmN7/b/w6+wDUEe2
	bikmA7JjpOSPcOHO0AidUyyVTfnQT4O1bXkee3H0GPAJvu5oI/8KO+nmaZYHGoPOH4xTgDCx5MS
	0waFgUYarovAnWdCAK/gRzDT6HPZSHmoW2Gx50bcZ53nw/SWfgYa7dvDFoCv9G6tBISI8n7pfqf
	OuC/Y3+nSfM5ubyPF4mS4sArEhFOl08CRAk7O7Wvd7ozPqZSaFCIRFt0J9o898wJmHDjMET/BrS
	IbfCyEAjBAkHfIRDMakwGeTGTHOk1wr46+AfdqJEA5iT08lIZArNgGmDT1C45VhbmZAwvn6PAo7
	NGHcSomMRYqnTLSZLUmAXHKCKc4ebJM0U6BsDgm/NbIHxYeZyrbkuV6eaYnOACSgM8khr/QnRAf
	j5SMY=
X-Received: by 2002:a05:6000:2906:b0:48b:db7:86a7 with SMTP id ffacd0b85a97d-49c73afb0damr32270843f8f.50.1794930614756;
        Tue, 17 Nov 2026 07:50:14 -0800 (PST)
X-Received: by 2002:a05:6000:2906:b0:48b:db7:86a7 with SMTP id ffacd0b85a97d-49c73afb0damr32270802f8f.50.1794930614342;
        Tue, 17 Nov 2026 07:50:14 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60da0a03sm23414900f8f.53.2026.11.17.07.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 07:50:08 -0800 (PST)
Date: Tue, 17 Nov 2026 16:49:49 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Yuri Andriaccio <yurand2000@gmail.com>
Cc: tj@kernel.org, bsegall@google.com, cgroups@vger.kernel.org,
	dietmar.eggemann@arm.com, hannes@cmpxchg.org,
	kprateek.nayak@amd.com, linux-kernel@vger.kernel.org,
	luca.abeni@santannapisa.it, mgorman@suse.de, mingo@redhat.com,
	mkoutny@suse.com, peterz@infradead.org, rostedt@goodmis.org,
	vincent.guittot@linaro.org, vschneid@redhat.com,
	yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <avx3nfSu1cl9I0W1@jlelli-thinkpadt14gen4.remote.csb>
References: <212c244d534ee1fdb0538a980789e16c@kernel.org>
 <20261111175657.250354-1-yurand2000@gmail.com>
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
In-Reply-To: <20261111175657.250354-1-yurand2000@gmail.com>

On 11/11/26 18:56, Yuri Andriaccio wrote:

...

> - `cpu` and `cpuset` controllers are decoupled, as it was before the `cpuset`
>   integration patch. The user/admin is responsible for inconsistencies between
>   the two controllers (i.e. empty intersection between active server in the
>   rt-cgroup and the allowed cpuset just disallows executing RT tasks entirely).

Curious to see what Tejun (and others) think about this and the other
points, but FWIW I'd also lean towards decoupling.

It looks like the enforcement you need for it is already in the
patchset: RT tasks can't be placed on CPUs where their cgroup's server
has no runtime (find_lowest_rt_rq() skips them). So an empty
intersection between a cgroup's per-CPU entries and its cpuset just
means no RT execution there, and that's the user's configuration, same
as an isolated partition with no tasks in it.

Thanks,
Juri

