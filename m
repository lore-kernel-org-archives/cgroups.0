From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 3/8] cgroup/cpuset: Allow no-task partition to have
 empty cpuset.cpus.effective
Date: Mon, 13 Jun 2022 12:47:37 -0400
Message-ID: <f1c33447-1f82-9698-6b0c-fc9ffb12b4bb@redhat.com>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-4-longman@redhat.com>
 <YqYlCRywdgSYtwKk@slm.duckdns.org> <YqYlOQjKtQCBsQuT@slm.duckdns.org>
 <ce3106c1-a3c4-b449-bafc-6940d672bd94@redhat.com>
 <YqanEZZooeZwtutA@slm.duckdns.org> <20220613140206.GA6910@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655138862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PtMrsrYPM0J5i/yjkLVXsmYxyhse0DEHxO9KbSLC6N4=;
        b=NVm6JHcqgeYrZPnJbsnO4rOARkx/0Tby1Eo96q+HGKo/dfsqvRg9EnggvRTlPnzn8XvBNv
        THSzrRDXJLa+1+zSAmWJLHA/rHZhlyAhQOjUeWN1bPWAMTfonFk+0ED5d5rGvBXmLwjlR5
        lMsvX6tb50kaPLCgA0FEW2VaCQTfv9U=
Content-Language: en-US
In-Reply-To: <20220613140206.GA6910@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>

On 6/13/22 10:02, Michal Koutn=C3=BD wrote:
> On Sun, Jun 12, 2022 at 04:55:13PM -1000, Tejun Heo <tj@kernel.org> wrote:
>> But how would that happen? A lot of other things would break too if that
>> were to happen.
> cpuset is a threaded controller where the internal-node-constraint does
> not hold. So the additional condition for cpuset migrations is IMO
> warranted (and needed if there's no "fall up").

Yes, you are right. cpuset is threaded and so it may have tasks even if=20
it is not the leaf node.

Thanks,
Longman

