Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88CC5372E6
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 23:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790119859; cv=none; b=R2c8oGnQnmqefvrqloqX6OWpBdn8yxLN7o50J/HXG1wWflVnt5MD072igvrAdul4W0XXbMHna8HRWuUl32i/dwR5zvImhg6M3r0K2EAB0pifZqZsQO6xPkTXmVavcPJg07w4D0p8sQ72cHUUoOx/esi4xFU1Qooolj45F8DJT2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790119859; c=relaxed/simple;
	bh=IGAKDJgi2dJx6WJK/BkSLxg7707mBJgxdKRPlFR4c3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fQ/XQV736csneEO3cFPavUS7PfDQcricywIkHdIXfxGSm5SqYQegccXew3VL985xf8Zvu8DSV8kbxBGUfeMEu8uWQ+Mf97qqxeHhLOGxDoRT1LA+bZXz1+DsscQj4zA4Rt0oC6IxQdDbAG19Jms8I8z+M4Z4bIvdl+VsZOq13A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CKJGQg7+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CKJGQg7+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790119857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q5+YBN+Xt2oI+X9FvnLri1OubT6BbtyJ9+8TD+cFyTU=;
	b=CKJGQg7+HzktRZMgfiGphKnDLptpOCsWMKfSHQfcVvTyd97UHZJ6Ya/OQk15uG5TU20k6i
	UVz1sZmaCt3syAXyMCi//gc2MdxrhfAPqMa2PX8QN7dnBSZntTUMTwLdd5S30MtRBmCfqi
	cZc94s3G62Lf05FBW8/5ZoOZdgo4/iw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-311-o3JUVDV5OMqaUhTNzsUouw-1; Tue,
 22 Sep 2026 19:30:53 -0400
X-MC-Unique: o3JUVDV5OMqaUhTNzsUouw-1
X-Mimecast-MFC-AGG-ID: o3JUVDV5OMqaUhTNzsUouw_1790119851
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7836E1955F24;
	Tue, 22 Sep 2026 23:30:50 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CD4811956095;
	Tue, 22 Sep 2026 23:30:47 +0000 (UTC)
Message-ID: <9fadb6a1-df92-4c8f-96f3-f5fdf43e68d4@redhat.com>
Date: Tue, 22 Sep 2026 19:30:46 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] docs: cgroup-v2: Correct cpuset CPU descriptions
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Ridong Chen <ridong.chen@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260922092034.68840-1-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260922092034.68840-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 9/22/26 5:20 AM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> The cpuset interface documentation says cpuset.cpus.isolated is empty
> unless an isolated partition exists, omitting CPUs isolated at boot with
> isolcpus=domain. Its cpuset.cpus.effective description also assumes CPUs
> come from the immediate parent and are normally a subset of
> cpuset.cpus, which is not always true for valid non-root partition roots.
>
> Update both descriptions to match the existing behavior.
>
> Changes since v2:
> - Update the valid partition root example to show that an offline CPU
>    can remain in cpuset.cpus.exclusive.effective while being excluded
>    from cpuset.cpus.effective.
> - Add the Reviewed-by tag to patch 2.
> - Patch 1 is unchanged.
>
> Guopeng Zhang (2):
>    docs: cgroup-v2: Describe boot-isolated CPUs in cpuset.cpus.isolated
>    docs: cgroup-v2: Describe effective CPUs of partition roots
>
>   Documentation/admin-guide/cgroup-v2.rst | 62 ++++++++++++++++++++-----
>   1 file changed, 51 insertions(+), 11 deletions(-)

For the patch series,

Reviewed-by: Waiman Long <longman@redhat.com>

