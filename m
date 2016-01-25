From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm/memcontrol: avoid a spurious gcc warning
Date: Mon, 25 Jan 2016 13:55:38 -0500
Message-ID: <20160125185538.GF29291@cmpxchg.org>
References: <1453736756-1959377-3-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1453736756-1959377-3-git-send-email-arnd@arndb.de>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, linux-arm-kernel@lists.infradead.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Hi Arnd,

On Mon, Jan 25, 2016 at 04:45:50PM +0100, Arnd Bergmann wrote:
> When CONFIG_DEBUG_VM is set, the various VM_BUG_ON() confuse gcc to
> the point where it cannot remember that 'memcg' is known to be initiali=
zed:
>=20
> mm/memcontrol.c: In function 'mem_cgroup_can_attach':
> mm/memcontrol.c:4791:9: warning: 'memcg' may be used uninitialized in t=
his function [-Wmaybe-uninitialized]
>=20
> On ARM gcc-5.1, the above happens when any two or more of the VM_BUG_ON=
()
> are active, but not when I remove most or all of them. This is clearly
> random behavior and the only way I've found to shut up the warning is
> to add an explicit initialization.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks Arnd.

This has been fixed upstream already:

commit eed67d75b66748a498a0592d9704081a98509444
Author: Ross Zwisler <ross.zwisler@linux.intel.com>
Date:   Wed Dec 23 14:53:27 2015 -0700

    cgroup: Fix uninitialized variable warning
   =20
    Commit 1f7dd3e5a6e4 ("cgroup: fix handling of multi-destination migra=
tion
    from subtree_control enabling") introduced the following compiler war=
ning:
   =20
    mm/memcontrol.c: In function =E2=80=98mem_cgroup_can_attach=E2=80=99:
    mm/memcontrol.c:4790:9: warning: =E2=80=98memcg=E2=80=99 may be used =
uninitialized in this function [-Wmaybe-uninitialized]
       mc.to =3D memcg;
             ^
   =20
    Fix this by initializing 'memcg' to NULL.
   =20
    This was found using gcc (GCC) 4.9.2 20150212 (Red Hat 4.9.2-6).
   =20
    Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
