From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH v3 6/9] cgroup/cpuset: Add a new isolated cpus.partition
 type
Date: Wed, 28 Jul 2021 12:27:58 -0400
Message-ID: <f1afbd9e-d16b-c972-c3c0-022a05cec2a6@redhat.com>
References: <20210720141834.10624-1-longman@redhat.com>
 <20210720141834.10624-7-longman@redhat.com>
 <20210728160900.GA8905@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627489681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oVx/5yrmyZbbRVeN3LD+d66Q2FozCvKMMwaCU5JpwKA=;
        b=C8TkkbLtJNQFJzm7vuOth01N1hoMg0o0Hs8+2dm7BpdaI8dOJqXNDhrEA3SBMadh7Jwh/W
        lPwIwRsPDZSA32snFj1Bcb9EEFYnZKf0h78flfT2UnWWzerOSoKlOUmmgKM5TXw/JDZkc8
        RwAXJ7aDIw2Oj6fYt/TdD2tgTxNPJqE=
In-Reply-To: <20210728160900.GA8905@blackbody.suse.cz>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>

On 7/28/21 12:09 PM, Michal Koutn=FD wrote:
> Hello Waiman.
>
> On Tue, Jul 20, 2021 at 10:18:31AM -0400, Waiman Long <longman@redhat.com=
> wrote:
>> @@ -2026,6 +2036,22 @@ static int update_prstate(struct cpuset *cs, int =
new_prs)
>> [...]
>> +	} else if (old_prs && new_prs) {
> If an isolated root partition becomes invalid (new_prs =3D=3D PRS_ERROR).=
..
>
>> +		/*
>> +		 * A change in load balance state only, no change in cpumasks.
>> +		 */
>> +		update_flag(CS_SCHED_LOAD_BALANCE, cs, (new_prs !=3D PRS_ISOLATED));
> ...this seems to erase information about CS_SCHED_LOAD_BALANCE zeroness.
>
> IOW, if there's an isolated partition that becomes invalid and later
> valid again (a cpu is (re)added), it will be a normal root partition
> without the requested isolation, which is IMO undesired.
>
> I may have overlooked something in broader context but it seems to me
> the invalidity should be saved independently of the root/isolated type.

PRS_ERROR cannot be passed to update_prstate(). For this patchset,=20
PRS_ERROR can only be set by changes in hotplug. The current design will=20
maintain the set flag (CS_SCHED_LOAD_BALANCE) and use it to decide to=20
switch back to PRS_ENABLED or PRS_ISOLATED when the cpus are available=20
again.

Cheers,
Longman

