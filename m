From: Cong Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH net-next 0/4] net_cls for sys container
Date: Thu, 2 Jan 2014 21:20:30 -0800
Message-ID: <CAM_iQpW0+Ftvk=QBE+0yMNW00VkBee1+yAEmbPkT+zjij9RX-Q@mail.gmail.com>
References: <52C62A44.4070304@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=RzUFP/BP3u1FZNgQmK6C3+twNj9udW6fRbAqnn6iwOk=;
        b=RtiPaGFPlt7JzYt+rAf0ESTgCOJAFLxSGTp8PK8ZcBOFgCp2dSkKcBtMwu8/GkqHdC
         1efm0HWpG9vYv64jScUZq/UsC/ZyXdGaC4fj7twINS9DGAYkp8ulXMaGdUAUhYVb97v9
         MChfZ79H7KWj03Y/b4IH4vEn7ZTUxvXsOJZAHCjsgZEmrlN6kAfNlhClPn6W0lvLSAkq
         VrB1zkWjzY0AhsPfLTQA5u/nMymIHMljN8R8nID9Y3T7JIUeMv7cJ5YxiNvdljzuVmWg
         ++6bylpfaXLo57BhXElhOLmdVOTMpjfuxaKvJxKkSFqPdXxVvu0fFElLT5agiE7yEsmm
         eDEg==
In-Reply-To: <52C62A44.4070304-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Libo Chen <clbchenlibo.chen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jamal Hadi Salim <jhs-jkUAjuhPggJWk0Htik3J/w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, pshelar-l0M0P4e3n4LQT0dZR+AlfA@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Simon Horman <horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Network Developers <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jan 2, 2014 at 7:11 PM, Libo Chen <clbchenlibo.chen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> Hi guys,
>
> Now, lxc created with veth can not be under control by
> cls_cgroup.
>
> the former discussion:
> http://lkml.indiana.edu/hypermail/linux/kernel/1312.1/00214.html
>
> In short, because cls_cgroup relys classid attached to sock
> filter skb, but sock will be cleared inside dev_forward_skb()
> in veth_xmit().


So what are you trying to achieve here?
