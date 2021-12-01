From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v8 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Wed, 1 Dec 2021 13:05:44 -0500
Message-ID: <4a021678-1896-2d16-4075-f626c7ab8513@redhat.com>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211018143619.205065-6-longman@redhat.com>
 <20211115193122.GA16798@blackbody.suse.cz>
 <8f68692b-bd8f-33fd-44ae-f6f83bf2dc00@redhat.com>
 <20211116175411.GA50019@blackbody.suse.cz>
 <293d7abf-aff6-fcd8-c999-b1dbda1cffb8@redhat.com>
 <YaZbXArNIMNvwJD/@slm.duckdns.org>
 <2347fe66-dc68-6d58-e63b-7ed2b8077b48@redhat.com>
 <Yaem+r/YZ9BNXv9R@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638381965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nL9jEjCjXMQ2Hi/cW7zIosXzbREOuqBP0onxXEUO1oE=;
        b=KgWcAPN04AjhIHgwoZYmKDl39i3gUbQ1GrJWAJWrHaDrjZXGlXu2jwnOTFUFc4xSbvSXvk
        Dr2JQXQPKnHttp/AgcOXXkLs+nH6R5riTRrLBNouBqS3QT8EonxBECYzNsoIDAXd08p2Ty
        Np3pfEbPvVxWNMQ2oDBICnfI6oj0nfo=
Content-Language: en-US
In-Reply-To: <Yaem+r/YZ9BNXv9R@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>


On 12/1/21 11:46, Tejun Heo wrote:
> Hello, Waiman.
>
> On Tue, Nov 30, 2021 at 10:56:34PM -0500, Waiman Long wrote:
>>> What happens if an isolated domain becomes invalid and then valid again due
>>> to cpu hotplug? Does it go "root invalid" and then back to "isolated"?
>> Yes, the current code allow recovering from an invalid state. In this
>> particular case, the transition will be "isolated" --> "root invalid" -->
>> "isolated".
> Wouldn't it be clearer if it became "isolated invalid"?

You are right. I have overlooked that. Will make the change.


>
>>> While it isn't necessarily tied to this series, it's a big no-no to restrict
>>> what a parent can do depending on what its descendants are doing. A cgroup
>>> higher up in the hierarchy should be able to change configuration however it
>>> sees fit as deligation breaks down otherwise.
>>>
>>> Maybe you can argue that cpuset is special and shouldn't be subject to such
>>> convention but I can't see strong enough justifications especially given
>>> that most of these restrictions can be broken by hotplug operations anyway
>>> and thus need code to handle those situations.
>> These are all pre-existing restrictions before the introduction of
>> partition. These are checks done in validate_change(). I am just saying out
>> loud the existing behavior. If you think that needs to be changed, I am fine
>> with that. However, it will be a separate patch as it is not a behavior that
>> is introduced by this series.
> I see. It looks more problematic now with the addtion of the state
> transition error reporting, more possible state transitions and, well,
> actual documentation.

I am going to add a patch to take out the child superset limitation for 
the default hierarchy as I believe it is probably an oversight that we 
were not aware of before. I would like to keep the exclusivity rule 
though as I think it makes sense.

>
>> Once an invalid partition is changed to "member", there is no way for a
>> child invalid partition root to recover and become valid again. There is why
>> I force them to become "member" also. I am OK if you believe it is better to
>> keep them in the invalid state forever until we explicitly changed them to
>> "member" eventually.
> That's because we don't allow turning a cgroup with descendants into a
> partition, right?
Yes, that is a major part of it.
>
> So, when we were first adding the partition support, the thinking was that
> as it's pretty niche anyway, we can take some aberrations and restrictions,
> but I don't think it's a good direction to be building up on top of those
> like this and would much prefer to clean up the rules and restrictions. I
> know that this has been going on for quite a while and am sorry that am
> coming back to the same issue repeatedly which isn't necessarily caused by
> the proposed change. What do you think?

I think I can relax some of the restrictions, but probably not all of 
them at this time. We can certainly working on removing as much 
restriction and limitations as possible in future update to the 
partition code.

Cheers,
Longman

