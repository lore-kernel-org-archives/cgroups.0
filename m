From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: mm: mkfs.ext4 invoked oom-killer on i386 - pagecache_get_page
Date: Thu, 21 May 2020 11:35:49 +0200
Message-ID: <CAK8P3a2Yna-BD+M6-+Y2Go_Y0ZXx8_7KMud7JxSfPbG8+-Q7Wg@mail.gmail.com>
References: <CA+G9fYu2ruH-8uxBHE0pdE6RgRTSx4QuQPAN=Nv3BCdRd2ouYA@mail.gmail.com>
 <20200501135806.4eebf0b92f84ab60bba3e1e7@linux-foundation.org>
 <CA+G9fYsiZ81pmawUY62K30B6ue+RXYod854RS91R2+F8ZO7Xvw@mail.gmail.com>
 <20200519075213.GF32497@dhcp22.suse.cz> <CAK8P3a2T_j-Ynvhsqe_FCqS2-ZdLbo0oMbHhHChzMbryE0izAQ@mail.gmail.com>
 <20200519084535.GG32497@dhcp22.suse.cz> <CA+G9fYvzLm7n1BE7AJXd8_49fOgPgWWTiQ7sXkVre_zoERjQKg@mail.gmail.com>
 <CA+G9fYsXnwyGetj-vztAKPt8=jXrkY8QWe74u5EEA3XPW7aikQ@mail.gmail.com>
 <20200520190906.GA558281@chrisdown.name> <CA+G9fYt1qvGQTAdUZ4WgitY18cydgnNzqu_fyoTtSm3W8JhF3w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+G9fYt1qvGQTAdUZ4WgitY18cydgnNzqu_fyoTtSm3W8JhF3w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Michal Hocko <mhocko@kernel.org>, Anders Roxell <anders.roxell@linaro.org>, "Linux F2FS DEV, Mailing List" <linux-f2fs-devel@lists.sourceforge.net>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, open list <linux-kernel@vger.kernel.org>, Linux-Next Mailing List <linux-next@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Chao Yu <chao@kernel.org>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Matthew Wilcox <willy@infradead.org>, Chao Yu <yuchao0@huawei.com>

On Thu, May 21, 2020 at 11:22 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
> On Thu, 21 May 2020 at 00:39, Chris Down <chris@chrisdown.name> wrote:
> > Since you have i386 hardware available, and I don't, could you please apply
> > only "avoid stale protection" again and check if it only happens with that
> > commit, or requires both? That would help narrow down the suspects.

Note that Naresh is running an i386 kernel on regular 64-bit hardware that
most people have access to.

> kernel config link,
> https://builds.tuxbuild.com/8lg6WQibcwtQRRtIa0bcFA/kernel.config

Do you know if the same bug shows up running a kernel with that
configuration in qemu? I would expect it to, and that would make
it much easier to reproduce.

I would also not be surprised if it happens on all architectures but only
shows up on the 32-bit arm and x86 machines first because they have
a rather limited amount of lowmem. Maybe booting a 64-bit kernel
with "mem=512M" and then running "dd if=/dev/sda of=/dev/null bs=1M"
will also trigger it. I did not attempt to run this myself.

       Arnd
