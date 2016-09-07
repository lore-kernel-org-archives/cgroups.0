From: Rami Rosen <roszenrami@gmail.com>
Subject: Re: [PATCH v4 2/6] cgroup: add support for eBPF programs
Date: Wed, 7 Sep 2016 07:58:19 +0300
Message-ID: <CAKoUAr=M6Mmqmrz=uRh6SEUXMki4m0yR+cGNZJUNe3pGk6NhNw@mail.gmail.com>
References: <1473169568-30525-1-git-send-email-daniel@zonque.org> <1473169568-30525-3-git-send-email-daniel@zonque.org>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Jk0TDNMiMrJpRl6AS1y7cc6OHfax9zYTRezWYFCNEPc=;
        b=uCX1U8U4dugMEmYN0orouXB/8Vwsm8SZnXZ6Ok/V64L6pJU9YxbVck8Lbm+9CgJ94o
         +oMQ1Ym2gCSvLuvwY69PGy2jufSBVhbzwZLN0xWJgQ2Ip4/WMLmEfHkWC/2EEuAm+xR9
         P73Y0MkRF71PVr0xcgBEzd+adfVZU5S10iaoLRXfa2fVPXJDzermvmSZxo7HHkMvrAJk
         8XW+oU4crQqVx06XDDuuHWzCaa7Gx6IB0djdxLMw985chqA6djuhnw0sNsyN7P6Kd3U5
         DzYDkxpphKWgem5GFBxmZwEK5KRqyffOLysEAFP7J17HvengT4OYHy458hXIBsCZcuaj
         iOmw==
In-Reply-To: <1473169568-30525-3-git-send-email-daniel@zonque.org>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Mack <daniel@zonque.org>
Cc: htejun@fb.com, daniel@iogearbox.net, ast@fb.com, David Miller <davem@davemloft.net>, kafai@fb.com, fw@strlen.de, pablo@netfilter.org, harald@redhat.com, Netdev <netdev@vger.kernel.org>, Sargun Dhillon <sargun@sargun.me>, cgroups@vger.kernel.org

Hi,


+ * __cgroup_bpf_update() - Update the pinned program of a cgroup, and
+ *                         propagate the change to descendants
+ * @cgrp: The cgroup which descendants to traverse

Missing here is @parent

+ * @prog: A new program to pin
+ * @type: Type of pinning operation (ingress/egress)

...

> +void __cgroup_bpf_update(struct cgroup *cgrp,
> +                        struct cgroup *parent,
> +                        struct bpf_prog *prog,
> +                        enum bpf_attach_type type)
> +{

Regards,
Rami Rosen
