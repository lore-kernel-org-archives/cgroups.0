From: Tejun Heo <tj@kernel.org>
Subject: Re: Cgroups "pids" controller does not update "pids.current" count
 immediately
Date: Fri, 15 Jun 2018 08:41:40 -0700
Message-ID: <20180615154140.GV1351649@devbig577.frc2.facebook.com>
References: <77af3805-e912-2664-f347-e30c0919d0c4@icdsoft.com>
 <20180614150650.GU1351649@devbig577.frc2.facebook.com>
 <7860105c-553a-534b-57fc-222d931cb972@icdsoft.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RQqufL1AJ0hin8mmegtZrm7Q1uCOPJvPz79HadixPSo=;
        b=QPSw42+0cLnRhrTWTvfC1TbIJ9h7g3F45g68aPrYdZ8RkIsSqS2CM9Nuq387yimndr
         Gl+FzDlU22WS28nlmhhViopvwfAsignuoxKC+fXaxye6nR38SIgRmf5+jED9uIQAzp1i
         HJ3VKXx4hEBAhFbx0AEpegYt8Z7tJ9GW9hiFpG2o/1l4+KYmFMCRXk5TOso5XPyC9EIh
         Zm7gBzeYcgn55W5NvmUu9P2gPvLt9v8fsBqOUX1kzgTuQctrqQGfj+Y2L4Wv+U5rY3cK
         DQ0CZ56guBQUrQ8UYDXSu1X8k5JfmciXBkJA0lcywZRCxEY4e14xlHsjgFgtHg5N/9QQ
         15AQ==
Content-Disposition: inline
In-Reply-To: <7860105c-553a-534b-57fc-222d931cb972@icdsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ivan Zahariev <famzah@icdsoft.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Fri, Jun 15, 2018 at 05:26:04PM +0300, Ivan Zahariev wrote:
> The standard RLIMIT_NPROC does not suffer from such accounting
> discrepancies at any time.

RLIMIT_NPROC uses a dedicated atomic counter which is updated when the
process is getting reaped; however, that doesn't actually coincide
with the pid being freed.  The base pid ref is put then but there can
be other refs and even after that it has to go through RCU grace
period to be actually freed.

They seem equivalent but serve a bit different purposes.  RLIMIT_NPROC
is primarily about limiting what the user can do and doesn't guarantee
that that actually matches resource (pid here) consumption.  pid
controller's primary role is limiting pid consumption - ie. no matter
what happens the cgroup must not be able to take away more than the
specified number from the available pool, which has to account for the
lazy release and draining refs and stuff.

> The "memory" cgroups controller also does
> not suffer from any discrepancies -- it accounts memory usage in
> real time without any lag on process start or exit. The "tasks" file
> list is also always up-to-date.

The memory controller does the same thing, actually way more
extensively.  It's just less noticeable because people generally don't
try to control at individual page level.

> Is it really technically not possible to make "pids.current" do
> accounting properly like RLIMIT_NPROC does? We were hoping to
> replace RLIMIT_NPROC with the "pids" controller.

It is of course possible but at a cost.  The cost (getting rid of lazy
release optimizations) is just not justifiable for most cases.

Thanks.

-- 
tejun
