From: Hao Luo <haoluo@google.com>
Subject: Re: [PATCH 4/4] cgroup/bpf: Honor cgroup NS in cgroup_iter for ancestors
Date: Mon, 29 Aug 2022 11:02:36 -0700
Message-ID: <CA+khW7jZCN54nUonNLp59fTAqOtAk_Ror+PgrLBfufRcE-CnFQ@mail.gmail.com>
References: <20220826165238.30915-1-mkoutny@suse.com> <20220826165238.30915-5-mkoutny@suse.com>
 <CAJD7tkZZ6j6mPfwwFDy_ModYux5447HFP=oPwa6MFA_NYAZ9-g@mail.gmail.com>
 <20220829125957.GB3579@blackbody.suse.cz> <CAJD7tkZySzWgJgp4xbkpSstc_RMN_tJqt83-FFrxv6jASeg8CA@mail.gmail.com>
 <Ywz8J70t3508J62n@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=UeCjsqVX03HELV6Qxt26VdXhNVQmFOTxZbHveZi3Wic=;
        b=cUqah88qiqkMfKXIggmg3kkUscXJDGR5OrYwItkLbrscXP0wYnc6ckeka2erXb9+EK
         sMS+NHZt6ZJeQw5uULvYMQj02mdFaEp9RH0AfvLiKJs1hk2KIeSzdztoblg4GHwuYAqo
         xJeq1L3lg9LCT0kx6VYK7lxh2La6HHLVxdQnn1yW8dW25hwlg5PRUQsgU5boHtjoRdVD
         2dJ9e3wrNYW/kfW4g7WqzZoY8OzS/twBI5CP3iVmtwlxOE/oC9V6GgT6xG4x7+OqE3Zl
         sTXfjeW5XeJ2pFjxoriPT0yfEIdAhd+uiYl+xGpi8w3v08bruNKjvsBUwGxhCPUrdKMl
         xAdQ==
In-Reply-To: <Ywz8J70t3508J62n@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Aditya Kali <adityakali@google.com>, Serge Hallyn <serge.hallyn@canonical.com>, Roman Gushchin <roman.gushchin@linux.dev>, Yonghong Song <yhs@fb.com>, Muneendra Kumar <muneendra.kumar@broadcom.com>

On Mon, Aug 29, 2022 at 10:49 AM Tejun Heo <tj@kernel.org> wrote:
>
> On Mon, Aug 29, 2022 at 10:30:45AM -0700, Yosry Ahmed wrote:
> > > I'd like to clarify, if a process A in a broad cgroup ns sets up a BPF
> > > cgroup iterator, exposes it via bpffs and than a process B in a narrowed
> > > cgroup ns (which excludes the origin cgroup) wants to traverse the
> > > iterator, should it fail straight ahead (regardless of iter order)?
> > > The alternative would be to allow self-dereference but prohibit any
> > > iterator moves (regardless of order).
> > >
> >
> > imo it should fail straight ahead, but maybe others (Tejun? Hao?) have
> > other opinions here.
>
> Yeah, I'd prefer it to fail right away as that's simple and gives us the
> most choices for the future.
>

Thanks Michal for fixing the cgroup iter use case! I agree that
failing straight ahead is better. I don't envision a use case that
wants the alternative.

> Thanks.
>
> --
> tejun
