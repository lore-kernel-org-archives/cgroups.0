From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 02/10] freezer: skip waking up tasks with PF_FREEZER_SKIP set
Date: Tue, 30 Apr 2013 13:48:43 +0200
Message-ID: <14549764.SU5BpuG0MO@vostro.rjw.lan>
References: <1367271946-7239-1-git-send-email-ccross@android.com> <20130429220831.GC2395@htj.dyndns.org> <20130429221624.GD2395@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130429221624.GD2395@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Colin Cross <ccross@android.com>, Linux PM list <linux-pm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>, Li Zefan <lizefan@huawei.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, containers@lists.linux-foundation.org, cgroups@vger.kernel.org

On Monday, April 29, 2013 03:16:24 PM Tejun Heo wrote:
> On Mon, Apr 29, 2013 at 03:08:31PM -0700, Tejun Heo wrote:
> > > spent freezing by a factor of 5.  It will have a similar effect on a
> > > non-Android system, although those generally don't care about
> > > suspend/resume optimization.
> > 
> > Yeah, if it's something which makes actual difference rather than
> > "this seems to be a good idea" thing, sure, let's find a way.
> 
> And a probably better approach would be rolling should_skip test into
> freeze_task() with a comment explaining the interlocking rather than
> adding should_skip test in its callers.

Agreed.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
