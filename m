From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v5 3/5] cgroup/cpuset: make callback_lock raw
Date: Thu, 8 Nov 2018 14:11:01 -0500
Message-ID: <95aeb057-d63f-a6b8-cf0e-cdff80e79021@redhat.com>
References: <20180903142801.20046-1-juri.lelli@redhat.com>
 <20180903142801.20046-4-juri.lelli@redhat.com>
 <20180925143416.GD25664@localhost.localdomain>
 <20181107155330.GA2509588@devbig004.ftw2.facebook.com>
 <20181107163841.GA18091@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181107163841.GA18091@localhost.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, cgroups@vger.kernel.org, peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org

On 11/07/2018 11:38 AM, Juri Lelli wrote:
> Hi,
>
> On 07/11/18 07:53, Tejun Heo wrote:
>> Hello,
>>
>> On Tue, Sep 25, 2018 at 04:34:16PM +0200, Juri Lelli wrote:
>>> It would be great if you could please have a look at the proposed change
>>> below (and the rest of the set of course :-).
>> Yeah, looks good to me.  Please feel free to add
>>
>>  Acked-by: Tejun Heo <tj@kernel.org>
> Thanks!
>
>>> Another bit that I'd be more comfortable after hearing your word on it
>>> is this one (discussed over 5/5):
>>>
>>> https://lore.kernel.org/lkml/20180925130750.GA25664@localhost.localdomain/
>> Can you please loop Waiman Long <longman@redhat.com> into discussion?
>> He's working on cgroup2 cpuset support which might collide.
> Sure, I've been originally working on this on top of his series, but
> didn't try with latest version. Hopefully the two series don't generate
> too much collisions. I'll try to find some time soon to check again.
>
> In the meantime, Waiman Long, how do you feel about it? :-)
>
> Thread starts at (you if missed it)
>
> https://lore.kernel.org/lkml/20180903142801.20046-1-juri.lelli@redhat.com/
>
> Best,
>
> - Juri

Your patches look good to me. There will be some minor conflicts, I
think, but nothing big.

Cheers,
Longman

