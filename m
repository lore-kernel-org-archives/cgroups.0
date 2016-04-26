From: Himadri Sarkar <s.himadri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: blkio weights not honoured with lvm setup and on amazon ebs
Date: Tue, 26 Apr 2016 23:02:48 +0530
Message-ID: <CAGC20Lq+jswsqmDCHwh7sRx8zFEkgHPez5Yxn-yYqrSVz+9aMA@mail.gmail.com>
References: <CAGC20LorhnUfchmB7OBNAHn+xMRRvwNRs_Dn0+P2eaga2Ds8ig@mail.gmail.com>
 <571E627B.40300@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=57BqtxcT1FiLg5RkAeccAcMUTVe1j6jOOrJuFJ1XYOg=;
        b=LfAIIENNo3q/9DBfe+tag9PZjMKI6xsC8zA4ybNUKzPrKU8M/KzojMtjMjlrKHSvnP
         8vP3TNlA25u8/Wtdz3Vfi5zCoxg8wrYWuGVlCtnUgwUshA4efA/7ExLF4NRi/puwp+II
         oU8Mn5kD7auOdh9zkMCUVA7MBwm0gc1KAVhAnzpmnm+e7iapEqSxThn/jyKnC4b40ysK
         zFZxveWetVpyz0Z8407/rd9rv/cY6sq0eWUHp+SwzMQoUjXTgsS8wift1ELrIlCv245G
         nkMBQow40CiCtv6lQUz5/9m+3muKcsUsXpvUdwQJIh3xIsHILnpzDC68cNxdCneV5BSE
         cWvQ==
In-Reply-To: <571E627B.40300-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nborisov <n.borisov.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Thanks for your reply.
Does it also not work with Amazon EBS and SAN based storage?
Regards
- Himadri


On Tue, Apr 26, 2016 at 12:01 AM, nborisov <n.borisov.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>
> On 25.04.2016 20:53, Himadri Sarkar wrote:
>> Hi,
>>
>> I was doing some experiments to test out blkio with the following
>> setups and was unable to get the expected behavior. It will be great
>> if someone can help me understand what might have gone wrong with my
>> setup.
>>
>> Setup 1
>> hardware: d2.xlarge machine on aws (It has 3 * 2 TB hdd)
>> logical volume: setup an lvm to use 2 disks out of 3
>> file system: xfs
>> IO Scheduler: cfq
>> blkio weights: test1 has weight 1000, test2 has weight 500
>>
>> Now when I run the tests as given in
>> https://www.kernel.org/doc/Documentation/cgroup-v1/blkio-controller.txt
>> using dd (I only executed read tests on already written files)
>> I found that both the processes were getting equal time share
>> (blkio.time) and serviced bytes (blkio.io_service_bytes) irrespective
>> of differential weights.
>>
>> Now when I modified the setup by not having lvm setup and just
>> creating a 2TB file system out of a single hdd it worked i.e. serviced
>> bytes were in the ratio 2 : 1
>>
>> On the other hand when I tested read with fio
>>
>> specifically
>>
>> fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1
>> --name=test2 --filename=file2 --bs=4k --iodepth=64 --size=4G
>> --readwrite=randrw --rwmixread=100
>>
>> Then also it worked even with the lvm setup. Which makes be believe
>> that with Setup 1 it is not working due to buffered reads. (But then
>> the same thing also worked without lvm)
>
> This is a well-known limitation to LVM, which supposedly was fixed in a
> recent kernel. For more information check this email thread:
> https://www.redhat.com/archives/dm-devel/2016-February/msg00183.html
>
> Then a patch was proposed in the following thread:
> https://www.redhat.com/archives/dm-devel/2016-March/msg00006.html
>
> This was tested by me and the proportional-based limits were working,
> provided that the devices hosting the LVM VG were using CFQ as their io
> scheduler.
>
> Regards,
> Nikolay
