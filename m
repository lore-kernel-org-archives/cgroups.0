From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] [PATCH 3/7 v2] memcg: remove PCG_MOVE_LOCK flag from pc->flags
Date: Mon, 23 Jan 2012 14:05:33 -0800
Message-ID: <CALWz4ixAT411PZMwngh17V8VZEDGbMNNzbWFwbpC5M-JO+TVOQ@mail.gmail.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
	<20120113174019.8dff3fc1.kamezawa.hiroyu@jp.fujitsu.com>
	<20120117164605.GB22142@tiehlicka.suse.cz>
	<20120118091226.b46e0f6e.kamezawa.hiroyu@jp.fujitsu.com>
	<20120118104703.GA31112@tiehlicka.suse.cz>
	<20120119085309.616cadb4.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:x-system-of-record:x-gm-message-state:content-type
         :content-transfer-encoding;
        bh=fz54nmNCpDqzmu7HPESWZvN5pWy6G5+BcP2GBRWzl5o=;
        b=zy+UpjM3xmrn5c4pgi+52iKbO/I3yiF9ifI4wW6SNdcwA2915U5vopHil5+XcHhmoV
         khVEBW26LARWs4NcrS0C7wWMSdZon0ix6Ge2Jk3/Hs2fQ7fMlq+EvOJmzcQ0Lom/TMg1
         neowLjLMnzztDBAS/V9dmuM0iCqhIiX3+j130=
In-Reply-To: <20120119085309.616cadb4.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jan 18, 2012 at 3:53 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> On Wed, 18 Jan 2012 11:47:03 +0100
> Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
>
>> On Wed 18-01-12 09:12:26, KAMEZAWA Hiroyuki wrote:
>> > On Tue, 17 Jan 2012 17:46:05 +0100
>> > Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
>> >
>> > > On Fri 13-01-12 17:40:19, KAMEZAWA Hiroyuki wrote:
>> [...]
>> > > > This patch removes PCG_MOVE_LOCK and add hashed rwlock array
>> > > > instead of it. This works well enough. Even when we need to
>> > > > take the lock,
>> > >
>> > > Hmmm, rwlocks are not popular these days very much.
>> > > Anyway, can we rather make it (source) memcg (bit)spinlock inste=
ad. We
>> > > would reduce false sharing this way and would penalize only page=
s from
>> > > the moving group.
>> > >
>> > per-memcg spinlock ?
>>
>> Yes
>>
>> > The reason I used rwlock() is to avoid disabling IRQ. =A0This rout=
ine
>> > will be called by IRQ context (for dirty ratio support). =A0So, IR=
Q
>> > disable will be required if we use spinlock.
>>
>> OK, I have missed the comment about disabling IRQs. It's true that w=
e do
>> not have to be afraid about deadlocks if the lock is held only for
>> reading from the irq context but does the spinlock makes a performan=
ce
>> bottleneck? We are talking about the slowpath.
>> I could see the reason for the read lock when doing hashed locks bec=
ause
>> they are global but if we make the lock per memcg then we shouldn't
>> interfere with other updates which are not blocked by the move.
>>
>
> Hm, ok. In the next version, I'll use per-memcg spinlock (with hash i=
f necessary)

Just want to make sure I understand it, even we make the lock
per-memcg, there is still a false sharing of pc within one memcg. Do
we need to demonstrate the effect ?

Also, I don't get the point of why spinlock instead of rwlock in this c=
ase?

--Ying

>
> Thanks,
> -Kame
>
>
