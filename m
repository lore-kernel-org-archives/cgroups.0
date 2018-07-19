From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/10] psi: pressure stall information for CPU, memory,
 and IO v2
Date: Thu, 19 Jul 2018 08:18:37 -0400
Message-ID: <20180719121837.GA13799@cmpxchg.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180716155745.10368-1-drake@endlessm.com>
 <20180717112515.GE7193@dhcp22.suse.cz>
 <20180718222157.GG2838@cmpxchg.org>
 <143db4db-2613-345d-9b8e-1794b6d8c4fe@sony.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=N3oEpLPHTXz9ks1wW/amyWMiqmFylX3q9a6y6+vx0RY=;
        b=x6Su2GdQE0Vmnu8c4Qjav5ztHBlJEm7lqyzo1kAUzQt0MUBOlziFrRJpQ0yjPnk/Pk
         okAUXRQxXRs8afsOcPPKuVCAWmlpUzARpfrbn0PDs2qKTzGEDZpWvbgAP1J78AXIsd9N
         y7ydh136JnuDlU1Z2wlfPqSyOrUZf9542fhpNoWjcbX1WRiYQTzX1H7+7CuUvfoB5I0H
         rv+HmeQ/+O1TljaDks6sEGo5Zw3V4Bn46g189C/uJIpi3HmQhrQvEUBYmNB3Iszl1L4S
         HE2Lgb+8aMmX9S0DPOdWAnJ7XPUH2DIBGWBqGjM9W32o+6MCErgbGubcvBNFqzJi3w/k
         MKeQ==
Content-Disposition: inline
In-Reply-To: <143db4db-2613-345d-9b8e-1794b6d8c4fe@sony.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peter enderborg <peter.enderborg@sony.com>
Cc: Michal Hocko <mhocko@kernel.org>, Daniel Drake <drake@endlessm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux@endlessm.com, linux-block@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Thu, Jul 19, 2018 at 01:29:39PM +0200, peter enderborg wrote:
> On 07/19/2018 12:21 AM, Johannes Weiner wrote:
> >
> > Yes, we currently use a userspace application that monitors pressure
> > and OOM kills (there is usually plenty of headroom left for a small
> > application to run by the time quality of service for most workloads
> > has already tanked to unacceptable levels). We want to eventually add
> > this back into the kernel with the appropriate configuration options
> > (pressure threshold value and sustained duration etc.)
> Is that the same application as googles lmkd for android? Any source
> that you might share?

Sure! This is the oomd we've been developing and using at Facebook:

	https://github.com/facebookincubator/oomd
