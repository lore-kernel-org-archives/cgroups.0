Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718842;
	b=syC2odxFbRY5CfmdM1z3FyIYLCg3+vou4FUvfvVQkUubgVsN/nWuAKGlYXmQuAhla37G
	 f3/TvPkFp9aSMNW5RNYi41YSkphumZTRODpJGNtDTFUi8/OZ82BBcBOqY9Ee2gwAbHyw2
	 6wImYWW3s/e30CZ6D5ZwNvWXeYwgXY50/RBSFdlYOUg0D1pKFCe8P4wojl42NnojqtLLP
	 ygKeJAsy4mFtAJaV9pJLbEEbzWMxaZxJHe9kwu0k6ZBXSHyqxZsj5lB/4Gp827Ta+bxlA
	 gape4ojTrsM56nThfDoY3Ko2LpbzghIYdFJvcuxlXjzcLcQ4bifc+W25o+0wlbjte7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718842;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=In5hDuKiBdou1zv+joOPBenp7vdBADvUYuAlqVBsoTA=;
	b=EskP+xW4uG08bJeEupx5UI8IUavY6kCBLDqM6PPbopUFrRUAlDJkUTVlgUHeG1pzv2jP
	 GUUrEDUcHJwY2bMgh8fHhsJa4m1c7X26sehjwjcAKM5aYTBoRDA3+3/nBR82CN/XqnG/6
	 LuSxjDVy3iV3FZD397ZKOb7h5Ekg3h5m2RXcEiYm6JkTBLzSH9KKkIsO5+fIokGsfHvMv
	 R7C1tcSTrAA6TUbcCitimZPZjbL4taOJR6OXzcd8HfU/HeOFh5W309A5TLzmlRKz5k13c
	 h3qgdcuuw7FNcL8TsyFLz7TFKNTpDREGFd3ovgFXgCFXZL2Qq6nNM8VqfmhmeHRhHQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Ll4zK9kp;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1739606A782
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 15:14:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1739606A782
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Ll4zK9kp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793718840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=In5hDuKiBdou1zv+joOPBenp7vdBADvUYuAlqVBsoTA=;
	b=Ll4zK9kp0vs716v31WEvpc3/0vtAp9wiRoNYOzGxbjhN2W1txgHvwM7cs9REy6u3nt+tvY
	r2SiHTpDa3DLwXC5Y1WZSJJ06PFHDrGgosdG1+eBSM4OrMioT+VTsQqYP9hLHWUhn9jCsb
	eI2yvWyOK1rc/GtU7FryeoCkut4mBu8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-496-8_7V8QBKPBibu_MNcB0H3Q-1; Tue,
 03 Nov 2026 10:13:56 -0500
X-MC-Unique: 8_7V8QBKPBibu_MNcB0H3Q-1
X-Mimecast-MFC-AGG-ID: 8_7V8QBKPBibu_MNcB0H3Q_1793718826
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 37FD5180065E;
	Tue,  3 Nov 2026 15:13:45 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BF564195608C;
	Tue,  3 Nov 2026 15:13:39 +0000 (UTC)
Message-ID: <c9b24dd9-8c6a-4d35-8f68-07274f06299d@redhat.com>
Date: Tue, 3 Nov 2026 10:13:38 -0500
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
Subject: Re: [PATCH 2/6] kthread: Keep unbound kthreads off nohz_full CPUs
To: Frederic Weisbecker <frederic@kernel.org>,
 Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Caron Wills <caron.wills@pulsar.com>,
 Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 Jay Vosburgh <jay.vosburgh@canonical.com>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
 <20261103075940.110308-3-matthew.ruffell@canonical.com>
 <aunpNqPV38FG94-f@localhost.localdomain>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <aunpNqPV38FG94-f@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 11/3/26 9:01 AM, Frederic Weisbecker wrote:
> Le Tue, Nov 03, 2026 at 08:59:36PM +1300, Matthew Ruffell a écrit :
>> From: Caron Wills <caron.wills@pulsar.com>
>>
>> Since commit 041ee6f3727a ("kthread: Rely on HK_TYPE_DOMAIN for
>> preferred affinity management") kthread_fetch_affinity() only removes
>> domain isolated CPUs from a kthread's affinity, assuming that nohz_full
>> CPUs are always domain isolated as well. Up to v6.13 every kthread
>> inherited kthreadd's affinity to housekeeping_cpumask(HK_TYPE_KTHREAD),
>> and from v6.14 the preferred affinity was filtered with HK_TYPE_KTHREAD,
>> so nohz_full CPUs were always excluded.
> This was done on purpose because on all setup we have met so far, it didn't
> make sense to run nohz_full with load balancing. After all the point is to
> run a pinned single task on a single CPU. We have seen too many misconfigured
> CPU isolation workloads due to that constraint not being enforced since the
> origins.
>
> I'm open to counter-arguments of course but you better have a good case.

I do see configurations where nohz_full/managed_irq CPUs are set at boot 
time without isolcpus=domain. But these nohz_full CPUs are there as a 
backup in case some latency critical workloads need a set of fully 
isolated CPUs to run on. Right now, isolcpus=domain can be set 
dynamically by using the cpuset isolated partition feature and they will 
be used when the need arises.

Matthew, is it possible for users to adapt their workloads to 
dynamically domain-isolated the CPUs before running RT tasks on them?

Cheers,
Longman

