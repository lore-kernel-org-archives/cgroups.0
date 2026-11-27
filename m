Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795813644;
	b=egY1hIsRKyrcU0xi+VMmw8X+r136Rfb+wqFdrk04brk92Vm55ps4hUizkjILdQ6YcxUa
	 LSMVKWrWiSrxgrWBFt56eHd00o8unFQUB1iaS2Eok1ZlUfUcGIIYlDLbWAg0KLOSUpjez
	 rxdN9EXntm+7MDnHYZlnK+J9LZoDk+s0z69ffb4AJB60DtfHE5N/RUjAZ0mHuupSRb0iI
	 QlQ+21qOxxJdfK4ZtTeaZwxhZw+ZAWJXyeTkgiSl0O2FJIIEiEHoV3SfdDftaelzUitXG
	 xP9AIYYqP3OXpk0Ub6xl361RzO/Z/8es/xURCayf3oGK27uIa5yuyjxBDT4u0Ld7E3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795813644;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=75YAovdgsRFUeKVqA3TUR6xQY8rTnMfl5GJ0cvr/WsY=;
	b=ejRUo93hscu8I0Phe4J4RtiyU9eX34TJijCtNl41TvwcKgVXBNc/clAxvXAuZBJZx72q
	 OcmIq2IeWN0bRjnwGiyVSX5p/NE41y+jb/DWyfhobaqUlXEd7XP7B6ygVpU5wqY/QwFAb
	 f7ptg3cXXWUIXJIhb0h+/43D8Jid6HEj7mbsnzkUR9+F6A3OA13pk/rTCNUTS36eXytOI
	 BbHmpTJVDlXTB8+n8/FlJFpw6eTZRHSKn0ia41NKZCRm22orw7pPVFeqfcjOgxjQXgeS9
	 FjxyDvL8Il72Ksxqw4BYIJreIkVqSfKmJmPXY5MxH9DvQtNcYTlrssGQyWsjNB71Y/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LAGWrOSu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70342606A31C;
	Fri, 27 Nov 2026 21:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LAGWrOSu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8161F00893;
	Fri, 27 Nov 2026 21:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795813644;
	bh=75YAovdgsRFUeKVqA3TUR6xQY8rTnMfl5GJ0cvr/WsY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LAGWrOSuhC11xoBjQRQwV2no4ffVwFXzPmayAeiHcWKVjZ3XCtgL0WVGQdqdRpFBh
	 AUnDV3YXFURdmPjkcOMZtDVXOSqYtr5stbOIcA+s5jkc47q7c8BE/YBPd0zBUDB0qX
	 mLdK5/pWbmj+wnlB/Fu6DlV0HoxhlzDgbRjtpGMHSkfOB/ys+Yqm4vegPx/xfNPBkR
	 +6tn9b+aRbeXzPpOXaoMGZNFfbJgziaRAHB+vzu3pA9xYbvfaSMk1KYOo++dVKprtl
	 kIGg+Z5Ix0bw/rTytQ5AJYesXlmWy14LGy5jSh9XSdQ5MtQNKgAW1o9nxkCLy0SS+A
	 6GooT+cYbWuMQ==
Date: Fri, 27 Nov 2026 11:07:23 -1000
Message-ID: <6f3d7612a6b2628fae3c14aaa87771ec@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: longman@redhat.com, frederic@kernel.org, peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, hannes@cmpxchg.org, mkoutny@suse.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, guopeng.zhang@linux.dev, mathieu.desnoyers@efficios.com, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH] sched/isolation: Publish new HK_TYPE_DOMAIN cpumask under cpuset_mutex
In-Reply-To: <bc6e38f6-1412-49d0-95e2-76d5e9fc3858@linux.dev>
References: <054a53a3-c038-48fe-ac01-fc24fd8065d0@linux.dev> <20261117083915.2971979-1-ridong.chen@linux.dev> <bc6e38f6-1412-49d0-95e2-76d5e9fc3858@linux.dev>
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
Content-Transfer-Encoding: 7bit

Hello, Ridong.

On Fri, Nov 27, 2026 at 10:15:07AM +0800, Ridong Chen wrote:
> If it is this one, I will send a v2 rebased onto for-7.5, as it now
> conflicts with housekeeping_set_cpu() from commit 884e88175b95.

Can you please send v2 based on cgroup/for-7.4-fixes instead?

Thanks.

--
tejun
