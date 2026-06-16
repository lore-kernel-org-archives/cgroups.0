Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FF73C5836
	for <cgroups@vger.kernel.org>; Tue, 16 Jun 2026 03:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781581491; cv=none; b=rfikI47JVzHZaVpIEFskPDVZZXeJdfrFKtwz9acEPZDV0W8CEW/M0ZCS7WkEx3HQ7nnabAylo/iMzcwMk4InVJZDYO1DYfPfx4JONun9EcMlcmE1HOkZd91/GJcJvni9p3VEiRXuTjhy6A0p/gr+JKEpWQxlFZTQhWIS+NoNk+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781581491; c=relaxed/simple;
	bh=TFtyinMqPQ19IcEq17kXTulEojnTxmEfRf7RlQMTY74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YilC4lqHMRda9a/ui/nG3uyRvULSAAm3Sosg6r5zJWBdTW6MFLk9kzP85gD936qoG/7XL8g84AHD1i4tTh7Z9023Yxte+nsjcLx5DNhgoMkVphKWrUb9GvGAcB4WtaqAeAXPhUMlj04xZJo9o6liNAVUnRGcQBL7BrL3WR1Ytcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gTIbe2ye; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gTIbe2ye"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781581489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4CBAdbeaPwufSf5TQIy/zd6n2OxNexkg/Jy4aiOrgAg=;
	b=gTIbe2yeZqyvKk6MFYWTcOgSmSMR6BclKZaI8OVcKyPFQfHv1f+K73MbJaWKrZdgVW+oz5
	LU275SyWV0g94tM8bgSe94fQY3hfzrT1iQDVC3i73O+hbvI7XUmz+cZK5vv4mlX+Xm5cPX
	zy8KAftU6VYcl2r1pzIdN/l2Fz9HdNU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-493-RdEAH-FfN2WOoR3uxj0weQ-1; Mon,
 15 Jun 2026 23:44:43 -0400
X-MC-Unique: RdEAH-FfN2WOoR3uxj0weQ-1
X-Mimecast-MFC-AGG-ID: RdEAH-FfN2WOoR3uxj0weQ_1781581480
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D42D1801F09;
	Tue, 16 Jun 2026 03:44:40 +0000 (UTC)
Received: from [10.22.89.117] (unknown [10.22.89.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 79022180057F;
	Tue, 16 Jun 2026 03:44:37 +0000 (UTC)
Message-ID: <977ac277-79be-4064-8f36-c113232911dc@redhat.com>
Date: Mon, 15 Jun 2026 23:44:36 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cgroup/cpuset: rebind mm mempolicy to effective_mems,
 not mems_allowed
To: Farhad Alemi <farhad.alemi@berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Farhad Alemi <falemi@asu.edu>, David Hildenbrand <david@kernel.org>,
 Gregory Price <gourry@gourry.net>, Yury Norov <ynorov@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, stable@vger.kernel.org
References: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
 <CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93


On 6/14/26 9:25 AM, Farhad Alemi wrote:
> Creating a child cpuset where cpuset.mems is never set leads to a div/0
> when a VMA mempolicy with MPOL_F_RELATIVE_NODES rebinds in response to a
> CPU hotplug event.
>
> Reproduction steps:
>   1) Create a cgroup w/ cpuset controls (do not set cpuset.mems)
>   2) Move the task into the child cpuset
>   3) Create a VMA mempolicy for that task with MPOL_F_RELATIVE_NODES
>   4) unplug and hotplug a cpu
>        echo 0 > /sys/devices/system/cpu/cpu1/online
>        echo 1 > /sys/devices/system/cpu/cpu1/online
>   5) mempolicy rebind does a div/0 in mpol_relative_nodemask on the
>      call to __nodes_fold()
>
> The cpuset code passes (cs->mems_allowed) which is not guaranteed to have
> nodes to the rebind routine.  Use cs->effective_mems instead, which is
> guaranteed to have a non-empty nodemask.
>
> Link: https://lore.kernel.org/linux-mm/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
> Link: https://lore.kernel.org/all/CA+0ovCiEz6SP_sn3kN4Tb+_oC=eHMXy_Ffj=usV3wREdQrUtww@mail.gmail.com/
> Fixes: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}")
> Suggested-by: Gregory Price <gourry@gourry.net>
> Suggested-by: Waiman Long <longman@redhat.com>
> Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Cc: stable@vger.kernel.org
> ---
> v2: rebind to cs->effective_mems instead of newmems (Waiman Long);
>      condense the changelog.
>
>   kernel/cgroup/cpuset.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2649,7 +2649,7 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
>
>   		migrate = is_memory_migrate(cs);
>
> -		mpol_rebind_mm(mm, &cs->mems_allowed);
> +		mpol_rebind_mm(mm, &cs->effective_mems);
>   		if (migrate)
>   			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
>   		else
Acked-by: Waiman Long <longman@redhat.com>

