From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH v5 1/6] cgroup/cpuset: Properly transition to invalid
 partition
Date: Sat, 14 Aug 2021 16:54:46 -0400
Message-ID: <150a4d86-3e50-67be-af2b-32dd8df0db3c@redhat.com>
References: <20210814173848.11540-2-longman@redhat.com>
 <202108150418.2ORAqLSj-lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628974490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mky//yXfNfMGPffYt4X50VSwGymNfab5t3UGoEej/Ec=;
        b=OCM5WyH8+6QRzVs8H/fgNBSZvx8gmXphcjklZpGMzcheviZg2lQyzL7QNTQkkt7EsRK/Ec
        u5bPt4JR9c+V7Yy/qDzdHZlwlE1feKh93KaRW30wUnJEnhNOjjOPRcbGnnOBvOIYWjBLpr
        sZ6/E+x/ybW5VbmW165sWXwb2n4T6A4=
In-Reply-To: <202108150418.2ORAqLSj-lkp@intel.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: kernel test robot <lkp@intel.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Cc: kbuild-all@lists.01.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On 8/14/21 4:21 PM, kernel test robot wrote:
> Hi Waiman,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on cgroup/for-next]
> [also build test WARNING on next-20210813]
> [cannot apply to kselftest/next v5.14-rc5]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Waiman-Long/cgroup-cpuset-Add-new-cpuset-partition-type-empty-effecitve-cpus/20210815-014333
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
> config: ia64-defconfig (attached as .config)
> compiler: ia64-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/0day-ci/linux/commit/56ec7dd271c77e3cc92f0df6fd766004a7a0aa88
>          git remote add linux-review https://github.com/0day-ci/linux
>          git fetch --no-tags linux-review Waiman-Long/cgroup-cpuset-Add-new-cpuset-partition-type-empty-effecitve-cpus/20210815-014333
>          git checkout 56ec7dd271c77e3cc92f0df6fd766004a7a0aa88
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross ARCH=ia64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>     kernel/cgroup/cpuset.c: In function 'update_prstate':

Oh, it was caused by a duplicated tmpmask in update_prstate() which 
isn't really necessary. Will send out a new version to fix that.

Thanks,
Longman

