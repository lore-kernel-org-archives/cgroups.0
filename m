Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E10392825
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 18:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790706092; cv=none; b=rydYlhSdOu1XPih8frl/VlYk6HWphBrSNQjIf9rfYLmx8FXLy1CU/Y+FJBIX6ARenA6d7UrBWSmd+VngHlpa1iSfHcP7dYpLa3rasLmZmIAvYEpr520vofKxAoepUpgh2AuuK0bRFDrINWyIMiI9FD0MJuKa0KH/ObJmICTCDV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790706092; c=relaxed/simple;
	bh=k385cy7oGczUOgFjI5/gVaVaL9INKElEuF+vvL+bF8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ojRCzGr3DXr1ye1MU0CSaxlTGhPJATpmUVsI2ZfEwpQkEj/YxW1UGAvB4szem1yZXkBPozaRDcvEwnx+0AzVHNZC1HwVzdHh9lXqmcuFx4CTfOErikdAMXRmjhA9r5HdbVE5oaPEdfs8ryttT3bNh9GpjQM4tvHe9eN8te4yicg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EyTQHRw/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EyTQHRw/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790706090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sd2OcXsJUu+pOOEVw0OShsqANOdAdmXTLdstWoBoReQ=;
	b=EyTQHRw/AGpp4q/pKJcrYXwEV0jQz/TSuGWg2HsFfM700goDvWdqCyMJzjzNE9HPxVNTow
	rgMnLo9s+Bo3MZRU0r1qQe0U5bpnUkH9LT8e2U1I+XDDwFXhfXhhMeLcJeK/1tYx5qpKVd
	yekhhtOSC20lzQ6r56fThT24puDbZnU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-WZJwBe_-MKygBGWmGoUlAQ-1; Tue,
 29 Sep 2026 14:21:25 -0400
X-MC-Unique: WZJwBe_-MKygBGWmGoUlAQ-1
X-Mimecast-MFC-AGG-ID: WZJwBe_-MKygBGWmGoUlAQ_1790706084
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E2FF31944B07;
	Tue, 29 Sep 2026 18:21:23 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6DF8E1956047;
	Tue, 29 Sep 2026 18:21:22 +0000 (UTC)
Message-ID: <ccfaf01f-2bd9-41fd-b733-693de840c2f4@redhat.com>
Date: Tue, 29 Sep 2026 14:21:21 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: Properly disable partition when partition
 state switching fails
To: Tejun Heo <tj@kernel.org>, Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Hui Peng <benquike@gmail.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260928235159.515654-1-longman@redhat.com>
 <941e5affde16b803741ddaf87b937f3d@kernel.org>
 <07403332-9fc3-41cf-ba2c-63a1f83a231c@redhat.com>
 <5e658521-1d8f-47bd-87a2-809a79a10186@linux.dev>
 <95e04dc55645c84c033ccca1a1359d84@kernel.org>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <95e04dc55645c84c033ccca1a1359d84@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17


On 9/29/26 12:42 PM, Tejun Heo wrote:
> Hello,
>
> On Tue, Sep 29, 2026 at 03:40:27PM +0800, Guopeng Zhang wrote:
>> However, after the parent is created, the ownership of full housekeeping
>> CPUs can still change, so passing the check at creation time doesn't seem
>> to guarantee that returning CPUs later is still safe.
> I think any CPU under an isolated partition should count as isolated when
> testing whether the system has a housekeeping CPU left, whether child
> partitions carved some out or not. Those CPUs go back to the isolated
> parent whenever the child partition is disabled or invalidated, so they
> can't be counted on for housekeeping. In your example, making C isolated
> would then fail.

I am now thinking about treating the whole user defined exclusive CPUs 
(exclusive_cpus or cpus) as wholly owned by the cpuset in question from 
the housekeeping check perspective.  That will require reworking the 
current housekeeping checking code and will require more extensive 
changes. So it will take some time before a patchset will be ready for 
review. This will prevent housekeeping check failure when a child 
partition is disabled and its CPU are moved back to its parent.

Cheers,
Longman

