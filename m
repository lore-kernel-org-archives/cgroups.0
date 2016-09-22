From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH v6 5/6] net: ipv4, ipv6: run cgroup eBPF egress programs
Date: Thu, 22 Sep 2016 11:54:11 +0200
Message-ID: <20160922095411.GA5654@pox.localdomain>
References: <1474303441-3745-6-git-send-email-daniel@zonque.org>
 <20160919191910.GA984@salvia>
 <ac88bb4c-ab7c-1f74-c7fd-79e523b50ae4@zonque.org>
 <20160919203533.GA888@salvia>
 <83afdc54-1bbe-3530-e5fd-b74fefe9a042@zonque.org>
 <20160920142931.GA31438@salvia>
 <6584b975-fa3e-8d98-f0c7-a2c6b194b2b6@zonque.org>
 <20160921154533.GA13656@salvia>
 <20160921184827.GA15732@pox.localdomain>
 <20160922092138.GA12108@salvia>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suug-ch.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hZO72DEn6yYyPajTHEeMley8M/r/FM8MVC2qPw83q5U=;
        b=Lbp9RHnclykpFjzOCqIiwOzBqubW55HtUg+vXFbmGa+b1deVLU1CW3JqQvYMc7lpgt
         iwWeMUR4YVV9/gIGbov7EvDBE1Cu8IQj4wWqDhbOKDMF75UzHbjDqTVjjaelGdCBt4+8
         8D5QpQxdGhhQ6RjsRxbPj6Sw8wdWk9z4H4tygeQidK8SEMocY9fgnSAgSglzdMjebnJB
         qMiyaQL4d/7gMnIqRobgGFBM9xY4Lkxv8XDdHKJpI2G9v2MpPNKiWGRX/WeE/56vnV9+
         zSph2r3R6nMcPB+rQulYYEnUxKqqbSJeJuvP4qSjZY/37bWPqZytf4ftVP7kOPPN32jZ
         8CcQ==
Content-Disposition: inline
In-Reply-To: <20160922092138.GA12108@salvia>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Daniel Mack <daniel@zonque.org>, htejun@fb.com, daniel@iogearbox.net, ast@fb.com, davem@davemloft.net, kafai@fb.com, fw@strlen.de, harald@redhat.com, netdev@vger.kernel.org, sargun@sargun.me, cgroups@vger.kernel.org

On 09/22/16 at 11:21am, Pablo Neira Ayuso wrote:
> I have a hard time to buy this new specific hook, I think we should
> shift focus of this debate, this is my proposal to untangle this:
> 
> You add a net/netfilter/nft_bpf.c expression that allows you to run
> bpf programs from nf_tables. This expression can either run bpf
> programs in a similar fashion to tc+bpf or run the bpf program that
> you have attached to the cgroup.

So for every packet processed, you want to require the user to load
and run a (unJITed) nft program acting as a wrapper to run a JITed
BPF program? What it the benefit of this model compared to what Daniel
is proposing? The hooking point is the same. This only introduces
additional per packet overhead in the fast path. Am I missing something?
