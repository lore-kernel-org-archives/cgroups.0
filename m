From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v4 1/2] sched/topology: Don't try to build empty sched
 domains
Date: Fri, 1 Nov 2019 11:08:50 +0100
Message-ID: <20191101100850.GA16165@blackbody.suse.cz>
References: <20191023153745.19515-1-valentin.schneider@arm.com>
 <20191023153745.19515-2-valentin.schneider@arm.com>
 <20191031162334.GA18570@blackbody.suse.cz>
 <3752bca9-a670-f415-4aaa-e8ff75ea6fcc@arm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3752bca9-a670-f415-4aaa-e8ff75ea6fcc@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Valentin Schneider <valentin.schneider@arm.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org, mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org, Dietmar.Eggemann@arm.com, morten.rasmussen@arm.com, qperret@google.com, stable@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 31, 2019 at 06:23:12PM +0100, Valentin Schneider <valentin.schn=
eider@arm.com> wrote:
> Do you reckon the following would work?=20
LGTM (i.e. cpuset will be skipped if no CPUs taking part in load
balancing remain in it after hot(un)plug event).

Michal

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAl28BC0ACgkQia1+riC5
qShiWQ//coKu7sUzL9S712rBkjJuuZTbEgiG4vayWNJkI6CiV4/kPvqoRqqHW6jx
tqjaJc8WnvcGPzviRbO2MxxSolez/lV3YBsEG7yxAWEOqEl8KLTAiYXk//muLupK
e95/iLA/abTMER+gTOLi4qqMsKBtnH433QTCP/c9jzxaQjlXlo/T5D9s0lDD0bEN
+/wkfUdHyQyOB2+LZpufCjaPdQSKkjsa1o29J48VV5lBaIb86rX1AWmcz5woCULP
R4b3sO2lvcUwalH/ri6n7soF8Vm/IivPawNqSwVbK84te6SKzqSfnHO75gCalCWW
6W+kilNsX2A9pDPj3omTvC4LzCNkeeXW7UQyOYmEOikDhj5aVAUcJDeeuCPiUXMW
/WeQD6dT8adPMBAJEnN/GwsPW2QLAy5jXtbVJBonOD6syF7oSGLONMVl8LDMA2Es
PHpyRCKcvZGPmpjXA65ooE9ZV52732RHlGGqxnsgN6iXns6XRxD7H9M37NIIc+FK
8c61qsrcMVZEtxBehdchoXe6vcvdmS8Ic4o8auQWzVJjoa1BYNJcWo7YYnMsdMW4
cBbg9JlUeuIiCg8I016NtBUOwkRa656L/3OtroXD5Xqbq2/T9k0UVbVM2r16wLMD
xDouMZUIBFUaPspkEqS1PQwgXGt8D/7dNtFP4iiVNHMDhhc1xO4=
=bZv+
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
