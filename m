From: Himadri Sarkar <s.himadri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: blkio weights not honoured with lvm setup and on amazon ebs
Date: Mon, 25 Apr 2016 23:23:16 +0530
Message-ID: <CAGC20LorhnUfchmB7OBNAHn+xMRRvwNRs_Dn0+P2eaga2Ds8ig@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:date:message-id:subject:to;
        bh=eol32+ZnNR7b2vZVelFsWXILskVG2X1/0n9oaS41kPQ=;
        b=NNc3m7bR3cJ9JjCo2+t//VMAGlNvjotOLxa7IXvB5x76i7hyDaRVHrNp4WjbcaCKFV
         IzfiDtLr/zU+NbIwlT4/CUSpzQn5u1VIzx6syG3wYzZL3E93rBnZKrjLKhwcGtoCJO2O
         sVCjzFlslBcyeKVzQ3UjM/+PLGup5R87rWQ7/AwTOPGsOpwjMd4/e4zo8L3qALvHih0L
         PPCmfK9SUM6iLcmWaKZlHQTkJEb6eVs2GbJujxMcWYIo8unvt0CWbsQgQDwFLSd4GkVM
         8i9zj64N5eL+WEfK3l2alfEkQIYrK8SKnBVzy2/OXEvSArLrIozcoA5qXnb38r9yDazu
         mbRw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I was doing some experiments to test out blkio with the following
setups and was unable to get the expected behavior. It will be great
if someone can help me understand what might have gone wrong with my
setup.

Setup 1
hardware: d2.xlarge machine on aws (It has 3 * 2 TB hdd)
logical volume: setup an lvm to use 2 disks out of 3
file system: xfs
IO Scheduler: cfq
blkio weights: test1 has weight 1000, test2 has weight 500

Now when I run the tests as given in
https://www.kernel.org/doc/Documentation/cgroup-v1/blkio-controller.txt
using dd (I only executed read tests on already written files)
I found that both the processes were getting equal time share
(blkio.time) and serviced bytes (blkio.io_service_bytes) irrespective
of differential weights.

Now when I modified the setup by not having lvm setup and just
creating a 2TB file system out of a single hdd it worked i.e. serviced
bytes were in the ratio 2 : 1

On the other hand when I tested read with fio

specifically

fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1
--name=test2 --filename=file2 --bs=4k --iodepth=64 --size=4G
--readwrite=randrw --rwmixread=100

Then also it worked even with the lvm setup. Which makes be believe
that with Setup 1 it is not working due to buffered reads. (But then
the same thing also worked without lvm)

Setup 2
hardware: c3.xlarge machine on aws with 300GB EBS (which I believe are
like SAN storage)
logical volume: setup an lvm
file system: xfs
IO Scheduler: cfq
blkio weights: test1 has weight 1000, test 2 has weight 500

Now with this setup I was not able to get it working in any of the
cases i.e. with lvm, without lvm, with fio sync reads.
Is it the problem with using EBS volumes? Is there way in which I can
get blkio to work with Setup 1 and Setup 2? Please let me know if
providing more data points might help.


Regards
- Himadri
