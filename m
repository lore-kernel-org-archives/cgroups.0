From: Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>
Subject: Re: [PATCH v6 5/6] net: ipv4, ipv6: run cgroup eBPF egress programs
Date: Mon, 19 Sep 2016 23:28:00 +0200
Message-ID: <20160919212800.GA21217@pox.localdomain>
References: <1474303441-3745-1-git-send-email-daniel@zonque.org>
 <1474303441-3745-6-git-send-email-daniel@zonque.org>
 <20160919191910.GA984@salvia>
 <20160919201322.GA84770@ast-mbp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suug-ch.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rlH7zNDJuhXXWcJs3tNKZV5bfWiIwBQD86FSeHoYI30=;
        b=ITo9iqfsV3q9cl/peHNdW3aQouE5fn7D90xiHeftrjCtIeaiHaPtgwJaEz7o/lHCAG
         R/AFqTdIW0R0CpOoTaHxAv8P2XU3Z41NcM7ZWjKAeCiINyUPLo3aSzqBSVy39SnjyDgZ
         v+z/SS/G5cJD1xRs5tdOlgem7f5PUEoUFToXlS0mICiwGu0rAZ4oUkjRR9gSoR9VPHHx
         +ZTbExrzi7n6s8TjBRxVGgxPNic+vo9MnC0qFjyIRQ3gxGZ+XdzLCXgv/6nouqNNVTgs
         U3yjE15tug84UvSmf6NH5xhEDB1fDY9+Us2MhyHF0tT8MLyNvSw3d5qfvzUhiPFYMgkU
         TNzA==
Content-Disposition: inline
In-Reply-To: <20160919201322.GA84770-+o4/htvd0TDFYCXBM6kdu7fOX0fSgVTm@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Pablo Neira Ayuso <pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, htejun-b10kYP2dOMg@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, ast-b10kYP2dOMg@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org, harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 09/19/16 at 01:13pm, Alexei Starovoitov wrote:
> as far as bpf debuggability/visibility there are various efforts on the way:
> for kernel side:
> - ksym for jit-ed programs
> - hash sum for prog code
> - compact type information for maps and various pretty printers
> - data flow analysis of the programs

We made a generic map tool available here as well:
https://github.com/cilium/cilium/blob/master/bpf/go/map_ctrl.go
