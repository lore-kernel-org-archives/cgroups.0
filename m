Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794544665;
	b=YhIa6nqa87eBk8Etz5bDE5+kcNXlvJAX9AJ1rQqH4/RaP77jT+DJ1+xeipHzBDzJcNmb
	 +xyWY+kUFJ3oqOSBaJsEIxU0cy/YjIM3eA6GYFd01tKBlvTgHQK+ll+2cWMb/sIhcbNDs
	 ulntvmieXqcqQGPygNU8YiI1iUdRDvQC5rhwcxLKrhQEO0+b0gup5yoF8gXzZaXH+9/O1
	 mnIvOyBCvRzNzdBLHSzY/6NIWKf46JtVwmKwzb3+yB9o7MA4p9r8litcBQc6ssw6JWxii
	 /jI6ApzzRqnuaYfPsyK9NEctoa+mv4wuOHRsJc6IkNTknG9bz0sOH5Br6qhx/b8wVnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794544665;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=MzPZHAwZUR6XQNi+lr4SvNO3O8lOE7xor3LFCCcEfZw=;
	b=l8tuQ/1kv5/RODNOH90t8K9wKR801UxokffeUcfpoa4WRPNt4yn4NxykzrJIM2zwr0dF
	 3gB6hgfg6NRJPGpYH6WPm6jefsgO1f42BVIxqlHpOqWxwejughWg4Tn7++E2Vq4UvoLYN
	 9hJcm+StmREOzrnghnNjAdvgWKGhfanNtHzZ3dFn2n7ShIhlvbztIzm5JzOf2bjetXd+2
	 3Yw7yBYWyXRou9QLAtOmP9nomksp72ZqPVJir4+2GbO86amco4kDMN9vW9JHeJwneoklr
	 9Oe5TfqIJKt5dcJfToNuena5imBF8kspg4hEA7buWi46T3pSPhM5BTxITr/AR0vvH1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dK0yLTn9;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE195606A323
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 04:37:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE195606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dK0yLTn9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794544663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MzPZHAwZUR6XQNi+lr4SvNO3O8lOE7xor3LFCCcEfZw=;
	b=dK0yLTn9MUQnY9GmcCMOW0G85zN8nRgyLe8ZfOJjlWOd+G+96vZ/6qlSls11ZBF52aEnbI
	hQBGeMe28r37nq4OGcSAHWM3cieQ1r24lAd6DKowDHR9TUMCjQ78lKjFdD96LDHiilD1Yg
	JNbdyZBDH3ck+yehSAtXB0Frr5o8z68=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-219-Em2cxYDQMlSJlLId5uNroA-1; Thu,
 12 Nov 2026 23:37:37 -0500
X-MC-Unique: Em2cxYDQMlSJlLId5uNroA-1
X-Mimecast-MFC-AGG-ID: Em2cxYDQMlSJlLId5uNroA_1794544654
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3014C180024D;
	Fri, 13 Nov 2026 04:37:33 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 87F8E18004F7;
	Fri, 13 Nov 2026 04:37:27 +0000 (UTC)
Message-ID: <bcb60245-abfb-4e3a-aa4e-f134ed310381@redhat.com>
Date: Thu, 12 Nov 2026 23:37:26 -0500
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 18/29] sched/deadline: Move a task's bandwidth only
 where room was made
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 juri.lelli@redhat.com, peterz@infradead.org, mingo@redhat.com,
 vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org, tglx@kernel.org, will@kernel.org,
 boqun@kernel.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, luca.abeni@santannapisa.it,
 mathieu.poirier@linaro.org, ridong.chen@linux.dev, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 bigeasy@linutronix.de, clrkwllms@kernel.org, parri.andrea@gmail.com,
 m.szyprowski@samsung.com, kayracizmeci@gmail.com, weihengqiuu@gmail.com,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, stable@vger.kernel.org
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-19-mathieu.desnoyers@efficios.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261108185406.1549770-19-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 11/8/26 1:53 PM, Mathieu Desnoyers wrote:
> Commit 7f51412a415d ("sched/deadline: Fix bandwidth check/update when
> migrating tasks between exclusive cpusets") moves a deadline task's
> bandwidth in two halves. cpuset_can_attach() reserves it in the
> destination root domain. set_cpus_allowed_dl() then frees it in the
> source, when the task's affinity changes. Its comment relies on the
> first half: "We already made space for us in the destination domain".
>
> But set_cpus_allowed_dl() runs on every change of affinity. It frees
> the bandwidth whenever the new mask leaves the task's root domain, with
> or without a reservation. sched_setaffinity() gets there too, if the
> task's cpuset spans two root domains. With admission control on,

For cpuset v2, it is not possible for a cpuset to span two root domains. 
I believe it is not possible for v1 too, though I am not 100% sure. 
Please let me know if you are aware of a way to do that.

Cheers,
Longman

