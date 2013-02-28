From: Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: Re: [PATCH] memcg: implement low limits
Date: Thu, 28 Feb 2013 15:13:15 +0400
Message-ID: <61661362049995@webcorp1g.yandex-team.ru>
References: <8121361952156@webcorp1g.yandex-team.ru>
 <20130227094054.GC16719@dhcp22.suse.cz>
 <17521361961576@webcorp1g.yandex-team.ru> <20130227161352.GF16719@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1362049996;
	bh=X3ljLuitAdX3/G0y/Ec/jy4/E822GTjQxRMlauodkxk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=AVFgtskQPukEHavJlGjMjS5Pqog70hTUJE7MWUnJ35kBAD9npIQ18mkeucv+Qz03p
	 wd1SQiUWoCLhSP1uOSxQndOwoLO8gnLpvxkp1rY7F6VNn1J7ytAtL2BHdSURx1utR5
	 2ecgkLMWI1IXItBPXHWuJcV6kCFBI34b4gKWefMY=
In-Reply-To: <20130227161352.GF16719-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner-Arquette <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org" <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org" <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org" <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

27.02.2013, 20:14, "Michal Hocko" <mhocko-AlSwsSmVLrQ@public.gmane.org>:
> On Wed 27-02-13 14:39:36, Roman Gushchin wrote:
>
>> =9A27.02.2013, 13:41, "Michal Hocko" <mhocko-AlSwsSmVLrQ@public.gmane.org>:
>>> =9ALet me restate what I have already mentioned in the private
>>> =9Acommunication.
>>>
>>> =9AWe already have soft limit which can be implemented to achieve t=
he
>>> =9Asame/similar functionality and in fact this is a long term objec=
tive (at
>>> =9Aleast for me). I hope I will be able to post my code soon. The l=
ast post
>>> =9Aby Ying Hand (cc-ing her) was here:
>>> =9Ahttp://comments.gmane.org/gmane.linux.kernel.mm/83499
>>>
>>> =9ATo be honest I do not like introduction of a new limit because w=
e have
>>> =9Atwo already and the situation would get over complicated.
>> =9AI think, there are three different tasks:
>> =9A1) keeping cgroups below theirs hard limit to avoid direct reclai=
m
>> =9A(for performance reasons),
>
> Could you clarify what you mean by this, please? There is no backgrou=
nd
> reclaim for memcgs currently and I am a bit skeptical whether it is
> useful. If it would be useful then it should be in par with the globa=
l
> reclaim (so something like min_free_kbytes would be more appropriate)=
=2E

I mean, that it's a good idea to keep memory usage of any cgroup a litt=
le bit=20
under it's hard limit to avoid direct reclaim. There is no good mechani=
sm yet,
but it can be developed later.

>> =9A2) cgroup's prioritization during global reclaim,
>
> Yes, group priorities sound like a useful feature not just for the
> reclaim I would like it for oom selection as well.
> I think that we shouldn't use any kind of limit for this task, though=
=2E

I'm thinking about them. Do you know, did someone any attempts to imple=
ment them?
I have an idea how to implement them (and also implementing (fast) stri=
ct lower limits limits).
I'll try to post my version soon.

>> =9A3) granting some amount of memory to a selected cgroup (and prote=
cting
>> =9Ait from reclaim without significant reasons)
>
> and soft limit sounds like a good fit with this description.
>
>> =9AIMHO, combining them all in one limit will simplify a kernel code=
,
>> =9Abut will also make a user's (or administrator's) life much more
>> =9Acomplicated.
>
> I do not think all 3 tasks you have described can be covered by a sin=
gle
> limit of course. We have hard limit to cap the usage, we have a soft
> limit to allow over-committing the machine. Task 2 would require a ne=
w
> knob but it shouldn't be covered by any limit or depend on the group
> usage. And task 1 sounds like a background reclaim and then it should=
 be
> consistent with the global knob.
>
>> =9AIntroducing low limits can make the situation simpler.
>
> How exactly? I can see how it would address task 3 but yet again, sof=
t
> limit can be turned into this behavior as well without changing its
> semantic (that limit would be still considered if we are able to hand=
le
> memory pressure from the above - either global pressure or parent
> hitting the limit).

Actually, I don't like the name of soft limits - the word "soft". It's =
not clear from
the name if it's lower or upper limit. It's a little bit confusing that=
 "limit"=20
means upper limit, and "soft limit" means lower limit.

Assuming it's possible to implement strict lower limit efficiently, how=
 do you call them?

Thank you!

--
Regards,=20
Roman
