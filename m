From: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: A problem with memory.oom_control
Date: Tue, 15 Apr 2014 07:03:50 +0300
Message-ID: <CAGXs5wVPsdPFm5EssN3_MSSermVMoUtAqc9XTH_YVN+bkPKVyA@mail.gmail.com>
References: <CAGXs5wUdhEYQ-kGEPSD2A=OceZuA1tovLs04gPcRcqBPagQJCw@mail.gmail.com>
	<534C9E45.9090005@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=MWpXN/+YR8gG51y+kNQwYWwoGn8cPnRKwlInISz38Ak=;
        b=j9T4SawlnmtKMCjooznGUVTBzV0cUbK8Rx41+vB+gIEhShidt5C4Q50QXtMKMT47Vt
         X2hQQlNXYp64G/IH7g1xW6adjF/0bbNWMkck5Ro8aYxSmGMneJnB1G0f8/jrmnUm9AB2
         jM0k7mIBfydGytCC6PZKYuPnJniLK6kq7qGiq1wfM/Dis2CQzDsPeIRZIWkoohE+nUBC
         ahMW1e835yRswduaQ+K5iZKu/YUFYaWXxYHl+t75pokN1L/CGmfjP7Hm9yUtUxLp+s+5
         f/bDDv1Co0uHRNUE8VLE7vL2WTHyU7gp4htmvaqC8OMJKdVQsgP9TsL7AdP7V/vfe2Rw
         fODw==
In-Reply-To: <534C9E45.9090005-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
Thanks to the fast response.

Indeed:

#cat /sys/fs/cgroup/memory/memory.use_hierarchy
1

#cat /sys/fs/cgroup/memory/0/memory.use_hierarchy
1

However:

#echo 0 >  /sys/fs/cgroup/memory/memory.use_hierarchy
bash: echo: write error: Device or resource busy

#echo 0 >  /sys/fs/cgroup/memory/0/memory.use_hierarchy
bash: echo: write error: Invalid argument

So it seems that use_hierarchy cannot be changed via writing to sysfs

Any advice ?
Regards,
Kevin




On Tue, Apr 15, 2014 at 5:49 AM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> =E4=BA=8E 2014/4/14 19:54, Kevin Wilson =E5=86=99=E9=81=93:
>> Hello,
>>
>> First I hope this mailing list is the proper one for asking the
>> following question:
>> I do the following, as root,  on Fedora 20 with 3.12.7-300.fc20.x86_=
64 kernel:
>>
>> create a cgroup called "0"
>> /sys/fs/cgroup/memory/0
>>
>> run:
>>
>> echo "1" > /sys/fs/cgroup/memory/0/memory.oom_control
>> bash: echo: write error: Invalid argument
>>
>> Why am I having this error  ?
>>
>> According to the documentation:
>>
>> http://lxr.free-electrons.com/source/Documentation/cgroups/memory.tx=
t
>> this should work.
>>
>
> Check if /sys/fs/cgroup/memory/memory/use_hierarchy is 1, if so the f=
ailure
> is an expectecd bahavior.
>
> "This operation is only allowed to the top cgroup of a sub-hierarchy.=
"
>
