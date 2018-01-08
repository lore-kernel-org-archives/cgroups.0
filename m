From: yuyufen <yuyufen@huawei.com>
Subject: is a bug in blk-throttle?
Date: Mon, 8 Jan 2018 20:46:32 +0800
Message-ID: <2c99866a-3075-7a51-02c0-f683eec503c7@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: tj@kernel.org, axboe@fb.com, shli@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

Hi, all

I test blk throttle in linux.4.15-rc6, and find that,
system can't throttle IOs accurately, when io.max is set a small value.

I make a directory 'mytest' in cgroup2 and set /dev/vdc io.max to 1M/s.
Device /dev/vdc(253:32) is mounted on /ext4 with type ext4.

$ echo "253:32 wbps=1048576" > /sys/fs/cgroup/unified/mytest/io.max
$ echo $$ > /sys/fs/cgroup/unified/mytest/cgroup.procs


Test result as follow:

$ dd if=/dev/zero of=/ext4/f1 bs=1M count=10 oflag=direct
$ iostat 1 -d -h -y -p vdc
Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
vdc
                   3.00         0.0k         1.0M       0.0k 1.0M

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
vdc
                   5.00         0.0k         1.0M       0.0k 1.0M

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
vdc
                   3.00         0.0k         1.0M       0.0k 1.0M

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
vdc
                   3.00         0.0k         1.0M       0.0k 1.0M

when bs = io.max, it seems OK!


$ dd if=/dev/zero of=/ext4/f1 bs=512k count=10 oflag=direct
$ iostat 1 -d -h -y -p vdc
Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
vdc
                       3.00         0.0k         1.0M 0.0k       1.0M

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
vdc
                       2.00         0.0k         1.0M 0.0k       1.0M

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
vdc
                       2.00         0.0k         1.0M 0.0k       1.0M

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
vdc
                       2.00         0.0k         1.0M 0.0k       1.0M
When bs < io.max, it also seems OK!


$ dd if=/dev/zero of=/ext4/f1 bs=2M count=10 oflag=direct
$ iostat 1 -d -h -y -p vdc
Device:            tps    MB_read/s    MB_wrtn/s    MB_read MB_wrtn
vdc
                       4.00         0.0k         2.0M 0.0k       2.0M

Device:            tps    MB_read/s    MB_wrtn/s    MB_read MB_wrtn
vdc
                       0.00         0.0k         0.0k 0.0k       0.0k

Device:            tps    MB_read/s    MB_wrtn/s    MB_read MB_wrtn
vdc
                       6.00         0.0k         2.0M 0.0k       2.0M

Device:            tps    MB_read/s    MB_wrtn/s    MB_read MB_wrtn
vdc
                       0.00         0.0k         0.0k 0.0k       0.0k
However,
when bs > io.max, the max MB_wrtn/s is 2M, which is over the limit (i.e. 
io.max=1M).
We also test with bs = 10M, the result also show as above.


Reason:
In my system, a bio's BIO_MAX_PAGES=512 pages (i.e. 2M).
Since dd is sequence write, each submitted bio is 2M, when bs > 2M.
blk-throttle will dispatch an integral number of bios from struct 
throtl_service_queue,
resulting in MB_wrtn/s = 2M.

Is this a bug and worth to fix?


Thanks.
Yufen Yu

