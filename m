From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] [PATCH 3/7 v2] memcg: remove PCG_MOVE_LOCK flag from pc->flags
Date: Wed, 25 Jan 2012 15:07:47 -0800
Message-ID: <CALWz4iy0ajriTk7V0xL1+W7rDFS+-M5w4OdPjasMGUTH=ZLgrw@mail.gmail.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
	<20120113174019.8dff3fc1.kamezawa.hiroyu@jp.fujitsu.com>
	<20120117164605.GB22142@tiehlicka.suse.cz>
	<20120118091226.b46e0f6e.kamezawa.hiroyu@jp.fujitsu.com>
	<20120118104703.GA31112@tiehlicka.suse.cz>
	<20120119085309.616cadb4.kamezawa.hiroyu@jp.fujitsu.com>
	<CALWz4ixAT411PZMwngh17V8VZEDGbMNNzbWFwbpC5M-JO+TVOQ@mail.gmail.com>
	<20120124084335.GE26289@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:x-system-of-record:x-gm-message-state:content-type
         :content-transfer-encoding;
        bh=RBAE2rCLMypTCIybqJby9/YhYOLlAilygm4TP7p8/8g=;
        b=l7USWWl0xTsZTUcH5Ww4nsKg0svsu6Zso5xa4b7OPLCpDJcH7a3B4iqmF3Qq/cTu4N
         hG+7flvph3g4iOydpisjfX6le5Ej67LOj1on4tgRpPFsc0sOW6tCAaNKgiSpNfIGCUgM
         Dx+ZjNsZwNZZh3IaFIcv/hlY8EoaLs8vqj6BM=
In-Reply-To: <20120124084335.GE26289-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, Jan 24, 2012 at 12:43 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Mon 23-01-12 14:05:33, Ying Han wrote:
>> On Wed, Jan 18, 2012 at 3:53 PM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
>> > On Wed, 18 Jan 2012 11:47:03 +0100
>> > Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
>> >
>> >> On Wed 18-01-12 09:12:26, KAMEZAWA Hiroyuki wrote:
>> >> > On Tue, 17 Jan 2012 17:46:05 +0100
>> >> > Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
>> >> >
>> >> > > On Fri 13-01-12 17:40:19, KAMEZAWA Hiroyuki wrote:
>> >> [...]
>> >> > > > This patch removes PCG_MOVE_LOCK and add hashed rwlock arra=
y
>> >> > > > instead of it. This works well enough. Even when we need to
>> >> > > > take the lock,
>> >> > >
>> >> > > Hmmm, rwlocks are not popular these days very much.
>> >> > > Anyway, can we rather make it (source) memcg (bit)spinlock in=
stead. We
>> >> > > would reduce false sharing this way and would penalize only p=
ages from
>> >> > > the moving group.
>> >> > >
>> >> > per-memcg spinlock ?
>> >>
>> >> Yes
>> >>
>> >> > The reason I used rwlock() is to avoid disabling IRQ. =A0This r=
outine
>> >> > will be called by IRQ context (for dirty ratio support). =A0So,=
 IRQ
>> >> > disable will be required if we use spinlock.
>> >>
>> >> OK, I have missed the comment about disabling IRQs. It's true tha=
t we do
>> >> not have to be afraid about deadlocks if the lock is held only fo=
r
>> >> reading from the irq context but does the spinlock makes a perfor=
mance
>> >> bottleneck? We are talking about the slowpath.
>> >> I could see the reason for the read lock when doing hashed locks =
because
>> >> they are global but if we make the lock per memcg then we shouldn=
't
>> >> interfere with other updates which are not blocked by the move.
>> >>
>> >
>> > Hm, ok. In the next version, I'll use per-memcg spinlock (with has=
h if necessary)
>>
>> Just want to make sure I understand it, even we make the lock
>> per-memcg, there is still a false sharing of pc within one memcg.
>
> Yes that is true. I have missed that we might fault in several pages =
at
> once but this would happen only during task move, right? And that is =
not
> a hot path anyway. Or?

I was thinking of page-statistics update which is hot path. If the
moving task and non-moving task share the same per-memcg lock, any
page-statistic update from the non-moving task will be blocked? Sorry
If i missed something here :)

>
>> Do we need to demonstrate the effect ?
>>
>> Also, I don't get the point of why spinlock instead of rwlock in thi=
s case?
>
> spinlock provides a fairness while with rwlocks might lead to
> starvation.

that is true.

--Ying

>
>
> --
> Michal Hocko
> SUSE Labs
> SUSE LINUX s.r.o.
> Lihovarska 1060/12
> 190 00 Praha 9
> Czech Republic
