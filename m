From: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Error: /bin/echo: write error: No space left on device
Date: Fri, 29 Mar 2013 20:44:25 +0300
Message-ID: <CAGXs5wVRqanB_++m4hFbG1RgzqnFic8qVss=ogh92n6MOmTSMg@mail.gmail.com>
References: <CAGXs5wUE5MaazKPuS9F3cyoFytCeuH9g8FFBMctHa6pDJ3P6xg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:content-type:content-transfer-encoding;
        bh=x92SRkmt8MDemx7hkC4xvs9HrHtGpGUFUxHbIjzYQN8=;
        b=woIwNPfaqY4yE9FhL9u5+x7jF7By/Nriwn4W1KMJT1Nh5L2No3epSCDhXANNof5rdw
         lRWXsst5+cGys3aF8fOWZdYm9E0B+HhMfKIx2SO0OwxGmL4UF+hk0hrfwqW6MyE1qAV3
         tdVYbkTO2tH+0ObI2OC6omryM7AhRwuSNViHDTmuq8mqMzro2KvbpBavYLXsr6CRx/C4
         XnlIE+5RoeaP9dZ1snOrd/cavTV/0gcskSh1eVvMSV9OBTEHQrVH2B1pTLX4o28JSmPe
         FmK4h50qI3to2UHzWkbXDWvLlkmm3KYt2rDCZJmmzKiMwGVVM2qad4S9ceCeteoOU8Ow
         zN/A==
In-Reply-To: <CAGXs5wUE5MaazKPuS9F3cyoFytCeuH9g8FFBMctHa6pDJ3P6xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
With

echo 1 > cpuset.mems
everything worked!

Best,
Kevin


On Fri, Mar 29, 2013 at 7:32 PM, Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> Hello,
>
> I tried this sequence of actions according to
> Documentation/cgroups/cgroups.txt:
>
>   mount -t tmpfs cgroup_root /sys/fs/cgroup
>   mkdir /sys/fs/cgroup/cpuset
>   mount -t cgroup cpuset -ocpuset /sys/fs/cgroup/cpuset
>   cd /sys/fs/cgroup/cpuset
>   mkdir Charlie
>   cd Charlie
>   /bin/echo 2-3 > cpuset.cpus
>
>
> [root@h Charlie]# /bin/echo 1 > cpuset.mems
> /bin/echo: write error: Invalid argument
> [root@h Charlie]# /bin/echo $$ > tasks
> /bin/echo: write error: No space left on device
>
>
> Any ideas why are these two error ?
> BTW:
>
> [root@h Charlie]# df -h
> df: =91/sys/fs/cgroup/systemd=92: No such file or directory
> df: =91/sys/fs/cgroup/cpu,cpuacct=92: No such file or directory
> df: =91/sys/fs/cgroup/memory=92: No such file or directory
> df: =91/sys/fs/cgroup/devices=92: No such file or directory
> df: =91/sys/fs/cgroup/freezer=92: No such file or directory
> df: =91/sys/fs/cgroup/net_cls=92: No such file or directory
> df: =91/sys/fs/cgroup/blkio=92: No such file or directory
> df: =91/sys/fs/cgroup/perf_event=92: No such file or directory
> Filesystem      Size  Used Avail Use% Mounted on
> devtmpfs        991M     0  991M   0% /dev
> tmpfs          1002M  324K 1002M   1% /dev/shm
> tmpfs          1002M  2.9M  999M   1% /run
> tmpfs          1002M     0 1002M   0% /sys/fs/cgroup
>
> So it seems that there is 1002M available on  /sys/fs/cgroup
>
> any ideas?
> Kevin
