From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] [PATCH 2/7 v2] memcg: add memory barrier for checking
 account move.
Date: Fri, 20 Jan 2012 10:08:44 -0800
Message-ID: <CALWz4iz59=-J+cif+XickXBG3zUSy58yHhkX6j3zbJyBXGzpYw@mail.gmail.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
	<20120113173347.6231f510.kamezawa.hiroyu@jp.fujitsu.com>
	<20120117152635.GA22142@tiehlicka.suse.cz>
	<20120118090656.83268b3e.kamezawa.hiroyu@jp.fujitsu.com>
	<20120118123759.GB31112@tiehlicka.suse.cz>
	<20120119111727.6337bde4.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:x-system-of-record:content-type:content-transfer-encoding;
        bh=PB8BKBMcTZzUL4uEyhTmmz+zCg1nXLCj6syf+3UT9o4=;
        b=r2lR1GmIDjh3f1NImo0dwewsMyjuVXfCM4rgDdHind4AgSnKxMKbj/WTfZwlarx4Vw
         RnCeb5dWY2b4x5jsBNJSj3hPppy0IpjWAEHRnGlDr0GQFB2Khte9bc+o5Qzn9ce9jYD4
         HY4w8ChxzNzbZ7eir9ptgPREHn6LwCtqRNn2Y=
In-Reply-To: <20120119111727.6337bde4.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jan 18, 2012 at 6:17 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> On Wed, 18 Jan 2012 13:37:59 +0100
> Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
>
>> On Wed 18-01-12 09:06:56, KAMEZAWA Hiroyuki wrote:
>> > On Tue, 17 Jan 2012 16:26:35 +0100
>> > Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
>> >
>> > > On Fri 13-01-12 17:33:47, KAMEZAWA Hiroyuki wrote:
>> > > > I think this bugfix is needed before going ahead. thoughts?
>> > > > =3D=3D
>> > > > From 2cb491a41782b39aae9f6fe7255b9159ac6c1563 Mon Sep 17 00:00=
:00 2001
>> > > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> > > > Date: Fri, 13 Jan 2012 14:27:20 +0900
>> > > > Subject: [PATCH 2/7] memcg: add memory barrier for checking ac=
count move.
>> > > >
>> > > > At starting move_account(), source memcg's per-cpu variable
>> > > > MEM_CGROUP_ON_MOVE is set. The page status update
>> > > > routine check it under rcu_read_lock(). But there is no memory
>> > > > barrier. This patch adds one.
>> > >
>> > > OK this would help to enforce that the CPU would see the current=
 value
>> > > but what prevents us from the race with the value update without=
 the
>> > > lock? This is as racy as it was before AFAICS.
>> > >
>> >
>> > Hm, do I misunderstand ?
>> > =3D=3D
>> > =A0 =A0update =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 reference
>> >
>> > =A0 =A0CPU A =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CPU B
>> > =A0 set value =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rcu_read_lock()
>> > =A0 smp_wmb() =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0smp_rmb()
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0read_value
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rcu_read_un=
lock()
>> > =A0 synchronize_rcu().
>> > =3D=3D
>> > I expect
>> > If synchronize_rcu() is called before rcu_read_lock() =3D> move_lo=
ck_xxx will be held.
>> > If synchronize_rcu() is called after rcu_read_lock() =3D> update w=
ill be delayed.
>>
>> Ahh, OK I can see it now. Readers are not that important because it =
is
>> actually the updater who is delayed until all preexisting rcu read
>> sections are finished.
>>
>> In that case. Why do we need both barriers? spin_unlock is a full
>> barrier so maybe we just need smp_rmb before we read value to make s=
ure
>> that we do not get stalled value when we start rcu_read section afte=
r
>> synchronize_rcu?
>>
>
> I doubt .... If no barrier, this case happens
>
> =3D=3D
> =A0 =A0 =A0 =A0update =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0reference
> =A0 =A0 =A0 =A0CPU A =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CPU B
> =A0 =A0 =A0 =A0set value
> =A0 =A0 =A0 =A0synchronize_rcu() =A0 =A0 =A0 rcu_read_lock()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0read_v=
alue <=3D find old value
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rcu_re=
ad_unlock()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0do no =
lock
> =3D=3D

Hi Kame,

Can you help to clarify a bit more on the example above? Why
read_value got the old value after synchronize_rcu().

Sorry for getting into this late.

--Ying

Sorry for getting into this late.
>
>> > Here, cpu B needs to read most recently updated value.
>>
>> If it reads the old value then it would think that we are not moving=
 and
>> so we would account to the old group and move it later on, right?
>>
> Right. without move_lock, we're not sure which old/new pc->mem_cgroup=
 will be.
> This will cause mis accounting.
>
>
> Thanks,
> -Kame
>
>
>
>
>
