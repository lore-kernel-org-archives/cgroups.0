Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839181;
	b=vmEGi3cGUSBL/kIb/2V741WhIzp2HXc4hRgG8MNyklYCDQSeDmXxodzrKctZDBdCy3H/
	 B0pk/VZeE5xtblzcSxkLRX+zOq0gFO2lAZoMnUzNr+CSXNmWpvzwMIGTuw7ukMUKrnsfh
	 a8ymUaSH3qA9JOK11Yrjhaujkc8hDqv3AW4pGGID16u6u/42TqP7C8JNqUCJ76m7/1/rg
	 x6PaBSI2xHhO2eARnbGGCw/6qzDz44p2KRdCIjx3VfiDXMpncBNk8udf44NBfA777BKAv
	 1qq9NW9o1qhxw+DR2d/ImzxX+K1Uuw79Y8GESon+aspxhfUSFdH9cBBwJWztXBYSSHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839181;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=nCuKQ2B+U6EFNvvi/XwnoZbaxFRZS/VTpXWrU5IbtZY=;
	b=F5P5rL2/dSLpA4OKac/FOCHwlGIy7wwSgv1xu2M0LL0Q3OxostbyCUxkpGnqxwP44o5N
	 ae1ALwbdFHeGbQbu6wt+KxCYEwE4wTozDh9gUqIqhBbCW+LhuatiWkMmL4Nc8pHXbn77D
	 rrSQSvtzDME5UgcSO3migOwNnAASGFFVftrZQ0wzPJohevZoC8c/WYMVwVeHW3ghV7bYW
	 T0DvJGrDa6QW6OFORzrEYYsQpr4Dx0RmYRChRVZTy/F+OwCXUZK6wQmNa8nK7akSo5InU
	 u3LdfXr8mAPUc7Sv85PavfVm6/Kpjftu7So2vmr/0H/cGQxoiG7tTb1kg49bsq9yQcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UAR64hJx;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=kF2jTtyN;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67192606A894
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 14:26:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67192606A894
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UAR64hJx;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=kF2jTtyN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794839179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nCuKQ2B+U6EFNvvi/XwnoZbaxFRZS/VTpXWrU5IbtZY=;
	b=UAR64hJxo3UWQynhJqR9/6EqnyPkL2Aq9bqeqPRGZJ3gpdyQ+w39SV54VG/TdIgx0xbl6q
	exFVcoCj/csv4C4LJt5kviRd7rDNeORqQBFqiOh3bhHNs7MrIFjVWZW7yiRluCEYEF8Tsy
	iS2fgY6f4fkJl84c3idX/TrT2tTniOc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-FpPJNvUEPVavYqixLeF1zQ-1; Mon, 16 Nov 2026 09:26:16 -0500
X-MC-Unique: FpPJNvUEPVavYqixLeF1zQ-1
X-Mimecast-MFC-AGG-ID: FpPJNvUEPVavYqixLeF1zQ_1794839175
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a359b714f8so18094575e9.2
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 06:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794839175; x=1795443975; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nCuKQ2B+U6EFNvvi/XwnoZbaxFRZS/VTpXWrU5IbtZY=;
        b=kF2jTtyNIOSCU2A+vnCWysiG5eNF3XvL53kiM0+I8sIKTQCPhpt/9w2zgAWTjO1sbo
         sxQc8akoz1aYsdG5jskfqEC6f2cL1JvveNa/ckaMXQw4AksirhTClWxGzPcm9Ccuanoy
         HNqYW7O5tKFhdaU1KV9cUbeBloD0AwD/TvD/AChhNZSKPJ3GG+XN9L3mHwb1n3XxNeOj
         7fWFe8ENYQJSyy4FKEe77TIMz01kQSGPguFL1Ofu2k800bX0hzmcgBxwhhq+BmShrUMd
         owNFF3INuCUDtD1oEK1oAAjc9JHUkz4aZ3BERpAiggKHX8AINtY8LxhrsnkZhdGxlI33
         0HAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839175; x=1795443975;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nCuKQ2B+U6EFNvvi/XwnoZbaxFRZS/VTpXWrU5IbtZY=;
        b=GCUUZwh3MQD9W7ocgKTuphZ2T0FuISYhdSPSzg4RBL4CfR3U5aKPy9bX5i76slp9YN
         Zuy/pSDumfgoX7kzpe1teY2nbv0S5/QFh79nF4pLZWM+SEwTdvr3HJQ4ffr+mA1b0KpA
         k3++vTVpdWIoOSw04kR9tbyjwWfDpJmDM2WYAbfI/17LNwsO7tZO8dwGq5bSHfxOwNIA
         kA+i1zpyc+zA/vam306zGZbqyYhBJrfJgdecq6w0JcwHSVaVbustZQkFaVrei5VgA5f3
         I7R1itQSmmLV8YMLlW0FzviVZ57tg5EA+x5MEizZghRi4mH8XA2ZCppeguvBF5xUT36M
         7a8Q==
X-Forwarded-Encrypted: i=1; AL+hErFaZX/UxSLUyciE54FL0aqzHgwbCiRJjZaGPFvJ0excHDdoLmWrBFZzdJUUl2J1+GIL0/vG71EU@vger.kernel.org
X-Gm-Message-State: APuU4Z+ryCSr+I8QX7dYJYaOq96HFTMT5Tk1OMXVBKL6WI5K1QZ2LkqA
	HABCckvBvnlLMGS64Q4fps7acqq4JhCVfSjMa3myc5h0kD4BHDmrQSxC7kmcqIE3PchMJGawsSY
	rsG2aKFAgTNvlgu1PRpvub9GboCdUTla7nJBzMe9EgTz2fxqZMJ2VNsv2Rmw=
X-Gm-Gg: AYBFou3cAJiN/KCK5tw6hswlHhGqcIp5XC+K1FH0GUD/in/XMVOdnc0bvvZYhVY4Scd
	1zfqe2e21kZqGkiEaRMgaXa43MjCt3klC2QOwHPww02wLDLREspstLQRYFOmavpnFYIPveu/xbM
	F/VYe83exa2qHFJIKZM8QQp8FGsgkrK+CykZp3x8eNOApeSpBm8atpxHYs0Yu+BWzPDQhlaor8O
	TTaYs0EIYkSr369qeG6tvckV92Uitlv9UPrc57fyEme8Hvc+hSnvDbG8zDB4/5lo2w+Zyszk4eG
	WperugOfzAY2JsMNx6MO9VbIq9yhOF30f4l2jxx8T1LJfAuXdSGXi0+IAqzzt36rNnY4BzzKMl4
	4j7S/rQ99nzocTn0EnaIihB1+HCj3Rv/g655slhSGEStvQeWn2r9cw3D+X5XJZac2xbvPoVvk8n
	IYMDw=
X-Received: by 2002:a05:600c:c4a3:b0:4a1:9663:7639 with SMTP id 5b1f17b1804b1-4bb55ab5526mr234942065e9.34.1794839174900;
        Mon, 16 Nov 2026 06:26:14 -0800 (PST)
X-Received: by 2002:a05:600c:c4a3:b0:4a1:9663:7639 with SMTP id 5b1f17b1804b1-4bb55ab5526mr234941455e9.34.1794839174492;
        Mon, 16 Nov 2026 06:26:14 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb56689bc2sm176845115e9.2.2026.11.16.06.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 06:26:07 -0800 (PST)
Date: Mon, 16 Nov 2026 15:25:57 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Yuri Andriaccio <yurand2000@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <avsSdeZFb7CXnMro@jlelli-thinkpadt14gen4.remote.csb>
References: <20261109163616.195264-1-yurand2000@gmail.com>
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
In-Reply-To: <20261109163616.195264-1-yurand2000@gmail.com>

Hello,

On 09/11/26 17:35, Yuri Andriaccio wrote:

...

> Version v7 introduces a lot of changes since v6. First off there have been a
> lot of bug fixes from the comments by the reviewers and the automated AI tool
> Sashiko, which surprisingly caught a lot of issues. Later, we've finally had
> time to add features which were planned a long time ago. The following are the
> most meaningful updates since v6 (the complete changelog can be found on the
> github readme):
> - Rebase to kernel version 7.4-rc1.
> - Address (most of) bugs as reported in the v6 reviews.
> - Introduce dl_freq_invariant flag for dl_servers.
>     + Force fair/ext servers to be frequency/capacity invariant, while allow
>       HCBS servers to scale their consumed runtime.
>     + This enables capacity-aware bandwidth reservation also for HCBS.
> - Rework cgroup-v2 interface:
>     + Rename cpu.rt.internal to cpu.rt.effective.local
>     + Fix internal runtime rounding errors.
> - Update cgroup balance callbacks to allow balancing operation of multiple
>   cgroups at the same time.
> - Allow unprivileged FIFO/RR tasks inside cgroups.
> - Allow HRTICK_DL for HCBS servers.
> - Integrate `cpu` and `cpuset` controllers.
> - Integrate HCBS with hotplug/hotunplug operations.
> - Introduce dl_server overrides (previously known as multi-runtime/multi-CPU).

...

> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> Testing v7:
> 
> The patchset has been tested with a suite of tests tailored to stress all the
> implemented functionalities.
> The tests are available at https://github.com/Yurand2000/HCBS-Test-Suite .
> Refer to the README of the repository for more details.
> 
> Follow these steps to test HCBS v7:
> - Get the HCBS patch up and running. Any kernel/disto should work effortlessly.
> - Get, compile and _install_ the tests.
> - Run the `go_rt.sh` script to set the frequency of the CPUs to a fixed value
>   and disable hyperthreading and power saving features.
> - Run the `run_tests.sh full` script, to run the whole test suite.
> 
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

I think Sashiko already commented about it, but I had to apply the
following to make the series compile with clang.

BTW, since you already received comments from Tejun and Sashiko also
raised lots of stuff to look at, shall I wait for a v8 before engaging
as well, so that you don't get overwhelmed? :)

Thanks for your work!
Juri
---
 kernel/sched/rt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 8702d0e0c4e3c..c9c8752a61532 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -3113,11 +3113,13 @@ static int sched_rt_global_validate(void)
 
 DEFINE_MUTEX(sched_rt_handler_mutex);
 
-void sched_rt_handler_mutex_lock() {
+void sched_rt_handler_mutex_lock(void)
+{
 	mutex_lock(&sched_rt_handler_mutex);
 }
 
-void sched_rt_handler_mutex_unlock() {
+void sched_rt_handler_mutex_unlock(void)
+{
 	mutex_unlock(&sched_rt_handler_mutex);
 }
 

