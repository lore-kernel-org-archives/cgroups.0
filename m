Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A207B3A75AD
	for <cgroups@vger.kernel.org>; Mon, 20 Apr 2026 17:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776707088; cv=none; b=dr8w0P0O9p3bbF8pgtMhlBcvURAJbLX9Tu70zDlk20zI8zNTBzMLb8aHu24lVXyswMK/6Abtj0+MuUkfKRAXKlEIXYhy6YokEu4Rneb8X+kyJInmJf6V5n23wRbXAto9/dAtwH/GNTeRXlb54NbJyqIiOKgZnGeC9T7VLCL8gRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776707088; c=relaxed/simple;
	bh=R72b3K6jz1tHjZxm7IaNA1g7loVMQoHiUU5Fx23xmuY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aK5m3+AXTrJHw7nOP9tpi88XKrlMim6IZOR0S1AkJUZoA1HgdxWzPj+oE3DIfle1EqvKZLKKxe9XKXxuDDWGApdwL94ZPTntt1PLIgykBe452Cju+DUulOSqhASdg/tO7UcfjufL1ibLm9nlum6fOqpV6TB+01A8UH+of6HQVF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PwDuPEd4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PwDuPEd4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776707086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H/9htZ55gqnG10ouhQdXUGui1FWiGObZFJTqztwfmQI=;
	b=PwDuPEd4PeJDdjUK7vMWlb08zVLP/gDaBqsR0Zu6AQYfE7fCsMZjAJQdjE1U4f/LRFL1XK
	F/S+9IrKuUbtHIyqQdxFxnsfQ2M11u4axz4GtkzAtNHVFrq7yJWV1SCWLR9yeU1v4PNNKs
	Z7mpBpjy29fzYODUUgxR/sewBFpAr3c=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-474-1Tv9FQ6aNVai2nCvUyZdwQ-1; Mon,
 20 Apr 2026 13:44:43 -0400
X-MC-Unique: 1Tv9FQ6aNVai2nCvUyZdwQ-1
X-Mimecast-MFC-AGG-ID: 1Tv9FQ6aNVai2nCvUyZdwQ_1776707082
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D572F195608E;
	Mon, 20 Apr 2026 17:44:41 +0000 (UTC)
Received: from [10.22.65.81] (unknown [10.22.65.81])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 225A3180047F;
	Mon, 20 Apr 2026 17:44:39 +0000 (UTC)
Message-ID: <ec115c35-4484-483e-bd06-9ee35bd98a93@redhat.com>
Date: Mon, 20 Apr 2026 13:44:39 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] cgroup/cpuset: Skip security check for hotplug
 induced v1 task migration
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Chen Ridong <chenridong@huawei.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260331151108.2771560-1-longman@redhat.com>
 <20260331151108.2771560-3-longman@redhat.com>
 <7i2hhyijet57lfwvz3ipzlwrze3i6bm343evgpjixmj6bj44kl@rhszdi6rlycg>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <7i2hhyijet57lfwvz3ipzlwrze3i6bm343evgpjixmj6bj44kl@rhszdi6rlycg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93


On 4/20/26 1:08 PM, Michal Koutný wrote:
> On Tue, Mar 31, 2026 at 11:11:08AM -0400, Waiman Long <longman@redhat.com> wrote:
>> If a strict security policy is in place, however, the task migration
>> may fail when security_task_setscheduler() call in cpuset_can_attach()
>> returns a -EACCESS error.
> I think this should be generally safe to skip (since v2 doesn't consider
> the object of cpuset migration at all).
>
>> That will mean that those tasks will have no CPU to run on. The system
>> administrators will have to explicitly intervene to either add CPUs to
>> that cpuset or move the tasks elsewhere if they are aware of it.
> That "no CPU to run on" means the affected tasks would remain in
> schedule() indefinitely?

I believe the scheduler has a fallback mechanism in that particular 
case, but it can be any CPU. So I don't think we should rely on that.

Cheers,
Longman

