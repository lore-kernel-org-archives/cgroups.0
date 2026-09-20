Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9083DD528
	for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 08:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789892617; cv=none; b=GH2Icbmil36qcU2GNk7tGTeUbNQ7hSo9RBrbWIPp6lYBUaTflNrvDxo2Z4UgMgNNCqjANZQ5XC7eDfz8WoVHnAxVIQnTKxn+6ZsDGJUrTW6Ha1vmHHxR0M30qvvuGVIFfwrU16skm6wGwn76HA7nvuBW2nUHr5k9aZZvIDy3JXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789892617; c=relaxed/simple;
	bh=ev7PcESFwVFa9qTkRTwUckmXc+KPfrq3DAOonZwMU0U=;
	h=Message-ID:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O0uomwkm1CK5mNd6RXvupit5rfpW9j4p/1txh2yRKGZYKJUzAhKEghUTID0g8xqaAXS/pMfmrgqJSLFaVtn/XoZR3YVO2SshRVKMjJ6wMBabLVAAW4TOwOLDiG4K9ihk5lgW/r+hAnOYVy2FWy1ZHYCe47J9DhSRdkEJ3ijPwRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ssNntqBa; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ssNntqBa"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2dd1dcdcf95so14589585ad.1
        for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 01:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789892615; x=1790497415; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:cc:to:from:date:message-id:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wqdthH2+u7ccIC4kuTBUygyDe5dzFriIWbVHHdP//7c=;
        b=ssNntqBa0cWT+g0TUwPcCeKUhnPoRUmLuwZMKk/CW4OAgy7zidu4PLl5vHGQvxJSVz
         bBCP2vseMPR9QSkqTL+namnScCb8bZ9XHU46y2cf6sp86w3Wlt0iyJtb4O1uSqlxO2c3
         DNuOFgzbZq7FbwmG1KUQ+nh0EdzwjxroJZO6UWteCpZNCtmiBiFllupAq6Bvx9xDPTYm
         NuFihOBTLJ/6kDwNcvvdaV+ieBPcKJaS6yXWjHhToW45RY4QFWCOFY7m4XsZjCiTw404
         Uu2iR7bD4hVeZsojr9x2LKLaLkVQjSc6xSx2Vj2vNnbS+gZwjao/wti5fli2l+5uCT9l
         E9fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789892615; x=1790497415;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:cc:to:from:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wqdthH2+u7ccIC4kuTBUygyDe5dzFriIWbVHHdP//7c=;
        b=MTkn6Luw36zIFSrURwKX5jJi8FvcPXkng7b0TOxhpRTNdTlh2Gdo17zflXiYKIxvnR
         cItHGBrFTBrUkOJX6EOyDpusy7vyH+NalB3J25dxWV1ZIPEC5kKmLwWltHzp6/8L8fyT
         mOIcntaPgn+VeoeHaJJktkgdDNmM+qTGrEyr6sv7lvUyNTYEqukmQkNbZ7o9QW/oq6Qf
         38s6AySJz6neH8+fHOqTQvG9gJO9/Vn06dqc6Y3+NCFi0SieAS5qwy5U5MIZ2gPDV23j
         NI5wEm0UZ2EIP4sPmJf7VOSZCRR648hEF1ANgi9kmCOecfLnYo1U5deb7uDr1DCh8Ub8
         RfuA==
X-Forwarded-Encrypted: i=1; AKwUvBz0Aca3UeS8oz+qu5I2myX2ZwkYTZAEGuVJFIObIKlDDvnf4jpRDWvpyWdkvJ9S7li9NHGhPT00@vger.kernel.org
X-Gm-Message-State: AFuF++lQSKpD9NYbHXkeIPqUgHrmasPcr8GksA69GuudqctwqoFWfvSt
	VrguGhd8g9f7WfPgpDFhvB+PYGi2etpp2lmcfZFkaWhK/CjVpB69oAXa
X-Gm-Gg: AYBFou0LolfB0REenni7EIdtSArOTWZzws94UwaOEic9rVTZfSbzujygKvaorJRSFTb
	IIdvGPndDdhCD+b0+kxq/tyXfGc5xCHZYJhDYsM9wc15Q7mA5QG60lFrt7vrRqA8CSIiOOmsn5K
	ZOyov8NNOYSZPFEM0tn1AcA5De5YEZV7RTcSx/hiTrFPCOEQiIYYGTyBwEgRVHON6vDQwNW0Dzu
	Va/AtKAzniIFPZVBQPz9jaLKHbSnrdmb9D0syZqJ+9xciZMYDnVjL9SSBCGFsvbbCglMadXo2cI
	av31kIo+aSJsSc5pAtT5HEms8oy+ogVBHijwrb3VTh2Pg1kBsWJaTthjwvnOq9+yFr+Arc5+/OR
	7bEZmCPfzXXzA5PnhYk8cV4uin3xRIOzCri1T3ZWepf1VDlmS1nVQwP8+xRoA23hddtHqZJXgX3
	Bc9yZv7Qpw2aeiqwrbsqMmNVEdqOTMrvXSQhqbeOZdqN3EXBgsF89mjvWkZThzuSid2GNk+WLp7
	Jt6B89ZsblALwPpe8fc1LnRGfS3s5Q5JsIDoaVo+Qq1jmKM2j9EffyW/RE04kGR7MSmfooW6tHt
	4sFi
X-Received: by 2002:a17:902:f68b:b0:2d0:401c:2edc with SMTP id d9443c01a7336-2dd9c6b9174mr152954355ad.1.1789892615248;
        Sun, 20 Sep 2026 01:23:35 -0700 (PDT)
Received: from phui-2.c.googlers.com (67.51.127.34.bc.googleusercontent.com. [34.127.51.67])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddc1788890sm17346245ad.27.2026.09.20.01.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 01:23:34 -0700 (PDT)
Message-ID: <6aaf9806.106316eb.1c5ef5.5b58@mx.google.com>
Date: Sun, 20 Sep 2026 01:23:34 -0700 (PDT)
From: Hui Peng <benquike@gmail.com>
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Ridong Chen <ridong.chen@linux.dev>, Waiman Long <longman@redhat.com>,
 Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hui Peng <benquike@gmail.com>
Subject: Re: [PATCH] cgroup/cpuset: prevent overlapping local and remote
 partition creation
In-Reply-To: <25b72fce-5354-435b-9256-482c15ae7b06@linux.dev>
References: <20260919204807.2812708-1-benquike@gmail.com>
 <139d9231-4723-4365-9af7-8142e6581ede@linux.dev>
 <20260920030458.1800040-1-benquike@gmail.com>
 <25b72fce-5354-435b-9256-482c15ae7b06@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Guopeng,

On Sun, Sep 20, 2026 at 02:30:23PM +0800, Guopeng Zhang wrote:
> Should this return PERR_NOCPUS instead?
>
> +	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
> +		return PERR_NOCPUS;
>
...
> Would using PERR_NOCPUS here be more appropriate? This would keep the
> initial remote-partition enable path consistent with the CPU update path
> for an existing remote partition, and it also seems to describe the
> failure more accurately: the CPU itself is not invalid, but has already
> been allocated to another partition, so the parent can no longer
> distribute it downstream.

Agreed, returning PERR_NOCPUS when tmp->new_cpus intersects
subpartitions_cpus is much more accurate and keeps remote_partition_enable()
consistent with remote_cpus_update(). I have updated this in v2.

Thanks,
Hui
