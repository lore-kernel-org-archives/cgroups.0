From: Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: [PATCH V3] MM: make vmpressure_win dynamic
Date: Mon, 12 May 2014 11:40:32 -0700
Message-ID: <1399920032.2648.33.camel@buesod1.americas.hpqcorp.net>
References: <20140510085217.24a34794f0e4a4881c8eec0b@skynet.be>
	 <20140512075537.GA9564@dhcp22.suse.cz>
	 <20140512202249.8f5b8475ba2c5018585e68b1@skynet.be>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140512202249.8f5b8475ba2c5018585e68b1@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Fabian Frederick <fabf@skynet.be>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, akpm <akpm@linux-foundation.org>, Li Zefan <lizefan@huawei.com>, cgroups <cgroups@vger.kernel.org>

On Mon, 2014-05-12 at 20:22 +0200, Fabian Frederick wrote:
> On Mon, 12 May 2014 09:55:37 +0200
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > On Sat 10-05-14 08:52:17, Fabian Frederick wrote:
> > > This patch addresses TODO featuring in original version :
> > 
> > This is the 3rd version of the patch and I still fail to see the
> > motivation other than addressing a TODO which doesn't sound like a
> > sufficient justification to me. Why is the new scheme needed in the
> > first place? Why is calculate_normal_threshold a proper scheme?
> Nothing more than trying to have that value dynamic.

No, that's not a valid justification. This is your reason, Fabian:

https://lkml.org/lkml/2013/1/8/45
