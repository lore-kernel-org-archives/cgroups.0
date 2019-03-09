From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v3] blkcg: prevent priority inversion problem during
 sync()
Date: Sun, 10 Mar 2019 02:53:57 +0800
Message-ID: <201903100216.OQdFKZhP%lkp@intel.com>
References: <20190308212806.GA1172@xps-13>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190308212806.GA1172@xps-13>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Andrea Righi <andrea.righi@canonical.com>
Cc: kbuild-all@01.org, Josef Bacik <josef@toxicpanda.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Paolo Valente <paolo.valente@linaro.org>, Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Dennis Zhou <dennis@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrea,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.0 next-20190306]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Andrea-Righi/blkcg-prevent-priority-inversion-problem-during-sync/20190310-020543
config: riscv-tinyconfig (attached as .config)
compiler: riscv64-linux-gcc (GCC) 8.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=8.2.0 make.cross ARCH=riscv 

All errors (new ones prefixed by >>):

   fs/sync.c: In function 'sync_fs_one_sb':
>> fs/sync.c:83:3: error: implicit declaration of function 'blkcg_start_wb_wait_on_bdi' [-Werror=implicit-function-declaration]
      blkcg_start_wb_wait_on_bdi(bdi);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~
>> fs/sync.c:85:3: error: implicit declaration of function 'blkcg_stop_wb_wait_on_bdi' [-Werror=implicit-function-declaration]
      blkcg_stop_wb_wait_on_bdi(bdi);
      ^~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +/blkcg_start_wb_wait_on_bdi +83 fs/sync.c

    77	
    78	static void sync_fs_one_sb(struct super_block *sb, void *arg)
    79	{
    80		struct backing_dev_info *bdi = sb->s_bdi;
    81	
    82		if (!sb_rdonly(sb) && sb->s_op->sync_fs) {
  > 83			blkcg_start_wb_wait_on_bdi(bdi);
    84			sb->s_op->sync_fs(sb, *(int *)arg);
  > 85			blkcg_stop_wb_wait_on_bdi(bdi);
    86		}
    87	}
    88	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--envbJBWh7q8WU6mo
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--envbJBWh7q8WU6mo--
