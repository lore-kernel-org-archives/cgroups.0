From: Rami Rosen <roszenrami-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: using cgroups' classif with iptables
Date: Fri, 21 Mar 2014 11:10:17 +0200
Message-ID: <CAKoUArkS2mBZkFULqvvHEUEt6btcAAmV-+oWBk2KbNxrnt-s8Q@mail.gmail.com>
References: <532B252F.80302@ovh.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=XmZVxd3HVoCVoboE0pF7HvmJYypW+o+MjWNHx793X7I=;
        b=LQRVJCUs2ueZQLz+tYKx1N0c4LME0g94W4jvnsgjqia++el1TkPcxWlNDUPBoQxmGR
         pg+7bzCFjFp/EZ3x7y8GXov3VEnb31ERoQTN2/1j+uhYVzSV4t965bT+vnM+bOln8M2h
         QKLc7TevUtnVdK/ZYlIzJp2eLQG6yR24b/7X0JaF/2PAkZc5lAdLh49QiyDXQQR5PWxh
         dzTxRRkfYGnS1sx0AyE+YvAeKWGf4d3By32V8vKhkZw4fNds098m51OqMYFB7WXFd1UC
         DIreXx/9cyHiqD+aQyOueMzS54pq0bY/oC1q76lkSTZqoqZZV1L+wwhZ4r1sfSgRyRwj
         JIcg==
In-Reply-To: <532B252F.80302-SavXxUIaH7I@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jean-Tiare LE BIGOT <jean-tiare.le-bigot-SavXxUIaH7I@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi, Jean,

You should look at t the Control Group Classifier module:
http://lxr.free-electrons.com/source/net/sched/cls_cgroup.c

Best regards,
Rami Rosen
http://ramirose.wix.com/ramirosen


On Thu, Mar 20, 2014 at 7:28 PM, Jean-Tiare LE BIGOT
<jean-tiare.le-bigot-SavXxUIaH7I@public.gmane.org> wrote:
> Hi,
>
> In https://www.kernel.org/doc/Documentation/cgroups/net_cls.txt there is a
> example to match the classid, set with a cgroup, with iptables:
>         iptables -A OUTPUT -m cgroup ! --cgroup 0x100001 -j DROP
>
> However, I've not been able to find the corresponding kernel module neither
> the iptables side module...
>
> Do you have any hint where I could find it ?
>
> Thanks,
>
> --
> Jean-Tiare, shared-hosting team
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
