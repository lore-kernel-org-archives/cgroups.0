From: Michal Hocko <mhocko@kernel.org>
Subject: Re: Possible mem cgroup bug in kernels between 4.18.0 and 5.3-rc1.
Date: Fri, 2 Aug 2019 16:41:10 +0200
Message-ID: <20190802144110.GL6461@dhcp22.suse.cz>
References: <5659221C-3E9B-44AD-9BBF-F74DE09535CD@apple.com>
 <20190802074047.GQ11627@dhcp22.suse.cz>
 <7E44073F-9390-414A-B636-B1AE916CC21E@apple.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7E44073F-9390-414A-B636-B1AE916CC21E@apple.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Masoud Sharbiani <msharbiani@apple.com>
Cc: gregkh@linuxfoundation.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri 02-08-19 07:18:17, Masoud Sharbiani wrote:
> =20
>=20
> > On Aug 2, 2019, at 12:40 AM, Michal Hocko <mhocko@kernel.org> wrote:
> >=20
> > On Thu 01-08-19 11:04:14, Masoud Sharbiani wrote:
> >> Hey folks,
> >> I=E2=80=99ve come across an issue that affects most of 4.19, 4.20 and =
5.2 linux-stable kernels that has only been fixed in 5.3-rc1.
> >> It was introduced by
> >>=20
> >> 29ef680 memcg, oom: move out_of_memory back to the charge path=20
> >=20
> > This commit shouldn't really change the OOM behavior for your particular
> > test case. It would have changed MAP_POPULATE behavior but your usage is
> > triggering the standard page fault path. The only difference with
> > 29ef680 is that the OOM killer is invoked during the charge path rather
> > than on the way out of the page fault.
> >=20
> > Anyway, I tried to run your test case in a loop and leaker always ends
> > up being killed as expected with 5.2. See the below oom report. There
> > must be something else going on. How much swap do you have on your
> > system?
>=20
> I do not have swap defined.=20

OK, I have retested with swap disabled and again everything seems to be
working as expected. The oom happens earlier because I do not have to
wait for the swap to get full.

Which fs do you use to write the file that you mmap? Or could you try to
simplify your test even further? E.g. does everything work as expected
when doing anonymous mmap rather than file backed one?
--=20
Michal Hocko
SUSE Labs
