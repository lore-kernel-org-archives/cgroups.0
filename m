From: Rami Rosen <roszenrami-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Error: /bin/echo: write error: No space left on device
Date: Fri, 29 Mar 2013 21:09:15 +0300
Message-ID: <CAKoUArkjE6arXSJGtDUZch=Kmxv-h0yDypT9wrof_OggYUZ1Jw@mail.gmail.com>
References: <CAGXs5wUE5MaazKPuS9F3cyoFytCeuH9g8FFBMctHa6pDJ3P6xg@mail.gmail.com>
	<CAGXs5wVRqanB_++m4hFbG1RgzqnFic8qVss=ogh92n6MOmTSMg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        bh=41Z7PvoCcgQWzJToamv+3cWyT7hsX5NCkn17bxlKtbs=;
        b=vQhrMYlvazAiY387Nih7LkORux5HfGVIQEAwsKcof0PMnwroNbwOI8OzBO1TVcAnGa
         4w4z9JrMUSoEIyeGw7EUP9HeVF0E2wk+0k2r1y8ZG3nBgbzVeBpAj1dqO7I1gvBQdmD5
         8ChJfvpn+8JqWezNrjmsMKkY/JeP9KSe3+icfEj5aD2ZY3W7b3EmQrqhoQFLZ9oNswZb
         YC9pSfCbm6Xmjecm32d6R29UgHHPisT6fHQLer1e45Jexx5dmKz5DKtfLVPP9tzpkAog
         o/3iS0Tln2LqlAcOANaLg0rUAewc5UqUnyAC6I1FDqXAFT/8Ow9fvc1nOApEPCF5Dp33
         vqTQ==
In-Reply-To: <CAGXs5wVRqanB_++m4hFbG1RgzqnFic8qVss=ogh92n6MOmTSMg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

It is always better to run the external echo command:
/bin/echo 1 > cpuset.mems
instead of echo 1 > cpuset.mems

as this command will display write(2) errors.

see: man 7 cpuset


regards,
Rami Rosen
http://ramirose.wix.com/ramirosen


On Fri, Mar 29, 2013 at 8:44 PM, Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> Hi,
> With
>
> echo 1 > cpuset.mems
> everything worked!
>
> Best,
> Kevin
>
>
> On Fri, Mar 29, 2013 at 7:32 PM, Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
>> Hello,
>>
>> I tried this sequence of actions according to
>> Documentation/cgroups/cgroups.txt:
>>
>>   mount -t tmpfs cgroup_root /sys/fs/cgroup
>>   mkdir /sys/fs/cgroup/cpuset
>>   mount -t cgroup cpuset -ocpuset /sys/fs/cgroup/cpuset
>>   cd /sys/fs/cgroup/cpuset
>>   mkdir Charlie
>>   cd Charlie
>>   /bin/echo 2-3 > cpuset.cpus
>>
>>
>> [root@h Charlie]# /bin/echo 1 > cpuset.mems
>> /bin/echo: write error: Invalid argument
>> [root@h Charlie]# /bin/echo $$ > tasks
>> /bin/echo: write error: No space left on device
>>
>>
>> Any ideas why are these two error ?
>> BTW:
>>
>> [root@h Charlie]# df -h
>> df: =91/sys/fs/cgroup/systemd=92: No such file or directory
>> df: =91/sys/fs/cgroup/cpu,cpuacct=92: No such file or directory
>> df: =91/sys/fs/cgroup/memory=92: No such file or directory
>> df: =91/sys/fs/cgroup/devices=92: No such file or directory
>> df: =91/sys/fs/cgroup/freezer=92: No such file or directory
>> df: =91/sys/fs/cgroup/net_cls=92: No such file or directory
>> df: =91/sys/fs/cgroup/blkio=92: No such file or directory
>> df: =91/sys/fs/cgroup/perf_event=92: No such file or directory
>> Filesystem      Size  Used Avail Use% Mounted on
>> devtmpfs        991M     0  991M   0% /dev
>> tmpfs          1002M  324K 1002M   1% /dev/shm
>> tmpfs          1002M  2.9M  999M   1% /run
>> tmpfs          1002M     0 1002M   0% /sys/fs/cgroup
>>
>> So it seems that there is 1002M available on  /sys/fs/cgroup
>>
>> any ideas?
>> Kevin
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
