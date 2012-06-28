From: Li Zefan <lizefan@huawei.com>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup cgroup]
Date: Thu, 28 Jun 2012 14:07:51 +0800
Message-ID: <4FEBF4B7.2070105@huawei.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com> <20120627182903.GP15811@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120627182903.GP15811@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "tj@kernel.org" <tj@kernel.org>
Cc: shyju pv <shyju.pv@huawei.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Sanil kumar <sanil.kumar@huawei.com>, Masanari Iida <standby24x7@gmail.com>

tj@kernel.org wrote:

> On Sun, Jun 24, 2012 at 07:08:07PM +0000, shyju pv wrote:
>> Hi,
>> Observed a crash on 3.5-rc3 with cgroup tests from LTP(Stable April,2012 release)on Dell Inspiron 1526[Intel(R) Core2Duo T7250, MEM 4GB] and also on another x86 quad core target(4GB RAM).
>> LTP test case: cgroup_regression_test.sh(test 4,7 and 9 crashes randomly when the test cases are executed in order)


I wrote thoese test scripts. ;)

>> Shyju
>>
>> [  532.805905] BUG: Dentry ffff8801164db490{i=491b,n=/} still in use (1) [unmount of cgroup cgrou
> 
> Hmm... fa980ca87d "cgroup: superblock can't be released with active
> dentries" is supposed to have fixed that.  Looking into it.
> 


I think I know what happened here:

umount
  deativate_super(sb)
                       dput(subdir)
                         subdir->d_count--
                         d_release(subdir)
                           deactivate_super(sb)
                             shrink_dcache_for_umount(sb)
                               BUG(root->d_count)!!
                         root->d_count--

I use this script to reproduce the bug:

mount -t cgroup -o cpu xxx /mnt
mkdir /mnt/sub
sleep 100 < /mnt/sub &
kill $!
wait $!
rmdir /mnt/sub
umount /mnt
