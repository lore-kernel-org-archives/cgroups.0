From: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [BUG] kernel BUG at mm/memcontrol.c:1074!
Date: Thu, 19 Jan 2012 10:05:01 -0500
Message-ID: <CA+1xoqe5zNrx5H66HwkoywHf9FD6QTr2fcAPJSUbEx2KHf1VOg@mail.gmail.com>
References: <1326949826.5016.5.camel@lappy> <20120119122354.66eb9820.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LSU.2.00.1201181932040.2287@eggly.anvils> <20120119130353.0ca97435.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LSU.2.00.1201182100010.2830@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        bh=zy5hBAdQSLWdWt4E3e8cGpdvROaXfOZDKMPXfupev9Q=;
        b=CHZD62dayHux9HaN9ba36upa1nDjXbVNCFW8warS9hUxCqIQrCQ+Jmpqi2j0G0MPJ3
         DQPWJGI4xM3KmEeP0CEdkZ8yCQESArgGfkesTo9mQTpuAZ20xwzgCMz4FF7EagpfAzxy
         qZFKEgNP1MeEcQZvIfOPin//8I+SUq3uAh25A=
In-Reply-To: <alpine.LSU.2.00.1201182100010.2830-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, hannes <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Jan 19, 2012 at 12:16 AM, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Thu, 19 Jan 2012, KAMEZAWA Hiroyuki wrote:
>> On Wed, 18 Jan 2012 19:41:44 -0800 (PST)
>> Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> >
>> > I notice that, unlike Linus's git, this linux-next still has
>> > mm-isolate-pages-for-immediate-reclaim-on-their-own-lru.patch in.
>> >
>> > I think that was well capable of oopsing in mem_cgroup_lru_del_lis=
t(),
>> > since it didn't always know which lru a page belongs to.
>> >
>> > I'm going to be optimistic and assume that was the cause.
>> >
>> Hmm, because the log hits !memcg at lru "del", the page should be ad=
ded
>> to LRU somewhere and the lru must be determined by pc->mem_cgroup.
>>
>> Once set, pc->mem_cgroup is not cleared, just overwritten. AFAIK, th=
ere is
>> only one chance to set pc->mem_cgroup as NULL... initalization.
>> I wonder why it hits lru_del() rather than lru_add()...
>> ................
>>
>> Ahhhh, ok, it seems you are right. the patch has following kinds of =
codes
>> =3D=3D
>> +static void pagevec_putback_immediate_fn(struct page *page, void *a=
rg)
>> +{
>> + =A0 =A0 =A0 struct zone *zone =3D page_zone(page);
>> +
>> + =A0 =A0 =A0 if (PageLRU(page)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 enum lru_list lru =3D page_lru(page);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_move(&page->lru, &zone->lru[lru].=
list);
>> + =A0 =A0 =A0 }
>> +}
>> =3D=3D
>> ..this will bypass mem_cgroup_lru_add(), and we can see bug in lru_d=
el()
>> rather than lru_add()..
>
> I've not thought it through in detail (and your questioning reminds m=
e
> that the worst I saw from that patch was updating of the wrong counts=
,
> leading to underflow, then livelock from the mismatch between empty l=
ist
> and enormous count: I never saw an oops from it, and may be mistaken)=
=2E
>
>>
>> Another question is who pushes pages to LRU before setting pc->mem_c=
group..
>> Anyway, I think we need to fix memcg to be LRU_IMMEDIATE aware.
>
> I don't think so: Mel agreed that the patch could not go forward as i=
s,
> without an additional pageflag, and asked Andrew to drop it from mmot=
m
> in mail on 29th December (I didn't notice an mm-commits message to sa=
y
> akpm did drop it, and marc is blacked out in protest for today, so I
> cannot check: but certainly akpm left it out of his push to Linus).
>
> Oh, and Mel noticed another bug in it on the 30th, that the PageLRU
> check in the function you quote above is wrong: see PATCH 11/11 threa=
d.

So reverting this patch seems to indeed solve the issue (though
reverting wasn't clean - some minor conflicts in mm/swap.c).
