From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] cpuset: use static key better and convert to new API
Date: Wed, 6 Apr 2016 11:16:50 +0200
Message-ID: <5704D402.5040705@suse.cz>
References: <201604061600.UbEyxDC5%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <201604061600.UbEyxDC5%fengguang.wu@intel.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On 04/06/2016 10:56 AM, kbuild test robot wrote:
> Hi Vlastimil,
>
> [auto build test ERROR on v4.6-rc2]
> [also build test ERROR on next-20160406]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
>
> url:    https://github.com/0day-ci/linux/commits/Vlastimil-Babka/cpuset-use-static-key-better-and-convert-to-new-API/20160406-164542
> config: x86_64-randconfig-x011-201614 (attached as .config)
> reproduce:
>          # save the attached .config to linux build tree
>          make ARCH=x86_64
>
> All errors (new ones prefixed by >>):
>
>     mm/page_alloc.c: In function 'get_page_from_freelist':
>>> mm/page_alloc.c:2653:5: error: implicit declaration of function '__cpuset_zone_allowed' [-Werror=implicit-function-declaration]

Ah, forgot about !CONFIG_CPUSETS. Sorry, I'll send v2.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
