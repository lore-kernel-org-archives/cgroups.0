Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795828048;
	b=OHTBlhiv9BDGHQklbsCp/QonQ7y/3ONzeuFCEIoad2jmJBEkgm0zBzB5+M2SlTzO+8ox
	 esymyrde4lXJioTPPlTEVcRCu/Levfa2UNSDNDzXdPzXOGgd3fro4PB5l6PCo8KPrkgvs
	 6qvY2Os6mgSRDSy77IiLZOARQIVfeSGISaID+MJOK3IJ4mGucAmBXqCWDqJs2Xqk8FTQa
	 nIJYll1ZnG8y+6YJHEasFBAK1pk/IJwga9WIL6mvRCVSBNRZTrh3hRXOM7A4MgsYcr7G2
	 z/fsMLUmwWWUekx7Z+8/WgjJ1FxXFehEKSW2Cm0MueODhwT81baP/W6CkkSuk9+dr1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795828048;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=a65dJjXELLvBjblKrcEEJmFH72J16tMPfL8+2JJSMhA=;
	b=3Xu/QiMpu8y/uQOIYU3lcZ1c/9Xv7bZos9bv5SjAR+Tp7haEtZl+o00hbMmR6gU/kLyJ
	 H3g3wzjmsux7PvENbjTnYwmMINNNfZc0sSTcJHtHQTfMeXuH4D++lw4T1drmvgTYeu2Pb
	 JGYJLNppKgHuJJ4Vzvk8SLFDp9Zk8k8Nalk1lyjeOfax7afcDLySBuUJNNlt40mROqW6o
	 M6S/MdIYTGh3Ww9vf+9YV0fEH686ZyPCZADcZp8ep6T7d0Lu/hA8EZdix6q4MTOg9bNO2
	 /rdHN49F2W3jO1VxXLj4yNp/cIbbQ27pWnDWX2+Sxk4tLfQfIO628TjwTYDiny4X8wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Yvikbyzl;
	arc=none smtp.remote-ip=95.215.58.157
Received: from mta1.migadu.com (out-157.mta1.migadu.com [95.215.58.157])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0F7606A31C
	for <cgroups@vger.kernel.org>; Sat, 28 Nov 2026 01:07:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D0F7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Yvikbyzl
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6o1m5Sj0nUNsooY5Q6+XpT1gVnU3nCsPrMfZZdGQvm8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795828046; v=1; x=1796432846;
 b=Yvikbyzl96oTGl48ew7/zn5/ACkXbb34oJfA8SvyxPQWJJpZta/Z3U+C08eY8Ook3UO5DpX1
 zaXt1Wj8Mwx8lhJ5EuYPe5jMPc90gkYfFXsxBHB27RbRxvxs9uFK5AHXgbqMZb8j8WXMcG0Bi5z
 UKeUBsZOPF9Bqtr21HzTWUVg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4ce7dcfcfce2fff3;
	Sat, 28 Nov 2026 01:07:25 +0000
X-Mizu-Trace-ID: 4ce7dcfcfce2fff3
X-Migadu-Flow: FLOW_OUT
Message-ID: <200b9f7c-e533-4875-8cd4-3debd4e7ae94@linux.dev>
Date: Sat, 28 Nov 2026 09:07:19 +0800
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
Subject: Re: [PATCH] sched/isolation: Publish new HK_TYPE_DOMAIN cpumask under
 cpuset_mutex
To: Tejun Heo <tj@kernel.org>
Cc: longman@redhat.com, frederic@kernel.org, peterz@infradead.org,
 mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
 hannes@cmpxchg.org, mkoutny@suse.com, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, guopeng.zhang@linux.dev,
 mathieu.desnoyers@efficios.com, Ridong Chen <chenridong@xiaomi.com>
References: <054a53a3-c038-48fe-ac01-fc24fd8065d0@linux.dev>
 <20261117083915.2971979-1-ridong.chen@linux.dev>
 <bc6e38f6-1412-49d0-95e2-76d5e9fc3858@linux.dev>
 <6f3d7612a6b2628fae3c14aaa87771ec@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <6f3d7612a6b2628fae3c14aaa87771ec@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/28/2026 5:07 AM, Tejun Heo wrote:
> Hello, Ridong.
> 
> On Fri, Nov 27, 2026 at 10:15:07AM +0800, Ridong Chen wrote:
>> If it is this one, I will send a v2 rebased onto for-7.5, as it now
>> conflicts with housekeeping_set_cpu() from commit 884e88175b95.
> 
> Can you please send v2 based on cgroup/for-7.4-fixes instead?
> 
Sure.

https://lore.kernel.org/cgroups/20261128010535.1831141-1-ridong.chen@linux.dev/T/#u

-- 
Best regards
Ridong

