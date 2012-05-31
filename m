From: Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
Date: Thu, 31 May 2012 15:58:41 +0800
Message-ID: <4FC724B1.70508@cn.fujitsu.com>
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com> <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com> <4FC6B68C.2070703@jp.fujitsu.com> <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com> <4FC6BC3E.5010807@jp.fujitsu.com> <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com> <4FC6C111.2060108@jp.fujitsu.com> <alpine.DEB.2.00.1205301831270.25774@chino.kir.corp.google.com> <4FC6D881.4090706@jp.fujitsu.com> <alpine.DEB.2.00.1205302156090.25774@chino.kir.corp.google.com> <4FC70355.70805@jp.fujitsu.com> <alpine.DEB.2.00.1205302314190.25774@chino.kir.corp.google.com> <4FC70E5E.1010003@gmail.com> <alpine.DEB.2.00.1205302325500.25774@chino.kir.corp.google.com> <4FC711A5.4090003@gmail.com> <alpine.DEB.2.00.1205302351510.25774@chino.kir.corp
 .google.com> <CAHGf_=qVDVT6VW2j9gE3bQKwizW24iivrDryiCKoxVu4m_fWKw@mail.gmail.com> <alpine.DEB.2.00.1205310028420.8864@chino.kir.corp.google.com> <4FC720EE.3010307@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC720EE.3010307-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

=E4=BA=8E 2012=E5=B9=B405=E6=9C=8831=E6=97=A5 15:42, KOSAKI Motohiro =E5=
=86=99=E9=81=93:
> (5/31/12 3:35 AM), David Rientjes wrote:
>> On Thu, 31 May 2012, KOSAKI Motohiro wrote:
>>
>>>> As I said, LXC and namespace isolation is a tangent to the discuss=
ion of
>>>> faking the /proc/meminfo for the memcg context of a thread.
>>>
>>> Because of, /proc/meminfo affect a lot of libraries behavior. So, i=
t's not only
>>> application issue. If you can't rewrite _all_ of userland assets, f=
ake meminfo
>>> can't be escaped. Again see alternative container implementation.
>>>
>>
>> It's a tangent because it isn't a complete psuedo /proc/meminfo for =
all
>> threads attached to a memcg regardless of any namespace isolation; t=
he LXC
>> solution has existed for a couple of years by its procfs patchset th=
at
>> overlaps procfs with fuse and can suppress or modify any output in t=
he
>> context of a memory controller using things like
>> memory.{limit,usage}_in_bytes.  I'm sure all other fields could be
>> modified if outputted in some structured way via memcg; it looks lik=
e
>> memory.stat would need to be extended to provide that.  If that's mo=
unted
>> prior to executing the application, then your isolation is achieved =
and
>> all libraries should see the new output that you've defined in LXC.
>>
>> However, this seems like a seperate topic than the patch at hand whi=
ch
>> does this directly to /proc/meminfo based on a thread's memcg contex=
t,
>> that's the part that I'm nacking.
>=20
> Then, I NAKed current patch too. Yeah, current one is ugly. It assume=
 _all_
> user need namespace isolation and it clearly is not.
>=20
>=20
>> I'd recommend to Gao to expose this
>> information via memory.stat and then use fuse and the procfs lxc sup=
port
>> as your way of contextualizing the resources.
>=20
> It's one of a option. But, I seriously doubt fuse can make simpler th=
an kamezawa-san's
> idea. But yeah, I might NACK kamezawa-san's one if he will post ugly =
patch.
>=20

It seams I should do some homework to make the implement beautifully.

I think kamezawa-san's idea is more simpler.
thanks for your advice.

>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20
