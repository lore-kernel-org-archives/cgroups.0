From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: remove unneeded header files
Date: Mon, 19 Jun 2023 09:38:47 +0800
Message-ID: <1b7ef52f-bf7b-692f-d906-288c8a64f37c@huawei.com>
References: <20230617072658.1826560-1-linmiaohe@huawei.com>
 <202306171649.O90yt13M-lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <202306171649.O90yt13M-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: oe-kbuild-all-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On 2023/6/17 17:12, kernel test robot wrote:
> Hi Miaohe,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on akpm-mm/mm-everything]
> [also build test ERROR on linus/master v6.4-rc6 next-20230616]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Miaohe-Lin/memcg-remove-unneeded-header-files/20230617-152922
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20230617072658.1826560-1-linmiaohe%40huawei.com
> patch subject: [PATCH] memcg: remove unneeded header files
> config: nios2-randconfig-r004-20230617 (https://download.01.org/0day-ci/archive/20230617/202306171649.O90yt13M-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
> compiler: nios2-linux-gcc (GCC) 12.3.0
> reproduce: (https://download.01.org/0day-ci/archive/20230617/202306171649.O90yt13M-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202306171649.O90yt13M-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/

Many thanks for report. Will fix it.

