Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795083644;
	b=NTAhvlHf5CWKnQjtYPO1dqnPgm9xlm8RYKTK9+UEtB/GTAFipBisnjTMXSfu24oCtPPf
	 1lmJE4xe1iJna1knbwq7Hjpka+btsyxfMkgb4l2hBp7k1AXvaqlXOafdYIRdseQNIsAas
	 mPieZB9OaJaoqGnjbSjbz6r9ffPQqfAv50lPY0xcnSAg+C6oRLVjL7ZaV5pBvn0HatsIa
	 +5OASha2NHhMUBRDpmx+80Ms/zreIwnWtCIv+LQQcsFjKc4Df2q0OtZ6EyXl1XEYumhn5
	 6UHdA1MS2ZEYxJhsoNPyhk6eRDZWpXujexguqQJJiTmH0LIIspagQwMBfv8tzBwE7og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795083644;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=BhMldp/vd/3xPeYieMpRCN6PVD+GGJcYfaPHMFtkt6g=;
	b=dtHDrwq/Qi25SiiDtAtFK1JE48Q1hIBEvLiwb0jEh3mvdXdXhJv3FeoMCAQrNTLYmPFz
	 QeQVBKN2MmTnZMs1k1XnjkXihTj4qaataQK5ZJnW/LZe7x5FgkUhecV0s3PE4bRlb74qy
	 1BysG3gbOhBE1udnpgrNpMI2lc4T/tfaeANufCYmSAw7pEPnco5vHxhDWVdCXSa66Tqa7
	 fHAGxOJ85Yame4gP9JzHiItPvHBm2QerJPa7x6Bzhxe/A0ubaBOItieV+SQFBx+zrhhjl
	 6Jvj35UI3SXL9FKBIFetiK3I+El5XdUh+RQiUJUIEaN3n+M02rGbjVwBls4snrrde7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MfwQ7KBl;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=f1hmI4Sc;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBA9606A330
	for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 10:20:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DBA9606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MfwQ7KBl;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=f1hmI4Sc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795083642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BhMldp/vd/3xPeYieMpRCN6PVD+GGJcYfaPHMFtkt6g=;
	b=MfwQ7KBldieroLzt6RxKDwhHxePDVQY5zw3T1SCSt64R6gVNNcZd/iYQrhoFcEIa6b+geY
	TF5q5/NbJqRgXEvUk8aFX5HdR7zyuXrLmPgJLtxhE1yutZU2W2XcraK7OUkG6HOngoWkUA
	FDkCMzD2JkCXf8gP/A9qptWpwnNcODA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-s9-RzkyXPk6ixQ1DyqKNtw-1; Thu, 19 Nov 2026 05:20:40 -0500
X-MC-Unique: s9-RzkyXPk6ixQ1DyqKNtw-1
X-Mimecast-MFC-AGG-ID: s9-RzkyXPk6ixQ1DyqKNtw_1795083639
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4bb680f0ac4so12804305e9.0
        for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 02:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795083639; x=1795688439; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BhMldp/vd/3xPeYieMpRCN6PVD+GGJcYfaPHMFtkt6g=;
        b=f1hmI4ScajTFU6GbpU8sXup0ewKM/uV8y6MP2vb6N3uIQwjA0IW5IlaK1TZdTrb8xj
         T1RpV/D22ixGyGfh0q2h0MCNQyhkt3A6o+3WiLfL+ELiDjQC8Mx0MKsTdGfqukJKUNYI
         YvlSxXHP0gcfX2tJgf1LhUNQSMkJjQvvOQ5wgZCuoIIi549FXtcZ1IC1DBIsD7sVnYgq
         oZdgyYxUv8Khl8wl5WB73NZk6cptbCssyiUrKoNbpF1qaXgxMHg2RTPKlFFcV3JpgtgD
         gALxJU4E+5PPeOpycwb82seH0sgznn84UV5ExW4HuTCsokPSCIeW3ZzrPLRJCkItzS5l
         sD1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795083639; x=1795688439;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BhMldp/vd/3xPeYieMpRCN6PVD+GGJcYfaPHMFtkt6g=;
        b=BwhLwHxUCxq/27Wtv09BUznNHefsS/K1vTeicRNnnWbPY82svJzxYl1LbgFI13AOim
         yQTnQLRtphvB92kdomYJy7rYWtd80+0RvWmuvvxzkfzSDfrFS28sivkcCuaufPQ53wGV
         L9BqNvExohglcsMdXGcwHq77Qmu8OSKzGAdp6zGIsghJUXsxg9uqQ0yd9jLyauROw1do
         PipuazQ4GDnYTvodccx++YkvLEdR2+QvjjAoPTob94W0MrexedYFOXW4a6IEHXfrUs9e
         lF+ZTpjCUO1Wx90yXgb1d9Ytz9cunw3TCqho+taKI4UI8WLxF7VIBl7YdRrIZfk7ziuk
         DyUw==
X-Forwarded-Encrypted: i=1; AL+hErGUXxV19qP5kTK3FGcrzIaaan1yUeGXlInW5svEEnD/rFD8KDt5U8mmz/VfU/h+sgenoyVGtaPC@vger.kernel.org
X-Gm-Message-State: APuU4Z+ZPImEJVq/IcShOxycU4Z66+Ta2Dk37tWqTYHi0sWSSHQfMhXP
	k9KfcKwFx8/qk5wA4ud8rPF8Ax5ke7r8XF+/5tyiSjgIfokl9w15MRcxrJLB/mBB9DrLnrwZ7eq
	DRgyizpmiURfZXWQYdIdOb5DT7TJjMz68hQXvGyOs2LvKifRcclHIKNC2pUg=
X-Gm-Gg: AYBFou0ElcvAmhjGk5PPMxHsKIUEw33HCEv5RILe5unkljNd1esshcPcw3LG6EGXTIX
	MvVjNCCCuGTOwuYTBeq948Er65GxLQhbCWxfdr9S6QGEKBtnwbnQVXUTjjAYzuq+hLqpaJevIZr
	kMn/SHy3/Dqy3gAxvfH36iL5hgUC11HsorKdodA476D5XLKjEiph1blnU5oKuALjY4LmsK1FJIQ
	1b2b3FdoQbvO2E0t5A3nigrnSJFYRNn1k6ZmyQ6257vU0CtgqGcd/cihWV68pztZeNeGHAE490Z
	d3h3atJHoesYxkswDMk2aBN73JZ8i4az2UmGF/afEhyYONcVhn0vCUZRIDUOVpwhEOl2kt000LE
	gcwcp3v+brQzUnWH8ECcm9t/60A3Ecvs3IxARpDiZ76yTkC9e4L+F1mjF8DQsZMHqWyhx2RbN7N
	vbMFE=
X-Received: by 2002:a05:600c:4e45:b0:4bb:6814:738c with SMTP id 5b1f17b1804b1-4bb7da267bamr95705565e9.22.1795083638714;
        Thu, 19 Nov 2026 02:20:38 -0800 (PST)
X-Received: by 2002:a05:600c:4e45:b0:4bb:6814:738c with SMTP id 5b1f17b1804b1-4bb7da267bamr95704865e9.22.1795083638277;
        Thu, 19 Nov 2026 02:20:38 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853b2437sm37226425e9.13.2026.11.19.02.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 02:20:37 -0800 (PST)
Date: Thu, 19 Nov 2026 11:20:34 +0100
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
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v2 00/16] sched/deadline: first bandwidth accounting
 fixes and selftests
Message-ID: <av7NchMg0wnyzjcd@jlelli-thinkpadt14gen4.remote.csb>
References: <cover.1795037078.git.mathieu.desnoyers@efficios.com>
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
In-Reply-To: <cover.1795037078.git.mathieu.desnoyers@efficios.com>

Hello,

On 18/11/26 16:24, Mathieu Desnoyers wrote:
> Hi Ingo, Juri,
> 
> This series fixes 13 bugs of SCHED_DEADLINE. Then it shows the deadline
> bandwidth of each runqueue in sched_debug, and adds two selftests. The
> fixes come first, so that stable can take patches 1 to 13.

Thanks for splitting this out. I ran v2 in 8-CPU guests with lockdep and
proxy exec on. deadline_switch_test passes 5/5 (sysrq cases included),
and deadline_bw_test passes 45/46 (move_cancelled skips without
RT_GROUP_SCHED). There were no splats. Reverting patch 10 brings back
asleep_round_trip, stopped_switched_out and overrun_caught, as claimed.
cgroup's test_cpuset_prs.sh also passes, as on rc2.

I also covered two of the "not tested" items:

- cgroup v1 cpusets (two exclusive cpusets, root load balancing off):
  admission, affinity, refused moves and hotplug all behave as on v2.
  On both v1 and v2, moving a task A -> B -> A leaves its bandwidth
  in B, so A is under-counted once the task dies. The leak is on rc2
  too and the full v7 fixes it, so it is not a regression.

- sched_ext: the in-tree sched_ext selftests pass on v2, total_bw
  included (dsp_local_on needs IKCONFIG_PROC for its __kconfig extern).
  With scx_simple loaded, deadline_switch_test passes. The server cases
  of deadline_bw_test fail, because they configure fair_server, which is
  detached while ext is enabled. Pointed at ext_server, server_params,
  server_rebuilds, server_states and server_reclaim pass. hotplug_server
  still fails there, as scx_simple gets ejected when the CPU goes
  offline (I haven't dug further). Could the test pick the server that
  is active?

...

> Patch 10 clears the parameters of a task that leaves the class asleep.
> On v7.4-rc2, such a task kept them. That hid a bug of the rtmutex chain
> walk

Please move this into the changelog of patch 10 itself, as the cover
won't end up in git. IIUC, the owner then sits in the patch 8 bail-out
with a deadline of "now" until it unlocks. Other deadline tasks keep
their bandwidth, but lose latency, and RT/fair tasks on that CPU get
possibly starved.

Doesn't your separate "Fix an overflow of the 0-lag time with long
periods" also fits here, right before patch 10, which adds a caller of
that computation?

Patch 5: yes, keep my Reviewed-by on the version with the cpu_active()
check.

Thanks!
Juri

