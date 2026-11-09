Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794235313;
	b=SPVuxussKit2n7SnoBpzQAMsH7EIgxlx/ZZd403ZM5A4iA2/7uJONHiTUPLS2m2YL9Ws
	 lJ+7BwErTxwA2fPKdazZjM9DFvKwM0yp08hZ16y3pY8gqldqktjcUkvjJfFK/fiRVvITZ
	 7JmuS56jO4YO2lRNWHNh5gKao1sbYdLvH2wHR1xEI6SPbD8sH1Q4tRoEDyW1SrytVs9hN
	 n+5u8jAGZwLOxJq24xuSgoYI3nVtWpaTHsEqOpNHV4kg5ueEoC4gIu03k5OFquYzVyazF
	 eqpPykIiZVs7HCw2KaUd4Jy+Kom6n54R0XyjLqS1esGMQr0VkNE87dBKvbf+gnx6OTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794235313;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=3DmiQTkcDrfvNKdokvdjGTmMgiq//nGrn6FpXJ0M9ek=;
	b=puh/u6h7D5oo+X++3dcloAdWL48P9IsC/Zu100uH0b8CBU/3OMWMgH7q+TF29OaQwBnR
	 tqj/YbD6CJ4KzAQRzsloM2eCwEHV7KPBDGR0REVLytSd9paN9FQhLy3HOs6uO1rGsw3o3
	 C3SGkG57Z5EgrIVcJixcPTYDe6NrGjQkxeB+UJn7zf8pbJXtJm/ChUYLjoIpKyEtCRmgG
	 yeJXbXHer6v03WU/31qeJqwZTAPNb4LevZxq4I4NstlGwcvpzL0Q7YtfZ7u/gtBfTonSA
	 iLaZImtul5HX+eE3qBqPGHBl2FwytK9npP6Bcfi6rFB8P1eIbX0+422rpaWnIk6GgsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=EEsG3kgQ;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA17A606A331
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 14:41:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA17A606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=EEsG3kgQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794235312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DmiQTkcDrfvNKdokvdjGTmMgiq//nGrn6FpXJ0M9ek=;
	b=EEsG3kgQA80vAMGfXDZ0v5pSBX2hcBdyB90TF6NDwk1T0oahVK7jt1CywyhnnXDK68ZqW9
	QoFmG86RGZOAcapKQVj+U+ZFMl9TmnjCKAlKgRS1HiR2k3BTDIxpLHfsxCnJ2URNSd1U4D
	tHvgtLqrAy7ozbPFzyJ/J5WJNVgwDaM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-426-8PhPwMfTO4yn30hLTk4k0g-1; Mon,
 09 Nov 2026 09:41:47 -0500
X-MC-Unique: 8PhPwMfTO4yn30hLTk4k0g-1
X-Mimecast-MFC-AGG-ID: 8PhPwMfTO4yn30hLTk4k0g_1794235304
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A035B1955E89;
	Mon,  9 Nov 2026 14:41:43 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8DFFB1956089;
	Mon,  9 Nov 2026 14:41:41 +0000 (UTC)
Message-ID: <e575df2d-71dd-4844-83b7-d29bed349992@redhat.com>
Date: Mon, 9 Nov 2026 09:41:40 -0500
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
Subject: Re: [PATCH v2 1/3] cgroup/cpuset: Reject updates that empty the top
 sched domain
To: Guopeng Zhang <guopeng.zhang@linux.dev>, tj@kernel.org,
 ridong.chen@linux.dev
Cc: hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261105130344.664336-1-guopeng.zhang@linux.dev>
 <20261105130344.664336-2-guopeng.zhang@linux.dev>
 <ccdab485-e1d1-4055-bb0b-f8f712fc0a9b@redhat.com>
 <0ae6fffe-d492-4e85-b464-fafdc4c2b064@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <0ae6fffe-d492-4e85-b464-fafdc4c2b064@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 11/8/26 11:42 PM, Guopeng Zhang wrote:
>> Could you also put this new test matrix together with the other test matrices?
>>
> I'm not quite sure what you mean here. In v2, the new matrix is between
> ISOLCPUS_TEST_MATRIX and NOHZ_FULL_TEST_MATRIX. Do you mean moving its
> definition elsewhere, or merging its test cases into an existing
> matrix?

Sorry, forget what I said here. I have misread the context of the hunk.

Cheers,
Longman

