From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] [PATCH 1/7 v2] memcg: remove unnecessary check in mem_cgroup_update_page_stat()
Date: Thu, 19 Jan 2012 12:07:22 -0800
Message-ID: <CALWz4iy=hpEbXgjdkD+OH69MHjBorSELB3RZ8BxWNFjk=5yRNw@mail.gmail.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
	<20120113173227.df2baae3.kamezawa.hiroyu@jp.fujitsu.com>
	<20120117151619.GA21348@tiehlicka.suse.cz>
	<20120118085558.6ed1a988.kamezawa.hiroyu@jp.fujitsu.com>
	<20120118130102.GC31112@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:x-system-of-record:content-type:content-transfer-encoding;
        bh=qKIBGYmIUFbpehLtuXT4sAwNnFPFKC76gQD1oAPKq60=;
        b=f/BnqhvPMt6w9dpa4xi4vs1TEyWYFIxMvFjm055mbL+F/4yDePPR0Y9++o4M9FcpPG
         6usYqxm4fM1QSA2q9nk5UemybPWLoe8s8cx5xyp8OHg8vaAJKkntnhfbu027aK/KJ9Lp
         6MGxGS/GftMgJY2asWe0Kz2PcMhBvwwLk7ewY=
In-Reply-To: <20120118130102.GC31112-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jan 18, 2012 at 5:01 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Wed 18-01-12 08:55:58, KAMEZAWA Hiroyuki wrote:
>> On Tue, 17 Jan 2012 16:16:20 +0100
>> Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
>>
>> > On Fri 13-01-12 17:32:27, KAMEZAWA Hiroyuki wrote:
>> > >
>> > > From 788aebf15f3fa37940e0745cab72547e20683bf2 Mon Sep 17 00:00:0=
0 2001
>> > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> > > Date: Thu, 12 Jan 2012 16:08:33 +0900
>> > > Subject: [PATCH 1/7] memcg: remove unnecessary check in mem_cgro=
up_update_page_stat()
>> > >
>> > > commit 10ea69f1182b removes move_lock_page_cgroup() in thp-split=
 path.
>> > > So, this PageTransHuge() check is unnecessary, too.
>> >
>> > I do not see commit like that in the tree. I guess you meant
>> > memcg: make mem_cgroup_split_huge_fixup() more efficient which is =
not
>> > merged yet, right?
>> >
>>
>> This commit in the linux-next.
>
> Referring to commits from linux-next is tricky as it changes all the
> time. I guess that the full commit subject should be sufficient.
>
>> > > Note:
>> > > =A0- considering when mem_cgroup_update_page_stat() is called,
>> > > =A0 =A0there will be no race between split_huge_page() and updat=
e_page_stat().
>> > > =A0 =A0All required locks are held in higher level.
>> >
>> > We should never have THP page in this path in the first place. So =
why
>> > not changing this to VM_BUG_ON(PageTransHuge).
>> >
>>
>> Ying Han considers to support mlock stat.
>
> OK, got it. What about the following updated changelog instead?
>
> =3D=3D=3D
> We do not have to check PageTransHuge in mem_cgroup_update_page_stat
> and fallback into the locked accounting because both move charge and =
thp

one nitpick. Should it be "move account" instead of "move charge"?

--Ying

> split up are done with compound_lock so they cannot race. update vs.
> move is protected by the mem_cgroup_stealed sufficiently.
>
> PageTransHuge pages shouldn't appear in this code path currently beca=
use
> we are tracking only file pages at the moment but later we are planni=
ng
> to track also other pages (e.g. mlocked ones).
> =3D=3D=3D
>
>>
>> Thanks,
>> -Kame
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe cgroups" i=
n
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> --
> Michal Hocko
> SUSE Labs
> SUSE LINUX s.r.o.
> Lihovarska 1060/12
> 190 00 Praha 9
> Czech Republic
