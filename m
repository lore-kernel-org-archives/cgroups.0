From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH -next v2 2/2] blk-throttle: fix io hung due to
 configuration updates
Date: Thu, 19 May 2022 09:01:52 +0200
Message-ID: <CAMuHMdV6NysKKh+HZ-cgHh+=SVcydmxO6ic82+t3ySTgfkoEOg@mail.gmail.com>
References: <20220518072751.1188163-3-yukuai3@huawei.com> <202205182347.tMOOqyfL-lkp@intel.com>
 <84fe296e-6e56-3ca9-73a8-357beb675c6e@huawei.com> <3d6878f4-1902-633d-0af2-276831364a4f@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3d6878f4-1902-633d-0af2-276831364a4f@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "yukuai (C)" <yukuai3@huawei.com>
Cc: kernel test robot <lkp@intel.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, kbuild-all@lists.01.org, cgroups@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, yi.zhang@huawei.com

Hi Yukuai,

On Thu, May 19, 2022 at 5:25 AM yukuai (C) <yukuai3@huawei.com> wrote:
> 在 2022/05/19 10:11, yukuai (C) 写道:
> > 在 2022/05/18 23:52, kernel test robot 写道:
> >> Thank you for the patch! Yet something to improve:
> >>
> >> [auto build test ERROR on next-20220517]
> >>
> >> url:
> >> https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/bugfix-for-blk-throttle/20220518-151713
> >>
> >> base:    47c1c54d1bcd0a69a56b49473bc20f17b70e5242
> >> config: m68k-allyesconfig
> >> (https://download.01.org/0day-ci/archive/20220518/202205182347.tMOOqyfL-lkp@intel.com/config)
> >>
> >> compiler: m68k-linux-gcc (GCC) 11.3.0
> >> reproduce (this is a W=1 build):
> >>          wget
> >> https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross
> >> -O ~/bin/make.cross
> >>          chmod +x ~/bin/make.cross
> >>          #
> >> https://github.com/intel-lab-lkp/linux/commit/f8345dbaf4ed491742aab29834aff66b4930c087
> >>
> >>          git remote add linux-review
> >> https://github.com/intel-lab-lkp/linux
> >>          git fetch --no-tags linux-review
> >> Yu-Kuai/bugfix-for-blk-throttle/20220518-151713
> >>          git checkout f8345dbaf4ed491742aab29834aff66b4930c087
> >>          # save the config file
> >>          mkdir build_dir && cp config build_dir/.config
> >>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0
> >> make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash
> >>
> >> If you fix the issue, kindly add following tag as appropriate
> >> Reported-by: kernel test robot <lkp@intel.com>
> >>
> >> All errors (new ones prefixed by >>):
> >>
> >>     m68k-linux-ld: block/blk-throttle.o: in function `tg_conf_updated':
> >>>> blk-throttle.c:(.text+0x25bc): undefined reference to `__udivdi3'
> >>>> m68k-linux-ld: blk-throttle.c:(.text+0x2626): undefined reference to
> >>>> `__udivdi3'
> > Hi,
> >
> > I'm confused here, the only place that I can relate to this:
> >
> >      return dispatched * new_limit / old_limit;
> >
> > However, I don't understand yet why this is problematic...
> >>     `.exit.text' referenced in section `.data' of
> >> sound/soc/codecs/tlv320adc3xxx.o: defined in discarded section
> >> `.exit.text' of sound/soc/codecs/tlv320adc3xxx.o
>
> + static u64 throtl_update_bytes_disp(u64 dispatched, u64 new_limit,
> +                                    u64 old_limit)
> + {
> +        if (new_limit == old_limit)
> +                return dispatched;
> +
> +        if (new_limit == U64_MAX)
> +                return 0;
> +
> +        return dispatched * new_limit / old_limit;
>
> I understand it now. I'm doing (u64 / u64), I should use div64_u64

Better, use mul_u64_u64_div_u64(), as "dispatched * new_limit"
may overflow?

> + }
> +
> + static u32 throtl_update_io_disp(u32 dispatched, u32 new_limit, u32 old_limit)
> + {
> +        if (new_limit == old_limit)
> +                return dispatched;
> +
> +        if (new_limit == UINT_MAX)
> +                return 0;
> +
> +        return dispatched * new_limit / old_limit;

This is the same as above, but now operating on u32s instead of u64s.
Likewise, can the multiplication overflow?

> + }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
