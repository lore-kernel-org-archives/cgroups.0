Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794380112;
	b=tMiFYmttIO6ZPzqfDiH1zy2+45hLU3HYcLZQh5Z+lEi2tNwarn/eFTbNsyNIcu9zx8My
	 7WyvoaHt3fO0RJ+9Br4dZRbSb9QEMR+h+M1WWJil4AQpy+CYtLSqGltniXhOTYJ6KsEgp
	 8rAqNnSw15JIEsotgCLfu/lG+k23nK8gA47HhjNZ3dt2E+Jcm3MuhlDuESMYlB6GQDVos
	 C6tcRf34Ro3nFl6hcMbyep+eD6qYuMSaB/JzpxXoqlVFsOg0Pgw0uFBMckZDvYUgPgHCF
	 S2vBZkVVlqkh3MxULfrvTC4T3GF+j8UW32wH9s1qObwbr3e+GJ9VyzPonUVAWA5SQbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794380112;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=yk7uCCWqva6Cz5l1wMiNcrGG28MVu58wttnXuq3Zst4=;
	b=bmrsXsuN4sVAscIvkmF51sm2eb5hBk7TKNGOZXb+aqZbyEkTHZnTUQglnr3pkLidSfIq
	 8IVaY0DrkmxYemr52xTI8qbbSnalU2/m5GJQMglwMWqWkOxdtPk+TKR+JXaHlj1jO1Rjg
	 YwXzScUxLncZqkw1m4GoxG7V3IsQWB0CQnGmuhRL2ilMuqytcN+WZr+/nKjKSu8kvKthT
	 GNwxN3cMU+D4w1ZI2F0HOVkiiFNntDauzOooc3D91qqmT9xw3PE1KHXuseZz4+H3q0v0a
	 KRgisuNSFSYtmhA+I45q3DI1tOiCyg5htMtGEMvmIhchgY98IhdVvO4kcVv4wEY/oTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Q8ytxZJl;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b="UyX3yv/Y";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45693606A326
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 06:55:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45693606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Q8ytxZJl;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=UyX3yv/Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794380111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yk7uCCWqva6Cz5l1wMiNcrGG28MVu58wttnXuq3Zst4=;
	b=Q8ytxZJliyqx8KAEE2UjXU77OB1fQ2bn4K+A3H/cyLxscxslyCOgRauNIYUZGQUN5nPCcG
	FQs/uKXQVjt9oa42NFXtbza+DJTi0eRdcMdGJUCoUPtwYgLhAsbx5//Pn/MaaxjhsuuAax
	b+SW2oVBqMPUuiy3f2dpBxDgyCWjTzU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-32-BcG_rWXRPxWG1E_BIJjtVQ-1; Wed, 11 Nov 2026 01:55:09 -0500
X-MC-Unique: BcG_rWXRPxWG1E_BIJjtVQ-1
X-Mimecast-MFC-AGG-ID: BcG_rWXRPxWG1E_BIJjtVQ_1794380109
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a027f2e364so20212045e9.3
        for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 22:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794380108; x=1794984908; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yk7uCCWqva6Cz5l1wMiNcrGG28MVu58wttnXuq3Zst4=;
        b=UyX3yv/YQ2i4wO9frSBnspnz7bdpT+z6pnNbaQpExynrIgYcp9KJZcoGuMDXqchZaZ
         RDhT2aTINacelsVBg375+O/TDH7rJpXFhJIB4NLq4UY3bkjFgOgzZIcIIRC3dByh0lPX
         mKXiVyOWazCba43QiTmI/jskbCAF4UW0Zd9ATL2ehHs+CnxAF7uY6xbUnx9BcR8WbPj0
         fsTuQXEuwZJXhRYFlNe3K3TUO0AP0YhCQKcwXvafUblk0aM4zZmQqnJqDjWQpFHOS1eJ
         8eoBqQgAsdQMYZjhFt0QAsBwsmvstJ5woGI2ERwiE5j4hlUOwT/+Iwr+m8mTbY5FNJBI
         cMTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794380108; x=1794984908;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yk7uCCWqva6Cz5l1wMiNcrGG28MVu58wttnXuq3Zst4=;
        b=jKE/fCFtOAQ5wJztz3JnRY1FCQA7tpxutt/dcY4D4WbuA28IP/3cmunBRAVJ0SG0zX
         ix5wnVgoXMeoaJMHjR11ppL48Yur9dewfpeEOKy+/yXLFnSE9j8ipNwGQ2C9BGWnQwUX
         eHyikSuU/XhUV2dcFjgwEBWPJ6JHJDLQZLXWEji73dAWsCc13kADiJPtvBzzGcmUVFfY
         jAmF7ldEnGp6Lh31aToSMACS8GXkIy4Aq1dHFkRP+aYKMF0TSMmE5KmSAsicVqh05BH4
         ddMGhTmvetNXXqAitehDByOuUAKTWpH4IdLjAtCoqGzWZFzhukIrVWwuJlIyXKyTeXZz
         9kJQ==
X-Forwarded-Encrypted: i=1; AL+hErHToZNm3L/RqqGJjLuC+mCtrtXae1y71R/1rs2jN0YpQMde+boGB++hoqbOJeHYiIbVXJHRj5Sm@vger.kernel.org
X-Gm-Message-State: APuU4Z+Ve2mcyWt+7YI4Sdpc1nZuF+2za40h+bEGxPt+Gid+zOY7bT09
	/udcfXngAKFzX+rkCet/tFzETR+QcwSJJpqMtvgFcnh114283T34YqrrbqSppqdMKgscC3LSRQW
	WtF+Cnxn/pcrOy0sTxXJXrK8Oet0Fp8BuuMPCuMa/W8mDvH2xxMlAK7bPAXA=
X-Gm-Gg: AYBFou2xewGNz/tne0ctowUwcxd5gQkffhR8Riv9RRaWIL5o1P89c4v/J6GeCqvB/PR
	r16ny2k0VoO6dYW/80zk6gseGreTQw4z5pO5A9Y5X7gpGjwIawfbVh4/FM+pkZOQxw45bCJ1bBG
	DNZN491JfSdKg+HuieIrJGuTg4SrVPG+PRAneSWwoPEIZR4RAv6MSj/0WMbBrop02sSuqFg3onh
	lJw8mlmO2johZrtBomyx5a9Py/ot9QGbFwXbRHgtVZxGK6EODk99k1aWH0/mPh+6CI8ixTss6Sy
	pJbtE1l8RYStHDZ9R2BKOZzQ/3dmWmcvnfqbl5eR7WHCBuH5rgasEcRXicks9EcvNZpG/Z7hXVC
	wJW/oWMibcHOCtWluYyXxndhugjR/wl3xN5qQ+auJkfZvCJy5FWx1tR8mp1pEGp1XFPp3zTN/wi
	1rheA=
X-Received: by 2002:a05:600c:4f55:b0:4a7:8fe8:130c with SMTP id 5b1f17b1804b1-4ba0938197dmr25955165e9.28.1794380108618;
        Tue, 10 Nov 2026 22:55:08 -0800 (PST)
X-Received: by 2002:a05:600c:4f55:b0:4a7:8fe8:130c with SMTP id 5b1f17b1804b1-4ba0938197dmr25954715e9.28.1794380108281;
        Tue, 10 Nov 2026 22:55:08 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba09517bc7sm24307235e9.3.2026.11.10.22.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:55:07 -0800 (PST)
Date: Wed, 11 Nov 2026 07:55:05 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org, tglx@kernel.org, will@kernel.org,
	boqun@kernel.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	kprateek.nayak@amd.com, luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org, longman@redhat.com,
	ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, shuah@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, parri.andrea@gmail.com,
	m.szyprowski@samsung.com, kayracizmeci@gmail.com,
	weihengqiuu@gmail.com, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH v5 12/29] sched/deadline: Reject SCHED_DEADLINE on exited
 tasks
Message-ID: <avQRSdb-dRzzsmc4@jlelli-thinkpadt14gen4.remote.csb>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-13-mathieu.desnoyers@efficios.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261108185406.1549770-13-mathieu.desnoyers@efficios.com>

Hello,

On 08/11/26 13:53, Mathieu Desnoyers wrote:
> From: Juri Lelli <juri.lelli@redhat.com>
> 
> sched_setattr(SCHED_DEADLINE) on a zombie task succeeds and charges
> total_bw via sched_dl_overflow(), but the task has already done its
> final schedule() and will never run again. Nothing releases the reserved
> bandwidth. Repeating this fills total_bw to the admission cap, after
> which sched_setattr(SCHED_DEADLINE) and CPU offline fail with -EBUSY.
> 
> Reject sched_setattr(SCHED_DEADLINE) on exited tasks with -ESRCH.
> 
> A task of the class that exited, switched to another policy, runs
> switched_from_dl(), which decrements the count of deadline tasks of its
> cpuset that cgroup_task_dead() decremented already: at 0 with a deadline
> task left in it, the cpuset is skipped by the next rebuild of the root
> domains' accounting, and that task's bandwidth with it. Reject that as
> well. The deadline_bw_test selftest added later in this series has the
> case, death_zombie_switched: on v7.4-rc1 the switch is accepted, and
> the one-CPU partition root the zombie ran in admits 9 tasks of 10% after
> a rebuild, with a task of 30% still in it, where 6 are due.
> 
> Fixes: 332ac17ef5bf ("sched/deadline: Add bandwidth management for SCHED_DEADLINE tasks")
> Reported-by: Weiheng Qiu <weihengqiuu@gmail.com>
> Closes: https://lore.kernel.org/all/3f6e6c87-645b-45fd-8fc6-8da5bc5b82d8@gmail.com/
> Link: https://lore.kernel.org/all/20261103-b4-sched-dl-bw-fixes-v1-4-dd761fe005b4@redhat.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
> [mathieu: reject a task of the class leaving it too, found by the
>  Sashiko AI review of the patch]
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---

Looks good to me, thanks!

Best,
Juri

