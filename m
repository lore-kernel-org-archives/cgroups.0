From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v7 0/6] Add eBPF hooks for cgroups
Date: Fri, 28 Oct 2016 23:24:47 -0700
Message-ID: <20161029062442.GA61550@ast-mbp.thefacebook.com>
References: <1477390454-12553-1-git-send-email-daniel@zonque.org>
 <20161026195933.GA2031@salvia>
 <c9683122-d770-355b-e275-7c446e6d1d0f@zonque.org>
 <CAKD1Yr2aRDNUxX8onReZyURufphxGoSTek=Fjk3Wswq9WOVp4w@mail.gmail.com>
 <20161029045107.GA61294@ast-mbp.thefacebook.com>
 <CAKD1Yr2pMk52h7BdRwTvGwnP5+ONmr4ac6cyUBoZ9P+Kt-B8jw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u5ubwGkMtC3MBpleFK1i00cBP0li/mQPOy7mTrQw+d4=;
        b=WldDY0Iz5GN1qzQz5gnTf/9UKaoKCBl2i7rp4rfbDUqD18HerXNF4LblZwDMuqV0v7
         C+rZjKf+CoOXmfNAB85+eHewEZn+CTmFVFmCCcStRlkr/kBUlm5zMjSTaACgpoyc4fgK
         pnlHIGuluA3PX6iYArC+qJuaVHm/hyF80JRqtAAIqopDg2naPPV8psJbuGA0DeRUlVqC
         139yyc37CKqxPPpTYXANIC/JVrK5F2wqEajYbbeef3V24oiTueF/PE4U2pGHLPAUbNJJ
         Pe+7M6an1cxqHELLaLVvqMeySqg2ihqWecmua8PRQfBnxZaj++NlFU+wsxyNem/vi7zI
         ihKw==
Content-Disposition: inline
In-Reply-To: <CAKD1Yr2pMk52h7BdRwTvGwnP5+ONmr4ac6cyUBoZ9P+Kt-B8jw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lorenzo Colitti <lorenzo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Pablo Neira Ayuso <pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org>, htejun-b10kYP2dOMg@public.gmane.org, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, ast-b10kYP2dOMg@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, kafai-b10kYP2dOMg@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Oct 29, 2016 at 01:59:23PM +0900, Lorenzo Colitti wrote:
> On Sat, Oct 29, 2016 at 1:51 PM, Alexei Starovoitov
> <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> What's the use case for egress?
> >>
> >> We (android networking) are currently looking at implementing network
> >> accounting via eBPF in order to replace the out-of-tree xt_qtaguid
> >> code. A per-cgroup eBPF program run on all traffic would be great. But
> >> when we looked at this patchset we realized it would not be useful for
> >> accounting purposes because even if a packet is counted here, it might
> >> still be dropped by netfilter hooks.
> >
> > don't use out-of-tree and instead drop using this mechanism or
> > any other in-kernel method? ;)
> 
> Getting rid of out-of-tree code is the goal, yes. We do have a
> requirement that things continue to work, though. Accounting for a
> packet in ip{,6}_output is not correct if that packet ends up being
> dropped by iptables later on.

understood.
it could be solved by swapping the order of cgroup_bpf_run_filter()
and NF_INET_POST_ROUTING in patch 5. It was proposed some time back, but
the current patch, I think, is more symmetrical.
cgroup+bpf runs after nf hook on rx and runs before it on tx.
imo it's more consistent.
Regardless of this choice... are you going to backport cgroupv2 to
android? Because this set is v2 only.

> > We (facebook infrastructure) have been using iptables and bpf networking
> > together with great success. They nicely co-exist and complement each other.
> > There is no need to reinvent the wheel if existing solution works.
> > iptables are great for their purpose.
> 
> That doesn't really answer my "what is the use case for egress"
> question though, right? Or are you saying "we use this, but we can't
> talk about how we use it"?

if the question is "why patch 4 alone is not enough and patch 5 is needed"?
Then it's symmetrical access. Accounting for RX only is a half done job.

> > there is iptables+cBPF support. It's being used in some cases already.
> 
> Adding eBPF support to the xt_bpf iptables code would be an option for
> what we want to do, yes. I think this requires that the eBPF map to be
> an fd that is available to the process that exec()s iptables, but we
> could do that.

yes. that's certainly doable, but sooner or later such approach will hit
scalability issue when number of cgroups is large. Same issue we saw
with cls_bpf and bpf_skb_under_cgroup(). Hence this patch set was needed
that is centered around cgroups instead of hooks. Note, unlike, tc and nf
there is no way to attach to a hook. The bpf program is attached to a cgroup.
It's an important distinction vs everything that currently exists in the stack.
