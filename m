From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH -next] arm64/mm: fix a bogus GFP flag in pgd_alloc()
Date: Wed, 12 Jun 2019 14:35:57 -0400
Message-ID: <1560364557.5154.2.camel@lca.pw>
References: <1559656836-24940-1-git-send-email-cai@lca.pw>
         <20190604142338.GC24467@lakrids.cambridge.arm.com>
         <20190610114326.GF15979@fuggles.cambridge.arm.com>
         <1560187575.6132.70.camel@lca.pw>
         <20190611100348.GB26409@lakrids.cambridge.arm.com>
         <20190611124118.GA4761@rapoport-lnx>
         <3F6E1B9F-3789-4648-B95C-C4243B57DA02@lca.pw>
         <20190612065728.GB4761@rapoport-lnx>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ccd2Dl/s5BEnRCE+LL0hkZ64UWDD7pEB/PZyv8yO8ZY=;
        b=IcABX1nM51p2QrQVsut+vh/j10d5dr6geQ+a/RrmE6DOHq7udCPilWtmRYD99j0boR
         ov5Ysub7+GqF4lbZDxDthsXnWeXk+ES3UVFuSCse5kakCEymFY4P7BJeaa1eqMTm9m4J
         a+/2xER8DdWKm0/0yHAUhnmEJWAiez71uz/DfX4C+ZMkDAyMe9n6LHO40E10deKj4zJN
         Wel0wmmIihoR/AvHw5HUgRWq+VZtm2o2vy9xdx+v9Lo1iXmV5/ZbXP3K7XF07He5wGRh
         eTLt9p7wJXVFha1pn5wg6b5vpyG2Z/ZLgk4Y4y0kGDJ+N6XDcakHacAueyHQQONRObHL
         LFHA==
In-Reply-To: <20190612065728.GB4761@rapoport-lnx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Mike Rapoport <rppt@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Morton <akpm@linux-foundation.org>, catalin.marinas@arm.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mhocko@kernel.org, linux-mm@kvack.org, vdavydov.dev@gmail.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org

On Wed, 2019-06-12 at 09:57 +0300, Mike Rapoport wrote:
> Hi,
> 
> On Tue, Jun 11, 2019 at 08:46:45AM -0400, Qian Cai wrote:
> > 
> > > On Jun 11, 2019, at 8:41 AM, Mike Rapoport <rppt@linux.ibm.com> wrote:
> > > 
> > > Sorry for the delay, I'm mostly offline these days.
> > > 
> > > I wanted to understand first what is the reason for the failure. I've
> > > tried
> > > to reproduce it with qemu, but I failed to find a bootable configuration
> > > that will have PGD_SIZE != PAGE_SIZE :(
> > > 
> > > Qian Cai, can you share what is your environment and the kernel config?
> > 
> > https://raw.githubusercontent.com/cailca/linux-mm/master/arm64.config
> > 
> > # lscpu
> > Architecture:        aarch64
> > Byte Order:          Little Endian
> > CPU(s):              256
> > On-line CPU(s) list: 0-255
> > Thread(s) per core:  4
> > Core(s) per socket:  32
> > Socket(s):           2
> > NUMA node(s):        2
> > Vendor ID:           Cavium
> > Model:               1
> > Model name:          ThunderX2 99xx
> > Stepping:            0x1
> > BogoMIPS:            400.00
> > L1d cache:           32K
> > L1i cache:           32K
> > L2 cache:            256K
> > L3 cache:            32768K
> > NUMA node0 CPU(s):   0-127
> > NUMA node1 CPU(s):   128-255
> > Flags:               fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics
> > cpuid asimdrdm
> > 
> > # dmidecode
> > Handle 0x0001, DMI type 1, 27 bytes
> > System Information
> >         Manufacturer: HPE
> >         Product Name: Apollo 70             
> >         Version: X1
> >         Wake-up Type: Power Switch
> >         Family: CN99XX
> > 
> 
> Can you please also send the entire log when the failure happens?

https://cailca.github.io/files/dmesg.txt

> Another question, is the problem exist with PGD_SIZE == PAGE_SIZE?

No.
