From: Chris Down <chris@chrisdown.name>
Subject: Re: mm: mkfs.ext4 invoked oom-killer on i386 - pagecache_get_page
Date: Wed, 17 Jun 2020 14:57:58 +0100
Message-ID: <20200617135758.GA548179@chrisdown.name>
References: <CA+G9fYsiZ81pmawUY62K30B6ue+RXYod854RS91R2+F8ZO7Xvw@mail.gmail.com>
 <20200519075213.GF32497@dhcp22.suse.cz>
 <CAK8P3a2T_j-Ynvhsqe_FCqS2-ZdLbo0oMbHhHChzMbryE0izAQ@mail.gmail.com>
 <20200519084535.GG32497@dhcp22.suse.cz>
 <CA+G9fYvzLm7n1BE7AJXd8_49fOgPgWWTiQ7sXkVre_zoERjQKg@mail.gmail.com>
 <CA+G9fYsXnwyGetj-vztAKPt8=jXrkY8QWe74u5EEA3XPW7aikQ@mail.gmail.com>
 <20200520190906.GA558281@chrisdown.name>
 <20200521095515.GK6462@dhcp22.suse.cz>
 <20200521163450.GV6462@dhcp22.suse.cz>
 <CA+G9fYsdsgRmwLtSKJSzB1eWcUQ1z-_aaU+BNcQpker34XT6_w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=czz/LMTUSEyCUOCBc2bpVTh7IggBB8ARvYVKv0fzm0w=;
        b=oHJZsmwDgazVpFYFy9f1b0DXnvsC0m5vxNXELt2qWUG2KfVfS0Fn9Az8Mm4tsT5Yun
         T0BN8K2g46PCiRW5Vtd3CYq9U6e5qZuldGsqUGrQVKibeXmeDBk6U6AB2EVkl4AOMQoQ
         bb1tNkHgfcvlaxd0Rj1tDcDG32lDe0/EQGnL4=
Content-Disposition: inline
In-Reply-To: <CA+G9fYsdsgRmwLtSKJSzB1eWcUQ1z-_aaU+BNcQpker34XT6_w@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Michal Hocko <mhocko@kernel.org>, Yafang Shao <laoar.shao@gmail.com>, Anders Roxell <anders.roxell@linaro.org>, "Linux F2FS DEV, Mailing List" <linux-f2fs-devel@lists.sourceforge.net>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, open list <linux-kernel@vger.kernel.org>, Linux-Next Mailing List <linux-next@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Chao Yu <chao@kernel.org>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Matthew Wilcox <willy@infradead.org>, Chao Yu <yuchao0@huawei.com>, lkft-triage@l

Naresh Kamboju writes:
>mkfs -t ext4 /dev/disk/by-id/ata-TOSHIBA_MG04ACA100N_Y8RQK14KF6XF
>mke2fs 1.43.8 (1-Jan-2018)
>Creating filesystem with 244190646 4k blocks and 61054976 inodes
>Filesystem UUID: 7c380766-0ed8-41ba-a0de-3c08e78f1891
>Superblock backups stored on blocks:
>32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
>4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
>102400000, 214990848
>Allocating group tables:    0/7453 done
>Writing inode tables:    0/7453 done
>Creating journal (262144 blocks): [   51.544525] under min:0 emin:0
>[   51.845304] under min:0 emin:0
>[   51.848738] under min:0 emin:0
>[   51.858147] under min:0 emin:0
>[   51.861333] under min:0 emin:0
>[   51.862034] under min:0 emin:0
>[   51.862442] under min:0 emin:0
>[   51.862763] under min:0 emin:0

Thanks, this helps a lot. Somehow we're entering mem_cgroup_below_min even when 
min/emin is 0 (which should indeed be the case if you haven't set them in the 
hierarchy).

My guess is that page_counter_read(&memcg->memory) is 0, which means 
mem_cgroup_below_min will return 1.

However, I don't know for sure why that should then result in the OOM killer 
coming along. My guess is that since this memcg has 0 pages to scan anyway, we 
enter premature OOM under some conditions. I don't know why we wouldn't have 
hit that with the old version of mem_cgroup_protected that returned 
MEMCG_PROT_* members, though.

Can you please try the patch with the `>=` checks in mem_cgroup_below_min and 
mem_cgroup_below_low changed to `>`? If that fixes it, then that gives a strong 
hint about what's going on here.

Thanks for your help!
