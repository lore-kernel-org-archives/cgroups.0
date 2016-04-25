From: nborisov <n.borisov.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: blkio weights not honoured with lvm setup and on amazon ebs
Date: Mon, 25 Apr 2016 21:31:23 +0300
Message-ID: <571E627B.40300@gmail.com>
References: <CAGC20LorhnUfchmB7OBNAHn+xMRRvwNRs_Dn0+P2eaga2Ds8ig@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding;
        bh=AYEwekseusufCq7XSFlrVs0Kq28vhQGxsrkO+NF29Po=;
        b=eaprDhg5799r4daMGZfSb12G7SWkdZjl4ME4aLJPeY8RFHu28uBoNR26AvomM/t6XV
         W5NsqN66Ma767Ou96MWnippXYa9YevzCXhP/rSy4TjWqqvdXSFuE5XLVfO1bcPigruQK
         J9iJzJ8lioTe7qhmcF2KPGWz0YnekMwhyBExaT7eaPXZ+9zqu3N3mrqBaXlf2VLgzqQW
         qjuGatHb6NW5ABvgatVTJ3+NGyp34iMk2xFtt73nu1Z0QKGQDM8u3YKnMF7OYw148xFy
         8DWk6at7eckTHUWeA9IufAE28GozG/+tSCK4JzUiRrImBGYjYJajCgX2v63jnkyesj+1
         yX+g==
In-Reply-To: <CAGC20LorhnUfchmB7OBNAHn+xMRRvwNRs_Dn0+P2eaga2Ds8ig-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Himadri Sarkar <s.himadri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 25.04.2016 20:53, Himadri Sarkar wrote:
> Hi,
> 
> I was doing some experiments to test out blkio with the following
> setups and was unable to get the expected behavior. It will be great
> if someone can help me understand what might have gone wrong with my
> setup.
> 
> Setup 1
> hardware: d2.xlarge machine on aws (It has 3 * 2 TB hdd)
> logical volume: setup an lvm to use 2 disks out of 3
> file system: xfs
> IO Scheduler: cfq
> blkio weights: test1 has weight 1000, test2 has weight 500
> 
> Now when I run the tests as given in
> https://www.kernel.org/doc/Documentation/cgroup-v1/blkio-controller.txt
> using dd (I only executed read tests on already written files)
> I found that both the processes were getting equal time share
> (blkio.time) and serviced bytes (blkio.io_service_bytes) irrespective
> of differential weights.
> 
> Now when I modified the setup by not having lvm setup and just
> creating a 2TB file system out of a single hdd it worked i.e. serviced
> bytes were in the ratio 2 : 1
> 
> On the other hand when I tested read with fio
> 
> specifically
> 
> fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1
> --name=test2 --filename=file2 --bs=4k --iodepth=64 --size=4G
> --readwrite=randrw --rwmixread=100
> 
> Then also it worked even with the lvm setup. Which makes be believe
> that with Setup 1 it is not working due to buffered reads. (But then
> the same thing also worked without lvm)

This is a well-known limitation to LVM, which supposedly was fixed in a
recent kernel. For more information check this email thread:
https://www.redhat.com/archives/dm-devel/2016-February/msg00183.html

Then a patch was proposed in the following thread:
https://www.redhat.com/archives/dm-devel/2016-March/msg00006.html

This was tested by me and the proportional-based limits were working,
provided that the devices hosting the LVM VG were using CFQ as their io
scheduler.

Regards,
Nikolay
