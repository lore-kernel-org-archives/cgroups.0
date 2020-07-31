From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5.4 00/19] 5.4.55-rc1 review
Date: Fri, 31 Jul 2020 19:15:47 +0200
Message-ID: <20200731171547.GC2012979@kroah.com>
References: <20200730074420.502923740@linuxfoundation.org>
 <CA+G9fYvCPwwmF-k=Z9Z6P2KYrOMHurcORwa3RW2H1j6pq1QEDg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596215761;
        bh=9bNhpovPSTGi6X3LF9twzY/MMA9zySnTVDjOd55Ntxc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2dlBa5GvxepmB1bZWS6B4sDbxrGegsTyQ4h4AQ1rmaWhT1WYYuPVBcjLzEYBROrYs
         eI8bf1euA96BCgOWN+O8i/1WbCxMhrQb/d5IwLpc+PWlibzAt7QRE5yyqaBRBahQpf
         HKwa1SAokQSMNQqWrUcwplngTMoq0no3Ux2vRfxc=
Content-Disposition: inline
In-Reply-To: <CA+G9fYvCPwwmF-k=Z9Z6P2KYrOMHurcORwa3RW2H1j6pq1QEDg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: open list <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Guenter Roeck <linux@roeck-us.net>, Shuah Khan <shuah@kernel.org>, patches@kernelci.org, Ben Hutchings <ben.hutchings@codethink.co.uk>, lkft-triage@lists.linaro.org, linux- stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Basil Eljuse <Basil.Eljuse@arm.com>, Shakeel Butt <shakeelb@google.com>, Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@linux.com>, Roman Gushchin <guro@fb.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm <linux-mm@kvack.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>, Muchun Song <songmuchun@bytedance.com>

On Fri, Jul 31, 2020 at 04:02:16PM +0530, Naresh Kamboju wrote:
> On Thu, 30 Jul 2020 at 13:36, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.55 release.
> > There are 19 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 01 Aug 2020 07:44:05 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.4.55-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>=20
> Results from Linaro=E2=80=99s test farm.
> Regressions on arm64 Juno-r2 device running LTP controllers-tests
>=20
> CONFIG_ARM64_64K_PAGES=3Dy
>=20
> Unable to handle kernel paging request at virtual address dead000000000108
> [dead000000000108] address between user and kernel address ranges
> Internal error: Oops: 96000044 [#1] PREEMPT SMP
>=20
> pc : get_page_from_freelist+0xa64/0x1030
> lr : get_page_from_freelist+0x9c4/0x1030
>=20
> We are trying to reproduce this kernel panic and trying to narrow down to
> specific test cases.

If you come up with something that needs to be reverted, please let me
know.

Otherwise, thanks for testing all of these.

greg k-h
