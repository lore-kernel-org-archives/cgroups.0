From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v8 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Fri, 3 Dec 2021 14:27:20 -0500
Message-ID: <583191c1-4153-cee8-1836-a4037b9ea304@redhat.com>
References: <20211018143619.205065-6-longman@redhat.com>
 <20211115193122.GA16798@blackbody.suse.cz>
 <8f68692b-bd8f-33fd-44ae-f6f83bf2dc00@redhat.com>
 <20211116175411.GA50019@blackbody.suse.cz>
 <293d7abf-aff6-fcd8-c999-b1dbda1cffb8@redhat.com>
 <YaZbXArNIMNvwJD/@slm.duckdns.org>
 <2347fe66-dc68-6d58-e63b-7ed2b8077b48@redhat.com>
 <Yaem+r/YZ9BNXv9R@slm.duckdns.org>
 <4a021678-1896-2d16-4075-f626c7ab8513@redhat.com>
 <8f56f7a3-1d4b-679b-7348-d8ecb4ef3d6c@redhat.com>
 <20211203182500.GD16798@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638559665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pmMKiB3N4p3pnZNkTKPE5eWVpNIexw+a16FHU/X1k2I=;
        b=ITvoRtlA15KBwPBaV1BoV2Y6n1Xgqm7P0heIWPjD9dhP1c5Vr34DsmGOh4f0K3TpfHiGp9
        lZ1ZXO/aquB/Yga9xrgtEg62uKs9HyrN47eK3sA5U+gqNazV9NhmNjsFQp4LC42uoo34Oh
        giiG0PXvTb6/4DsKvwVsKS3rm3mbf/0=
Content-Language: en-US
In-Reply-To: <20211203182500.GD16798@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>

On 12/3/21 13:25, Michal Koutný wrote:
> Hello Longman.
>
> On Wed, Dec 01, 2021 at 08:28:09PM -0500, Waiman Long <longman@redhat.com> wrote:
>> 1) The limitation that "cpuset.cpus" has to be a superset of child's
>> "cpuset.cpus" has been removed as a new patch to remove that limitation will
>> be added.
> Superb!
>
>> 2) The initial transition from "member" to partition root now requires that
>> "cpuset.cpus" overlap with that of the parent's "cpuset.cpus" instead of
>> being a superset.
> That's sensible.
>
>> For the transition back to "member", I haven't changed the current wording
>> of forcing child partition roots to become "member" yet. If you think
>> keeping them as invalid partition root is better, I can made that change
>> too.
> I wrote I was indifferent about this in a previous mail but when I think
> about it now, switching to invalid root is perhaps better than switching
> to member since it'd effectively mean that modifications of the parent
> config propagate (permanently) also to a descendant config, which is
> an undesired v1-ism.

That makes sense. I will keep those child partitions in an invalid state 
then.

>
>> Please let me know what other changes you would like to see.
> I hope my remarks below are just clarifications and not substantial
> changes. Besides that I find your new draft good. Thanks!
>
>> [...]
>>      An invalid partition root can be reverted back to a valid one
>>      if none of the validity constraints of a valid partition root
>>      are violated.
> s/can be/will be/
>
> (I understand the intention is to make it asynchronously and
> automatically, i.e. without writing into the affected descendant(s)
> cpuset.partition again.)
Yes, that will be automatic and the partition will become valid again if 
other events cause changes that unbreak the validity constraints.
>
>>      Poll and inotify events are triggered whenever the state of
>>      "cpuset.cpus.partition" changes.  That includes changes caused by
>>      write to "cpuset.cpus.partition", cpu hotplug and other changes
>>      that make the partition invalid.
> -> that change validity status
>
> (In accordance with the comment above.)
Cheers,
Longman

