From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v11 2/9] hugetlb_cgroup: add interface for charge/uncharge
 hugetlb reservations
Date: Wed, 5 Feb 2020 14:08:47 -0800
Message-ID: <a48fbdd1-fc0e-f17d-09c2-1492c8466254@oracle.com>
References: <20200203232248.104733-1-almasrymina@google.com>
 <20200203232248.104733-2-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=UI5rcdJyqYY+DTVX9PvejzMOeqMSnFQuRyuUoAASGRc=;
 b=amq1bDa2j2jr0FdogaTIiBaUkmJs12vblBWkfjEZ3yvBoAM6o1IfmTIWYYmYr4HCkqRn
 BqoSMNEX0mw329ZDgIutoFzFPSuMafaPpkJrIA9DfDmiYgJFyMX7IqhHjRCxgHzEtr3v
 bsLVgSGt7l2KMBOuUbuxM9RIH/m8jIr7LqygRGfT0NxwLR5jG8XT0l4hYyvKkIrM2ikv
 Ofqsnv6dnJth+H6QmDgTkUle6N/q9SeHbcSS7dJCTHomvGqjAtB072owaFJIajDOX5xa
 h8rGTOPCDJ808FdEnQF2Qu51oswqREnDd7scBYKeAHQhSCYUS4JiZPCQ4r7kaAqEx43X aw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=UI5rcdJyqYY+DTVX9PvejzMOeqMSnFQuRyuUoAASGRc=;
 b=jNa8oHnompyhuHvnOSs87JodhwiPsd+wjoF6vNTBx4IbJXIAJi6aNHfFAAJO2n1rg2XS
 RC0SHxmMmb33K+LTvxLYXT1H28ds7MVGClgTQ81ViKDTny8BKXY3DzqCREfOIystbodz
 j4z2z1CRw6KKlh5CVQ4RgnrEEH8FJDqM3v3tEAg6gSRpUi4DzuCQNivGuJrXENkOyLCP
 YDO8IOi8pV1ZMv3iaoHSWwbizMHr/o9tiNiu7Eq5iHALNxRV8w6kqWyv8R2ACr2Cq+fk
 d8xaQ33EQWJbPXCVyuJJKuQPqLZutK9jyV2vWC8xkU7gLb6IsEIQI6RG8fWADbQ+uvbr ww== 
In-Reply-To: <20200203232248.104733-2-almasrymina@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: shuah@kernel.org, rientjes@google.com, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org

On 2/3/20 3:22 PM, Mina Almasry wrote:
> Augments hugetlb_cgroup_charge_cgroup to be able to charge hugetlb
> usage or hugetlb reservation counter.
> 
> Adds a new interface to uncharge a hugetlb_cgroup counter via
> hugetlb_cgroup_uncharge_counter.
> 
> Integrates the counter with hugetlb_cgroup, via hugetlb_cgroup_init,
> hugetlb_cgroup_have_usage, and hugetlb_cgroup_css_offline.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
> Acked-by: David Rientjes <rientjes@google.com>
> 
> ---
> 
> Changes in v11:
> - Changed all 'reserved' or 'reservation' to 'rsvd' to reflect the user
> interface.

Thanks.

Small nit,

> @@ -450,8 +496,7 @@ static ssize_t hugetlb_cgroup_reset(struct kernfs_open_file *of,
>  	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(of_css(of));
> 
>  	counter = &h_cg->hugepage[MEMFILE_IDX(of_cft(of)->private)];
> -	rsvd_counter =
> -		&h_cg->rsvd_hugepage[MEMFILE_IDX(of_cft(of)->private)];
> +	rsvd_counter = &h_cg->rsvd_hugepage[MEMFILE_IDX(of_cft(of)->private)];
> 

That looks like a change just to reformat a line added in the first patch?

>  	switch (MEMFILE_ATTR(of_cft(of)->private)) {
>  	case RES_MAX_USAGE:

-- 
Mike Kravetz
