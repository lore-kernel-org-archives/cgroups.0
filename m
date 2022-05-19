From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next v2 2/2] blk-throttle: fix io hung due to
 configuration updates
Date: Thu, 19 May 2022 10:11:06 +0800
Message-ID: <84fe296e-6e56-3ca9-73a8-357beb675c6e@huawei.com>
References: <20220518072751.1188163-3-yukuai3@huawei.com>
 <202205182347.tMOOqyfL-lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <202205182347.tMOOqyfL-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org



=D4=DA 2022/05/18 23:52, kernel test robot =D0=B4=B5=C0:
> Hi Yu,
>=20
> Thank you for the patch! Yet something to improve:
>=20
> [auto build test ERROR on next-20220517]
>=20
> url:    https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/bugfix-for=
-blk-throttle/20220518-151713
> base:    47c1c54d1bcd0a69a56b49473bc20f17b70e5242
> config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/202205=
18/202205182347.tMOOqyfL-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
> compiler: m68k-linux-gcc (GCC) 11.3.0
> reproduce (this is a W=3D1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sb=
in/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/intel-lab-lkp/linux/commit/f8345dbaf4ed4917=
42aab29834aff66b4930c087
>          git remote add linux-review https://github.com/intel-lab-lkp/lin=
ux
>          git fetch --no-tags linux-review Yu-Kuai/bugfix-for-blk-throttle=
/20220518-151713
>          git checkout f8345dbaf4ed491742aab29834aff66b4930c087
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-11.3.0 make.cr=
oss W=3D1 O=3Dbuild_dir ARCH=3Dm68k SHELL=3D/bin/bash
>=20
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.o=
rg>
>=20
> All errors (new ones prefixed by >>):
>=20
>     m68k-linux-ld: block/blk-throttle.o: in function `tg_conf_updated':
>>> blk-throttle.c:(.text+0x25bc): undefined reference to `__udivdi3'
>>> m68k-linux-ld: blk-throttle.c:(.text+0x2626): undefined reference to `_=
_udivdi3'
Hi,

I'm confused here, the only place that I can relate to this:

	return dispatched * new_limit / old_limit;

However, I don't understand yet why this is problematic...
>     `.exit.text' referenced in section `.data' of sound/soc/codecs/tlv320=
adc3xxx.o: defined in discarded section `.exit.text' of sound/soc/codecs/tl=
v320adc3xxx.o
>=20
