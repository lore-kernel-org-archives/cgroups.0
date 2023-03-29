From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/7] mm: page_owner: add support for splitting to any
 order in split page_owner.
Date: Wed, 29 Mar 2023 09:16:32 -0400
Message-ID: <657AFA72-1604-4FFF-8F40-1B6CFB0B5061@nvidia.com>
References: <20230329011712.3242298-5-zi.yan@sent.com>
 <202303291732.7OqWI96E-lkp@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary="=_MailMate_4B7CCE87-645F-4425-A0C9-5A14AB99006F_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkkfzvzIrc/sY02IgoyBaFfrBtVtIdUj4W8RRCy6PQ0=;
 b=J89lKcoDAW48rBtQCezx6f8FZtHF5CqZB6eDEoSllKLeycwGUuOmSh5G2WBdAIzgSNtaTAYmYJf+IOapbai0awSimU81EPqPHVHlsQeRvgQDxK7IaYUZxyYCwxMIsaE1OOXWT9ekm/e1gnNV844d58ni7bMl2fCmcLB+UqvZ3Alk6MPI3n7Qv+Pwa/M8yfi+A2nhktnmTOMCBQZyVePIjmkVy6g+wVxGkWo1ZXWdVV2O7LXi+sIsB+bpIOSovyNrZ2//aNgF8ACSBzwzlucojYYdNlgFSKY8WOV17ZFM7oDMVgLyOnxV76Wl8eckl18TVUx4OM92gzJUmP823jApbA==
In-Reply-To: <202303291732.7OqWI96E-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, oe-kbuild-all-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ryan Roberts <ryan.roberts-5wv7dgnIgG8@public.gmane.org>, =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Zach O'Keefe <zokeefe-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--=_MailMate_4B7CCE87-645F-4425-A0C9-5A14AB99006F_=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On 29 Mar 2023, at 5:58, kernel test robot wrote:

> Hi Zi,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on akpm-mm/mm-everything]
> [also build test ERROR on linus/master v6.3-rc4 next-20230329]
> [If your patch is applied to the wrong git tree, kindly drop us a note.=

> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Zi-Yan/mm-memcg-=
use-order-instead-of-nr-in-split_page_memcg/20230329-091809
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-=
everything
> patch link:    https://lore.kernel.org/r/20230329011712.3242298-5-zi.ya=
n%40sent.com
> patch subject: [PATCH v2 4/7] mm: page_owner: add support for splitting=
 to any order in split page_owner.
> config: i386-randconfig-m021 (https://download.01.org/0day-ci/archive/2=
0230329/202303291732.7OqWI96E-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
> compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
> reproduce (this is a W=3D1 build):
>         # https://github.com/intel-lab-lkp/linux/commit/6d1831c0e01a1a7=
42e026454fe6e5643e08c5985
>         git remote add linux-review https://github.com/intel-lab-lkp/li=
nux
>         git fetch --no-tags linux-review Zi-Yan/mm-memcg-use-order-inst=
ead-of-nr-in-split_page_memcg/20230329-091809
>         git checkout 6d1831c0e01a1a742e026454fe6e5643e08c5985
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=3D1 O=3Dbuild_dir ARCH=3Di386 olddefconfig
>         make W=3D1 O=3Dbuild_dir ARCH=3Di386 SHELL=3D/bin/bash
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> | Link: https://lore.kernel.org/oe-kbuild-all/202303291732.7OqWI96E-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    mm/page_owner.c: In function '__split_page_owner':
>>> mm/page_owner.c:226:28: error: implicit declaration of function 'look=
up_page_ext' [-Werror=3Dimplicit-function-declaration]
>      226 |                 page_ext =3D lookup_page_ext(page + i);
>          |                            ^~~~~~~~~~~~~~~
>    mm/page_owner.c:226:26: warning: assignment to 'struct page_ext *' f=
rom 'int' makes pointer from integer without a cast [-Wint-conversion]
>      226 |                 page_ext =3D lookup_page_ext(page + i);
>          |                          ^
>    cc1: some warnings being treated as errors
>
>
> vim +/lookup_page_ext +226 mm/page_owner.c
>
>    213	=

>    214	void __split_page_owner(struct page *page, int old_order, int ne=
w_order)
>    215	{
>    216		int i;
>    217		struct page_ext *page_ext =3D page_ext_get(page);
>    218		struct page_owner *page_owner;
>    219		unsigned int old_nr =3D 1 << old_order;
>    220		unsigned int new_nr =3D 1 << new_order;
>    221	=

>    222		if (unlikely(!page_ext))
>    223			return;
>    224	=

>    225		for (i =3D 0; i < old_nr; i +=3D new_nr) {
>> 226			page_ext =3D lookup_page_ext(page + i);
>    227			page_owner =3D get_page_owner(page_ext);
>    228			page_owner->order =3D new_order;
>    229		}
>    230		page_ext_put(page_ext);
>    231	}
>    232	=

>
> -- =

> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests

It can be fixed by the patch below. I will fix it in the next version. Th=
anks.

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 347861fe9c50..72244a4f1a31 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -223,9 +223,9 @@ void __split_page_owner(struct page *page, int old_or=
der, int new_order)
                return;

        for (i =3D 0; i < old_nr; i +=3D new_nr) {
-               page_ext =3D lookup_page_ext(page + i);
                page_owner =3D get_page_owner(page_ext);
                page_owner->order =3D new_order;
+               page_ext =3D page_ext_next(page_ext);
        }
        page_ext_put(page_ext);
 }

--=_MailMate_4B7CCE87-645F-4425-A0C9-5A14AB99006F_=--
