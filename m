From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH kselftest-next] Add cgroup core selftests
Date: Thu, 19 Jul 2018 10:08:30 -0700
Message-ID: <20180719170829.GB21770@castle.DHCP.thefacebook.com>
References: <20180718173358.14007-1-claudiozumbo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=C3y+iFNwz7PrpjkVQpJg70wnvpwxnCMyM24OC4iGUi0=;
 b=aEZ2Xu6Y//GXfaVQzFATo8fTcVpGMKYttTKxjcmDVGPfQz7Rp3kTsCEzUZQpEkXskRfW
 vVRM2n5vu3rjSiSCbNuTeRblbDF5nBynLHyq1o/Wwbhbj5KQCmDky48977FMhcmKFSWU
 +FVeDKoHFN0wbeZoY7cDJZ3p6cvj3TbiXCs= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3y+iFNwz7PrpjkVQpJg70wnvpwxnCMyM24OC4iGUi0=;
 b=WlndKxlUBHuvFEEXj50UEZzcDV5t+k4cZiSLFLhLcN31u93cQmH5hOn/U1jTW1FljQ2sCC7fcDln2dBLx/m3zaTElMemJhiNof5cmvC3h8WKJnO/9waJpAazE5Yrz2WVM1ezvJrRLhodDnql3oRxgPRvmgjMl2Df8cEw5MBo/J8=
Content-Disposition: inline
In-Reply-To: <20180718173358.14007-1-claudiozumbo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Claudio <claudiozumbo@gmail.com>
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Claudio Zumbo <claudioz@fb.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com

On Wed, Jul 18, 2018 at 07:33:58PM +0200, Claudio wrote:
> This commit adds tests for some of the core functionalities
> of cgroups v2.
> 
> The commit adds tests for some core principles of croup V2 API:
> 
> - test_cgcore_internal_process_constraint
> 
>   Tests internal process constraint.
>   You can't add a pid to a domain parent if a controller is enabled.
> 
> - test_cgcore_top_down_constraint_enable
> 
>    Tests that you can't enable a controller on a child if it's not enabled
>    on the parent.
> 
> - test_cgcore_top_down_constraint_disable
> 
>   Tests that you can't disable a controller on a parent if it's
>   enabled in a child.
> 
> - test_cgcore_no_internal_process_constraint_on_threads
> 
>   Tests that there's no internal process constrain on threaded cgroups.
>   You can add threads/processes on a parent with a controller enabled.
> 
> - test_cgcore_parent_becomes_threaded
> 
>   Tests that when a child becomes threaded the parent type becomes
>   domain threaded.
> 
> - test_cgcore_invalid_domain
> 
>   In a situation like:
> 
>   A (domain threaded) - B (threaded) - C (domain)
> 
>   it tests that C can't be used until it is turned into a threaded cgroup.
>   The "cgroup.type" file will report "domain (invalid)" in these cases.
>   Operations which fail due to invalid topology use EOPNOTSUPP as the errno.
> 
> - test_cgcore_populated
> 
>   In a situation like:
> 
>   A(0) - B(0) - C(1)
>          \ D(0)
> 
>   It tests that A, B and C's "populated" fields would be 1 while D's 0.
>   It tests that after the one process in C is moved to root, A,B and C's
>   "populated" fields would flip to "0" and file modified events will
>   be generated on the "cgroup.events" files of both cgroups.
> 
> Signed-off-by: Claudio Zumbo <claudioz@fb.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: kernel-team@fb.com

Looks good to me!

Reviewed-by: Roman Gushchin <guro@fb.com>

Thank you!
