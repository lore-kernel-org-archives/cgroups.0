From: Tim Hockin <thockin@hockin.org>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Tue, 26 Sep 2017 20:37:37 -0700
Message-ID: <CAAAKZws88uF2dVrXwRV0V6AH5X68rWy7AfJxTxYjpuiyiNJFWA@mail.gmail.com>
References: <20170918061405.pcrf5vauvul4c2nr@dhcp22.suse.cz>
 <20170920215341.GA5382@castle> <20170925122400.4e7jh5zmuzvbggpe@dhcp22.suse.cz>
 <20170925170004.GA22704@cmpxchg.org> <20170925181533.GA15918@castle>
 <20170925202442.lmcmvqwy2jj2tr5h@dhcp22.suse.cz> <20170926105925.GA23139@castle.dhcp.TheFacebook.com>
 <20170926112134.r5eunanjy7ogjg5n@dhcp22.suse.cz> <20170926121300.GB23139@castle.dhcp.TheFacebook.com>
 <20170926133040.uupv3ibkt3jtbotf@dhcp22.suse.cz> <20170926172610.GA26694@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=U2vxmDhEinAPQdqMS6xUW7J07oZL/r4UoiUwcV3igSY=;
        b=N/Tp+Oa13BC9NVLCqog8FE7cFOa6reVMcYuUuKRAJ1NeDfob5ToHES5sRbbw0Iay2E
         3KNDmj+yLl2/UA3/vwITIvIY4X+fft9sUhitrX9LTNhfH+KPtWJ/uRSn7SFjK+n+6J/i
         JEGjL7jSKAy8urOIaWpFigHJbXI2i2IfghbQb+7S2h0FYn2yIbfabooEc7zgiqQodN9v
         +tQQcK/lqmi0gOPZWXwaHqXIRMxSZeM3e9pUkFQcQ9xTPRgETa/h+fAkHkaCptGPv49U
         Kk1kWgQ6Cc/rHUdIusUSM13Zdwi+JmaLXLdxsIp/oJvpZDUdvFmz1UWOjKdiLzdGu1Nh
         4E8g==
In-Reply-To: <20170926172610.GA26694@cmpxchg.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, David Rientjes <rientjes@google.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

I'm excited to see this being discussed again - it's been years since
the last attempt.  I've tried to stay out of the conversation, but I
feel obligated say something and then go back to lurking.

On Tue, Sep 26, 2017 at 10:26 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Tue, Sep 26, 2017 at 03:30:40PM +0200, Michal Hocko wrote:
>> On Tue 26-09-17 13:13:00, Roman Gushchin wrote:
>> > On Tue, Sep 26, 2017 at 01:21:34PM +0200, Michal Hocko wrote:
>> > > On Tue 26-09-17 11:59:25, Roman Gushchin wrote:
>> > > > On Mon, Sep 25, 2017 at 10:25:21PM +0200, Michal Hocko wrote:
>> > > > > On Mon 25-09-17 19:15:33, Roman Gushchin wrote:
>> > > > > [...]
>> > > > > > I'm not against this model, as I've said before. It feels logical,
>> > > > > > and will work fine in most cases.
>> > > > > >
>> > > > > > In this case we can drop any mount/boot options, because it preserves
>> > > > > > the existing behavior in the default configuration. A big advantage.
>> > > > >
>> > > > > I am not sure about this. We still need an opt-in, ragardless, because
>> > > > > selecting the largest process from the largest memcg != selecting the
>> > > > > largest task (just consider memcgs with many processes example).
>> > > >
>> > > > As I understand Johannes, he suggested to compare individual processes with
>> > > > group_oom mem cgroups. In other words, always select a killable entity with
>> > > > the biggest memory footprint.
>> > > >
>> > > > This is slightly different from my v8 approach, where I treat leaf memcgs
>> > > > as indivisible memory consumers independent on group_oom setting, so
>> > > > by default I'm selecting the biggest task in the biggest memcg.
>> > >
>> > > My reading is that he is actually proposing the same thing I've been
>> > > mentioning. Simply select the biggest killable entity (leaf memcg or
>> > > group_oom hierarchy) and either kill the largest task in that entity
>> > > (for !group_oom) or the whole memcg/hierarchy otherwise.
>> >
>> > He wrote the following:
>> > "So I'm leaning toward the second model: compare all oomgroups and
>> > standalone tasks in the system with each other, independent of the
>> > failed hierarchical control structure. Then kill the biggest of them."
>>
>> I will let Johannes to comment but I believe this is just a
>> misunderstanding. If we compared only the biggest task from each memcg
>> then we are basically losing our fairness objective, aren't we?
>
> Sorry about the confusion.
>
> Yeah I was making the case for what Michal proposed, to kill the
> biggest terminal consumer, which is either a task or an oomgroup.
>
> You'd basically iterate through all the tasks and cgroups in the
> system and pick the biggest task that isn't in an oom group or the
> biggest oom group and then kill that.
>
> Yeah, you'd have to compare the memory footprints of tasks with the
> memory footprints of cgroups. These aren't defined identically, and
> tasks don't get attributed every type of allocation that a cgroup
> would. But it should get us in the ballpark, and I cannot picture a
> scenario where this would lead to a completely undesirable outcome.

That last sentence:

> I cannot picture a scenario where this would lead to a completely undesirable outcome.

I feel like David has offered examples here, and many of us at Google
have offered examples as long ago as 2013 (if I recall) of cases where
the proposed heuristic is EXACTLY WRONG.  We need OOM behavior to kill
in a deterministic order configured by policy.  Sometimes, I would
literally prefer to kill every other cgroup before killing "the big
one".  The policy is *all* that matters for shared clusters of varying
users and priorities.

We did this in Borg, and it works REALLY well.  Has for years.  Now
that the world is adopting Kubernetes we need it again, only it's much
harder to carry a kernel patch in this case.
