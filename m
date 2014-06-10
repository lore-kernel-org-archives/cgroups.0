From: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
Subject: Re: Protection against container fork bombs [WAS: Re: memcg with
 kmem limit doesn't recover after disk i/o causes limit to be hit]
Date: Tue, 10 Jun 2014 17:50:11 +0300
Message-ID: <53971B23.8000509@yuhu.biz>
References: <20140416154650.GA3034@alpha.arachsys.com>	<20140418155939.GE4523@dhcp22.suse.cz>	<5351679F.5040908@parallels.com>	<20140420142830.GC22077@alpha.arachsys.com>	<20140422143943.20609800@oracle.com>	<20140422200531.GA19334@alpha.arachsys.com>	<535758A0.5000500@yuhu.biz> <20140423084942.560ae837@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="3GVEq5bqWT2KnhLROH8Ev1bRXASdGQ3PF"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yuhu.biz; s=default;
	t=1402411804; bh=oVJaycz3H9nvIpMyqNevhtFZmEPDimHnlFaQhVhDyFk=;
	h=Date:From:To:CC:Subject:References:In-Reply-To;
	b=hYvnTxwcMSePAjc92yxgvmhPaWmFC4+WEm5A1c4xLXtvnAsTIrFH+2/Z0EC9/WgdX
	 NyZ99ue1TRZxnz6nNIzQ5ueAxVZmFXGcMw+KrjiSYGxU4mPqM74qc3DWRxQUfxzL4K
	 LcRS7lqW568upHYu6LH3k/J93dkqzm2UBVwvmZ0A=
In-Reply-To: <20140423084942.560ae837-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Dwight Engen <dwight.engen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Richard Davies <richard-li8END47hbdWk0Htik3J/w@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Max Kellermann <mk-xMchvyqCc6DQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, William Dauchy <wdauchy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Daniel Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Berrange <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3GVEq5bqWT2KnhLROH8Ev1bRXASdGQ3PF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 04/23/2014 03:49 PM, Dwight Engen wrote:
> On Wed, 23 Apr 2014 09:07:28 +0300
> Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org> wrote:
>=20
>> On 04/22/2014 11:05 PM, Richard Davies wrote:
>>> Dwight Engen wrote:
>>>> Richard Davies wrote:
>>>>> Vladimir Davydov wrote:
>>>>>> In short, kmem limiting for memory cgroups is currently broken.
>>>>>> Do not use it. We are working on making it usable though.
>>> ...
>>>>> What is the best mechanism available today, until kmem limits
>>>>> mature?
>>>>>
>>>>> RLIMIT_NPROC exists but is per-user, not per-container.
>>>>>
>>>>> Perhaps there is an up-to-date task counter patchset or similar?
>>>>
>>>> I updated Frederic's task counter patches and included Max
>>>> Kellermann's fork limiter here:
>>>>
>>>> http://thread.gmane.org/gmane.linux.kernel.containers/27212
>>>>
>>>> I can send you a more recent patchset (against 3.13.10) if you
>>>> would find it useful.
>>>
>>> Yes please, I would be interested in that. Ideally even against
>>> 3.14.1 if you have that too.
>>
>> Dwight, do you have these patches in any public repo?
>>
>> I would like to test them also.
>=20
> Hi Marian, I put the patches against 3.13.11 and 3.14.1 up at:
>=20
> git://github.com/dwengen/linux.git cpuacct-task-limit-3.13
> git://github.com/dwengen/linux.git cpuacct-task-limit-3.14

I did a backport of the patches to 3.12.16 and forward ported them to 3.1=
2.20.

I'm very happy with how they work.

I used the patches on machines with 10-20k processes and it worked perfec=
tly when some of the containers spawned 100s of
processes. It really saved us when one of the containers was attacked :)

The only thing that I'm going to add is on the fly change of the limit.

Marian

> =20
>> Marian
>>
>>>
>>> Thanks,
>>>
>>> Richard.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe cgroups"
>>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20



--3GVEq5bqWT2KnhLROH8Ev1bRXASdGQ3PF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlOXGyMACgkQ4mt9JeIbjJSbZwCfYE/EfljGWfMgz0MxBcNArv+1
uIIAnjDyTp++AzAotNpxNRj5ZyBtdi85
=ruWh
-----END PGP SIGNATURE-----

--3GVEq5bqWT2KnhLROH8Ev1bRXASdGQ3PF--
