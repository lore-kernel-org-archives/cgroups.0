From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/1] freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD
Date: Thu, 25 Oct 2012 22:13:05 +0200
Message-ID: <18773928.vP4l182XdI@vostro.rjw.lan>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <20121025173756.GB7650@redhat.com> <CAOS58YPAVVr=itauGD9eTpfRLSBLuM8Bpyuq9AP73MDr8dPmiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOS58YPAVVr=itauGD9eTpfRLSBLuM8Bpyuq9AP73MDr8dPmiQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, lizefan@huawei.com, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Thursday, October 25, 2012 10:37:31 AM Tejun Heo wrote:
> Hello,
> 
> On Thu, Oct 25, 2012 at 10:37 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> How should this be routed?  -mm?  Andrew, can you please pick this up?
> >
> > or perhaps Rafael can take it?
> 
> Yeah, that works too.  Rafael?

Yup, I'm taking it.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
