Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43CD28506C
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 13:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784725300; cv=none; b=Hfvk9Kxu3oLNa2KSMKVO3xmmNkFuJ+z/Nyfwz9uV54OozRDe77Ni8aJrVSSavtTG5IlY4E2YSl5NXd9zOvWqlhwXLQHPTrT7zMPoVkqt2ARfmSKmvQugdEhKC1PtncuxFHExYehdAsXiEhuwnJocbcOb8B5gAZHeX69j33pQ+qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784725300; c=relaxed/simple;
	bh=wQrqwaqAAAHfV06ufuWJnrTQGXAusn8DdkbMG8nkRrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DQ72gefPrixIMY1JmusUYnS5uslmlTaJ1a4dir7Uz9j26QYb6oojEdSNeESu6wrKDmYzaedNo78KP4tDS5Ej8X3PnVUPlc8pyt2pBnZx694L0FFaampntGPTQeGVIwVKQKgQIA1rUx1S4nKlBu+sCqahedgUVuGPIHj30bSNuts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=lSwOyNcO; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="lSwOyNcO"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b2a8e4c77eso1362645e87.1
        for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 06:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784725295; x=1785330095; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1S07zOcIxbdMXlT+EiHelCK8nLPptceTFpPa+ZORBrc=;
        b=lSwOyNcOHc/w7R3T8cuA3HUrsb5sm0KVk3Zgf/bHte8+MsvMQWOu/k6YYNsknhN+eJ
         x/ak3a6Sdq/54Y/gjWURvy1djNP28eRYLaclncqhM9M0+S4k2e8SvzCNiw/+80J3qseg
         8UKphu7S/SNXYeLTd7psvuPqXFPN2uLreJhNZxWnUr9kkE0qc8F/kwZZrBru0kn9+o0/
         CbPWFHan74qCCeeWiTtik2vovy5iTo/jqqR70oPHpDas0g+fB5lOm/m0PZvJTTEkxeed
         rieaAXRpnYz1CB2oCPMn0nRhjdF14S20w/5lSobcVPvuofdK13l7ekrq4bz24Ab3FeCP
         m8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784725295; x=1785330095;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1S07zOcIxbdMXlT+EiHelCK8nLPptceTFpPa+ZORBrc=;
        b=QLR9zfz1Zr+bqdARf/CjnITWQ2xC5X9ds/Ij2EYT1aXMVEnArtd7Ai+18/rVnZba5h
         7qQrnFuliTRFomY3qPIp03DygQmVKhafpoYWpEMCvQc9BWCd+0zcsobaX6jO1b+BzboD
         Y4Awv6fZPAnBzzGYTz6+aC0wuDWV29XAAG+HaBs5Pxzqtau6Esmo7k2N6xyld8F1w8q5
         p47yGwNdBWjNoKbi0TbxKcsHMBQOrEd0LG8St32uvIdEyJN0JJvqAYTEouVt8Lm7Ztt9
         E57oPOo+zle0Ns1tBG4zSw7C+Waft4j0MzUNND2tHU62+CyfdpQ0zHM6odMrqqpH2jbf
         ND3A==
X-Forwarded-Encrypted: i=1; AHgh+Rq2NajZYRwc2EqHV785JIbqHMZhJlgeHOJgJnhAqDJhdVPEm3ke/wAJamgi9Mf0sO1fFI3TOVHP@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3JWuUNMA2N8RF5KMzMi7bYRoyVXC9SXsw00GvzEILqDG1JPvs
	upZv+yvDMZpszi2JaxPw4dSUhx+cbHL6MtUC4+lEx5DccCI6a/IUl8OleFbwqUZPL8Q=
X-Gm-Gg: AR+sD12huHKW62aDKyylvudiiU1sTxqLx6HliyAmMUv8OLyY970edkO9Cxsdzfhb6xS
	acjNfkHozIRGyzEKFyGpY5O756tigp4zY/Q12Sa0iYy6lAIfwJCfos3WE+3OWpGALqjb7BEZgIF
	pP0mjpQzk7KpNFhj5t6Z5kVlaw6y0qNqpM2C2ObvD7QbGZU/oWNWmw6sRTEVvs16r/byU1pwhZG
	gMtUh4uQEvIzljgYa4o686Vc3kWbPzMTX0eyeGWkHnx2KEnkvbdGjJu3ViV8fOHAqJGn5dp+ftN
	vaACekICdfLzYY0IcZ2/xZo50TeBmEbq412Y4StabSvkT2UFzk3fsxA2ouMOikLzW+/aLRnz/3u
	ISb4N+rxiS/uDImCw6Z6awR9hzQE5GYfiHUyt/kH03prYy0/OguWLeZ4qaK1qw0cOvX26Vpja+x
	1iVHCYV5bgwEtX
X-Received: by 2002:a05:6512:10d2:b0:5ae:c34c:aefe with SMTP id 2adb3069b0e04-5b28fad60c6mr5115853e87.62.1784725294622;
        Wed, 22 Jul 2026 06:01:34 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2a9e45344sm451183e87.64.2026.07.22.06.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 06:01:33 -0700 (PDT)
Date: Wed, 22 Jul 2026 15:01:30 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, cgroups@vger.kernel.org, 
	netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	jgg@ziepe.ca, parav@nvidia.com, mbloch@nvidia.com, cmeiohas@nvidia.com, 
	roman.gushchin@linux.dev, bvanassche@acm.org, zyjzyj2000@gmail.com, shuah@kernel.org, 
	tj@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org, alibuda@linux.alibaba.com, 
	dust.li@linux.alibaba.com, sidraya@linux.ibm.com, wenjia@linux.ibm.com, 
	yanjun.zhu@linux.dev, cui.tao@linux.dev
Subject: Re: [PATCH rdma-next v3 00/14] RDMA: Make device names unique per
 net namespace
Message-ID: <amC-_-7QZCPckp6e@FV6GYCPJ69>
References: <20260716132316.1495242-1-jiri@resnulli.us>
 <amCm6nW8IttsHGgY@FV6GYCPJ69>
 <20260722115323.GY110966@unreal>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722115323.GY110966@unreal>

Wed, Jul 22, 2026 at 01:53:23PM +0200, leon@kernel.org wrote:
>On Wed, Jul 22, 2026 at 01:19:00PM +0200, Jiri Pirko wrote:
>> Thu, Jul 16, 2026 at 03:23:01PM +0200, jiri@resnulli.us wrote:
>> >From: Jiri Pirko <jiri@nvidia.com>
>> >
>> >RDMA device names are unique system-wide today:
>> >__ib_device_get_by_name() checks a requested name against every
>> >registered device regardless of the network namespace it lives in.
>> >A device in one network namespace therefore cannot use a name already
>> >taken in another, even in exclusive netns mode (netns_mode=0) where
>> >the two are otherwise isolated. Net devices have no such restriction -
>> >their names only need to be unique within a network namespace.
>> >
>> >This series makes RDMA device names unique per network namespace,
>> >matching net device semantics, and adapts the users that assumed
>> >system-wide unique names.
>> >
>> >Scoping reuses the existing rdma_dev_access_netns() predicate, so
>> >behavior only changes in exclusive mode:
>> >  - shared mode (default): names stay unique system-wide, no change;
>> >  - exclusive mode: names only need to be unique within a namespace;
>> >  - CONFIG_NET_NS=n: everything is init_net, names stay system-wide
>> >    unique.
>> >
>> >There are two users that cannot be made per-namespace and are
>> >documented as known limitations instead of changed:
>> >  - the rdma_cm configfs tree: configfs has no network namespace
>> >    support, so it cannot represent two same-named devices;
>> >  - SELinux ibendport labelling: endports are labelled by (device
>> >    name, port) from a global policy; distinguishing same-named
>> >    devices would need net namespace support in the SELinux policy
>> >    language and tooling.
>> >
>> >Tested with the new rxe_netns_names kselftest added in the last patch.
>> 
>> This looks like good to go. All Sashiko findings are false positive or
>> unrelated. Care to merge? Thanks!
>
>We usually take extra time before merging complex changes touching
>core or UAPI code.

Sure, I just wanted to let you know the ball is on your side. Take your
time of course :)

Thanks!
