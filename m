From: kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 3/4] binder: Add flags to relinquish ownership of fds
Date: Wed, 25 Jan 2023 12:20:49 +0800
Message-ID: <202301251234.klClMpZF-lkp@intel.com>
References: <20230123191728.2928839-4-tjmercier@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674620525; x=1706156525;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NhOPx0gE0BklEYBntjw2S+n2t7urmONIUgn/cw4sNzQ=;
  b=cmZ/hpHuoi62xxIcTXpfAEozZ4cthOFFo5c8At44kqH5FJkVKQg54rPQ
   mtwrELPFObeZqdpgPpfgtW7gbsMwusud/pTS50NWnNQLiO3JOI6eYJ4wb
   6x1zKEtkulQbCwvApEFoR9t5/FN1zbVzDC/BDLK1uvadUDxtiybx0DYrW
   9v3uTyW/l2+86+kfxZmPXSQzdTfQrz5ubG2i7xIuB79oWz4N4OeACtAmr
   Pz1c05rwyy0Bx4F/iaGND6Q/R+/8U/83QgdRPVQDxHSVKnOT3Auy/vWga
   +AiStsNc94j+Xv6djwwIOGvfwMkWFB6P4yJsxXcTs4OTgfLL7UKOztDKl
   A==;
Content-Disposition: inline
In-Reply-To: <20230123191728.2928839-4-tjmercier@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, Suren Baghdasaryan <surenb@google.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, daniel.vetter@ffwll.ch, android-mm@google.com, jstultz@google.com, jeffv@google.com, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, cgroups@vger.kernel.org, Hridya Valsaraju <hridya@google.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Mercier",

Thank you for the patch! Yet something to improve:

[auto build test ERROR on 2241ab53cbb5cdb08a6b2d4688feb13971058f65]

url:    https://github.com/intel-lab-lkp/linux/commits/T-J-Mercier/memcg-Track-exported-dma-buffers/20230124-032017
base:   2241ab53cbb5cdb08a6b2d4688feb13971058f65
patch link:    https://lore.kernel.org/r/20230123191728.2928839-4-tjmercier%40google.com
patch subject: [PATCH v2 3/4] binder: Add flags to relinquish ownership of fds
config: x86_64-randconfig-a016-20230123 (https://download.01.org/0day-ci/archive/20230125/202301251234.klClMpZF-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/41e80f59d1b70691eefc0490e7f1df800cead9f2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review T-J-Mercier/memcg-Track-exported-dma-buffers/20230124-032017
        git checkout 41e80f59d1b70691eefc0490e7f1df800cead9f2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: dma_buf_transfer_charge
   >>> referenced by binder.c:2280 (drivers/android/binder.c:2280)
   >>>               drivers/android/binder.o:(binder_translate_fd) in archive vmlinux.a

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
