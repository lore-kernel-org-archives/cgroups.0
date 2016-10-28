From: David Ahern <dsa@cumulusnetworks.com>
Subject: Re: [PATCH v7 0/6] Add eBPF hooks for cgroups
Date: Fri, 28 Oct 2016 09:00:51 -0600
Message-ID: <28133272-ff53-8a02-cc5d-844b22819e39@cumulusnetworks.com>
References: <1477390454-12553-1-git-send-email-daniel@zonque.org>
 <20161026195933.GA2031@salvia>
 <20161027033502.GA43960@ast-mbp.thefacebook.com>
 <20161028112839.GA29798@salvia>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=eFZJilmhEisCio6sDsfyslP6Q3MY+tIFg9jXxEmQ8bc=;
        b=Q+sXBgswApOm0CaDlHZoUgQ0K3VWakW9t97x2TjzQu4fcl77mzQo1j4f7ICXYpmbsX
         6/qRj+XDOz2JM9TDUV/Op3duGMSzfB4epcHRn3ZL6cxb3JRT39rC9GK5GKUzeY2a9a5N
         OqqIijD9EQyuWUYuCSqrxEFaPQkyZp5hkjUrE=
In-Reply-To: <20161028112839.GA29798@salvia>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Pablo Neira Ayuso <pablo@netfilter.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Mack <daniel@zonque.org>, htejun@fb.com, daniel@iogearbox.net, ast@fb.com, davem@davemloft.net, kafai@fb.com, fw@strlen.de, harald@redhat.com, netdev@vger.kernel.org, sargun@sargun.me, cgroups@vger.kernel.org

On 10/28/16 5:28 AM, Pablo Neira Ayuso wrote:
> I saw those, I would really like to have a closer look at David
> Ahern's usecase since that skb iif mangling looks kludgy to me, and
> given this is exposing a new helper for general use, not only vrf, it
> would be good to make sure helpers provide something useful for
> everyone. So that new helper is questionable at this stage IMO. I'm
> concerned that people may start using bpf as the adhesive tape to glue
> things to solve probably design problems.

It's changing sk_bound_dev_if on a socket when the socket is created, not skb iif. I explain the need in the cover letter. I have also explained the use case in the other attempts to solve this problem -- a stand alone l3mdev cgroup and adding a default setting to the task struct.
