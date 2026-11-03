Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719365;
	b=SCg6QSuHoN1+CYrZ3rxJD5B4hCtq7lofxQmdUMkzNgKqbn45R2te99VFrxM86LnwlVf2
	 kc2URwAmLhNtpeXmvTIS/yc89ULUg62ccICgOboJ9TCI5Jmr4l4EQ+IXUs2yvP/QtTKel
	 imr1NZYdiFPdh32Zm4NWvG5giYysoenTNf/RJsFMBWBC5grqregumfGRH/qV9/NXcxxzC
	 hs1vQ9ATCwX+tYCujRZaVblqPxYXCLqDeZVAIHowSMoz5l53tphv/DtV8cnsl2cf3sUYy
	 rlUPEYaL8pu9DyNOq5OTQz6FvJpo/1k2FfQ1R1En7/Z8eFCVNU2bernAzLqY4T5mrog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719365;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=4+H98LPenOtXM20iyFs2uc1o5Gjvbk6CvWIcoeiCnUk=;
	b=OtT+TIQIEgcFNdQOEDdCQFGOPQ2XT8uI0eNf4OH1bKZjUyW2YESDC1i20lG5xlnjc99Q
	 9qv8X8GAyylyNIDEZqUsS51q6ZxurPcV9NzuVvEsrcTasbT2NjiJE7k124pN4o7urHqwf
	 JstIFCxtQGgaG+fvmJOR4TIv2DcjmdnLj9r58Ngy5/wI2+6h0/517xYztG+eSmA1gbz+y
	 taPHP/OViTQk1n7PpMnvIvQcjDE493FDxjcoCDB49cA285L+NiIqAfCjoM3yVLKNhn2pE
	 BOgBP9FWxMxetGK71tIQxGX4tzscLjEcosqTu2iDq9rbhQ6fGHrvQ36ox45IkGIVpvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="Iu/eUn1W";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9B3606B24D
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 15:22:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B9B3606B24D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Iu/eUn1W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793719364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4+H98LPenOtXM20iyFs2uc1o5Gjvbk6CvWIcoeiCnUk=;
	b=Iu/eUn1WYtB4MmUYpENh4yto/cqyDYmMP/wdyZ8Z8b7cfZ7B8P36YtJiZfu3tGUoWBUqOH
	3sykg3G5yaENEBraxzCGdubsI44dz1zTejNiXGQ86rs90YerukezsOY1cXaLC6iMjAA54h
	0tAN/SMjQRUUL8kFtkEZA29qUzBi2rw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-ZpBEt-W5O6Gb3NzZNS-d9g-1; Tue,
 03 Nov 2026 10:22:41 -0500
X-MC-Unique: ZpBEt-W5O6Gb3NzZNS-d9g-1
X-Mimecast-MFC-AGG-ID: ZpBEt-W5O6Gb3NzZNS-d9g_1793719357
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA50219560BF;
	Tue,  3 Nov 2026 15:22:35 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5C78C26C;
	Tue,  3 Nov 2026 15:22:30 +0000 (UTC)
Message-ID: <e2b45603-fedd-43ef-b3ee-63846b05bbd3@redhat.com>
Date: Tue, 3 Nov 2026 10:22:29 -0500
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
Subject: Re: [PATCH 5/6] cgroup/cpuset: Don't wait for memory migration when
 cpuset.mems is written with O_NONBLOCK
To: Tejun Heo <tj@kernel.org>, Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Frederic Weisbecker <frederic@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
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
 <20261103075940.110308-6-matthew.ruffell@canonical.com>
 <aun2vUjloJjH3Hpb@slm.duckdns.org>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <aun2vUjloJjH3Hpb@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95


On 11/3/26 9:59 AM, Tejun Heo wrote:
> On Tue, Nov 03, 2026 at 08:59:39PM +1300, Matthew Ruffell wrote:
>> From: Caron Wills <caron.wills@pulsar.com>
>>
>> Writing cpuset.mems migrates the memory of every task in the cpuset on
>> the ordered cpuset_migrate_mm_wq, and since commit 3514309e0322
>> ("cpuset: Defer flushing of the cpuset_migrate_mm_wq to task_work") the
>> writer flushes that workqueue from task_work before returning to
>> userspace, so that the write appears synchronous (the design of commit
>> e93ad19d0564 ("cpuset: make mm migration asynchronous")). The writer
>> therefore sleeps in TASK_UNINTERRUPTIBLE for as long as all queued
>> migrations take. On a system with isolated CPUs running SCHED_FIFO tasks
>> that was measured at 2 to 10 minutes (LP: #2165410), and it is unbounded
>> in principle: a migration blocked behind a starved kworker or a slow
>> expedited grace period holds up every migration queued after it.
>>
>> The writer is usually systemd. It applies AllowedMemoryNodes= from PID 1
>> itself, and since v259 it opens every cgroup v2 attribute file with
>> O_NONBLOCK precisely to opt into asynchronous semantics wherever the
>> kernel offers them (src/basic/cgroup-util.c, cg_set_attribute(), citing
>> the memory.max/memory.high behaviour of commit c8e6002bd611 ("memcg:
>> introduce non-blocking limit setting option")). While PID 1 is stuck in
>> the flush, logind cannot create sessions and SSH logins fail.
>>
>> Honour O_NONBLOCK the same way memcg does: skip the task_work flush when
>> the file was opened non-blocking and let the migration complete in the
>> background. Blocking writers keep the synchronous behaviour and the
>> cgroup.procs attach path is unchanged.
>>
>> This does not make the migration any faster; it only stops the writer,
>> in practice init, from being held hostage by it.
>>
>> Link: https://bugs.launchpad.net/bugs/2165410
>> Signed-off-by: Caron Wills <caron.wills@pulsar.com>
>> Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>
> This makes sense to me. Waiman?
>
> Thanks.

Yes, that looks good to me too.

Maybe, we should also update the cgroup-v2.rst to list the condition 
when synchronous waiting will be skipped when updating cpuset.mems as it 
is a behavioral change.

Cheers,
Longman

>

