From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH net-next v2] bpf: cgroup: fix documentation of
 __cgroup_bpf_update()
Date: Mon, 28 Nov 2016 11:34:31 -0800
Message-ID: <20161128193430.GB6722@ast-mbp.thefacebook.com>
References: <1480338664-22616-1-git-send-email-daniel@zonque.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uEgF2F6A48hKs9H3ZK7pt8zEg+9WiHhWA/CGXkmcrL8=;
        b=eQgLSIlVHcx8ZV3GQ69sN0nAWg6f4vYf2L0Y/dwNQiTkWXz1tcSUO4jLPBbB/67Svf
         hFB7jE6SYcpbdE7cCabYXO7fEA2aX8QxKh/2O6ljehwozNg4Hx7gelpHL7R0s4M9yufx
         v1lpBylyvoXvffFlSclYcHnEPA3bpRDN8CAAwrP+t2p9n3W7Um/RgOehs2rfjNRZRBnw
         R9fA3g9l3/2FIZyLw9md7k4D04mwvvKZoax0h17Bi/UjLhTcXPR8+Av9VLAX7u423Q6D
         /PfqWhU8/N1VIF2IgTB0JFwb5I7phPRR/KiOKeSvBvauGHPxLggqxPzxonirYSTafV2f
         BTiA==
Content-Disposition: inline
In-Reply-To: <1480338664-22616-1-git-send-email-daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Cc: ast-b10kYP2dOMg@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roszenrami-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Nov 28, 2016 at 02:11:04PM +0100, Daniel Mack wrote:
> There's a 'not' missing in one paragraph. Add it.
> 
> Signed-off-by: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
> Reported-by: Rami Rosen <roszenrami-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Fixes: 3007098494be ("cgroup: add support for eBPF programs")

Acked-by: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

btw more canonical patch format is to put Fixes tag before SOB.
