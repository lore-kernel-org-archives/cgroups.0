From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next v2 2/2] blk-throttle: fix io hung due to
 configuration updates
Date: Thu, 19 May 2022 11:01:19 +0800
Message-ID: <3d6878f4-1902-633d-0af2-276831364a4f@huawei.com>
References: <20220518072751.1188163-3-yukuai3@huawei.com>
 <202205182347.tMOOqyfL-lkp@intel.com>
 <84fe296e-6e56-3ca9-73a8-357beb675c6e@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <84fe296e-6e56-3ca9-73a8-357beb675c6e-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

在 2022/05/19 10:11, yukuai (C) 写道:
> 
> 
> 在 2022/05/18 23:52, kernel test robot 写道:
>> Hi Yu,
>>
>> Thank you for the patch! Yet something to improve:
>>
>> [auto build test ERROR on next-20220517]
>>
>> url:    
>> https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/bugfix-for-blk-throttle/20220518-151713 
>>
>> base:    47c1c54d1bcd0a69a56b49473bc20f17b70e5242
>> config: m68k-allyesconfig 
>> (https://download.01.org/0day-ci/archive/20220518/202205182347.tMOOqyfL-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config) 
>>
>> compiler: m68k-linux-gcc (GCC) 11.3.0
>> reproduce (this is a W=1 build):
>>          wget 
>> https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross 
>> -O ~/bin/make.cross
>>          chmod +x ~/bin/make.cross
>>          # 
>> https://github.com/intel-lab-lkp/linux/commit/f8345dbaf4ed491742aab29834aff66b4930c087 
>>
>>          git remote add linux-review 
>> https://github.com/intel-lab-lkp/linux
>>          git fetch --no-tags linux-review 
>> Yu-Kuai/bugfix-for-blk-throttle/20220518-151713
>>          git checkout f8345dbaf4ed491742aab29834aff66b4930c087
>>          # save the config file
>>          mkdir build_dir && cp config build_dir/.config
>>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 
>> make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash
>>
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> All errors (new ones prefixed by >>):
>>
>>     m68k-linux-ld: block/blk-throttle.o: in function `tg_conf_updated':
>>>> blk-throttle.c:(.text+0x25bc): undefined reference to `__udivdi3'
>>>> m68k-linux-ld: blk-throttle.c:(.text+0x2626): undefined reference to 
>>>> `__udivdi3'
> Hi,
> 
> I'm confused here, the only place that I can relate to this:
> 
>      return dispatched * new_limit / old_limit;
> 
I understand it now. I'm doing (u64 / u64), I should use div64_u64
> However, I don't understand yet why this is problematic...
>>     `.exit.text' referenced in section `.data' of 
>> sound/soc/codecs/tlv320adc3xxx.o: defined in discarded section 
>> `.exit.text' of sound/soc/codecs/tlv320adc3xxx.o
>>
