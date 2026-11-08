Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794163163;
	b=vmaemYXtBOrCjZMm2zbBqVVaWDQDIp2Ay9QIgBYZ7iyhGji/TPmHAEDLLLBdt9Bd5u66
	 3tRyQbItHVmZjjyI7GqRo/HkePzyWq7Ey24IIhTKAfvaqqNiysTDF4ZQ2Fw4GCBCoJV4d
	 kllnkutRBgrCtRKLXvn6Fna/cUcS6rXASGznsjoWNa4BpUp5oV3EEmTSdCrWKBK9QkoqH
	 RaCwSmH275GNDfIjufpHB4cu6uwo5pBUVZqO2fS3GRZt6Kyve71w6Qt4ea6ZyLs3i+MHp
	 sqPafqWJiNjoPnE7h20pvwCsaXWuKHkbXXVdqIlMT1zjaoelNfTrcfHH4fU/RsVY8Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794163163;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=u5lmPv9eUWA1lCjITL7OtZoO9QEWtitob2td072ED/M=;
	b=vhxC4gLM4RvKZfgJu5gXOaDnqE6E5EtP60ZTbxRjAVvG6+7BENdVmS0qhJ0rWkhw67WJ
	 vCa6pnVIEQWt0wNrETpdfbR/OR2RY7E0SuGaGWiKZw9NfaRiVBy4Uf7C0kyDCvNHzLO9o
	 4NfG4y/hYvYcCEThWIneBkw2QiQFs6j1rKI2EBwv1WSuVf/kFC5Fn9knPRk/dGg3MK7dd
	 qRsRq+YzqddsXe189GOC1PbGD7TYzv7Ak6DV0gYmOSrwwUXXW7Wik1H3IA3mz50/4MbCY
	 nhWcw3Ow4Ymq0PGYpTzTy5kBPsyAu5G5i4pdFbjlnI1gdXPgOW8ET0BYrZg1v9fxQ5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Zaq2hLIh;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57870606A330
	for <cgroups@vger.kernel.org>; Sun,  8 Nov 2026 18:39:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57870606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Zaq2hLIh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794163159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u5lmPv9eUWA1lCjITL7OtZoO9QEWtitob2td072ED/M=;
	b=Zaq2hLIhTFyOAyaJTXhx8DAj4HWIisphCuwkX+PjvH6TiILRAT4gxPwGE+z2cDIdpwdJXp
	B9pM1jxwDRYMzHMmvX9/pAJO6dchVPyEXQWunLjNjYlNHQcqzu/eMn6ZSmFyPgSiQXUF5Y
	hDtSTKaADTmUiNDLekfzv4bvFECAIU4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-122-Rt-Rk6xVPw686NPZ4Wpe0A-1; Sun,
 08 Nov 2026 13:39:08 -0500
X-MC-Unique: Rt-Rk6xVPw686NPZ4Wpe0A-1
X-Mimecast-MFC-AGG-ID: Rt-Rk6xVPw686NPZ4Wpe0A_1794163143
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD168180034E;
	Sun,  8 Nov 2026 18:39:02 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3B5141956089;
	Sun,  8 Nov 2026 18:39:01 +0000 (UTC)
Message-ID: <f750e716-07da-47b2-a474-1c731b8c5b72@redhat.com>
Date: Sun, 8 Nov 2026 13:39:00 -0500
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
Subject: Re: [BUG] cpuset: WARNING in cpuset_update_sd_hk_unlock() when
 isolated partitions take every housekeeping CPU
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Frederic Weisbecker <frederic@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Ridong Chen <ridong.chen@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261108145754.1532162-1-mathieu.desnoyers@efficios.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261108145754.1532162-1-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 11/8/26 9:57 AM, Mathieu Desnoyers wrote:
> Hi,
>
> With isolcpus=domain, cpuset accepts isolated partitions that leave no
> housekeeping CPU. housekeeping_update() then refuses the new mask, and
> cpuset_update_sd_hk_unlock() warns.
>
> I found this while testing a fix for another cpuset problem [1]. Its
> sequence goes through that problem first, so I ran it only on a kernel
> with that fix.
>
> Trigger
> =======
>
> Boot 5 CPUs with isolcpus=domain,0,1. CPUs 2 to 4 are then the
> housekeeping CPUs. With cgroup v2:
>
>    cd /sys/fs/cgroup
>    echo +cpuset > cgroup.subtree_control
>    mkdir P Q
>    echo 4 > P/cpuset.cpus
>    echo isolated > P/cpuset.cpus.partition
>    echo 2-3 > Q/cpuset.cpus
>    echo root > Q/cpuset.cpus.partition
>    echo isolated > Q/cpuset.cpus.partition    # WARNING
>
> The last write is accepted. Q reads back as isolated.
>
>    WARNING: kernel/cgroup/cpuset.c:1481 at cpuset_update_sd_hk_unlock+0x79/0x80, CPU#1: k2/93
>    CPU: 1 UID: 0 PID: 93 Comm: k2 Not tainted 7.4.0-rc1-00268-ge99d0e004b05 #108 PREEMPT(lazy)
>    RAX: 00000000ffffffea
>    Call Trace:
>     cpuset_partition_write+0x9e/0xe0
>     kernfs_fop_write_iter+0x14d/0x210
>     vfs_write+0x252/0x550
>     ksys_write+0x6c/0xe0
>     do_syscall_64+0x109/0x5d0
>
> RAX is -EINVAL, the return of housekeeping_update().
>
> Analysis
> ========
>
>  From reading tip sched/urgent (006991aa8997):
> - Making Q isolated would remove CPUs 2 and 3 from HK_TYPE_DOMAIN.
>    CPUs 0 and 1 are isolated at boot, and P holds CPU 4. So no
>    housekeeping CPU would remain.
> - housekeeping_update() refuses that mask with -EINVAL. Commit
>    03ff73510169 ("cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset")
>    calls it under WARN_ON_ONCE() in cpuset_update_sd_hk_unlock().
> - prstate_housekeeping_conflict() refuses such a partition only with
>    nohz_full, since commit 103b08709e8a ("cgroup/cpuset: Fail if
>    isolated and nohz_full don't leave any housekeeping").
>
> So cpuset and the housekeeping code disagree on what is valid. The
> write returns 0, and the isolated CPUs of the top cpuset read 0-4. But
> by reading, HK_TYPE_DOMAIN keeps its old mask.
>
> Should cpuset refuse an isolated partition that leaves no
> HK_TYPE_DOMAIN housekeeping CPU, as it does for nohz_full? I did not
> write a patch, since you may prefer another place for the check.

As said in my previous email, cpuset will ensure that there will be at 
least one online housekeeping CPU left for generating sched domain for 
the top_cpuset.

Cheers,
Longman

>
> The analysis was written by an LLM coding assistant under my direction
> and review.
>
> Thanks,
>
> Mathieu
>
> [1] The empty sched domain report, sent along with this one.

