From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 2/2] cgroup: Skip subtree root in
 cgroup_update_dfl_csses()
Date: Thu, 28 Jul 2022 10:49:21 -0400
Message-ID: <8e0a41e6-8d03-b0ad-02b5-04449c49c470@redhat.com>
References: <20220728005815.1715522-1-longman@redhat.com>
 <20220728005815.1715522-2-longman@redhat.com>
 <20220728144426.GA26631@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659019770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y72epJF5d8qli+9Ce0BVC/x2v9XQ9z23UFNcVj/FJ4A=;
        b=Fc8wIT1wXK1+SxUbIFbxzulBtkPLyuxLqHjQZLK+z2m4xY7ZV2VLKwaFIaQHZ+IOADuHLV
        ninCdV7+fLKPvFgpz0BHFBGzuMoSfFjBwfcCvaWqgL071utlAkrTDtBozMnnYOSjWNclVR
        qHEKerfUyM6taRzCEI4YoTWTLtZFfik=
Content-Language: en-US
In-Reply-To: <20220728144426.GA26631@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org


On 7/28/22 10:44, Michal Koutný wrote:
> On Wed, Jul 27, 2022 at 08:58:15PM -0400, Waiman Long <longman@redhat.com> wrote:
>> The cgroup_update_dfl_csses() function updates css associations when a
>> cgroup's subtree_control file is modified. Any changes made to a cgroup's
>> subtree_control file, however, will only affect its descendants but not
>> the cgroup itself.
> I find this correct.
>
>> So there is no point in migrating csses associated with that cgroup.
>> We can skip them instead.
> Alone it's not such a big win but it componds with the recent Tejun's
> threadgroup_rwsem elision.
>
It is more an optimization patch trying to not waste cpu time doing 
unnecessary work.
>> ---
>>   kernel/cgroup/cgroup.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
> Feel free to have
> Reviewed-by: Michal Koutný <mkoutny@suse.com>
>
Thanks for the review.

Cheers,
Longman

