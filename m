Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794758197;
	b=Z0X2FPh2RkULa7RLn51cdvb0hFWHypxBYUScCj4ESmjwKEn6KH/I+PVOlOxWuz/YMQe5
	 fWrUq4kH3dblrdES2/16U2wXAqtv7vi5Fm++T+qH51KO+UPbAzv1Hw5QALVVssIwetPuT
	 mqN8EjxhsGA5vX0p5Wmr4apjQmk4/1/7ylqJfKd1PhBJaZMPoDbs7rfKSh1xm423wRfg9
	 KyIR03lKzKjL5W1WNRSthrmMT73f2+v4bA8Tc+J9OCkhMTmkvEN7i7/Ry9yElbMe6II6Z
	 6DKiQ0su2TV9TkRIdqCFASXgQ7wAU4qTnkq+NFP+b2S5+t09PA/4x4AeYu51ZUybiEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794758197;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=gucgyH9UJ4PzIs/wJYjaqcqVwySmiuvzgHUjJmOtkC8=;
	b=YZ/ax/t41+1VuY0wMtX51/l17xV6u896waVdyFoe+k32vamT4bWT9wrsRpXMBpNmzMql
	 /4iqIyropWFalB+uvHcBFuuWWrLhZDuaFJ5xBLvp4IwRrdKd+EkZdj8xX8uIgfp+m3mSy
	 IcDfEMu35CNzcYE6q8YGJsMvNN1juXCYg5G2vAyJ/O9KROVh76Pezz3kyoztESOM2eQUt
	 Df0VvcGKWjRW/LDCen7SayfMGZXGNU2BUwIIT4SlgnNdPLbNRCQLCp8nhOq+7y0xfQ93i
	 3TpYig8ukQs1x1GrzmkuPh1hVPRK3vuSFj1EoTZjHZYEJwsNNFOBPse6xEWHmURjb6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iB77yRSd;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72678606A31E
	for <cgroups@vger.kernel.org>; Sun, 15 Nov 2026 15:56:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72678606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iB77yRSd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794758195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gucgyH9UJ4PzIs/wJYjaqcqVwySmiuvzgHUjJmOtkC8=;
	b=iB77yRSdMzdlHdIA67bDtuerJ/esvu2ZnYFkaSSwcKAnlY0+sNFWvaXnmthvgyOFgwJlBx
	FWvvaiLLK6H7+uDBTgUGosYmFCoPU606VbYl//nkZ/cAFpGI+C30pYX4jx0fLJIiF94JQM
	0CKmoI39r3cJ5b+KTbYsJ9/bsDTTJnc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-B4KiHO_SO9u3L3OXpNYHgw-1; Sun,
 15 Nov 2026 10:56:34 -0500
X-MC-Unique: B4KiHO_SO9u3L3OXpNYHgw-1
X-Mimecast-MFC-AGG-ID: B4KiHO_SO9u3L3OXpNYHgw_1794758192
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7077D180035E;
	Sun, 15 Nov 2026 15:56:32 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EFB201800545;
	Sun, 15 Nov 2026 15:56:30 +0000 (UTC)
Message-ID: <ec69f1c9-4798-47cf-b91c-ed6a9ec96ffe@redhat.com>
Date: Sun, 15 Nov 2026 10:56:30 -0500
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
Subject: Re: [PATCH for-7.4-fixes] cgroup/cpuset: Don't revive invalid
 partition without active CPU on hotplug
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, Ridong Chen <chenridong@xiaomi.com>
References: <20261114120532.1438512-1-ridong.chen@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261114120532.1438512-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 11/14/26 7:05 AM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
>
> When a CPU hotplug leaves no CPU outside of the partitions for the top
> cpuset, cpuset_handle_hotplug() clears subpartitions_cpus and gives all
> the active CPUs back to the top cpuset. cpuset_hotplug_update_tasks()
> then walks the hierarchy and invalidates the partitions, as
> subpartitions_cpus is empty.
>
> However, an invalid partition visited in the same walk may be revived
> if its effective_xcpus is not empty. tasks_nocpu_error() doesn't catch
> it when its CPUs are all offline but it has no task. Its CPUs are put
> back into subpartitions_cpus, and the valid partitions visited after it
> are no longer invalidated, as subpartitions_cpus is not empty any more.
> The top cpuset is left with CPUs overlapping with these partitions.
>
> It can be reproduced on a system with 8 CPUs:
>
>    # cd /sys/fs/cgroup
>    # echo +cpuset > cgroup.subtree_control
>    # mkdir A1 B1
>    # echo 1 > A1/cpuset.cpus
>    # echo 1 > A1/cpuset.cpus.exclusive
>    # echo 0,2-7 > B1/cpuset.cpus
>    # echo root > B1/cpuset.cpus.partition
>    # echo root > A1/cpuset.cpus.partition
>    # cat A1/cpuset.cpus.partition
>    root invalid (Parent unable to distribute cpu downstream)
>    # echo 0 > /sys/devices/system/cpu/cpu1/online
>    # cat A1/cpuset.cpus.partition B1/cpuset.cpus.partition
>    root
>    root
>    # cat cpuset.cpus.effective
>    0,2-7
>
> A1 can't take CPU 1, the last CPU of the root cgroup which has tasks.
> When CPU 1 is offlined, A1 is revived without any active CPU, and B1
> stays valid while its CPUs are also in the effective CPUs of the root
> cgroup, which triggers
>
>    WARNING: kernel/cgroup/cpuset.c:919 at rebuild_sched_domains_locked
>
> Only revive an invalid partition in hotplug if its effective_xcpus has
> an active CPU, the same as what is required to create a partition with
> tasks. With that, A1 and B1 are both invalidated in the above case.
>
> Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20261114083124.1340140-1-ridong.chen%40linux.dev?part=11
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>   kernel/cgroup/cpuset.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 7e374210c123..bfc852090765 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -4016,10 +4016,10 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>   		partcmd = partcmd_invalidate;
>   	/*
>   	 * On the other hand, an invalid partition root may be transitioned
> -	 * back to a regular one with a non-empty effective xcpus.
> +	 * back to a regular one if its effective xcpus has an active CPU.
>   	 */
>   	else if (is_partition_valid(parent) && is_partition_invalid(cs) &&
> -		 !cpumask_empty(cs->effective_xcpus))
> +		 cpumask_intersects(cs->effective_xcpus, cpu_active_mask))
>   		partcmd = partcmd_update;
>   
>   	if (partcmd >= 0) {
>
> base-commit: e234ed1bb82c96a5643fd70784f16cf3d72eeed3
Reviewed-by: Waiman Long <longman@redhat.com>

