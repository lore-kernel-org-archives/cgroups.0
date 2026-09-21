Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016894D4869
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 15:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005234; cv=none; b=tqtqLEt/sLwSGI2EmIF16y2zTKdsz1PtJ7MWNLAmgQZwpgE2Trbv870m8QkC/JYjke0Ypvz9GUqK06czfAllqN1ZQcw6hFaWBHVUyuwvQhzAWLCozM1zvNzAgw9ITRNEQuUDXBWK6l6HSvsBVbYndXBYGhk9wxiDb/VSQUCvgAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005234; c=relaxed/simple;
	bh=wt5E/QJz6dc9lKW8FK3rtWBj8KcEjhouIvoKejKPvpA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fg+14hSNS5eMWC8teuJuscqOKcO9rwtohoW34V/3wY59zFsiNsMfjFyRvZj442wNIWmU33fucA+UeX32JMlhA+eDpAJ1Zr60yuYLVq9ZRAzbOWl0dX9AFIqKyVFpa1MFJ9V0lx3yKU+AE12SmhMWpg9xQSCW86trIJcygLUPPPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C9ynR9Tf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C9ynR9Tf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790005230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ugTLVS0nHA+6GGq/RD2gCMdXGKXiSoj83EmDRdst9VE=;
	b=C9ynR9TfWWtuOuZjMLChEcV8wOiaqvdv56Vz2va2+H4iU6TEbMlE23BxNKPd/5fLjpmkT4
	YjnBYeF6zuEAWNM7UA60vy9QpJ1s+EGWv9YHW5fBKkVnT8/hIEta0XGQTtXXAZ9xN1pEvF
	GHCacJT7w5zwgFJwwzMrJDOs4wfVAY0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-527-1-puMsCANDOGM9r3vA5zLw-1; Mon,
 21 Sep 2026 11:40:27 -0400
X-MC-Unique: 1-puMsCANDOGM9r3vA5zLw-1
X-Mimecast-MFC-AGG-ID: 1-puMsCANDOGM9r3vA5zLw_1790005225
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 00C7A1953992;
	Mon, 21 Sep 2026 15:40:24 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3EA151800446;
	Mon, 21 Sep 2026 15:40:20 +0000 (UTC)
Message-ID: <a99674dd-7dd8-4097-af40-e8a0b16595b4@redhat.com>
Date: Mon, 21 Sep 2026 11:40:19 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] docs: cgroup-v2: Correct cpuset CPU descriptions
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Ridong Chen <ridong.chen@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, cgroups@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260918102359.71826-1-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260918102359.71826-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 9/18/26 6:23 AM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> The cpuset interface documentation says cpuset.cpus.isolated is empty
> unless an isolated partition exists, omitting CPUs isolated at boot with
> isolcpus=domain. Its cpuset.cpus.effective description also assumes CPUs
> come from the immediate parent and are normally a subset of
> cpuset.cpus, which is not always true for valid non-root partition roots.
>
> Update both descriptions to match the existing behavior.

The behavior of cpuset partitions have evolved over time and the 
documentation doesn't fully reflect the current behavior. Your 2 docs 
patch look good so far and I am looking forward to your v2 patches.

Cheers,
Longman

> Guopeng Zhang (2):
>    docs: cgroup-v2: Describe boot-isolated CPUs in cpuset.cpus.isolated
>    docs: cgroup-v2: Describe effective CPUs of partition roots
>
>   Documentation/admin-guide/cgroup-v2.rst | 37 ++++++++++++++++---------
>   1 file changed, 24 insertions(+), 13 deletions(-)
>

