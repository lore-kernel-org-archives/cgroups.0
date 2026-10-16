Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CDF2E266C
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 13:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792156723; cv=none; b=lGTEEIe0Ym2KiNRVfJZ+cOjwaspKL7R60ajyj/RslTx6Ij2EDAXbUWDFgT1XcNGWZvWgVerMFxQYHBiCy+l+r0NzbXLzEivbrhmzfdyWH/4qqJD16vht7/MOeVnuPoHm6EN+rRrL7kMrThtLe8x0OqiX0FZexAtRxBLgYGvjAs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792156723; c=relaxed/simple;
	bh=QL8io3hFYe/v8PWzmMCFcoQk6f8JTOuZ0YD1MSHt3Ok=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=LoO6mR6Yp6HHj/FbSJNkMW/ybD3ldW4greW/f5aNCmeAd85LFKiWMmxTnzcNZB4e49JkxBBIBTQtie0jI27srgDr8sCKYRyvow1NjVLDJu1KijTv+FfU7u0eNOzbuCZKJa6XmDZmCAQiy7hg3nzsKgGRkm2xCyo1iwyqSh6k9rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=okonski.org; spf=none smtp.mailfrom=okonski.org; dkim=pass (2048-bit key) header.d=okonski-org.20251104.gappssmtp.com header.i=@okonski-org.20251104.gappssmtp.com header.b=jJJ4uC6O; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=okonski.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=okonski.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=okonski-org.20251104.gappssmtp.com header.i=@okonski-org.20251104.gappssmtp.com header.b="jJJ4uC6O"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b1ab2ad719so2548334a12.3
        for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 06:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=okonski-org.20251104.gappssmtp.com; s=20251104; t=1792156720; x=1792761520; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fWhFq5kg3woqxSUvm+Zp+h0Q0CYXygiXnJMyVN/bSws=;
        b=jJJ4uC6O2JMRJv7OeWKJwsY3POZY8fsv6V49MFD5oelnrD8R6cccslXjFUFDzMyll+
         kJr9M8Tpw3TFo2g0WTm1sY3d05x3fwmEm0O6A349xPBCyvxHsiR0AMFJ8Kf0l7nO8M3r
         9HGD42hVmCL3z0YxrUZfHt+7mx0rNCFYHLDX/zgE3E0zsHLkiuj0WTM1+zshaRC9dPtk
         jVBin+mv40C0ytRte8E4f1EyY9a+YYVapQyTnpVmesfxBQ8Q60JTgwjqVwK3FHASNeVp
         K0tY/3Wz2dSrKvg+E34XULxCWYQRwkLCGNawpDtjoPyJlcWOwC4WU8rpOtdF67naTNu2
         RcyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792156720; x=1792761520;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fWhFq5kg3woqxSUvm+Zp+h0Q0CYXygiXnJMyVN/bSws=;
        b=eFHIjEaTt73C/yJ5Cd0QviAQS/YuXVKRkkx9rRmGA63CqgJkVmmtizTb4m0lst9rpN
         MUI3fMizNTyRMAMZCi+h99x2ieyYgr0tDOa5vmxNjW8SUK3MOU/HI17c2JX5QjClug7M
         mBXAYA6x5uB27L1dfHmhTVhBQLBSnc5vkc+OHPQUkDsjrIKBqEfxIS9PmfsHJok1l0k9
         53n9sSNRKLSl9Zwo7BVcVkKQuP+3u8zlGn+O7DMApQBQKPSKx4I9rXA9JH7xT2U1N62M
         oSAApT5viHreJMCvbWiYPSOgM4uDMLnQdd1s2ZHXFqdWG3eZxUMCAQvSXpf//TqYiRmw
         D1IQ==
X-Forwarded-Encrypted: i=1; AKwUvBxtfTMoeJBQ6kkuSBPF/SKIO1TxzNLYHrp2ytf4YIPU8m+lG7ik8UDDxNtbLhEi0f/svCj38zuj@vger.kernel.org
X-Gm-Message-State: AFq9FYJnQj20oASmPcjHh8tLXk0W+2TIr3KaSIXNjYJpeXVoIf3gSlSz
	Vw5IQPNdASjNMmzEkBluGtVbak9nIEuDkBHvKUt6qrxd2/kuNFWugAVQ0tWtRrjJDpk=
X-Gm-Gg: AYBFou3QclTF1nz4VBN7niflRTuZY5HOwAmNBPUWigV+8SFC4Bnns3JlC43FAdZHwVv
	JVJiKBCEM01q2cfUTOlf25tmWaaqbd0YN0WdMo+ZqR8xeloq8Krdo6L+xUpDHH7CQgWG51suc86
	9ThVK4qWUXe5FTlmHQ50FVBet5RxM9hHSaP0YA3i3rgQrNWbYak3pYswHTNXy5HyvC/uwfh1r1V
	LeuSz6N9oq7bkISGbzyHEK1ElfA+np9ZhwFdtgMz1PfUjPRpDV5epCNfWz9NP1cQ6oaF6qvvbpQ
	jry0Ql04h6UQT3gq4yB6k1SU+L5uT9LeZh9nkO7DQYMBVJWElHTT1AHQB9SOAcW10VrBvmZkJ+q
	st0R0iblqvx4IrHyzNUd6oYVYy2kqBSx8tuFCYYLHAxl+OXGU7HBSjlx/wCaAvCE5wyOt8GY5Dq
	vEYyGF6/vQOIAhTpll0Sy2lFiF4teQOEAnHv/bkJSjKTlIfJFvL+Ed3Wg8bilTkfJXGoIU5GCcZ
	N/jJXNuYm/tDdzR7JmdVGSNSgjevOcbD8mm2SQUvysL4Wj5kuHAX9d9mKK/p59po+w1kiDZcOAj
	5mTTPTbOapIadaaGLPiw2g+VOzuFceTrvVGlNrWmgShETyRAL7Jntg==
X-Received: by 2002:a17:907:72cc:b0:c2e:3ed7:7d94 with SMTP id a640c23a62f3a-c31aa0d364emr2098881066b.37.1792156720081;
        Fri, 16 Oct 2026 06:18:40 -0700 (PDT)
Received: from ?IPV6:2a02:21a0:10:748:1::2? ([2a02:21a0:10:748:1::2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40918c6e6asm68799166b.53.2026.10.16.06.18.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 06:18:38 -0700 (PDT)
Message-ID: <58dc8e8a-7260-43ce-aebb-8d9c29a6afc9@okonski.org>
Date: Fri, 16 Oct 2026 15:18:36 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: =?UTF-8?Q?Jakub_Oko=C5=84ski?= <jakub@okonski.org>
Subject: Re: [PATCH v3 7/7] sched/eevdf: Move to a single runqueue
To: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org
Cc: longman@redhat.com, chenridong@huaweicloud.com, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, jstultz@google.com, kprateek.nayak@amd.com,
 qyousef@layalina.io
References: <20260605105513.354837583@infradead.org>
 <20260605124052.227463677@infradead.org>
Content-Language: en-US
In-Reply-To: <20260605124052.227463677@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Peter,

On 6/5/26 14:40, Peter Zijlstra wrote:

> Change fair/cgroup to a single runqueue.
>
> [...]
>
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -9916,7 +9837,6 @@ static void wakeup_preempt_fair(struct r
>  	if (!sched_feat(WAKEUP_PREEMPTION))
>  		return;
>  
> -	find_matching_se(&se, &pse);
>  	WARN_ON_ONCE(!pse);
>  
>  	cse_is_idle = se_is_idle(se);

I think this changes how cpu.idle affects wakeup preemption.

With the single runqueue, find_matching_se() is gone and se_is_idle()
reduces to task_has_idle_policy(). Wouldn't this mean that SCHED_NORMAL
tasks in a cpu.idle cgroup are no longer treated as idle for
wakeup_preempt_fair()?

I tested my existing 7.2.9 desktop against 7.3-rc6 with the setup below.
cyclictest doesn't reproduce it because it just sleeps and wakes, no CPU
burn and therefore its accrued EEVDF lag keeps the latency low?

cc -O2 -o wakelat wakelat.c
systemd-run --user --collect --unit=spin -p AllowedCPUs=7 -p CPUWeight=idle sh -c 'while :; do :; done'
systemd-run --user --collect --wait --pipe --same-dir -p AllowedCPUs=7 ./wakelat 1000 15 200 |
  mlr --inidx --ifs space --opprint --barred --right label lat \
    then stats1 -a count,p50,p90,p99,max -f lat then rename -r '^lat_,' \
    then put -q 'emit mapsum({"kernel": system("uname -r")}, $*)'
systemctl --user stop spin

wakelat wakes on a fixed 1 ms schedule, records how late each wakeup
was, then busy-loops for 200 micros (wall clock).

+-----------+-------+-----+-----+------+------+
|    kernel | count | p50 | p90 |  p99 |  max |
+-----------+-------+-----+-----+------+------+
|     7.2.9 | 14998 |  11 |  11 |   12 | 1869 |
| 7.3.0-rc6 | 13853 |  11 |  12 | 2029 | 2116 |
+-----------+-------+-----+-----+------+------+

count is out of 15000 periods. rc6 had 1147 wakeups delayed by over 1 ms.


wakelat.c:

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <sys/prctl.h>
#include <time.h>

static long long now_ns(void)
{
	struct timespec t;
	clock_gettime(CLOCK_MONOTONIC, &t);
	return t.tv_sec * 1000000000LL + t.tv_nsec;
}

int main(int argc, char **argv)
{
	if (argc != 4)
		return 2;
	long long interval = atoll(argv[1]) * 1000, dur = atoll(argv[2]) * 1000000000LL;
	long long work = atoll(argv[3]) * 1000;
	long max = dur / interval + 1, n = 0;
	long *lat = malloc(max * sizeof(*lat));

	prctl(PR_SET_TIMERSLACK, 1UL);
	long long start = now_ns(), next = start + interval;
	while (next - start < dur && n < max) {
		struct timespec ts = { next / 1000000000LL, next % 1000000000LL };
		clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL);
		long long now = now_ns();
		lat[n++] = (now - next) / 1000;
		while (now_ns() - now < work)
			;
		do next += interval; while (next <= now);
	}
	for (long i = 0; i < n; i++)
		printf("%ld\n", lat[i]);
	return 0;
}

Regards,
Jakub
